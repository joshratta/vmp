#ifndef VMP_CORE_CONTROLLER_H_
#define VMP_CORE_CONTROLLER_H_

#include "../common/utils.h"
#include "../common/socketutils.h"
#include "../common/compatibility.h"
#include "../common/const.h"
#include "../common/stdafx.h"
#include "../common/videoencoder.h"
#include "../common/pipes.h"
#include "SoundWorker.h"
#include "VisualWorker.h"
#include "VideoWorker.h"
#include "AnimationWorker.h"
#include "PictureWorker.h"
#include "OrderManager.h"

using std::vector;
using std::advance;

class Controller: public CommandProcessor {
public:
	int m_fps;
	int64_t m_framedelta;
	int64_t m_tv;

	OrderManager orderManager;

	double m_stopat;

	Controller(const int width, const int height) :
			m_videoWidth(width), m_videoHeight(height) {
#ifndef _WIN32
        signal(SIGPIPE, SIG_IGN);
#endif
		m_pause = true;
		m_canUnpause = false;
        m_multiple = 1.0;
		m_sws = sws_alloc_context();
		m_stopat = -1.0;
		scaled = av_frame_alloc();

		m_testval = 0;
		m_bufferSize = avpicture_get_size(PIX_FMT_YUV420P, m_videoWidth,
				m_videoHeight);

		m_buffer = new uint8_t[m_bufferSize];
		memset(m_buffer, 0, m_bufferSize);
		m_currentResult = av_frame_alloc();
		avpicture_fill((AVPicture*) m_currentResult, m_buffer, PIX_FMT_YUV420P,
				m_videoWidth, m_videoHeight);
		m_currentResult->width = m_videoWidth;
		m_currentResult->height = m_videoHeight;

		Y = 0;
		Cb = 128;
		Cr = 128;
		m_fps = 24;
		fillblack();
#ifdef _WIN32
		p_ve = new VideoEncoder(m_videoWidth, m_videoHeight, m_fps, pipeName());
#else
		const char *dev_stdout = "/dev/stdout";
		p_ve = new VideoEncoder(m_videoWidth, m_videoHeight, m_fps,
				(char*) dev_stdout);
#endif
		p_ve->Init();

		m_renderMode = true;

		m_tv = TimeMs();
		// ms between frames
		m_framedelta = 1000 / m_fps;
	}

	~Controller() {
		_Info("In ~Controller()");
		delete[] m_buffer;
		_Info("In ~Controller() - step 1");
		av_free(m_currentResult);
		_Info("In ~Controller() - step 2");
		delete p_ve;
		_Info("In ~Controller() - step 3");
		for (int i = m_videos.size() - 1; i >= 0; --i) {
			delete m_videos[i];
		}
		_Info("In ~Controller() - step 4");
		for (int i = m_audios.size() - 1; i >= 0; --i) {
			delete m_audios[i];
		}
		_Info("In ~Controller() - done");
	}

    void rescaleSourcesByFactor(double f) {
        size_t size = m_videos.size();
        for (int i = 0; i < size; i++) {
            Source *s = m_videos[i]->GetSource();
            s->x=s->x*f;
            s->y=s->y*f;
            s->w=s->w*f;
            s->h=s->h*f;
            m_videos[i]->SetSource(s, s->position);
        }
    }
    
	int AddVideoSource(Source* source, double position, char t = 'v') {
		_InfoF("AddVideoSource: path >%s<", source->path);
		_InfoF("x=%d, y=%d", source->x, source->y);
		_InfoF("w=%d, h=%d, pos=%f", source->w, source->h, source->position);
		_InfoF("duration = %f, cmp = %c", source->duration, t);
		int size = m_videos.size();
		for (int i = 0; i < size; i++) {
			if (strcmp(m_videos[i]->GetId(), source->id) == 0) {
				m_videos[i]->SetSource(source, position);
				_InfoF("found same at %d", i);
				return i;
			}
		}
		_Info("Adding new");
		VisualWorker* mw = NULL;
		if (t == 'v')
			mw = new VideoWorker();
		if (t == 'i')
			mw = new PictureWorker();
		if (t == 'a')
			mw = new AnimationWorker();
		m_videos.push_back(mw);
		size = m_videos.size();
		int res = m_videos[size - 1]->SetSource(source, position);
		if (res != 0) {
			_ErrorF("SetSource() returned %d", res);
			m_videos.pop_back();
			return 0;
		}
		orderManager.reset(m_videos);
		_Info("Added new");
		return size - 1;
	}

