#ifndef VMP_CORE_SOUND_WORKER_H_
#define VMP_CORE_SOUND_WORKER_H_

#include "../common/stdafx.h"
#include "../common/utils.h"
#include "../common/audio.h"
#include "../common/log.h"

extern Log _log;

#include "Source.h"

class SoundWorker {
public:
	SoundWorker() {
		position = 0;

		m_validFrame = false;
		pFormatCtx = NULL;
		loop_flag = false;
		swr_ctx=NULL;
		frames = NULL;
		last_frame = NULL;
		m_ended = false;

		src_ch_layout = AV_CH_LAYOUT_STEREO;
		dst_ch_layout = AV_CH_LAYOUT_STEREO;
		src_rate = 44100;
		dst_rate = 44100;
		src_data = NULL;
		src_nb_channels = 0;
		dst_nb_channels = 2;
		src_linesize=1024;
		dst_linesize=1024;
		src_nb_samples = 1024;
		dst_nb_samples=1024;
		max_dst_nb_samples=1024;
		src_sample_fmt = AV_SAMPLE_FMT_FLT;
		dst_sample_fmt = AV_SAMPLE_FMT_S16;

		aCodec = NULL;
		aCodecCtx = NULL;
		aCodecCtxOrig = NULL;
		audioStream = NULL;
		frame = NULL;

		audioStreamIndex = 0;
		dst_bufsize = 0;
		duration = 0;
	}

	uint32_t GetLastPts() {
		if (!last_frame) return 0;
		return last_frame->pts;
	}

	int32_t GetIdealPts(double s) {
		return int32_t(double(dst_rate) * ((s)-source.position + source.internalPosition));
	}

	void ReadNext() {
		if (frames && frames->next) {
			return;
		}
		double p = position+1024.0/44100.0;
		if (frames) p+=frames->filled/44100.0;
		if (!frames) {
			free(frames);
		}
		Seek(p);
	}

	SoundFrame* GetNext() {
		if (frames == NULL) { return NULL;  }
		SoundFrame* res = frames;
		frames = frames->next;
		return res;
	}

	SoundFrame* GetNextAudioFrame(double secs) {
		if (-1 == audioStreamIndex) return NULL;
		if (GetIdealPts(secs) < 0) {
			return NULL;
		}
		Seek(secs);
		if (!frames) {
			return NULL;
		}
		SoundFrame* res = frames;
		frames = frames->next;
		while (res->next && res->pts < GetIdealPts(secs)) {
			free(res);
			res = frames;
			frames = frames->next;
		}
		return res;
	}

	~SoundWorker() {
		Cleanup();
	}

	void Cleanup() {
		_DebugF("Cleanup() for SoundWorker for asset %s", source.path);
		avcodec_close(aCodecCtx);
		avformat_free_context(pFormatCtx);
		avcodec_free_context(&aCodecCtx);
		swr_free(&swr_ctx);
		_DebugF("Cleanup() for SoundWorker for asset %s - DONE", source.path);
	}

	bool ended() {
		return m_ended;
	}

	char *GetId() {
		return source.id;
	}

	int SetSource(Source *s, double p) {
		source.copy(*s);
		position = 0;
		return OpenMedia();
	}
	
	double GetVolume() {
		return source.volume / 255.0*(double)CurAlpha();
	}

	uint8_t CurAlpha() {
		double secs = position - this->source.position;
		// fade in ended, fadeout hasn't started yet
		if (secs<0 || secs>this->source.duration ||
			(secs >= this->source.fadeIn && secs <= this->source.duration - this->source.fadeout)) {
			return 255;
		}
		// fadeIn
		if (secs < this->source.fadeIn) {
			return (uint8_t)(255.0*secs / source.fadeIn);
		}
		// fadeout
		secs -= (this->source.duration - this->source.fadeout);
		return (uint8_t)(255.0 - 255.0*secs / source.fadeout);
	}

	double GetDuration() {
		return duration;
	}

protected:

	Source source;

	// contains all zeros, for padding
	SoundFrame null_frame;

	double position;
	bool loop_flag;

	SoundFrame* frames;
	SoundFrame* last_frame;

	AVFormatContext* pFormatCtx;

