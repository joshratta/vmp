#ifndef VMP_CORE_ANIMATION_WORKER_H_
#define VMP_CORE_ANIMATION_WORKER_H_

#include <algorithm>
#include "../common/stdafx.h"
#include "VisualWorker.h"
#include "../common/utils.h"
#include "../common/log.h"
#include "../common/socketutils.h"
#include "Source.h"

template<class T>
void endswap(T *objp) {
	unsigned char *memp = reinterpret_cast<unsigned char*>(objp);
	std::reverse(memp, memp + sizeof(T));
}

extern Log _log;
#define factor 1

struct HDR {
	int32_t w;
	int32_t h;
	int32_t frame_number;
};

class AnimationWorker: public VisualWorker {
public:
	AnimationWorker() {
		_Info("In AnimationWorker()");
		frame = NULL;
		req_end = 0;
		fd = 0;
		req_w = 0;
		req_h = 0;
		request_always = false;
		m_nFrames = -1;
		_Info("Done with AnimationWorker()");
	}

	// just to override so it does nothing
	void cleanup() {

	}

	virtual ~AnimationWorker() {
		av_free(alpha_data);
		alpha_data = NULL;
		CloseSocket();
	}

	int Seek(double secs) {
#ifndef _WIN32
        signal(SIGPIPE, SIG_IGN);
#endif
		// see if we are in the range where the animation is to be shown,
		// exit otherwise
		m_validFrame = (secs >= source.position
				&& secs <= (source.position + source.duration));
		m_ended = (secs >= (source.position + source.duration));
		if (!m_validFrame) {
			_Info("not valid frame");
			return -1;
		}
		// open an input file, seek to the right position, read a frame

		// this is the pixel format or RAW file
		AVPixelFormat fmt = PIX_FMT_ARGB;
		int numBytes = avpicture_get_size(fmt, source.w / factor,
				source.h / factor);
		int fno = GetFrameNumber(secs);
		if (fno >= m_nFrames && m_nFrames != -1) {
			m_validFrame = false;
			m_ended = true;
			return -1;
		}

		// of the first run, prepare data array for main frame and alpha frame
		av_frame_free(&frame);
		av_frame_free(&alpha_frame);
		frame = MakeFrame(source.w, source.h, AV_PIX_FMT_ARGB, data);
		int size = avpicture_get_size(AV_PIX_FMT_GRAY8, source.w / factor,
				source.h / factor);
		if (alpha_data) {
			av_free(alpha_data);
			alpha_data = NULL;
		}
		alpha_data = (uint8_t*) av_malloc(size);
		alpha_frame = MakeFrame(source.w, source.h, AV_PIX_FMT_GRAY8,
				alpha_data);
		scaled_alpha_frame = MakeFrame(source.w, source.h, AV_PIX_FMT_GRAY8,
				alpha_data);
		int attempts = 0;
		bool re_requested = false;
		while (attempts < kReqLen * 2) {
			attempts++;
			// this will cause re-request only if no previous request was made, or 
			// size has changed
			RequestFrames(source.w, source.h, fno, request_always);
			if (request_always) {
				// can be invoked only once
				request_always = false;
				re_requested = true;
			}
			HDR hdr;
			fd_set readset;
			FD_ZERO(&readset);
			FD_SET(fd, &readset);
			int result = select(fd + 1, &readset, NULL, NULL, NULL);
			if (!result) {
				_Fail(
						"a selector waiting indefinitely resulted in zero return code, which it should not");
			}
			// no FD_ISSET needed because we have only 1 item in readset
			int len = recv(fd, (char*) &hdr, sizeof(hdr), MSG_WAITALL);
			if (len != sizeof(hdr)) {
				_ErrorF(
						"received %d bytes instead of %d, probably broken pipe,\
					   				    error code %d",
						len, sizeof(hdr), SocketErrno());
				request_always = true;
				continue;
			}
			endswap(&hdr.w);
			endswap(&hdr.h);
			endswap(&hdr.frame_number);
			if (hdr.w != source.w || hdr.h != source.h) {
				_InfoF("Dimensions change from %d x %d to %d x %d", hdr.w,
						hdr.h, source.w, source.h);
			}
			_InfoF("w=%d, h=%d", hdr.w, hdr.h);
			if (hdr.w > kMaxWidth || hdr.h > kMaxHeight) {
				_Fail("Invalid size specified");
			}
			int nb_actual = hdr.w * hdr.h * 4;
			int nb = nb_actual;
			int ctr = 0;
			try {
				while (nb) {
					if (ctr > 10000) {
						_Error("broken socket!");
						return -1;
					}
					ctr++;
					FD_ZERO(&readset);
					FD_SET(fd, &readset);
					int result = select(fd + 1, &readset, NULL, NULL, NULL);
					if (!result) {
						_Fail(
								"a selector waiting indefinitely resulted in zero return code, which it should not");
					}
					int res = recv(fd, (char*) data + nb_actual - nb, nb, 0);// , MSG_WAITALL);
					if (res < 0) {
						_ErrorF("recv() returned %d, error %d", res,
								SocketErrno());
					}
					if (res == 0) {
						_Error("socket probably dead");
					}
					nb -= res;
				}
			} catch (...) {
				_Fail("uncontrollable crash while reading from socket");
			}
			if (numBytes == nb_actual && hdr.frame_number == fno) {
				// we got the correct data, correct frame number with correct size;
				break;
			}
			if (numBytes == nb_actual
					&& (hdr.frame_number > fno || hdr.frame_number < fno - 10)) {
				// received frame is past the requested, or too much prior to this
				// meaning however log we wait we will never get the correct frame.
				// re-request.
				if (!re_requested) {
					_ErrorF(
							"Frame past requested or too far away %d, %d, %d, %d",
							numBytes, nb_actual, hdr.frame_number, fno);
					request_always = true;
				}
			}
			Sleep(10);
		}
		for (int i = 0; i < numBytes / 4; i++) {
			alpha_data[i] = data[i * 4];
		}

		RemakeFrame(frame, source.w, source.h, AV_PIX_FMT_ARGB);
		ResizeFrameTo(frame, m_scaledFrame, source.w, source.h);
		RemakeFrame(alpha_frame, source.w, source.h, AV_PIX_FMT_GRAY8);
		RemakeFrame(scaled_alpha_frame, source.w, source.h, AV_PIX_FMT_GRAY8);
		scaled_alpha_frame_valid = true;
		position = secs;

		if (fno == m_nFrames - 1) {
			// meaning, we just received the last frame. if we request further
			// we will not get anything. so next time, we will clearly need to
			// re-request again
			request_always = true;
		}

		return 0;
	}

