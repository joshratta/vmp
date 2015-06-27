// base class for audio capture

#ifndef VMP_SCAP_ACAP_H_
#define VMP_SCAP_ACAP_H_

#include "../../common/stdafx.h"
#include "../../common/audio.h"

class AudioCap {
public:

	AudioCap() {
		head = NULL;
		tail = NULL;
        pts = 0;
		sample_rate = 44100;
	}

	virtual int GetDeviceCount() = 0;
	virtual int GetDeviceName(int i, size_t max_len, char* output) = 0;
	virtual int StartRecording(int i) = 0;
	virtual int EndRecording() = 0;

	SoundFrame *GetNextFrame() {
		return head;
	}

	void TruncateHead() {
		if (!head) return;
		SoundFrame *tmp = head->next; 
		if (head == tail) {
			tail = tmp;
		}
		delete head;
		head = tmp;
	}

	uint32_t GetSampleRate() { return sample_rate; }

protected:
	SoundFrame *head;
	SoundFrame *tail;
	uint32_t pts;
	uint32_t sample_rate;

	void cleanup() {
		while (head) {
			head = head->next;
			delete head;
		}
		tail = head;
	}
};

#endif