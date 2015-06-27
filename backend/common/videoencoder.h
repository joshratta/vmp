#ifndef VMP_COMMON_VIDEOENCODER_H_
#define VMP_COMMON_VIDEOENCODER_H_

#include "stdafx.h"
#include "audio.h"
#include "const.h"
#include "utils.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#include "log.h"

using std::thread;

extern Log _log;

class VideoEncoder;
void encodeStub(VideoEncoder *ptr);

class VideoEncoder {
public:

	VideoEncoder(int width, int height, int fps, char *fname) :
			m_width(width), m_height(height), m_fps(fps) {

		_DebugF("In VideoEncoder(), filename is %s, fps is %d", fname, fps);

		st = NULL;
		supports_small_last_frame = 0;
		vcodec = NULL;
		p_aCodec = NULL;
		p_aOutStrm = NULL;
		p_aCodecCtx = NULL;
		p_aOutStrm = NULL;
		fmtCtx = NULL;
		format = 0;
		frame_size = 0;
		internalFrame = NULL;
		ioCtx = NULL;
		m_buffer = NULL;
		m_bufferSize = 0;
		p_outStrm = NULL;
		sample_size = 0;

		thr = NULL;

		m_cf = -1;
		align = 1;
		audio_time = 0;
		prev_pts = 0;

		memset(&pkt, 0, sizeof(AVPacket));

		memcpy(&file_name, fname, strlen(fname) + 1);

		bufferSize = 0;
		c = NULL;
		codec = NULL;
		expectedBufferSize = 0;

		_Debug("Done with VideoEncoder()");
	}

