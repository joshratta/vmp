////////////////////////////////////////////////////////////////////////////
// vmp_core - the main video montage app for VideoMotionPro, a descendant
// of what used to be called 'av_frames' in v2.0

#include "../common/stdafx.h"

#include "../common/const.h"
#include "../common/videoencoder.h"
#include "../common/compatibility.h"
#include "../common/utils.h"
#include "../common/pipes.h"
#include "../common/log.h"

#include "GreenScreen.h"
#include "Source.h"
#include "VideoWorker.h"
#include "SoundWorker.h"
#include "VisualWorker.h"
#include "Controller.h"
#include "thumbnail.h"

#ifdef _DEBUG
Log _log(LogLevel::LOG_DEBUG);
#else
Log _log(LogLevel::LOG_INFO);
#endif

int main(int argc, char* argv[]) {
	_InfoF("app started, pid is %d", _getpid());
#ifdef _DEBUG
	_InfoF("DEBUG mode - waiting to connect to debugger...");
	//Sleep(10000);
	_InfoF("continue");
#endif
#ifdef _WIN32
	// there is no such thing as binary or text in Mac/Linux
	_setmode(_fileno(stdout), _O_BINARY);
	// start a thread which reads from a pipe and outputs to stdout.
	// normally that won't be needed, but avformat only accepts file names 
	// as output, not filehandles, so it is not possible to output to stdout
	// (on a Mac, we can specify '/dev/stdout' which works perfectly fine).
	thread pipeInitThread(initpipes);
	Sleep(100);
	_InfoF("Started pipe thread, thread id is %d", pipeInitThread.get_id());
#endif
	_Info("initializing avformat");
	av_register_all();
	_InfoF("initializing SocketComm for port >%s<", argv[1]);
	SocketComm* sc = new SocketComm(atoi(argv[1]), atoi(argv[3]), atoi(argv[4]));
	_Info("start listening");
	// this creates listening loop for port 1025
	startThumbsThread(atoi(argv[2]));
	sc->listenToCommands();
	_Info("exiting");
	delete sc;
	_Info("destructor done");
#ifdef _WIN32
	exit_flag = 1;
	pipeInitThread.join();
	_InfoF("pipe joined");
#endif
	_Info("goodbye.");
	return 0;
}