	// for animation content, there is no difference
	int QuickSeek(double secs) {
		return Seek(secs);
	}

	// do nothing
	void AV_read_frame() {

	}

	// here we can redraw always
	int SetSource(const Source* src, double position) override {
		_InfoF(
				"in set source for animation, w=%d, h=%d, nw=%d, nh=%d, position = %f",
				src->w, src->h, src->rawW, src->rawH, position);
		if (alpha_data) {
			_Info("in set source for animation, clear everything");
			av_free(alpha_data);
			alpha_data = NULL;
		}
		if (strcmp(src->id, source.id) && strlen(source.id) > 0) {
			_FailF(
					"cannot change source id field for animation. old source id %s, new %s \
				   (just in case, old port %d, new %d)",
					source.id, src->id, atoi(source.path), atoi(src->path));
		}
		source.copy(*src);
		m_nFrames = source.duration * source.rawFPS;
		int res = OpenMedia();
		if (res == -1) {
			_Info("in set source for animation, error opening media");
			return -1;
		}
		Seek(position);
		_Info("in set source for animation, done");
		return 0;
	}

	// open from zero
	int OpenMedia() override {
		m_fps = source.rawFPS;
		if (fd) {
			_Info("In OpenMedia() it's already open");
			return 0;
		}
		int portno = atoi(source.path);
		_InfoF("Connect to %d", portno);
		fd = ConnectToServer(portno);
		if (!fd) {
			_FailF("Connect to port %d failed!", portno);
			m_validFrame = false;
			return -1;
		}
		return 0;
	}

	int GetNativeWidth() override {
		return source.w / factor;
	}

	int GetNativeHeight() override {
		return source.h / factor;
	}

	// there are no fadeins-fadeouts for animation
	uint8_t CurAlpha() override {
		return 255;
	}

	uint64_t GetNFrames() override {
		return m_nFrames;
	}

protected:

	void CloseSocket() {
		_Info("closing socket");
		if (fd)
			shutdown(fd, 2);
		fd = 0;
	}

	unsigned char data[kMaxWidth * kMaxHeight * 4];
	int fd;

	int req_w;
	int req_h;
	bool request_always;
	int req_end;

	const int kReqLen = 40;
	const int kLimit = 20;

	void DoRequest(int w, int h, int s, int e) {
		char cmd[512];
		memset(cmd, 0, 512);
		_snprintf_s(cmd, 512, 511, "%d;%d;%d;%d\r\n", w, h, s, e);
		int res = send(fd, cmd, strlen(cmd), 0);
		if (res != strlen(cmd)) {
			_ErrorF("send returned %d instead of %d, error %d", res,
					strlen(cmd), SocketErrno());
		}
		cmd[strlen(cmd) - 2] = 0;
		_InfoF("REQUEST: %s, port %s, fd %d", cmd, source.path, fd);
	}

	void RequestFrames(int w, int h, int no, bool request_always = false) {
		// if this condition is not met, it means the request for the frames in the right format and the right place is already sent. we just need to wait for these frames to come up.
		if (w != req_w || h != req_h || request_always) {
			req_w = w;
			req_h = h;
			req_end = no + kReqLen - 1;
			if (req_end >= m_nFrames && m_nFrames != -1) {
				req_end = m_nFrames - 1;
			}
			DoRequest(w, h, no, req_end);
			return;
		}
		if (no > (req_end - kLimit)) {
			int a = req_end + 1;
			req_end += kReqLen;
			if (req_end >= m_nFrames) {
				req_end = m_nFrames - 1;
			}
			if (a <= req_end)
				DoRequest(w, h, a, req_end);
		}
	}
};

#endif