	int AddAudioSource(Source* source, double position) {
		_InfoF("trying to add a new audio source, filename >%s<", source->path);
		_InfoF("x=%d, y=%d", source->x, source->y);
		_InfoF("w=%d, h=%d, pos=%f", source->w, source->h, source->position);
		_InfoF("duration = %f", source->duration);
		int size = m_audios.size();
		for (int i = 0; i < size; i++) {
			if (strcmp(m_audios[i]->GetId(), source->id) == 0) {
				m_audios[i]->SetSource(source, position);
				_InfoF("already there, re-added as %d", i);
				return i;
			}
		}
		_Info("not there yet, have to add new");
		SoundWorker *sw = new SoundWorker();
		m_audios.push_back(sw);
		size = m_audios.size();
		_InfoF("added as %d", size - 1);
		int res = m_audios[size - 1]->SetSource(source, position);
		_InfoF("SetSource returned %d", res);
		if (res != 0) {
			_Info("error. remove item. not added.");
			m_audios.pop_back();
		}
		_Info("Done with AddAudioSource()");
		return size - 1;
	}

	int removeSource(const char *id) {
		int ret = -1;
		char id_audio[512];
		memset(id_audio, 0, 512);
		_snprintf_s(id_audio, 512, 511, "%s_AUDIO", id);
		for (int i = 0; i < m_videos.size(); i++) {
			VisualWorker *m = m_videos[i];
			if (!strcmp(m->GetId(), id)) {
				ret = i;
				_InfoF("size  before deleting %d", m_videos.size());
				m_videos.erase(m_videos.begin() + i);
				_InfoF("size  before deleting %d", m_videos.size());
				delete m;
				break;
			}
		}
		for (int i = 0; i < m_audios.size(); i++) {
			SoundWorker *m = m_audios[i];
			if (!strcmp(m->GetId(), id)) {
				m_audios.erase(m_audios.begin() + i);
				delete m;
				break;
			}
		}
		for (int i = 0; i < m_audios.size();i++) {
			SoundWorker *m = m_audios[i];
			if (!strcmp(m->GetId(), id_audio)) {
				m_audios.erase(m_audios.begin() + i);
				delete m;
				break;
			}
		}
		return ret;
	}

	void seek(double position) {
		fillblack();
		m_currentPosition = position;
		redrawAll();
	}

	AVFrame* currentResult() const {
		return m_currentResult;
	}

	void getEyedropData(char *id, int x, int y, int w, int h, int* Y, int* U,
			int* V) {
		const type_info& t_new = typeid(new VideoWorker());
		for (size_t i = 0; i < m_videos.size(); ++i) {
			VisualWorker* mw = m_videos[i];
			const type_info& t_mw = typeid(m_videos[i]);
			char* s = mw->GetSource()->id;
			if (!strcmp(id, s)) {
				((VideoWorker*) (mw))->GetEyedropData(x, y, w, h, Y, U, V);
			}
		}
	}
    
    int scale(int x) {
        return (int)(m_multiple*x);
    }

	void advanceAFrameAll() {
		DWORD nCount = 0;
		thread* threads[100];
		memset(threads, 0, sizeof(thread*) * 100);
		// run all of them each in a separate thread
		for (size_t i = 0; i < m_videos.size(); ++i) {
			videoTask newTask;
			newTask.position = m_currentPosition;
			newTask.task = VTASK_PLAY;
			VisualWorker* w = m_videos[i];
			threads[nCount] = w->addTask(newTask);
			nCount++;
		}
		for (size_t i = 0; i < nCount; i++) {
			threads[i]->join();
		}
	}

	void redrawAll() {
		fillblack();
		orderManager.reset(m_videos);
		while (orderManager.hasNext()) {
			VisualWorker *item = orderManager.getNext();
			if (item->validFrame()) {
				drawOnResult(item);
			}
			char *msg = item->GetGSMsg();
			if (msg) {
				strcat_s(result, 512, msg);
			}
		}

	}

	char result[4096];

