#ifndef VMP_COMMON_VIDEOWORKER_H_
#define VMP_COMMON_VIDEOWORKER_H_

#include <string.h>

#include "../common/stdafx.h"
#include "../common/audio.h"
#include "../common/log.h"
#include "VisualWorker.h"
#include "Source.h"

extern Log _log;

// thread stub
void performThis(void *ptr);

class VideoWorker : public VisualWorker {
public:

	VideoWorker() {
		_Debug("In VideoWorker()");
		ctxInit = 0;
		codecCtx = NULL;
		m_sizeInvalidated = FALSE;
		m_stream_index = -1;
		frame_id = 0;
		position = 0.0;
		m_fps = -1;
		m_lastFrame = -1;
		m_ended = false;
		codec = NULL;
		pFormatCtx=NULL;
		duration = 0;
		videoStream = NULL;
		_Debug("Done with VideoWorker()");
	}

	virtual ~VideoWorker() {
		cleanup();
	}

	virtual void cleanup() {
		_Debug("In VideoWorker.Cleanup()");
		if (!ctxInit) {
			_Debug("Wasnt inited");
			return;
		}
		avcodec_close(codecCtx);
		av_frame_free(&frame);
		avformat_free_context(pFormatCtx);
		avcodec_free_context(&codecCtx);
		av_frame_free(&m_scaledFrame);
		av_free(m_destFrameBuffer);
		_Debug("Done with VideoWorker.Cleanup()");
	}

	void GetEyedropData(int x, int y, int w, int h, int *Y, int* U, int* V) {
		int wl = frame->width;
		int hl = frame->height;
		int sum = 0;
		for (int ctr = 0; ctr <= 2; ctr++) {
			sum = 0;
			if (ctr == 1) {
				x /= 2;
				y /= 2;
				w /= 2;
				h /= 2;
				wl /= 2;
				hl /= 2;
			}
			int x0 = x - w;
			if (x0 < 0) x0 = 0;
			int x1 = x + w;
			if (x1 > wl) x1 = wl;
			int y0 = y - h;
			if (y0 < 0) y0 = 0;
			int y1 = y + h;
			if (y1 > hl) y1 = hl;
			int cnt = 0;
			for (int i = x0; i < x1; i++) {
				for (int j = y0; j < y1; j++) {
					int ind = frame->linesize[ctr] * j + i;
					sum += frame->data[ctr][ind];
					cnt++;
				}
			}
			sum /= cnt;
			if (ctr == 0) *Y = sum; 

			if (ctr == 1) *U = sum;
			if (ctr == 2) *V = sum;
		}
	}

	virtual int GetNativeWidth() {
		return videoStream->codec->width;
	}

	virtual int GetNativeHeight() {
		return videoStream->codec->height;
	}

	virtual double GetFPS() {
		return m_fps;
	}

	virtual uint64_t GetNFrames() {
		return m_nFrames;
	}

	double GetVolume() {
		return source.volume / 255.0*(double)CurAlpha();
	}

	char *GetGSMsg() {
		return gs.GetMsg();
	}

	void CalcGS(bool reset_flag=false) {
		if (!m_scaledFrame || m_scaledFrame->width == 0) return;
		if (source.mode != G_OFF) {
			this->gs.init(source.mode, source.u, source.v, source.tola, source.tolb, scaled_alpha_frame, reset_flag);
			this->gs.PutVideo(m_scaledFrame);
		}
	}

protected:
	bool m_sizeInvalidated;
	int ctxInit;

	GreenScreen gs;

	AVFormatContext* pFormatCtx;
	AVStream* videoStream;

	double duration;
	// to make sure it initalizes, or if first stream is video than it's not
	// clear if it was initialized properly
	int m_stream_index;
	size_t frame_id;

	AVCodec* codec;
	AVCodecContext* codecCtx;

	AVPacket packet;

	int m_lastFrame;