	AVCodecContext *aCodecCtxOrig;
	AVCodecContext *aCodecCtx;
	AVCodec *aCodec;
	AVStream* audioStream;
	AVFrame* frame;

	double duration;
	int audioStreamIndex;

	bool m_validFrame;
	bool m_ended;

	int64_t src_ch_layout, dst_ch_layout;
	int src_rate, dst_rate;
	uint8_t **src_data;
	uint8_t dst_data[128 * 1024];
	int src_nb_channels, dst_nb_channels;
	int src_linesize, dst_linesize;
	int64_t src_nb_samples, dst_nb_samples, max_dst_nb_samples;
	enum AVSampleFormat src_sample_fmt, dst_sample_fmt;
	int dst_bufsize;
	struct SwrContext *swr_ctx;

	int OpenMedia()
	{
		_DebugF("in OpenMedia for file %s", source.path);
		m_validFrame = false;
		pFormatCtx = avformat_alloc_context();
		if (!pFormatCtx) {
			_Error("Failed to avformat_allow_context()");
			return -1;
		}
		int ret = 0;
		if (0 != (ret = avformat_open_input(&pFormatCtx, source.path, NULL, NULL))) {
			_ErrorF("Failed to avformat_open_input() for source file %s, error code %d", source.path, ret);
			return -1;
		}
		if (0 != (ret = avformat_find_stream_info(pFormatCtx, NULL))) {
			_ErrorF("Failed to avformat_find_stream_info(), error %d", ret);
			return -1;
		}
		duration = (double)pFormatCtx->duration / AV_TIME_BASE;
		for (unsigned int i = 0; i < pFormatCtx->nb_streams; ++i)
		{
			if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO)
			{
				audioStream = pFormatCtx->streams[i];
				audioStreamIndex = i;
			}
		}
		if (-1 == audioStreamIndex) {
			_Error("Failed to find audio stream");
			return -1;
		}
		_DebugF("Found an audio stream at %d", audioStreamIndex);
		aCodecCtxOrig = pFormatCtx->streams[audioStreamIndex]->codec;

		aCodec = avcodec_find_decoder(aCodecCtxOrig->codec_id);
		if (!aCodec) {
			_Error("Unsupported codec!");
			return -1;
		}

		aCodecCtx = avcodec_alloc_context3(aCodec);
		if (avcodec_copy_context(aCodecCtx, aCodecCtxOrig) != 0) {
			_Error("Couldn't copy codec context!");
			return -1;
		}

		int r = avcodec_open2(aCodecCtx, aCodec, NULL);
		if (r) {
			_ErrorF("avcodec_open2 returned %d", r);
			return -1;
		}

		frame = av_frame_alloc();
		if (!frame) {
			_Error("Failed to allocate avframe");
			return -1;
		}

		src_sample_fmt = aCodecCtx->sample_fmt;
		src_rate = aCodecCtx->sample_rate;
		src_ch_layout = aCodecCtx->channel_layout;
		src_nb_channels = aCodecCtx->channels;
		if (0 == src_ch_layout && 1 == src_nb_channels) {
			src_ch_layout = AV_CH_LAYOUT_MONO;
		}
		if (0 == src_ch_layout && 2 == src_nb_channels) {
			src_ch_layout = AV_CH_LAYOUT_STEREO;
		}

		/* allocate source and destination samples buffers */