	int processExternalCommand(char* command, SOCKET inSocket) {
		char tc[512];
		memset(tc, 0, 512);
		memset(result, 0, 4096);

		int64_t m_tv_current = TimeMs();
		// possible small, but precision loss
		int64_t md = m_tv - m_tv_current;
		// there is never a delay for renderMode as we dont use real timeline there
		if (!m_renderMode) {
			if (md > 0) {
				_DebugF("remaining time before this frame was %d ms", md);
				Sleep((DWORD) md);
			} else {
				uint64_t corr = (0 - md);
				m_tv += corr;
				_DebugF("FRAME_SLIP by %d ms", corr);
			}
			m_tv += m_framedelta;
		}

		bool autoPaused = false;
		if (!canUnpause()) {
			if (!m_pause) {
				autoPaused = true;
			}
			m_pause = true;
		}
		// udpxqblmrjaievsh
		char c = command[0];
		if (c) {
			char *body = command + 1;
			_InfoF("got a command >%c<, body >%s<", c, body);
			double position;
			switch (c) {
			case 'u': // if there's some video, then we unpause
				_Info("check if we can unpause");
				if (canUnpause()) {
					_Info("we can unpause, do it");
					m_pause = false;
					strcat_s(result, 512, "UNPAUSE_SUCCESS\n\r");
				} else {
					_Info(
							"we cant unpause atm - all streams have finished or there are no streams");
					strcat_s(result, 512, "UNPAUSE_FAILED\n\r");
				}
				break;
			case 'd':
				_Debug("Delay");
				m_tv += 100000;
				strcat_s(result, 512, "TIME_ADDED\n\r");
				break;
			case 'p': // pause
				_Info("Paused");
				m_pause = true;
				strcat_s(result, 512, "PAUSE_SUCCESS\n\r");
				break;
			case 'x': // remove source by id
			{
				_InfoF("Remove source >%s<", body);
				int id = removeSource(body);
				_Info("Source removed.");
				char dim[512];
				memset(dim, 0, 512);
				_snprintf_s(dim, 512, _TRUNCATE, "DELETED;ID=%d\n\r", id);
				strcat_s(result, 512, dim);
			}
				break;
			case 'q':
				_Info("Quit command received. Exit loop and shut down app.");
				_Info(
						"If this line appears in log no crash can happen from core.");
				// exit. do nothing. after this program will exit in main loop
				return -1;
				break;
			case 'b':
				_Info("Set background");
				Y = (unsigned short) (atof(strsep(&body, ";")));
				Cb = (unsigned short)(atof(strsep(&body, ";")));
				Cr = (unsigned short)(atof(strsep(&body, ";")));
				_InfoF("Background is set as %d, %d, %d", Y, Cb, Cr);
				break;
			case 'l':
				_InfoF("Register layers, >%s<", body);
				orderManager.registerLayers(body);
				_Info("Registered layers");
				break;
			case 'm':
				// get metadata
			{
				_Info("Get metadata");
				char *type = strsep(&body, ";");
				Source* so = new Source();
				const char* test = "test";
				so->SetId(test);
				so->SetPath(strsep(&body, ";"));
				so->w = 1280;
				so->h = 720;
				_InfoF("type is >%s<", type);
				if (!strcmp(type, "video") || !strcmp(type, "image")) {
					_Info("video or image");
					VisualWorker* mw = NULL;
					if (!strcmp(type, "video"))
						mw = new VideoWorker();
					else
						mw = new PictureWorker();
					_Info("try to SetSource()");
					mw->SetSource(so, 0);
					AVFrame *f = mw->GetScaledFrame();
					char dim[512];
					memset(dim, 0, 512);
					int w = -1;
					int h = -1;
					if (f) {
						w = mw->GetNativeWidth();
						h = mw->GetNativeHeight();
					}
					double fps = mw->GetFPS();
					_snprintf_s(dim, 512, _TRUNCATE,
							"METADATA;%s;%d;%d;%f;%d\n\r", so->path, w, h, fps,
							mw->GetNFrames());
					_Info(dim);
					strcat_s(result, 512, dim);
					delete mw;
				}
				if (!strcmp(type, "sound")) {
					_Info("sound");
					char dim[512];
					memset(dim, 0, 512);
					SoundWorker *w = new SoundWorker();
					w->SetSource(so, 0);
					int duration = (int)(w->GetDuration()*24.0);
					_snprintf_s(dim, 512, _TRUNCATE,
						"METADATA;%s;0;0;24;%d\n\r", so->path, duration);
					_Info(dim);
					strcat_s(result, 512, dim);
					delete w;

				}
				break;
			}
            // render mode
			case 'r': {
                int render_mode = atoi(strsep(&body, ";"));
                int input_res = int(atof(strsep(&body, ";")));
                int a_output_res = int(atof(strsep(&body, ";")));
                m_multiple = (double)a_output_res / (double)input_res;
                m_renderMode = (render_mode == 1);
                _InfoF("set RENDER to %s, input res is %d, output res is %d, multiple is %f", m_renderMode?"true":"false", input_res, a_output_res, m_multiple);
                if (m_renderMode) {
                    strcat_s(result, 512, "RENDER_ON\n\r");
                } else {
                    strcat_s(result, 512, "RENDER_OFF\n\r");
                }
                if (a_output_res != m_videoWidth) {
                    _InfoF("resize m_currentResult frame from %d to %d", m_videoWidth, a_output_res);
                    double f = (double)a_output_res/(double)m_videoWidth;
                    m_videoWidth = a_output_res;
					_InfoF("%d %d %d", kMaxWidth, kMaxHeight, m_videoWidth);
					m_videoHeight = int((double)m_videoWidth * (double)kMaxHeight / (double)kMaxWidth);
					_InfoF("new width and height are %d and %d", m_videoWidth, m_videoHeight);
                    RemakeFrame(m_currentResult, m_videoWidth, m_videoHeight,
                                AV_PIX_FMT_YUV420P);
					//delete p_ve;
					//p_ve = new VideoEncoder(m_videoWidth, m_videoHeight, m_fps, pipeName());
					//p_ve->Init();
					p_ve->JoinThread();
                    rescaleSourcesByFactor(f);
                    _Info("Done resizing");
					if (m_pause) {
						_Info("Advance a frame after resize");

						advanceAFrameAll();
						_Info("Advance a frame after resize-done");

					}
					_Info("exit from r command");

                } else
                    _InfoF("No need to resize frame, output res stays at %d", m_videoWidth);
                break;
			}
				// audio
			case 'j':
				// animation
			case 'a':
				// image
			case 'i':
				// video
			case 'v': {
				_Info("add an asset");
				Source so;
				so.SetId(strsep(&body, ";"));
				so.SetPath(strsep(&body, ";"));
				_InfoF("Id is >%s<, path is >%s<", so.id, so.path);
				so.x = tr(scale((int) atof(strsep(&body, ";"))));
                
				so.y = tr(scale((int) atof(strsep(&body, ";"))));
				so.w = tr(scale((int) atof(strsep(&body, ";"))));
				so.h = tr(scale((int) atof(strsep(&body, ";"))));
				so.position = atof(strsep(&body, ";"));
				so.duration = atof(strsep(&body, ";"));
				so.internalPosition = atof(strsep(&body, ";"));
				if (c == 'a') {
					_Info("animation");
					so.rawW = (int) atof(strsep(&body, ";"));
					so.rawH = (int) atof(strsep(&body, ";"));
					so.rawFPS = (int) atof(strsep(&body, ";"));
				}
				int mute = 0;
				if (c == 'v') {
					_Info("video");
					int mode = (int) atof(strsep(&body, ";"));
					if (mode == 0)
						so.mode = G_OFF;
					if (mode == 1)
						so.mode = G_MANUAL;
					if (mode == 2)
						so.mode = G_AUTO;
					so.u = (int) atof(strsep(&body, ";"));
					so.v = (int) atof(strsep(&body, ";"));
					so.tola = (int) atof(strsep(&body, ";"));
					so.tolb = (int) atof(strsep(&body, ";"));
				}
				if (body && (c == 'v' || c == 'j' || c == 'i')) {
					so.fadeIn = atof(strsep(&body, ";"));
					so.fadeout = atof(strsep(&body, ";"));
				} else {
					so.fadeIn = 0;
					so.fadeout = 0;
				}
				if (c == 'a') {
					so.Y = (int) atof(strsep(&body, ";"));
					so.Cb = (int) atof(strsep(&body, ";"));
					so.Cr = (int) atof(strsep(&body, ";"));
				}
				if ((c == 'v' || c == 'j') && body) {
					so.volume = atof(strsep(&body, ";")) / 100.0;
				}
				int ind = -1;
				if (c != 'j') {
					_Info("Adding video source");
					ind = AddVideoSource(&so, m_currentPosition, c);
					_Info("Added video source");
				} else {
					_Info("Adding audio source (standalone)");
					ind = AddAudioSource(&so, m_currentPosition);
					_Info("Added video source (standalone)");
				}
				if (c == 'v' && !mute) {
					char audio_id[512];
					_snprintf_s(audio_id, 512, _TRUNCATE, "%s_AUDIO", so.id);
					so.SetId(audio_id);
					_Info("Adding audio source");
					int ind2 = AddAudioSource(&so, m_currentPosition);
					_InfoF("Added audio source, result is %d", ind2);
				}
				char dim[4096];
				_snprintf_s(dim, 512, _TRUNCATE, "ASSET_ADDED;0\n\r");
				strcat_s(result, 512, dim);
			}
				break;
			case 'e': {
				// color picker
				char *id = strsep(&body, ";");
				int x = ((int) (atof(strsep(&body, ";"))));
				int y = ((int) (atof(strsep(&body, ";"))));
				int w = ((int) (atof(strsep(&body, ";"))));
				int h = ((int) (atof(strsep(&body, ";"))));
				// get pic from the asset at this position, return average color there
				int Y = 0;
				int U = 0;
				int V = 0;
				getEyedropData((char*) id, x, y, w, h, &Y, &U, &V);
				//getEyedropData((char*)full_id, x,y,w,h,&Y, &U, &V);
				char dim[512];
				memset(dim, 0, 512);
				_snprintf_s(dim, 512, _TRUNCATE, "EYEDROPDATA;%d;%d;%d\n\r", Y,
						U, V);
				strcat_s(result, 512, dim);
			}
				break;
			case 's':
				_Info("Seek");
				position = atof(body);
				m_currentPosition = position;
				_snprintf_s(result, 512, _TRUNCATE, "SEEK_DONE\n\r");
				if (m_pause) {
					advanceAFrameAll();
				}
				_Info("Seek done");
				break;
			case 'h':
				_Info("Halt");
				m_stopat = atof(body);
			}
		}
		_Debug("advancing frame");
		if (!m_pause) {
			m_currentPosition += (1.0 / m_fps);
			advanceAFrameAll();
		}
		_Debug("redrawibg");
		if (c != 0 || !m_pause) {
			redrawAll();
		}
		if (!m_pause || !m_renderMode) {
			if (!m_pause && m_stopat > 0.0 && m_currentPosition >= m_stopat && m_currentPosition < m_stopat+2.0/m_fps) {
				m_pause = true;
				m_stopat = -1.0;
				strcat_s(result, 512, "HALT_SUCCESS\n\r");
			}
			_Debug("join thread");
			// check that the video output thread has exited
			p_ve->JoinThread();
			_Debug("output sound");
			// then, output sound (it's quick, no thread required)
			SoundFrame out;
			double output_time = (double) p_ve->m_cf / (double) m_fps;
			double output_delta = output_time - m_currentPosition;
			uint32_t pts_start = uint32_t(
					((double) p_ve->m_cf / (double) m_fps) * 44100.0 / 1024.0)
					* 1024;
			uint32_t pts_end = uint32_t(
					((double) (p_ve->m_cf + 1.0) / (double) m_fps) * 44100.0
							/ 1024) * 1024;
			out.pts = pts_start;
			out.next = NULL;
			memset(&out.data, 0, 4096);
			SoundFrame *a = NULL;
			uint32_t apts = 0;
			if (!m_pause) {
				for (size_t i = 0; i < m_audios.size(); i++) {
					a = m_audios[i]->GetNextAudioFrame(
							(double) pts_start / 44100.0 - output_delta);
					if (a) {
						putOverlay((short*) &out.data, (short*) a->data,
								m_audios[i]->GetVolume());
						apts = a->pts;
						free(a);
					}
				}
			}

			p_ve->encodeAudioFrame(&out);

			out.pts += 1024;
			memset(&out.data, 0, 4096);
			while (out.pts < pts_end) {
				apts = 0;
				if (!m_pause) {
					for (size_t i = 0; i < m_audios.size(); i++) {
						a = m_audios[i]->GetNext();
						if (a) {
							putOverlay((short*) &out.data, (short*) a->data,
									m_audios[i]->GetVolume());
							apts = a->pts;
							free(a);
						}
					}
				}
				p_ve->encodeAudioFrame(&out);
				out.pts += 1024;
			}
			_Debug("output video");
			// then, launch a new video output thread
			p_ve->encodeFrame(m_currentResult);
		}
		_Debug("done output");
		if (autoPaused) {
			strcat_s(result, 4096, "AUTO_PAUSE\n\rPAUSE_SUCCESS\n\r");
			writeSocket(inSocket, result);
			memset(result, 0, 4096);
			if (m_renderMode) {
				return -1;
			}
		}

		if (!m_renderMode || !m_pause) {
			_snprintf_s((char*) tc, 512, 512, "TIMECODE;%f;%d\n\r",
					getCurrentPosition(), md);
			strcat_s(result, 4096, tc);
			writeSocket(inSocket, result);
			_Debug(result);
		}
		_Debug("done processing");
		return 0;
	}