	virtual int OpenMedia()
	{
		_DebugF("In OpenMedia() for video file %s", source.path);
		ctxInit = 1;
		// we're just trying to open a video, invalidate current frame just in case
		m_validFrame = false;
		m_lastFrame = -1;
		pFormatCtx = avformat_alloc_context();
		if (!pFormatCtx) {
			_Error("Failed to avformat_alloc_context()");
			return -1;
		}
		int ret = 0;
		if (0 != (ret = avformat_open_input(&pFormatCtx, source.path, NULL, NULL))) {
			_ErrorF("Failed to avformat_open_input(), error code %d", ret);
			return -1;
		}
		if (0 != (ret = avformat_find_stream_info(pFormatCtx, NULL))) {
			_ErrorF("Failed to find stream info, error code %d", ret);
			return -1;
		}
		duration = (double)pFormatCtx->duration / AV_TIME_BASE;
		_DebugF("found duration %f", duration);
		m_stream_index = -1;
		for (unsigned int i = 0; i < pFormatCtx->nb_streams; ++i)
		{
			if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO)
			{
				videoStream = pFormatCtx->streams[i];
				m_stream_index = i;
			}

		}
		if (m_stream_index == -1) {
			_Error("failed to find video stream!");
			return -1;
		}
		_InfoF("found video stream index as %d", m_stream_index);
		codecCtx = videoStream->codec;
		codec = avcodec_find_decoder(codecCtx->codec_id);
		if (codec == NULL) {
			_Error("codec is null");
			return -1;
		}
		_Info("Codec is OK");
		codecCtx = avcodec_alloc_context3(codec);
		if (0 != (ret = avcodec_copy_context(codecCtx, videoStream->codec))) {
			_ErrorF("unable to copy context, error code %d", ret);
			return -1;
		}
		_Info("avcodec_copy_context OK");
		if (0 != (ret = avcodec_open2(codecCtx, codec, nullptr))) {
			_ErrorF("avcodec_open2 returned %d", ret);
			return -1;
		}
		_Info("avcodec_open2 OK");
		frame = av_frame_alloc();
		if (!frame) {
			_Error("unable to av_frame_alloc()");
			return -1;
		}
		_Info("frame allocated successfully");
		if (videoStream->avg_frame_rate.num != 0) {
			m_fps = ((double)videoStream->avg_frame_rate.num) / ((double)videoStream->avg_frame_rate.den);
		}
		else {
			m_fps = ((double)videoStream->r_frame_rate.num) / ((double)videoStream->r_frame_rate.den);
		}
		_DebugF("fps is %f in file %s", m_fps, source.path);
		char lc[512];
		for (int i = 0; i < strlen(source.path)+1; i++) {
			lc[i] = tolower(source.path[i]);
		}
		if (strstr(lc, ".gif")) {
			// long and stupid way of determining length
			// but there is really no other one in case of gif
			while (!m_ended) {
				AV_read_frame();
			}
			m_nFrames = frame_id + 1;
			Seek(0.0);
			frame_id = 0;
		}
		else m_nFrames = (int)(duration * m_fps);
		_DebugF("m_nFrames is %d", m_nFrames);
		return 0;
	}

	int SetSource(const Source* src, double position) override {
		bool gs_changed = (src->mode != source.mode 
			|| src->w!=source.w || src->h!=source.h 
			|| src->tola!=source.tola || src->tolb!=source.tolb ||
			src->u!=source.u || src->v!=source.v);
		int ret = VisualWorker::SetSource(src, position);
		CalcGS(true);
		if (src->mode != G_OFF) {
			scaled_alpha_frame_valid = true;
		}
		return ret;
	}

	virtual void AV_read_frame() {
		AVPacket packet;
		int frame_done;
		int ctr = 0;
		int err = 0;
		while ((err = av_read_frame(pFormatCtx, &packet)) >= 0) {
			ctr++;
			if (packet.stream_index == m_stream_index) {
				err = avcodec_decode_video2(codecCtx, frame, &frame_done, &packet);
				if (err == 0) {
					_Error("avcodec_decode_video2 returned 0 meaning frame was invalid");
				}
				if (err < 0) {
					_ErrorF("avcodec_decode_video2 returned %d", err);
				}
				if (frame_done && (frame->pict_type != AV_PICTURE_TYPE_NONE || frame->width>100)) {
					ResizeFrameTo(frame, m_scaledFrame, source.w, source.h);
					CalcGS();
					if (alpha_frame) {
						UpdateScaledAlphaFrame(source.w, source.h);
					}
					double pts = 0;
					if (packet.dts != AV_NOPTS_VALUE) {
						pts = (double)av_frame_get_best_effort_timestamp(frame);
					}
					pts *= av_q2d(videoStream->time_base);
					frame_id = (int)(pts*(double)m_fps);
					av_free_packet(&packet);
					break;
				}
			}
		}
		if (err<0) {
			_InfoF("In av_read_frame for VideoWorker: got %d - either EOF or error", err);
		}
		if (!ctr) {
			// end of stream? I think its better to check this when av_read_frame returns value < 0
			m_ended = true;
		}
	}

	// seek only by keyframe, only back, do not read any frames
	// practical application is extraction of thumbnails
	virtual int QuickSeek(double secs) {
		m_validFrame = false;
		int f = GetFrameNumber(secs);
		if (f == -1) {
			m_validFrame = false;
			return -1;
		}
		size_t frame = f;
		int ret = av_seek_frame(pFormatCtx, m_stream_index, 
			(int64_t)((double(frame) / double(this->m_fps))*(videoStream->time_base.den)) / (videoStream->time_base.num),
			AVSEEK_FLAG_BACKWARD);
		if (ret < 0) {
			_ErrorF("av_seek_frame returned %d", ret);
		}
		avcodec_flush_buffers(codecCtx);
		AV_read_frame();
		return 0;
	}

	virtual int Seek(double secs)
	{
		int f = GetFrameNumber(secs);
		if (f == -1) {
			m_validFrame = false;
			return 0;
		}
		size_t frame = f;
		int frame_delta = frame - this->frame_id;
		// we are at beginning of video and need to go to the beginning, 
		// just read a frame so we have it
		if (frame == 0 && frame_delta == 0) {
			AV_read_frame();
			m_validFrame = true;
			m_lastFrame = 0;
			position = 0;
			return 0;
		}
		if (frame_delta < 0 || frame_delta>5) {
			int ret = av_seek_frame(pFormatCtx, m_stream_index, 
				(int64_t)((double(frame) / double(this->m_fps))*(videoStream->time_base.den)) / (videoStream->time_base.num),
				AVSEEK_FLAG_BACKWARD);
			if (ret < 0) {
				_ErrorF("av_seek_frame returned %d", ret);
			}
			avcodec_flush_buffers(codecCtx);
			m_validFrame = false;
			AV_read_frame();
		}
		while (this->frame_id < frame) {
			AV_read_frame();
			if (m_ended) break;
		}
		if (this->frame_id >= frame) {
			m_validFrame = true;
		}
		position = secs;
		return 0;
	}

};

void performThis(void *ptr) {
	VideoWorker *p = (VideoWorker*)ptr;
	p->perform();
}

#endif
