// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#ifndef VMP_STDAFX_H_
#define VMP_STDAFX_H_

#include "targetver.h"


#include <stdio.h>
#ifdef _WIN32
#pragma warning(disable : 4995)
#include <tchar.h>
#endif
#include <thread>
#include <iostream>
#include <string>
#include <typeinfo>

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libswscale/swscale.h>
#include <libavutil/cpu.h>
#include <libavutil/channel_layout.h>
#include <libavutil/samplefmt.h>
#include <libavutil/opt.h>
#include <libswresample/swresample.h>
}

#include <iostream>
#include <memory>
#include <vector>
#include <string>
#include <sstream>

#ifdef _WIN32
#include <thread>
#include <WinSock2.h>
#include <Windows.h>

#include <stdexcept>
#include <stdio.h>
#include <tchar.h>
#include <strsafe.h>
#include <io.h>
#include <fcntl.h>
#include <thread>
#include <thread>
#include <mutex>
#include <queue>
#include <atomic>
#include <condition_variable>
#include <string.h>
#include <winsock2.h>
#include <Ws2tcpip.h>
#include <stdio.h>

#endif
#include <stdexcept>
#include <stdio.h>

#include <fcntl.h>
#include <queue>
#include <string.h>
#include <stdio.h>
#include <thread>

#ifndef _WIN32
#include <unistd.h>
#endif


#endif