	double getCurrentPosition() {
		return m_currentPosition;
	}

private:
	bool m_pause;
	bool m_canUnpause;
    double m_multiple;
	SwsContext* m_sws;
	AVFrame* scaled;

	int m_testval;
	uint8_t* m_buffer;
	int m_bufferSize;
	AVFrame* m_currentResult;
	vector<VisualWorker*> m_videos;
	vector<SoundWorker*> m_audios;

	double m_currentPosition;
	int m_videoWidth;
	int m_videoHeight;
	VideoEncoder* p_ve;
	// true means no frames are being output on pause, for 'render video'
	// mode.
	bool m_renderMode;
	unsigned char Y;
	unsigned char Cb;
	unsigned char Cr;

	bool canUnpause() {
		bool can_unpause = false;
		if (!m_videos.empty()) {
			for (unsigned int i = 0; i < m_videos.size(); i++) {
				if (m_videos[i]->ended() == false) {
					can_unpause = true;
				}
			}
		}
		if (!m_audios.empty()) {
			for (unsigned int i = 0; i < m_audios.size(); i++) {
				if (m_audios[i]->ended() == false) {
					can_unpause = true;
				}
			}
		}
		m_canUnpause = can_unpause;
		return m_canUnpause;
	}

	void drawOnResult(VisualWorker *mw) {
		Source* src = mw->GetSource();
		int x = (int) (src->x);
		int y = (int) (src->y);
		int width = (int) (src->w);
		int height = (int) (src->h);
		AVFrame* input = mw->GetScaledFrame();
		int type = (mw->GetAlphaFrame()!=NULL) ? 1 : 0;
		// normal video without anything. fastest way, do it quickly.
		if (!type && src->mode == G_OFF && mw->CurAlpha() == 255) {
			if (input->format != -1) {
				m_currentResult->format = PIX_FMT_YUV420P;
				for (int yi = 0; yi < height; ++yi) {
					int r_y = yi + y;
					memcpy(
							m_currentResult->data[0]
									+ r_y * m_currentResult->linesize[0] + x,
							input->data[0] + yi * input->linesize[0],
							input->linesize[0]);
					memcpy(
							m_currentResult->data[1]
									+ (r_y / 2) * m_currentResult->linesize[1]
									+ x / 2,
							input->data[1] + (yi / 2) * input->linesize[1],
							input->linesize[1]);
					memcpy(
							m_currentResult->data[2]
									+ (r_y / 2) * m_currentResult->linesize[2]
									+ x / 2,
							input->data[2] + (yi / 2) * input->linesize[2],
							input->linesize[2]);
				}
			}
		} else {
			// this is animation or greenscreen. overlay it onto final image pixel by pixel. 
			// this can be slow :(
			m_currentResult->format = PIX_FMT_YUV420P;
			// this is source ARGB in original size, 1 plane

			int rawH = 0;
			int rawW = 0;
			uint8_t* alpha_arr = NULL;
			// fortunately, animations cannot have green screen :)
			// so we have either one of these two
			AVFrame *alpha_frame = mw->GetAlphaFrame();
			if (alpha_frame) alpha_arr = alpha_frame->data[0];
			uint8_t genAlpha = mw->CurAlpha();
			rawW = src->w;
			rawH = src->h;
			for (int yi = 0; yi < height; ++yi) {
				int r_y = yi + y;
				uint8_t* line = (m_currentResult->data[0]
						+ r_y * m_currentResult->linesize[0] + x);
				uint8_t* alphas = NULL;
				if (alpha_arr)
					alphas = alpha_arr + (yi * width);
				uint8_t* over = input->data[0] + yi * input->linesize[0];
				for (int xi = 0; xi < rawW; xi++) {
					// most common case is alpha being 0 or 255. if zero do nothing.
					// if 255 just take value from overlay
					if (alphas) {
						if (alphas[xi] == 255 && genAlpha == 255) {
							line[xi] = over[xi];
							continue;
						}
						// if more than zero but less than 255 (uncommon, rare case, edges only), calculate
						if (alphas[xi] > 0 || genAlpha > 0) {
							double a1 = genAlpha / 255.0 * (double) alphas[xi]
									/ 255.0;
							double a2 = 1.0 - a1;
							line[xi] = (uint8_t) (a1 * (double) over[xi]
									+ a2 * (double) line[xi]);
						}
					} else {
						if (genAlpha == 255) {
							line[xi] = over[xi];
							continue;
						}
						// if more than zero but less than 255 (uncommon, rare case, edges only), calculate
						if (genAlpha > 0) {
							double a1 = (double) genAlpha / 255.0;
							double a2 = 1.0 - a1;
							line[xi] = (uint8_t) (a1 * (double) over[xi]
									+ a2 * (double) line[xi]);
						}
					}
				}
			}
			for (int ctr = 1; ctr < 3; ctr++) {
				for (int yi = 0; yi < height / 2; ++yi) {
					int r_y = yi + y / 2;
					uint8_t* line = (m_currentResult->data[ctr]
							+ r_y * m_currentResult->linesize[ctr] + x / 2);
					uint8_t* alphas = NULL;
					if (alpha_arr)
						alphas = alpha_arr + yi * 2 * rawW;
					uint8_t* over = input->data[ctr]
							+ yi * input->linesize[ctr];

					for (int xi = 0; xi < width / 2; ++xi) {
						if (alphas) {
							if (alphas[xi * 2] == 255 && genAlpha == 255) {
								line[xi] = over[xi];
								continue;
							}
							if (alphas[xi * 2] > 0 && genAlpha > 0) {
								double a1 = genAlpha / 255.0
										* (double) alphas[xi * 2] / 255.0;
								double a2 = 1.0 - a1;
								line[xi] = (uint8_t) (a1 * (double) over[xi]
										+ a2 * (double) line[xi]);
							}
						} else {
							if (genAlpha == 255) {
								line[xi] = over[xi];
								continue;
							}
							if (genAlpha > 0) {
								double a1 = (double) genAlpha / 255.0;
								double a2 = 1.0 - a1;
								line[xi] = (uint8_t) (a1 * (double) over[xi]
										+ a2 * (double) line[xi]);
							}
						}
					}
				}
			}
		}
	}

