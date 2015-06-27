#ifndef VMP_CORE_THUMBNAIL_H_
#define VMP_CORE_THUMBNAIL_H_

#include "../common/stdafx.h"
#ifdef _WIN32
#include <process.h>
#else
#include <unistd.h>
#include <sys/socket.h>
#include <pthread.h>
#endif
#include <stdint.h>
#include "../common/socketutils.h"
#include "../common/utils.h"
#include "VisualWorker.h"
#include "VideoWorker.h"
#include "SoundWorker.h"
#include "PictureWorker.h"
#include "AnimationWorker.h"

#ifndef SHUT_WR
#define SHUT_WR SD_SEND
#endif

// if we have to read through more than that (2 seconds of audio), better seek
#define TOOMUCH 1024*82

typedef struct ThreadArgs {
	SOCKET socket;
} _ThreadArgs;

// keep them all here, don't trash and recreate
VisualWorker* workers[512];
SoundWorker* sounds[512];
char* names[512];
int nWorkers;

class Thumbnail : public CommandProcessor {
public:
	Thumbnail() {
		thumbs = NULL;
		frame2_buffer = NULL;
		scaled = NULL;
	}

	double getRelativePos(double* s, double* e, int n, double t) {
		// current interval
		int i=0;
		while (i < n && t > (e[i]-s[i])) {
			t -= (e[i]-s[i]);
			i++;
		}
		if (t>(e[i]-s[i])) {
			return -1;
		}
		return t+s[i];
	}

	int processExternalCommand(char * cmd, SOCKET inSocket) {
		if (!cmd[0]) return 0;
		if (cmd[0] == 'q') {
			return -1;
		}
		char *body = cmd + 1;

		char *path = strsep(&body, ";");
		int w = (int)atof(strsep(&body, ";"));
		int h = (int)atof(strsep(&body, ";"));
		double interval = atof(strsep(&body, ";"));
		int nItems = (int)atof(strsep(&body, ";"));

		double start[100];
		double end[100];

		double totalDuration=0.0;

		for (int i=0;i<nItems;i++) {
			start[i]=atof(strsep(&body, ";"));
			end[i]=atof(strsep(&body, ";"));
			totalDuration+=(end[i]-start[i]);
		}

		int rawW=0;
		int rawH=0;
		if (cmd[0]=='a') {
			rawW= (int)atof(strsep(&body, ";"));
			rawH = (int)atof(strsep(&body, ";"));
		}

		VisualWorker *m = NULL;
		SoundWorker *sw = NULL;

		Source s;
		s.position=0;
		s.duration=end[nItems-1];
		strcpy(s.path, path);
		s.internalPosition = 0;
		s.w=w;
		s.h=h;
		s.rawW=rawW;
		s.rawH=rawH;
		s.id[0] = 0;

		if (!m) {
			if (cmd[0] == 'v') {
				// preview
				m = new VideoWorker();
				sw = new SoundWorker();
			}
			if (cmd[0] == 'i') {
				m = new PictureWorker();
			}
			if (cmd[0] == 'j') {
				m=NULL;
				sw = new SoundWorker();
			}
			if (cmd[0] == 'a') {
				m = new AnimationWorker();
			}
			if (m) 
				m->SetSource(&s, 0);
			if (sw) {
				int res = sw->SetSource(&s, 0);
				if (res < 0) {
					delete sw;
					sw = NULL;
				}
			}
		}
		if (thumbs) {
			free(thumbs);
			thumbs = NULL;
		}

		// seconds per pixel
		double spp = (double)interval/w;

		// width is a duration in seconds with each pixel equal to 'pitch' seconds (will be about 0.05)
		int lineCount = (int)(totalDuration/spp);

		// how many thumbs we'll have? there may be a black padding in the end
		int numThumbs = (int)(std::ceil((double)lineCount/(double)w));

		int previewMode=0;
		if (numThumbs==0) {
			previewMode=1;
			numThumbs=1;
		}

		// allocate memory for result
		int allocSize = numThumbs*(w*h*4+w*4);
		thumbs = (uint8_t*)malloc(allocSize);
		memset(thumbs, 0, allocSize);

		SoundFrame *a=NULL;
		// process each thumb separately
		for (int t = 0;t<numThumbs;t++) {
			// find pointer to the result
			uint8_t* thumb = thumbs+(w*4+w*h*4)*t;
			// get video thumbs, only for preview
			if (m) {
				struct videoTask ts;
				double st = t*interval;
				ts.position = st;
				ts.task = VTASK_QSEEK;
				m->addTaskSyncronous(ts);
				m->perform();
				AVFrame *f = m->GetScaledFrame();
				resizeFrame2(f, w, h);
				// into thumbnail, after the area for audio waveform data (4 bytes=DWORD for
				// each vertical column, to be rendered by frontend
				memcpy(thumb+w*4, scaled->data[0], w*h * 4);
				av_free(frame2_buffer);
				av_frame_free(&scaled);
			}
			// now apply waveform
			// for every column in the output waveform
			for (int i=0;(i<w&&sw);i++) {
				double time = getRelativePos(start,end,nItems,t*interval+(double)(i)/(double)(w)*interval);
				// black padding in the end
				if (time < 0)
					break;
				// as many as needed + 2 full frames which won't be needed
				int sound_size = (int(spp*44100.0) + 1024 * 2) * 4;
				short* sound = (short*)malloc(sound_size);
				memset(sound, 0, sound_size);

				double tend = time + spp;
				int64_t pts_start = time * 44100;
				int64_t pts_end = tend * 44100;
				// first, do a full seek/read
				if (!a) {
					a = sw->GetNextAudioFrame(time);
				}
				// if the required position is ahead, but by not too much (~2 sec, read)
				while (a && a->pts<pts_start && (pts_start-a->pts) < TOOMUCH) {
					if (sw->ended())
						break;
					SoundFrame* tmp = a;
					if (a && a->next && a->next->next) {
						a = sw->GetNext();
						if (tmp) free(tmp);
					}
					else
						sw->ReadNext();
				}
				// if the required position is behind, or too much away ahead, seek instead
				if (!a || a->pts>pts_end || (pts_start-a->pts) > TOOMUCH) {
					if (a) free(a);
					a = sw->GetNextAudioFrame(time);
				}
				int64_t first_pts = -1;
				while (a && (a->pts) < pts_end) {
					if (sw->ended())
						break;
					if (first_pts == -1) {
						first_pts = a->pts;
					}
					int64_t ind1 = (a->pts - pts_start) * 2;
					int64_t ind2 = a->filled * 4;
					if (ind1 * 2 < 0 || ind2<0 || (ind1 * 2 + ind2) > sound_size || ind1 * 2 > sound_size || ind2 > sound_size) {
						_DebugF("memory error averted, %d, %d", ind1, ind2);
					}
					else {
						memcpy(sound + ind1, a->data, ind2);
					}
					SoundFrame* tmp = a;
					if (a->next && a->next->next) {
						a=sw->GetNext();
						free(tmp);
					} else
						// will do its own cleanup
						sw->ReadNext();
				}
				int32_t sumP = 0;
				if (first_pts!=-1) {
					for (int64_t j = first_pts - pts_start; j < (pts_end - pts_start); j++) {
						int64_t ind = j * 2;
						if (ind / 2 < sound_size) {
							int32_t next = abs(sound[ind]);
							if (sumP < next) { sumP = next; };
							next = abs(sound[ind + 1]);
							if (sumP < next) { sumP = next; };
						}
					}
				}
                memcpy(thumb+i*4, &sumP, 4);
				free(sound);
			}
		}
		send(inSocket, (char*)thumbs, allocSize, 0);
		cerr << "sent " << nItems << " thumbnail groups making up " << allocSize << " bytes" << endl;
		if (thumbs) {
			free(thumbs);
			thumbs = NULL;
		}
		if (m) delete (m);
		if (sw) delete (sw);
		return -1;
	};