	// because certain things can fail here, put it into a separate function that
	// returns a return code rather than leave it in constructor
	int Init(bool need_sound = true) {
		_Debug("in Init() for VideoEncoder");

		const char *format_name = "flv";

		internalFrame = av_frame_alloc();

		if (!internalFrame) {
			_Error("unable to allocate internalFrame");
			return -1;
		}

		m_bufferSize = avpicture_get_size(PIX_FMT_YUV420P, m_width, m_height);
		_DebugF(
				"Reported size for picture of PIX_FMT_YVU420P %d by %d pixels is %d",
				m_width, m_height, m_bufferSize);
		m_buffer = new uint8_t[m_bufferSize];
		memset(m_buffer, 0, m_bufferSize);
		int res = avpicture_fill((AVPicture*) internalFrame, m_buffer,
				PIX_FMT_YUV420P, m_width, m_height);
		if (res > 0) {
			_DebugF(
					"picture filled and took %d bytes (should be same as the line above)",
					res);
		} else {
			_ErrorF("Unable to fill picture, error code is %d", res);
			return -1;
		}
		internalFrame->width = m_width;
		internalFrame->height = m_height;

		int averr;

		format = NULL;
		for (AVOutputFormat *formatIter = av_oformat_next(NULL);
				formatIter != NULL; formatIter = av_oformat_next(formatIter)) {
			bool hasEncoder = (NULL != avcodec_find_encoder(formatIter->audio_codec));
			if (hasEncoder && 0 == strcmp(format_name, formatIter->name)) {
				format = formatIter;
				break;
			}
		}
		if (!format) {
			_ErrorF("Unable to find format %s", format_name);
			return -1;
		}
		_DebugF("Found format %s", format->name);
		fmtCtx = avformat_alloc_context();
		if (!fmtCtx) {
			_Error("error allocating AVFormatContext");
			return -1;
		}
		fmtCtx->oformat = format;

		if (need_sound) {
			_Debug("Setting up audio");

			codec = avcodec_find_encoder(AV_CODEC_ID_PCM_S16LE);
			if (!codec) {
				_Error("Could not find audio codec");
				return -1;
			}
			st = avformat_new_stream(fmtCtx, codec);
			if (!st) {
				_Error("error allocating AVStream");
				return -1;
			}
			if (fmtCtx->nb_streams != 1) {
				_ErrorF(
						"avformat_new_stream should have incremented nb_streams, but it's still %d",
						fmtCtx->nb_streams);
				return -1;
			}
			c = st->codec;
			if (!c) {
				_Error(
						"avformat_new_stream should have allocated a AVCodecContext for my stream");
				return -1;
			}
			st->id = fmtCtx->nb_streams - 1;
			_InfoF("Created stream %d", st->id);
			if (0 != (format->flags & AVFMT_GLOBALHEADER)) {
				c->flags |= CODEC_FLAG_GLOBAL_HEADER;
			}
			c->bit_rate = kAudioBandwidth;
			int bestSampleRate = kAudioSampleRate;
			c->sample_rate = bestSampleRate;
			c->channel_layout = AV_CH_LAYOUT_STEREO;
			c->channels = av_get_channel_layout_nb_channels(c->channel_layout);
			c->time_base.num = 1;
			c->time_base.den = c->sample_rate;
			if (c->channels != 2) {
				_ErrorF(
						"av_get_channel_layout_nb_channels returned %d instead of 2",
						c->channels);
				return -1;
			}
			c->sample_fmt = AV_SAMPLE_FMT_S16;
			if ((averr = avcodec_open2(c, codec, NULL)) < 0) {
				_ErrorF("avcodec_open2 returned error ", averr);
				return -1;
			}

			_Info("Setting up audio done, now set up video");
		} else
			_Info("Audio is off");
		ioCtx = NULL;
		// set up video
		vcodec = avcodec_find_encoder(format->video_codec);
		if (!vcodec) {
			_Error("cannot find video encoder");
			return -1;
		}
		p_outStrm = avformat_new_stream(fmtCtx, vcodec);
		if (!p_outStrm) {
			_Error("cannot create a video stream");
			return -1;
		}
		res = avcodec_get_context_defaults3(p_outStrm->codec, vcodec);
		if (res != 0) {
			_ErrorF("avcodec_get_context_defaults3 returned %d", res);
			return -1;
		}
		p_outStrm->codec->codec_id = format->video_codec;
		p_outStrm->time_base.num = 1;
		p_outStrm->time_base.den = 1000;
		p_outStrm->codec->width = m_width;
		p_outStrm->codec->height = m_height;
		p_outStrm->codec->bit_rate = kVideoBandwidth;
		p_outStrm->codec->pix_fmt = PIX_FMT_YUV420P;
		p_outStrm->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
		p_outStrm->codec->time_base = p_outStrm->time_base;
		p_outStrm->codec->codec_type = AVMEDIA_TYPE_VIDEO;
		p_outStrm->codec->gop_size = 5;
		int vOpenRes = avcodec_open2(p_outStrm->codec, vcodec, nullptr);
		if (vOpenRes<0) {
			_ErrorF("avcodec_open2 returned %d", vOpenRes);
		}
		if (0 != (averr = avio_open(&ioCtx, file_name, AVIO_FLAG_WRITE))) {
			_ErrorF("avio_open returned error %d", averr);
			return -1;
		}
		if (ioCtx == NULL) {
			_Error("AVIOContext should have been set by avio_open");
			return -1;
		}
		fmtCtx->pb = ioCtx;
		if (0 != (averr = avformat_write_header(fmtCtx, NULL))) {
			_ErrorF("avformat_write_header returned error %d", averr);
			return -1;
		}

		if (need_sound) {
			align = 1;

			sample_size = av_get_bytes_per_sample(c->sample_fmt);
			if (sample_size != sizeof(int16_t)) {
				_ErrorF("expected sample size=%d but got %d", (sizeof(int16_t)),
						sample_size);
				return -1;
			}
			frame_size = c->frame_size != 0 ? c->frame_size : 4096;
			bufferSize = av_samples_get_buffer_size(NULL, c->channels,
					frame_size, c->sample_fmt, align);
			expectedBufferSize = frame_size * c->channels * sample_size;
			supports_small_last_frame =
					c->frame_size == 0 ?
							1 :
							0
									!= (codec->capabilities
											& CODEC_CAP_SMALL_LAST_FRAME);
			if (bufferSize != expectedBufferSize) {
				_ErrorF("expected buffer size=%d but got %d\n",
						expectedBufferSize, bufferSize);
				return -1;
			}
		}
		_InfoF(
				"Wrote header. fmtCtx->nb_streams=%d, st->time_base=%d/%d; st->avg_frame_rate=%d/%d\n",
				fmtCtx->nb_streams, p_outStrm->time_base.num,
				p_outStrm->time_base.den, p_outStrm->avg_frame_rate.num,
				p_outStrm->avg_frame_rate.den);

		_Info("Finished Init() for VideoEncoder(), video can now be encoded");
		return 0;
	}

	char file_name[MAX_PATH + 1];