	void fillblack() {
		unsigned short lY = Y;
		unsigned short lCb = Cb;
		unsigned short lCr = Cr;
		orderManager.reset(m_videos);
		while (orderManager.hasNext()) {
			VisualWorker *item = orderManager.getNext();
			if (item->validFrame()) {
				Source *s = item->GetSource();
				if (s->Y != 256) {
					lY = s->Y;
					lCb = s->Cb;
					lCr = s->Cr;
				}
			}
		}
		m_currentResult->format = PIX_FMT_YUV420P;
		memset(m_currentResult->data[0], lY,
				m_currentResult->linesize[0] * m_currentResult->height);
		memset(m_currentResult->data[1], lCb,
				m_currentResult->linesize[1] * m_currentResult->height / 2);
		memset(m_currentResult->data[2], lCr,
				m_currentResult->linesize[2] * m_currentResult->height / 2);
	}

	double startTime(const double currentTime, const double offset,
			const double length) {
		double videoTime = currentTime - offset;
		if (videoTime >= 0 && videoTime <= length) {
			return videoTime;
		} else {
			return -1;
		}
	}

};

class SocketComm {
public:
	SocketComm(int port, int w = kMaxWidth, int h = kMaxHeight) {
		m_inSocket = openCommandSocket(port);
		m_controller = new Controller(w,h);
	}

	void listenToCommands() {
		// to store command id symbol
		runCommandLoop(m_inSocket, (CommandProcessor*) m_controller);
	}

	~SocketComm() {
		delete m_controller;
	}
private:
	int m_inSocket;
	Controller* m_controller;

	int openCommandSocket(int portno) {
		sockaddr_in service;
		int ListenSocket = initListeningSocket(portno, &service);
		int sockfdOut2 = acceptSocket(ListenSocket, &service);
		return sockfdOut2;
	}

};

#endif
