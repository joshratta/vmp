#ifndef VMP_COMMON_AUDIO_H_
#define VMP_COMMON_AUDIO_H_

#include "stdafx.h"

#include <cstdint>

const int SAMPLES_PER_FRAME = 1024;
const int SAMPLE_SIZE = 4;

typedef struct SoundFrame {
	uint32_t pts;
	uint8_t data[SAMPLES_PER_FRAME*SAMPLE_SIZE];
	uint32_t filled;
	struct SoundFrame* next;
} _soundFrame;

#endif