	int frame_size;
	int bufferSize;
	int expectedBufferSize;
	int supports_small_last_frame;
	AVOutputFormat *format;
	AVCodec *codec;
	AVCodec *vcodec;
	AVFormatContext *fmtCtx;
	AVStream *st;
	AVCodecContext *c;
	AVIOContext *ioCtx;
	int align;
	int sample_size;
	uint32_t audio_time;
	// check that we dont publish 2 same pts in a row;
	uint32_t prev_pts;
	AVPacket pkt;

	AVFrame *internalFrame;
	int m_bufferSize;
	uint8_t* m_buffer;

	thread *thr;

	void JoinThread() {
		if (!thr)
			return;
		if (!thr->joinable())
			return;
		thr->join();
	}

	void encodeFrame(AVFrame* frame) {
		encodeFrame(frame, (double) (++m_cf) / m_fps);
	}

	void encodeFrame(AVFrame* frame, double time, bool need_thread=true) {
		// don't start encoding next frame if previous one hasn't finished yet
		if (need_thread && thr != NULL && thr->joinable()) {
			thr->join();
			delete thr;
		}
		// make a copy of AVFrame because it is a pointer which can be
		// altered in main thread while encoding is happening, resulting
		// in trash output
		frame->format = AV_PIX_FMT_YUV420P;
		av_picture_copy((AVPicture*) internalFrame, (AVPicture*) frame,
				(AVPixelFormat) frame->format, frame->width, frame->height);
		internalFrame->format = AV_PIX_FMT_YUV420P;
		internalFrame->pts = (int64_t) (time * p_outStrm->codec->time_base.den
				/ p_outStrm->codec->time_base.num);
		_DebugF("v pts: %" PRIu64 "", internalFrame->pts);
		if (need_thread) {
			thr = new std::thread(encodeStub, this);
		}
		else {
			doEncodeVideoFrame();
		}
	}

	void doEncodeVideoFrame() {
		int gp = 0;
		av_free_packet(&pkt);

		int size_act = avcodec_encode_video2(p_outStrm->codec, &pkt,
				internalFrame, &gp);
		if (size_act<0) {
			_ErrorF("avcodec_encode_video2 returned %d", size_act);
		}
		pkt.stream_index = p_outStrm->index;
		int err = av_write_frame(fmtCtx, &pkt);
		if (err < 0) {
			_FailF("error writing video frame %d !", err);
		}
	}

	uint32_t encodeAudioFrame(SoundFrame *a) {
		AVFrame *frame = av_frame_alloc();
		if (frame == NULL) {
			_Error("unable to allocate audio frame!");
		}
		bufferSize = kAudioPacketSamples;
		frame->nb_samples = bufferSize;
		frame->pts = av_rescale_q(prev_pts, c->time_base, st->time_base);
		_DebugF("a pts: %" PRIu64 "", frame->pts);
		int num_bytes = avcodec_fill_audio_frame(frame, c->channels,
				c->sample_fmt, (const uint8_t*) a->data, bufferSize * 4, align);
		if (num_bytes<0) {
			_ErrorF("avcodec_fill_audio_frame returned %d", num_bytes);
		}
		AVPacket packet;
		av_init_packet(&packet);
		packet.data = NULL;
		packet.size = 0;
		int got_packet;
		int ret = 0;
		if (0 != (ret = avcodec_encode_audio2(c, &packet, frame, &got_packet))) {
			_ErrorF("avcodec_encode_audio2 returned %d", ret);
		}
		if (got_packet) {
			packet.stream_index = st->index;
			if (0 < (ret = av_write_frame(fmtCtx, &packet))) {
				_ErrorF("av_write_frame returned %d", ret);
			}
		}
		av_free_packet(&packet);
		av_frame_free(&frame);
		int pt = prev_pts;
		prev_pts += kAudioPacketSamples;
		return pt;
	}

	~VideoEncoder() {
		_Info("In ~VideoEncoder()");
		av_write_trailer(fmtCtx);
		avio_close(fmtCtx->pb);
		av_free(fmtCtx);
		_Info("Done with ~VideoEncoder()");
	}
	int m_cf;

private:

	AVStream* p_outStrm;

	int m_width;
	int m_height;

	int m_fps;

	AVStream* p_aOutStrm;
	AVCodec* p_aCodec;
	AVCodecContext* p_aCodecCtx;

};

void encodeStub(VideoEncoder *ptr) {
	ptr->doEncodeVideoFrame();
}

#endif
