// compatibility.h contains a lot of defines and manual implementations
// that bring some of the useful POSIX API functions used in Mac but lacking
// in Windows to Windows, and some of good WIN32 API functions to Mac.

#ifndef VMP_COMMON_COMPATIBILITY_H_
#define VMP_COMMON_COMPATIBILITY_H_

#include <iostream>
using namespace std;

#include "stdafx.h"

#ifndef _WIN32

// Windows-specific routines defined for Mac platform

#include <inttypes.h>
#include <sys/time.h>
#include <sys/syslimits.h>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>

// Windows Slep() takes milliseconds, map it into usleep() calls which take 
// microseconds
void Sleep(size_t ms) {
	usleep(ms*1000);
}

int _errno() {
	return errno;
}

#define BOOL bool

void fopen_s(FILE **f, const char* name, const char *opts) {
	*f = fopen(name, opts);
}

int SocketErrno() {
	return errno;
}

#define _TRUNCATE -1

// so we just trash s1, for Windows compatibility
void _snprintf_s(char *dest, int s1, int s2, const char* szFormat, ...)
{
	va_list arg;
	va_start(arg, szFormat);
	vsnprintf(dest, s1, szFormat, arg);
	va_end(arg);
}

char *HomeDir() {
	char* homedir;
	// sounds redundant, but it allows the user to change his
	// notion of 'home directory' during a login session.
	if ((homedir = getenv("HOME")) == NULL) {
	    homedir = getpwuid(getuid())->pw_dir;
	}
	return homedir;
}

// so-called 'secure' Windows functions - normal ones are deprecated in Visual
// Studio
#define strcat_s(a,b,c) strncat(a,c,b)
#define strcpy_s(a,b,c) strncpy(a,c,b)
#define sprintf_s snprintf
#define fread_s(a,b,c,d,e) fread(a,c,d,e)
#define _vsnprintf vsnprintf
#define _getpid getpid

// windows calling conventions have no meaning on Mac
#define __stdcall

#define ZeroMemory(a,b) memset(a,0,b);

// lastly, some constants
#define SOCKET int
#define nullptr NULL
#define DWORD uint32_t
#define ExitProcess(a) exit(a)
#define INVALID_HANDLE_VALUE NULL
#define INVALID_SOCKET -1
#define NO_ERROR 0
#define ioctlsocket ioctl
#define FALSE false
#define TRUE true

#define DIR_SLASH "/"
#define MAX_PATH PATH_MAX

#else

// Mac specific routines defined for Windows

#include <Windows.h>
#include <ws2tcpip.h>
#include <WinSock2.h>
#include <direct.h>
#include <windows.h>
#include <shlobj.h>
#include <stdio.h>

#define getcwd _getcwd
#define DIR_SLASH "\\"
#define socklen_t int
#define unlink _unlink

#ifndef MSG_WAITALL
#define MSG_WAITALL 8
#endif

int SocketErrno() {
	return WSAGetLastError();
}

char* LogDirectory()
{
	static char path[MAX_PATH + 1];
	if (SHGetSpecialFolderPathA(HWND_DESKTOP, path, CSIDL_DESKTOPDIRECTORY, FALSE))
		return (char*)path;
	else
		return "ERROR";
}

// some POSIX functions lacking in Windows, just copypaste from opensource

#define INADDRSZ         4

// inet_pton is defined on all Windows versions except Windows XP,
// just implement it myself and always use own implementation
int my_inet_pton(const int af, const char *src, int *dst)
{
	static const char digits[] = "0123456789";
	int saw_digit, octets, ch;
	unsigned char tmp[INADDRSZ], *tp;

	saw_digit = 0;
	octets = 0;
	tp = tmp;
	*tp = 0;
	while ((ch = *src++) != '\0') {
		const char *pch;

		if ((pch = strchr(digits, ch)) != NULL) {
			unsigned int val = *tp * 10 + (unsigned int)(pch - digits);

			if (saw_digit && *tp == 0)
				return (0);
			if (val > 255)
				return (0);
			*tp = (unsigned char)val;
			if (!saw_digit) {
				if (++octets > 4)
					return (0);
				saw_digit = 1;
			}
		}
		else if (ch == '.' && saw_digit) {
			if (octets == 4)
				return (0);
			*++tp = 0;
			saw_digit = 0;
		}
		else
			return (0);
	}
	if (octets < 4)
		return (0);
	memcpy(dst, tmp, INADDRSZ);
	return (1);
}

char* strsep(char **stringp, const char *delim) {
	char *start = *stringp;
	char *ptr;
	if (!start)
		return NULL;
	if (!*delim)
		ptr = start + strlen(start);
	else {
		ptr = strpbrk(start, delim);
		if (!ptr) {
			*stringp = NULL;
			return start;
		}
	}
	*ptr = '\0';
	*stringp = ptr + 1;
	return start;
}

#endif

#endif
