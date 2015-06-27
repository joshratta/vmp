// scap_v3.cpp : Defines the entry point for the console application.
//

#include "../common/stdafx.h"

#include "../common/const.h"
#include "../common/videoencoder.h"
#include "../common/compatibility.h"
#include "../common/utils.h"
#include "../common/log.h"

#include "scap/scap.h"
#include "scap/scap_windows.h"
#include "scap/scap_mac.h"

#include "scap/acap.h"
#include "scap/acap_mac.h"
#include "scap/acap_windows.h"

using std::thread;

Log _log(LogLevel::LOG_DEBUG);


VMPRect r;
void runRecording();


#ifndef _WIN32


#include <pthread.h>

struct thread_info {    /* Used as argument to thread_start() */
	pthread_t thread_id;        /* ID returned by pthread_create() */
	int       thread_num;       /* Application-defined thread # */
	char     *argv_string;      /* From command-line argument */
};

#ifdef __cplusplus
extern "C" {
#endif
    
    extern void appRun(uint32_t* result, bool need_selector);
    
uint32_t *res=new uint32_t[4];
    
    void macCallback() {
        _Info("start recording from a callback");
        r.x=res[0];
        r.y=res[1];
        r.w=res[2];
        r.h=res[3];
        delete res;
        thread *thr = new std::thread(runRecording);
    }
    
    void* macRunStub(bool need_selector) {
        // initial values are full screen
        res[0]=r.x;
        res[1]=r.y;
        res[2]=r.w;
        res[3]=r.h;
        // get real values, or just display the timer if we dont need them
        appRun(res, need_selector);
        return NULL;
    }
    
#ifdef __cplusplus
}
#endif

#endif

ScreenCap* sc = NULL;
char **argv;
int device_count = 0;

int main(int argc, char* _argv[]) {
	_Info("Start screencapture");
    _InfoF("argc = %d", argc);
    argv=(char**)_argv;
    for (int i=0;i<argc;i++) {
        _InfoF("argv[%d]=%s", i, argv[i]);
    }
	signal(SIGINT, signal_handler);
	signal(SIGTERM, signal_handler);
#ifdef SIGBREAK
	signal(SIGBREAK, signal_handler);
#endif
	_Info("Signal handlers installed");
    
#ifdef _WIN32
	sc = new ScreenCapWindows();
	_Info("Windows version - screencapture");
#else
	sc = new ScreenCapMac();
	_Info("Mac version - screencapture");
#endif
	if (!sc) {
		_Error("Unable to initialize screencapture");
		exit(1);
	}

	AudioCap *ac = NULL;
#ifdef _WIN32
	ac = new AudioCapWindows();
	_Info("Windows version - audiocapture");
#else
    ac = new AudioCapMac();
#endif
	if (!ac && atoi(argv[3])!=-1) {
		_Error("Unable to initialize audiocapture, while audio requested");
		exit(1);
	}

    if (ac) device_count = ac->GetDeviceCount();
	_InfoF("Audio device count %d", device_count);

	// if app is started with no parameters, just print list of devices and exit
	if (argc == 1) {
		for (int i = 0; i < device_count; i++) {
			char name[32];
			memset(name, 0, 32);
			int res = ac->GetDeviceName(i, 32, name);
			cout << "CAPTUREAUDIODATA;" << i << ";" << name << endl;
			_InfoF("%d-th audio device name is >%s<, retcode is %d",
					i, name, res);
		}
		_Info("Exiting - done");
		exit(0);
	}

    // the code above this line is executed syncronously on every session
    // now comes the hard part!
    
	r.x = 0;
	r.y = 0;
	r.w = sc->GetWidth();
	r.h = sc->GetHeight();
	// if argv[4] is '0' don't pick screen area, record right away
	// if argv[4] is '1', select region
    int ran = 0;
    if (!strcmp(argv[4], "1")) {
#ifdef _WIN32
		r = sc->SelectArea();
        // the function above will exit, the recording will start
        // and continue until aborted
        runRecording();
        // may or may not reach here depending on the way it was aborted
        // this isnt really important
        exit(0);
#else
        // this function will NOT exit and runRecording() will be
        // ran in a callback from it in a separate thread!
        macRunStub(true);
        // so basically at this point, we are done. execution should never reach here.
        // but just in case,
        exit(0);
#endif
    } else {
        // no selection necessary
#ifdef _WIN32
        runRecording();
#else
        macRunStub(false);
#endif
    }
    exit(0);
}

