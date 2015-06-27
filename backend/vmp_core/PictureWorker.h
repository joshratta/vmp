#ifndef VMP_CORE_PICTURE_WORKER_H_
#define VMP_CORE_PICTURE_WORKER_H_

#include "../common/stdafx.h"
#include "VisualWorker.h"

#define STB_IMAGE_IMPLEMENTATION
#include "../common/stb_image.h"

class PictureWorker : public VisualWorker {
public:
	PictureWorker() {
		m_opened = false;
	}

	~PictureWorker() {
	}

	int Seek(double secs) {
		m_validFrame = (secs >= source.position && secs <= (source.position + source.duration));
		if (secs >= (source.position + source.duration)) {
			m_ended = true;
		}
		else {
			m_ended = false;
		}
		position = secs;
		return 0;
	}

	// for image content, there is no difference
	int QuickSeek(double secs) {
		return Seek(secs);
	}

	// do nothing
	void AV_read_frame() {

	}

	virtual int SetSource(const Source* src, double position) {
		_Info("in SetSource() for Image");
		int rawW = source.rawW;
		int rawH = source.rawW;
		int res = VisualWorker::SetSource(src, position);
		source.rawW = rawW;
		source.rawH = rawH;
		return res;
	}

	int OpenMedia() {
		if (m_opened) return 0;
		frame = OpenImage(source.path);
		if (!frame) {
			av_frame_free(&m_scaledFrame);
			return -1;
		}
		m_scaledFrame = MakeFrame(source.w, source.h, AV_PIX_FMT_YUV420P, m_destFrameBuffer);
		ResizeFrameTo(frame, m_scaledFrame, source.w, source.h);

		if (frame->format == AV_PIX_FMT_RGBA) {
			if (alpha_data) {
				av_free(alpha_data);
				alpha_data = NULL;
			}
			alpha_data = (uint8_t*)malloc(frame->width*frame->height);
			// +3 because it is rgbA, A (alpha) is the last byte of each 4 
			// bytes forming a pixel
			for (int i = 0; i<frame->width*frame->height; i++) {
				alpha_data[i]=frame->data[0][i*4+3];
			}
			alpha_frame = MakeFrame(source.rawW, source.rawH, AV_PIX_FMT_GRAY8, alpha_data);
			UpdateScaledAlphaFrame(source.w, source.h);
		}

		m_fps = 0;
		m_opened = true;

		return 0;
	}

	uint64_t GetNFrames() {
		return 1;
	}

	virtual int GetNativeWidth() {
		return frame->width;
	}

	virtual int GetNativeHeight() {
		return frame->height;
	}

private:
	bool m_opened;

	AVFrame* OpenImage(const char* imageFileName)
	{
		int x, y, comp;
		unsigned char *data;

		FILE *file = fopen(imageFileName, "rb");
		if (!file)
			return NULL;

		data = stbi_load_from_file(file, &x, &y, &comp, 0);
		fclose(file);
		
		if (!data) return NULL;

		AVFrame *f = av_frame_alloc();
		AVPixelFormat fmt = (comp == 3) ? PIX_FMT_RGB24 : PIX_FMT_RGBA;
		int numBytes = avpicture_get_size(fmt, x, y);
		if (numBytes<0) {
			_ErrorF("avpicture_get_size returned %d", numBytes);
		}

		avpicture_fill((AVPicture *)f, data, fmt, x, y);
		f->format = fmt;
		f->width = x;
		f->height = y;

		source.rawW = x;
		source.rawH = y;

		return f;
	}

};

#endif
