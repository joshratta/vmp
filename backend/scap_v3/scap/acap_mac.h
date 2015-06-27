// mac implementation of audio capture

#ifndef VMP_SCAP_ACAP_MAC_H_
#define VMP_SCAP_ACAP_MAC_H_

#ifndef _WIN32

#include <portaudio/portaudio.h>
#include <string.h>
#include <portaudio/pa_asio.h>

class AudioCapMac;

AudioCapMac *ptr = NULL;

class AudioCapMac : public AudioCap {
public:

	AudioCapMac() {
        err = Pa_Initialize();
		buffer = NULL;
	}

	~AudioCapMac() {
		if (buffer) free(buffer);
	}

	virtual int GetDeviceCount() {
        int numDevices;
        numDevices = Pa_GetDeviceCount();
        if( numDevices < 0 )
        {
            _ErrorF( "ERROR: Pa_CountDevices returned 0x%x\n", numDevices );
            return 0;
        }
        return numDevices;
	}

	int GetDeviceName(int i, size_t max_len, char* output) {
        memset(output,0,max_len);
        const   PaDeviceInfo *pdi;
        pdi = Pa_GetDeviceInfo( i );
        if (pdi) {
            // if maxInputChannels is 0 it is
            // output device
            strncpy(output,pdi->name,max_len);
        }
		return 0;
	}

	int StartRecording(int i) {
        const   PaDeviceInfo *pdi;
        pdi = Pa_GetDeviceInfo( i );
        _InfoF("source number %d has name >%s<, %d input channels and %d output channels",
               i, pdi->name, pdi->maxInputChannels, pdi->maxOutputChannels);
        if (pdi) {
            if (pdi->maxInputChannels==0)
                return -1;
        }
        double srate = 44100.0;
        unsigned long framesPerBuffer = 1024;
        bzero( &inputParameters, sizeof( inputParameters ) ); //not necessary if you are filling in all the fields
        inputParameters.channelCount = 1;
        inputParameters.device = i;
        inputParameters.sampleFormat = paInt16;
        inputParameters.suggestedLatency = Pa_GetDeviceInfo(i)->defaultLowInputLatency ;
        inputParameters.hostApiSpecificStreamInfo = NULL; //See you specific host's API docs for info on using this field
        bzero( &outputParameters, sizeof( outputParameters ) ); //not necessary if you are filling in all the fields
        err = Pa_OpenStream(
                            &stream,
                            &inputParameters,
                            NULL,
                            srate,
                            framesPerBuffer,
                            paNoFlag, //flags that can be used to define dither, clip settings and more
                            portAudioCallback, //your callback function
                            (void *)this ); //data to be passed to callback. In C++, it is frequently (void *)this
        //don't forget to check errors!
        if( err != paNoError ) {
            _ErrorF("unable to init recording, err no %d", err);
            return -1;
        }
        ptr = this;
         err = Pa_StartStream( stream );
        //don't forget to check errors!
        if( err != paNoError ) {
            _ErrorF("unable to start recording, err no %d", err);
            return -1;
        }
        _Info("Started recording");
		return 0;
	}
    
    static int portAudioCallback( const void *inputBuffer, void *outputBuffer,
                                                           unsigned long framesPerBuffer,
                                                           const PaStreamCallbackTimeInfo* timeInfo,
                                                           PaStreamCallbackFlags statusFlags,
                                                           void *userData )
     {
         AudioCapMac* t = (AudioCapMac*)ptr;
         if (!t->head) {
             t->head = new SoundFrame();
             t->tail = t->head;
             _Info("first frame!");
         }
         if (framesPerBuffer > 0 && inputBuffer) {
             if (framesPerBuffer!=1024) {
                 _FailF("Broken buffer, just %d frames!", framesPerBuffer);
             }
             t->tail->filled = (uint32_t)framesPerBuffer;
             int16_t* arr = (int16_t*)inputBuffer;
             int16_t* dst = (int16_t*)t->tail->data;
             for (size_t i = 0; i < framesPerBuffer; i++) {
                 dst[i * 2] = arr[i];
                 dst[i * 2 + 1] = arr[i];
             }
             t->tail->pts = t->pts;
             t->pts += framesPerBuffer;
             t->tail->next = new SoundFrame();
             t->tail = t->tail->next;
         }
         return paContinue;
    }

	virtual int EndRecording() {
		return 0;
	}

	virtual SoundFrame *GetNextFrame() {
		return head;
	}

protected:
    unsigned char* buffer;
    PaError err;
    PaStream *stream;
       PaStreamParameters outputParameters;
    PaStreamParameters inputParameters;
};


#endif

#endif