void runRecording() {
	cout << "running callback" << endl;

    _Info("runRecording");
	sc->SwitchToRecordMode();
	sc->SetKeyboardHook(121);

	AudioCap* workers[10];
	int dev_count = 0;
	char *devices = argv[3];
	if (strcmp(devices, "-1")) {
		while (1) {
			char *ind = strsep(&devices, ":");
			if (!ind)
				break;
			int index = atoi(ind);
			if (index >= device_count) {
				_ErrorF("Invalid index %d", index);
				continue;
			}
#ifdef _WIN32
			workers[dev_count] = (AudioCap*)new AudioCapWindows();
#else
            workers[dev_count] = (AudioCap*)new AudioCapMac();
#endif
			if (!workers[dev_count]) {
				_ErrorF("Unable to create device no %d for source no %d", dev_count, index);
                exit(-1);;
			}
			int res = workers[dev_count]->StartRecording(index);
            if (-1==res) {
                _InfoF("Unable to start recording for source no %d", index);
            }
			dev_count++;
		}
	}

	int fps = atoi((const char*)argv[2]);
	uint64_t interval = 1000 / uint64_t(fps);
   
	av_register_all();
    
     Sleep(interval);

	char *fname = argv[1];

	BOOL highlight = true;
	if (atoi(argv[5]) == 0) {
		highlight = false;
	}

    int out_w=r.w;
    int out_h=r.h;
    // no support for 4K videos, and Retina is cropped 2x
    if (out_w>=2560) {
        out_w/=2;
        out_h/=2;
    }
	
    VideoEncoder *ve = new VideoEncoder(out_w, out_h, fps, fname);
    ve->Init(dev_count>0);
    
	AVFrame *scaled_frame = AllocFrame(out_w, out_h, AV_PIX_FMT_YUV420P);

	// continue while the user hasn't pressed F10 to stop or
	// ctrl-c didn't come from main app
	uint64_t audio_pts = 0;
	AVFrame *f = NULL;
	f = sc->GetNextFrame(r, highlight);
	ResizeFrame(f, scaled_frame);
	// initialize audio and video input at the same time
	uint64_t start_time = TimeMs();
	uint64_t zero_pts = start_time;
	int number = -1;
	SoundFrame out;
	while (!atomic_quit && !sc->GetFlag() && !feof(stdin)) {
		number++;
		uint64_t t = TimeMs();
		double pts = double(number) / (double)fps;
		ve->encodeFrame(scaled_frame, pts, false);
		while (dev_count) {
			memset(&out.data, 0, kAudioPacketSamples * 4);
			for (int i = 0; i < dev_count; i++) {
				AudioCap *ac = workers[i];
				SoundFrame* f = ac->GetNextFrame();
                if (f) {
                    _InfoF("frame from %d", i);
                    putOverlay((short*)&out.data, (short*)f->data, 1.0);
					ac->TruncateHead();
                } else {
                    _Info("no frames yet!");
                }
			}
			out.pts = audio_pts;
			audio_pts+=1024;
			ve->encodeAudioFrame(&out);
			bool quit = false;
			double cmp = (double)(number+1)/(double)fps*44100.0;
			if (audio_pts >= cmp)
				break;
		}
		fprintf(stderr, "OK\n");
		int rest = 0;
		f = sc->GetNextFrame(r, highlight);
		ResizeFrame(f, scaled_frame);
		do {
			sc->HandleEvents();
			t = TimeMs();
			rest = (size_t)(start_time + interval - t);
			if (rest > 0) {
				Sleep(1);
				rest--;
			}
		} while (rest > 0);
		start_time += interval;
	};
	_InfoF("quit is %d", atomic_quit);
	sc->Unhook();
	delete ve;
	delete sc;
}