	uint8_t *thumbs;
	uint8_t* frame2_buffer;
	AVFrame *scaled;

	void resizeFrame2(AVFrame* i_frame, int to_width, int to_height)
	{
		AVPixelFormat format = (AVPixelFormat)i_frame->format;
		format = AV_PIX_FMT_YUV420P;
		AVPixelFormat outFormat = AV_PIX_FMT_ARGB;
		SwsContext* resize = sws_getContext(i_frame->width, i_frame->height, format, to_width, to_height, outFormat, SWS_BICUBIC, NULL, NULL, NULL);
		int num_bytes = avpicture_get_size(outFormat, to_width, to_height);
		frame2_buffer = (uint8_t *)av_malloc(num_bytes*sizeof(uint8_t));
		if (!scaled) scaled = av_frame_alloc();
		avpicture_fill((AVPicture*)scaled, frame2_buffer, outFormat, to_width, to_height);
		sws_scale(resize, i_frame->data, i_frame->linesize, 0, i_frame->height, scaled->data, scaled->linesize);
		scaled->format = outFormat;
		scaled->width = to_width;
		scaled->height = to_height;

		sws_freeContext(resize);
	}

};
#ifdef _WIN32
int thr;
#else
pthread_t thr;
#endif

#ifdef _WIN32
void runThumbsSession(void *ptr) {
#else
void* runThumbsSession(void *ptr) {
#endif
	Thumbnail *tb = new Thumbnail();
	struct ThreadArgs* session = (struct ThreadArgs*)ptr;
	SOCKET s = session->socket;
	runCommandLoop(s, tb);
	Sleep(100);
	delete tb;
#ifndef _WIN32
	return NULL;
#endif
};

typedef struct port{
	int no;
} _port;

#ifdef _WIN32
void runThumbsThread(void *ptr) {
#else
void* runThumbsThread(void *ptr) {
#endif
	sockaddr_in service;
	struct port* p = (struct port*) ptr;
	int ListenSocket = initListeningSocket(p->no, &service);
	delete p;
	while (1) {
		struct ThreadArgs*  session = (struct ThreadArgs*)malloc(sizeof(struct ThreadArgs));
		session->socket = acceptSocket(ListenSocket, &service);
		runThumbsSession((void*)session);
		shutdown(session->socket, SHUT_WR);
	};
#ifndef _WIN32
	return NULL;
#endif
};

void startThumbsThread(int portno) {
	struct port* p = new struct port();
	p->no = portno;
#ifdef _WIN32
	thr = _beginthread(runThumbsThread, 0, p);
#else
	int ret = pthread_create(&thr, NULL, runThumbsThread, p);
	if (ret) {
		cerr << "Unable to create thread for Thumbnails Listener" << endl;
		exit(-1);
	}
#endif
}

#endif
