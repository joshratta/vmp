// windows implementation of audio capture

#ifndef VMP_SCAP_ACAP_WINDOWS_H_
#define VMP_SCAP_ACAP_WINDOWS_H_

#ifdef _WIN32

#include <Windows.h>

#include "../../common/stdafx.h"
#include "../../common/audio.h"

void CALLBACK MyStaticWaveInProc(
	HWAVEIN hwi,
	UINT uMsg,
	DWORD_PTR dwInstance,
	DWORD_PTR dwParam1,
	DWORD_PTR dwParam2
	);

class AudioCapWindows : public AudioCap {
public:

	AudioCapWindows() {
		buffer = NULL;
	}

	~AudioCapWindows() {
		if (buffer) free(buffer);
	}

	virtual int GetDeviceCount() {
		return waveInGetNumDevs();
	}

	int GetDeviceName(int i, size_t max_len, char* output) {
		WAVEINCAPSA wics;
		memset(&wics, 0, sizeof(WAVEINCAPSA));
		waveInGetDevCapsA(i, &wics, sizeof(WAVEINCAPSA));
		if (strlen(wics.szPname) > max_len - 1) {
			return -1;
		}
		memcpy(output, wics.szPname, strlen(wics.szPname) + 1);
		return 0;
	}

	int StartRecording(int i) {
		memset(&pwfx, 0, sizeof(WAVEFORMATEX));
		pwfx.nChannels = 1;
		pwfx.wBitsPerSample = 16;
		pwfx.nSamplesPerSec = sample_rate;
		
		pwfx.wFormatTag = WAVE_FORMAT_PCM;
		pwfx.nBlockAlign = pwfx.nChannels*pwfx.wBitsPerSample / 8;
		pwfx.nAvgBytesPerSec = pwfx.nSamplesPerSec*pwfx.nBlockAlign;

		pwfx.cbSize = sizeof(WAVEFORMATEX);

		MMRESULT r = waveInOpen(&phwi, i, &pwfx, (DWORD_PTR)MyStaticWaveInProc, (DWORD_PTR)this, 
			CALLBACK_FUNCTION);

		buffer = (LPSTR)malloc(pwfx.nBlockAlign*SAMPLES_PER_FRAME*MAX_BUFFERS);
		memset(buffer, 0, pwfx.nBlockAlign*SAMPLES_PER_FRAME*MAX_BUFFERS);

		for (int i = 0; i < MAX_BUFFERS; i++) {
			data[i].dwBufferLength = pwfx.nBlockAlign*SAMPLES_PER_FRAME;
			data[i].lpData = buffer + i*pwfx.nBlockAlign*SAMPLES_PER_FRAME;
			r = waveInPrepareHeader(phwi, &data[i], sizeof(WAVEHDR));
			r = waveInAddBuffer(phwi, &data[i], sizeof(WAVEHDR));
		}
		pts = 0;
		switch (r) {
		case MMSYSERR_INVALHANDLE:
			_Error("MMSYSERR_INVALHANDLE");
			break;
		case MMSYSERR_NODRIVER:
			_Error("MMSYSERR_NODRIVER");
			break;
		case MMSYSERR_NOMEM:
			_Error("MMSYSERR_NOMEM");
			break;
		case WAVERR_UNPREPARED:
			_Error("WAVERR_UNPREPARED");
			break;
		}
		r = waveInStart(phwi);
		return 0;
	}

	virtual int EndRecording() {
		waveInStop(phwi);
		return 0;
	}

	virtual SoundFrame *GetNextFrame() {
		return head;
	}

	void MyWaveInProc(
		HWAVEIN hwi,
		UINT uMsg,
		DWORD_PTR dwInstance,
		DWORD_PTR dwParam1,
		DWORD_PTR dwParam2
		) {
		if (WIM_DATA == uMsg) {
			locker.lock();
			LPWAVEHDR buf = (WAVEHDR*)dwParam1;
			// do something with data
			// ...
			if (!this->head) {
				this->head = new SoundFrame();
				this->tail = this->head;
			}
			this->tail->next = new SoundFrame();
			this->tail = this->tail->next;
			if (buf->dwBytesRecorded > 0) {
				this->tail->filled = buf->dwBytesRecorded / 2;
				int16_t* arr = (int16_t*)buf->lpData;
				int16_t* dst = (int16_t*)this->tail->data;
				for (size_t i = 0; i < buf->dwBytesRecorded / 2; i++) {
					dst[i * 2] = arr[i];
					dst[i * 2 + 1] = arr[i];
				}
				this->tail->pts = pts;
				pts += (buf->dwBytesRecorded / 2);
			}
			waveInAddBuffer(phwi, buf, sizeof(WAVEHDR));
			locker.unlock();
		}
	}

protected:
	static const int MAX_BUFFERS = 3;
	
	std::mutex locker;

	WAVEFORMATEX pwfx;
	HWAVEIN phwi;
	WAVEHDR data[MAX_BUFFERS];
	LPSTR buffer;
};

// a helper function: class members can't be callbacks so have to call a non-
// member function which it turn calls member one.
void CALLBACK MyStaticWaveInProc(
	HWAVEIN hwi,
	UINT uMsg,
	DWORD_PTR dwInstance,
	DWORD_PTR dwParam1,
	DWORD_PTR dwParam2
	) {
	reinterpret_cast<AudioCapWindows*>(dwInstance)->MyWaveInProc
		(hwi, uMsg, dwInstance, dwParam1, dwParam2);

}

#endif

#endif
