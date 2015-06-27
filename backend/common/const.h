#ifndef VMP_COMMON_CONST_H_
#define VMP_COMMON_CONST_H_

const int kMaxWidth=1920;
const int kMaxHeight=1080;

// bandwidth for video stream output (FLV format)
const int kVideoBandwidth = 20*1024*1024;

const int kAudioBandwidth = 96000;
const int kAudioSampleRate = 44100;
const int kSocketTimeoutMicrosec = 1000;
const int kSocketBufferSize = 2*1024*1024;
const char* kHostName = "127.0.0.1";
const int kMaxIdLength = 512;
const int kGSColorsToPick = 3;
const int kAudioPacketSamples = 1024;
// minimal buffer size
const double kCachedDuration = 0.1;
// if we are less than 20 packets away from target (about half second),
// don't seek, just skip frames until we are there. otherwise seek.
const int kSeekThreshold = 20;

struct VMPRect {
    int x;
    int y;
    int w;
    int h;
};

#endif