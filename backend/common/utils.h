#ifndef VMP_COMMON_UTILS_H_
#define VMP_COMMON_UTILS_H_

#include "stdafx.h"
#include "compatibility.h"
#include <stdint.h>
#include <cmath>
#include "log.h"

extern Log _log;

#include <csignal>
#include <iostream>
#include <ostream>
#include <string>
using namespace std;

namespace
{
	volatile sig_atomic_t atomic_quit;

	void signal_handler(int sig)
	{
		signal(sig, signal_handler);
		_Info("Break signaled by user");
		atomic_quit = 1;
	}
}

enum GSMode {
	G_OFF, G_MANUAL, G_AUTO
};

int tr(int a) {
	return a - a % 2;
}

bool eq(double a, double b) {
	return std::abs(a - b) < 0.000001;
}

void putOverlay(short* sBuf, short* aBuf, double volume) {
	int i = 0;
	for (i = 0; i < 2048; i++) {
		double inp = aBuf[i] * volume;
		inp /= 65536.0;
		inp += 0.5;
		double sum = sBuf[i];
		sum /= 65536.0;
		sum += 0.5;
		double z = 0;
		if (inp < 0.5 && sum < 0.5) {
			z = 2 * inp * sum;
		}
		else {
			z = 2 * (inp + sum) - 2 * inp * sum - 1;
		}
		z *= 65536;
		z -= 32768;
		short sz = z;
		sBuf[i] = sz;
	}
	return;
}


void addtime(timeval& t, int usec) {
	t.tv_sec += (usec / 1000000);
	t.tv_usec += (usec % 1000000);
	if (t.tv_usec > 1000000000) {
		t.tv_usec -= 1000000000;
		t.tv_sec++;
	}
	if (t.tv_usec < -1000000000) {
		t.tv_usec += 1000000000;
		t.tv_sec--;
	}
}

double msec_delta(timeval t2, timeval t1) {
	double t2_usec = t2.tv_sec * 1000000.0 + t2.tv_usec;
	double t1_usec = t1.tv_sec * 1000000.0 + t1.tv_usec;
	return ((t2_usec - t1_usec) / 1000.0);
}

int64_t TimeMs() {
#ifdef _WIN32
	FILETIME f;
	GetSystemTimeAsFileTime(&f);
	int64_t* t = (int64_t*)&f;

	*t /= 10000;
	return *t;
#else
	struct timeval t;
	gettimeofday(&t, NULL);
	int64_t res = ((int64_t) t.tv_sec) * 1000 + ((int64_t) t.tv_usec) / 1000;
	return res;
#endif
}

// recycle an existing frame with its own buffer, for new size and/or format
int RemakeFrame(AVFrame *f, int width, int height, AVPixelFormat fmt) {
	int num_bytes = avpicture_get_size(fmt, width, height);
	if (num_bytes < 0) {
		_ErrorF("got %d as result of avpicture_get_size!", num_bytes);
	}
	avpicture_fill((AVPicture*) f, f->data[0], fmt, width, height);
	f->width = width;
	f->height = height;
	f->format = fmt;
	return 0;
}

// create a frame and fill it with a given buffer
AVFrame *MakeFrame(int width, int height, AVPixelFormat fmt,
		uint8_t *frame_buffer) {
	AVFrame *out = av_frame_alloc();
	int num_bytes = avpicture_get_size(fmt, width, height);
	if (num_bytes<0) {
		_ErrorF("avpicture_get_size returned %d", num_bytes);
	}
	avpicture_fill((AVPicture*) out, frame_buffer, fmt, width, height);
	out->width = width;
	out->height = height;
	out->format = fmt;
	return out;
}

// create and return AVFrame of a given format and size, with buffer allocated and filled
AVFrame *AllocFrame(int width, int height, AVPixelFormat fmt) {
	int num_bytes = avpicture_get_size(fmt, width, height);
	uint8_t *frame_buffer = (uint8_t *) av_malloc(num_bytes * sizeof(uint8_t));
	return MakeFrame(width, height, fmt, frame_buffer);
}

// resize a frame, must be pre-filled with data arrays
int ResizeFrameTo(AVFrame *i_frame, AVFrame *out, int width, int height) {
	AVPixelFormat format = (AVPixelFormat) i_frame->format;
	// looks meaningless, but whole point is to change linesize-s and layout
	// of slices in data[]. data[0] is always the first byte of buffer,
	// bit dirty i know, but it works
	RemakeFrame(out, width, height, (AVPixelFormat) out->format);
	SwsContext* resize = sws_getContext(i_frame->width, i_frame->height, format,
			width, height, (AVPixelFormat) out->format, SWS_BICUBIC, NULL, NULL,
			NULL);
	int h_slice = sws_scale(resize, i_frame->data, i_frame->linesize, 0,
			i_frame->height, out->data, out->linesize);
	if (h_slice != height)
		_ErrorF("sws_scale resulted in %d rows instead of %d", h_slice, height);
	sws_freeContext(resize);
	return 0;
}

// resize a frame to fill the size (WxH) of out, keeping out's format
int ResizeFrame(AVFrame *i_frame, AVFrame *out) {
	return ResizeFrameTo(i_frame, out, out->width, out->height);
}

// resize a frame, convert it into YUV420P if needed  
AVFrame* AllocAndResizeFrame(AVFrame* i_frame, int to_width, int to_height) {
	AVFrame* out = AllocFrame(to_width, to_height, AV_PIX_FMT_YUV420P);
	int res = ResizeFrame(i_frame, out);
	if (!res) {
		return out;
	} else {
		return NULL;
	}
}

enum name {
	VTASK_QSEEK, VTASK_SEEK, VTASK_PLAY, VTASK_STOP, VTASK_EXIT, VTASK_NOP
};

string name_str[] = { "VTASK_QSEEK", "VTASK_SEEK", "VTASK_PLAY", "VTASK_STOP",
		"VTASK_EXIT", "VTASK_NOP" };

struct videoTask {
	videoTask() {
		task = VTASK_NOP;
		position = 0;
	}
	name task;
	double position;
};

#endif
