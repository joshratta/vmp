#ifndef VMP_CORE_WORKER_H_
#define VMP_CORE_WORKER_H_

#include "../common/stdafx.h"
#include "../common/audio.h"
#include "../common/utils.h"

// thread stub
void performThis(void *ptr);

class VisualWorker {
public:
	VisualWorker() {
		_Info("In VisualWorker()");
		memset(&source, 0, sizeof(Source));
		source.volume = 1.00;
		m_scaledFrame = av_frame_alloc();
		scaled_alpha_frame = NULL;
		int num_bytes = avpicture_get_size(PIX_FMT_YUV420P, kMaxWidth, kMaxHeight);
		m_destFrameBuffer = (uint8_t *) av_malloc(num_bytes);
		int ret = avpicture_fill((AVPicture*) m_scaledFrame, m_destFrameBuffer,
				PIX_FMT_YUV420P, kMaxWidth, kMaxHeight);
		if (ret <= 0) {
			_ErrorF(
					"avpicture_fill returned %d when allocating m_destFrameBuffer",
					ret);
		}
		m_scaledFrame->format = AV_PIX_FMT_YUV420P;

		alpha_data = NULL;
		alpha_frame = NULL;

		scaled_alpha_data = (uint8_t*) malloc(kMaxWidth * kMaxHeight);
		ResizeAlphaFrame(kMaxWidth, kMaxHeight);
		scaled_alpha_frame_valid = false;

		_Info("VisualWorker() done");
	}

	virtual ~VisualWorker() {

	}

	virtual bool validFrame() const {
		return m_validFrame;
	}

	virtual char *GetGSMsg() {
		return NULL;
	}
	virtual uint64_t GetNFrames() = 0;
	virtual int OpenMedia() = 0;
	virtual int Seek(double secs) = 0;
	virtual int QuickSeek(double secs) = 0;
	virtual int GetNativeWidth() = 0;
	virtual int GetNativeHeight() = 0;

	virtual uint8_t CurAlpha() {
		double secs = position - this->source.position;
		// fade in ended, fadeout hasn't started yet
		if (secs < 0 || secs > this->source.duration
				|| (secs >= this->source.fadeIn
						&& secs <= this->source.duration - this->source.fadeout)) {
			return 255;
		}
		// fadeIn
		if (secs < this->source.fadeIn) {
			return (uint8_t) (255.0 * secs / source.fadeIn);
		}
		// fadeout
		secs -= (this->source.duration - this->source.fadeout);
		return (uint8_t) (255.0 - 255.0 * secs / source.fadeout);
	}

	virtual AVFrame* GetAlphaFrame() {
		if (scaled_alpha_frame_valid)
			return scaled_alpha_frame;
		else
			return NULL;
	}

	virtual AVFrame* GetScaledFrame() {
		return m_scaledFrame;
	}

	virtual int SetSource(const Source* src, double position) {
		_Info("in SetSource()");
		bool source_changed = true;
		if (src->path[0] && source.path[0] && !strcmp(src->path, source.path)
				&& eq(src->position, source.position)
				&& eq(src->internalPosition, source.internalPosition)) {
			source_changed = false;
		} else
			m_validFrame = false;
		bool size_changed = (src->w != source.w || src->h != source.h);
		source.copy(*src);
		// if video is same, just the position or size has changed, don't re-read entire video
		// as it will cause slowness when resizing video due to time consumed with
		// frame-precise seek: why doing it if we are on the required frame already?
		_InfoF("source_changed: %s, size_changed: %s", source_changed?"true":"false", size_changed?"true":"false");
		if (source_changed) {
			int res = OpenMedia();
			if (res < 0) {
				_ErrorF("OpenMedia() returned %d", res);
				return res;
			}
			if (!m_scaledFrame)
				return -1;
			res = Seek(position);
			if (res < 0) {
				_ErrorF("Seek() returned %d", res);
				return res;
			}
		} else if (size_changed) {
			int res = ResizeFrameTo(frame, m_scaledFrame, source.w, source.h);
			if (res < 0) {
				_ErrorF("ResizeFrameTo() returned %d", res);
				return res;
			}
		}
		_Info("Done with SetSource()");
		return 0;
	}