		int res = InitSWR();
		if (res) {
			_Error("Failed to initialize audio resample context");
			return -1;
		}
		return 0;
	}

	int InitSWR() {
		_Debug("Init SWR resample context");
		/* create resampler context */
		swr_ctx = swr_alloc();
		if (!swr_ctx) {
			_Error("Could not allocate resampler context");
			return -1;
		}
		/* set options */
		int ret = av_opt_set_int(swr_ctx, "in_channel_layout", src_ch_layout, 0);
		if (0 != ret) {
			_ErrorF("av_opt_set_int for in_channel_layout returned %d when called with %d argument", ret, src_ch_layout);
			return -1;
		}
		ret = av_opt_set_int(swr_ctx, "in_sample_rate", src_rate, 0);
		if (0 != ret) {
			_ErrorF("av_opt_set_int for in_sample_rate returned %d when called with %d argument", ret, src_rate);
			return -1;
		}
		ret = av_opt_set_sample_fmt(swr_ctx, "in_sample_fmt", src_sample_fmt, 0);
		if (0 != ret) {
			_ErrorF("av_opt_set_sample_fmt for in_sample_fmt returned %d when called with %d argument", ret, src_sample_fmt);
			return -1;
		}
		ret = av_opt_set_int(swr_ctx, "out_channel_layout", dst_ch_layout, 0);
		if (0 != ret) {
			_ErrorF("av_opt_set_int for out_channel_layout returned %d when called with %d argument", ret, dst_ch_layout);
			return -1;
		}
		ret = av_opt_set_int(swr_ctx, "out_sample_rate", dst_rate, 0);
		if (0 != ret) {
			_ErrorF("av_opt_set_int for out_sample_rate returned %d when called with %d argument", ret, dst_rate);
			return -1;
		}
		ret = av_opt_set_sample_fmt(swr_ctx, "out_sample_fmt", dst_sample_fmt, 0);
		if (0 != ret) {
			_ErrorF("av_opt_set_sample_fmt for out_sample_fmt returned %d when called with %d argument", ret, dst_sample_fmt);
			return -1;
		}
		/* initialize the resampling context */
		if ((ret = swr_init(swr_ctx)) < 0) {
			_ErrorF("Failed to initialize the resampling context, error %d", ret);
			return -1;
		}
		ret = av_samples_alloc_array_and_samples(&src_data, &src_linesize, src_nb_channels,
			(int)src_nb_samples, src_sample_fmt, 0);
		if (ret < 0) {
			_ErrorF("Could not allocate source samples, error %d", ret);
			return -1;
		}

		/* compute the number of converted samples: buffering is avoided
		* ensuring that the output buffer will contain at least all the
		* converted input samples */
		max_dst_nb_samples = dst_nb_samples =
			av_rescale_rnd(src_nb_samples, dst_rate, src_rate, AV_ROUND_UP);
		_DebugF("dst_nb_samples computed as %d", dst_nb_samples);
		dst_nb_channels = av_get_channel_layout_nb_channels(dst_ch_layout);
		_DebugF("dst_nb_channels computed as %d", dst_nb_channels);
		memset(dst_data, 0, 128 * 1024);
		_Debug("Done initializing audio resample context");
		return 0;
	}

	double GetTime(int64_t t, AVPacket*p, AVFormatContext *c) {
		return ((double)t)*c->streams[p->stream_index]->time_base.num /
			c->streams[p->stream_index]->time_base.den;
	}

	void AV_read_frame() {
		AVPacket packet;
		int frame_done;
		int ctr = 0;
		int audio_ctr = 0;
		if (!frame) { frame = av_frame_alloc(); }
		while (av_read_frame(pFormatCtx, &packet) >= 0) {
			ctr++;
			if (packet.stream_index == audioStreamIndex) {
				avcodec_decode_audio4(aCodecCtx, frame, &frame_done, &packet);
				if (frame_done) {
					src_nb_samples = frame->nb_samples;
					/* compute destination number of samples */
					int64_t delay = swr_get_delay(swr_ctx, src_rate);
					dst_nb_samples = av_rescale_rnd(delay +
						src_nb_samples, dst_rate, src_rate, AV_ROUND_UP);
					/* convert to destination format */
					uint8_t* arr[8];
					arr[0] = (uint8_t*)dst_data;

					int ret = swr_convert(swr_ctx, (uint8_t**)&arr, (int)dst_nb_samples, (const uint8_t **)frame->data, (int)src_nb_samples);
					if (ret < 0) {
						_ErrorF("error while converting sound, code %d", ret);
					}
					dst_bufsize = av_samples_get_buffer_size(&dst_linesize, dst_nb_channels,
						ret, dst_sample_fmt, 1);
					if (dst_bufsize < 0) {
						_ErrorF("could not get sample buffer size, code %d", dst_bufsize);
					}

					int copied = 0;
					while (dst_bufsize) {
						int piece = dst_bufsize/4;
						// pack it to the end of the last frame
						
						// detect if we will be putting it into new frame or end of last frame
						// if there are frames existing, and last frame is PARTIALLY filled - 
						// use last frame, otherwise create new
						int new_frame = 1;
						if (last_frame && last_frame->filled > 0 && last_frame->filled<1024) {
							new_frame = 0;
						}

						// determine size of object to be packed
						if (!new_frame) {
							int sz = 1024 - last_frame->filled;
							if (piece > sz) {
								piece = sz;
							}
						}
						// frame is not bigger than 1024 samples
						if (piece > 1024) {
							piece = 1024;
						}
						SoundFrame *f;
						if (new_frame) {
							f = (SoundFrame*)malloc(sizeof(struct SoundFrame));
							memset(f, 0, sizeof(struct SoundFrame));
							f->pts = uint32_t(GetTime(packet.pts, &packet, pFormatCtx) * dst_rate + copied);
							f->next = NULL;
							f->filled = 0;
							if (this->frames == NULL) {
								this->frames = f;
								this->last_frame = f;
								this->frames->next = NULL;
							}
							else {
								this->last_frame->next = f;
								this->last_frame = f;
							}
						}
						else {
							f = last_frame;
						}
						memcpy(f->data + f->filled*4, dst_data+copied*4, piece*4);
						f->filled += piece;
						position = (double)f->pts/44100.0+source.position-source.internalPosition;
						dst_bufsize -= piece*4;
						copied += piece;
					}
					audio_ctr++;
					av_free_packet(&packet);
					break;
				}
			
			}
			av_free_packet(&packet);
		}
		if (!ctr) {
			// end of stream? I think its better to check this when av_read_frame returns value < 0
			m_ended = true;
		}
	}

	void EmptyCache() {
		while (frames != NULL) {
			SoundFrame *n = frames->next;
			free(frames);
			frames = n;
		}
		last_frame = NULL;
	}

	void Seek(double secs)
	{
		if (-1 == audioStreamIndex) {
			return;
		}
		// find where we should start, and where we should finish
		uint32_t pts_start = GetIdealPts(secs);
		uint32_t pts_end = GetIdealPts(kCachedDuration + secs);
		// if this is before the stream start, or after it finishes, decline
		if (pts_start < uint32_t((double)source.internalPosition*(double)dst_rate)
			|| pts_end > uint32_t((double)(source.internalPosition + source.duration)*(double)dst_rate)) {
			if (pts_end > uint32_t((double)(source.internalPosition + source.duration)*(double)dst_rate)) {
				m_ended = true;
			}
			else {
				m_ended = false;
			}
			m_validFrame = false;
			return;
		}
		m_ended = false;
		int pts_delta = pts_start - (!frames?INT_MIN:frames->pts);
		// we are at beginning of video and need to go to the beginning, 
		// just read a frame so we have it
		if (pts_start == 0 && pts_delta == 0) {
			while ((!frames) || GetLastPts()<pts_end) {
				AV_read_frame();
				if (m_ended) break;
			}
			if (!m_ended) 
				m_validFrame = true;
			return;
		}
		// if we are closer than seek_threshold packets from target, or
		// past target, clear all cached packets, and Seek
		if (pts_delta < (0 - 1024) || pts_delta>kSeekThreshold*dst_nb_samples || (frames && frames->pts>pts_end)) {
			EmptyCache();
			int64_t pts_seek = int64_t(((double)pts_start / (double)dst_rate)*(double)audioStream->time_base.den / (double)audioStream->time_base.num);
			int ret = av_seek_frame(pFormatCtx, audioStreamIndex, pts_seek, AVSEEK_FLAG_ANY);
			if (ret<0) {
				_ErrorF("av_seek_frame returned %d", ret);
			}
			avcodec_flush_buffers(aCodecCtx);
			m_validFrame = false;
			AV_read_frame();
		}
		// now, read to contain at least 5 audio frames, which is about
		// 0.12s or at least 2 video frames worth of audio
		while (!last_frame || (last_frame->pts < pts_end)) {
			AV_read_frame();
			if (m_ended) break;
		}
		if (!m_ended && last_frame->pts >= pts_end) {
			m_validFrame = true;
		};
	}

};

#endif