	double GetFPS() {
		return m_fps;
	}

	Source* GetSource() const {
		return (Source*) &source;
	}

	char* GetId() {
		return source.id;
	}

	thread* addTask(const videoTask& vt) {
		taskQueue.push(vt);
		return new thread(performThis, this);
	}

	thread* addTaskSyncronous(const videoTask& vt) {
		taskQueue.push(vt);
		return NULL;
	}

	bool ended() {
		return m_ended;
	}

	// maybe size of the image has changed
	void CheckSize() {
		if (m_validFrame) {
			if ((int)source.w / 2 != (int)m_scaledFrame->width / 2 ||
				(int)source.h / 2 != (int)m_scaledFrame->height / 2) {
				ResizeFrameTo(frame, m_scaledFrame, source.w, source.h);
			}
		}
		if (alpha_frame && scaled_alpha_frame_valid && 
			((int)(scaled_alpha_frame->width/2)!=(int)(source.w/2) || 
			(int)(scaled_alpha_frame->height / 2) != (int)(source.h / 2))) {
			UpdateScaledAlphaFrame(source.w, source.h);
		}
	}

	void perform()
	{
		videoTask currentTask;
		bool hasToExit = false;
		if (!taskQueue.empty())
		{
			currentTask = taskQueue.front();
			switch (currentTask.task)
			{
			case VTASK_EXIT:
				hasToExit = true;
				break;
			case VTASK_PLAY:
				// play a frame of the current video matching the currentTask.position
				Seek(currentTask.position);
				CheckSize();
				currentTask.task = VTASK_NOP;
				break;
			case VTASK_QSEEK:
				QuickSeek(currentTask.position);
				CheckSize();
				// seek only to keyframe. misses by several seconds but very fast
				// useful for thumbnails and other lower grade uses 
				currentTask.task = VTASK_NOP;
				break;
			case VTASK_SEEK:
				Seek(currentTask.position);
				CheckSize();
				// do nothing, play() operation seeks if needed
				currentTask.task = VTASK_NOP;
				break;
			case VTASK_STOP:
				break;
			case VTASK_NOP:
				break;
			}
			taskQueue.pop();
		}
	}

protected:
	Source source;
	bool m_ended;
	queue<videoTask> taskQueue;
	// the current/most recent frame read from the stream
	AVFrame* frame;
	bool m_validFrame;
	double position;
	double m_fps;
	uint8_t* m_destFrameBuffer;
	AVFrame* m_scaledFrame;
	int m_nFrames;

	unsigned char* alpha_data;
	AVFrame* alpha_frame;
	unsigned char* scaled_alpha_data;
	AVFrame* scaled_alpha_frame;
	bool scaled_alpha_frame_valid;



	int GetFrameNumber(double position) {
		if (position < source.position) {
			// hasnt started yet
			return -1;
		}
		if (position > source.position + source.duration) {
			// already ended;
			m_ended = true;
			return -1;
		}
		m_ended = false;
		double nframe = position - source.position + source.internalPosition;
		// now find this position in our internal timeline
		nframe *= (double) m_fps;
		return (int) std::round(nframe);
	}

	void ResizeAlphaFrame(int w, int h) {
		av_frame_free(&scaled_alpha_frame);
		scaled_alpha_frame = av_frame_alloc();
		avpicture_fill((AVPicture *) scaled_alpha_frame, scaled_alpha_data,
				AV_PIX_FMT_GRAY8, w, h);
		scaled_alpha_frame->format = AV_PIX_FMT_GRAY8;
	}

	int UpdateScaledAlphaFrame(int w, int h) {
		ResizeAlphaFrame(w, h);
		scaled_alpha_frame_valid = true;
		return ResizeFrameTo(alpha_frame, scaled_alpha_frame, w, h);
	}

};

#endif
