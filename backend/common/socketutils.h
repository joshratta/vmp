#ifndef VMP_SOCKETUTILS_H_
#define VMP_SOCKETUTILS_H_

#include "stdafx.h"
#include "compatibility.h"
#include "socketutils.h"
#include "const.h"
#include "log.h"

#ifndef _WIN32
#include <sys/socket.h>
#include <errno.h>
#include <sys/uio.h>
#include <netdb.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#endif

extern Log _log;

using std::thread;

class CommandProcessor{
public:
	virtual int processExternalCommand(char *command, SOCKET inSocket) = 0 ;
	virtual ~CommandProcessor() { };
};

SOCKET initListeningSocket(int portno, sockaddr_in *service) {
// no initialization is required on a mac
	_DebugF("In InitListeningSocket(), portno = %d", portno);
#ifdef _WIN32
	WSADATA wsaData;
	int iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);

	if (iResult != NO_ERROR) {
		_Error("Error at WSAStartup()");
		return 1;
	}
#endif

	SOCKET ListenSocket = 0;

	ListenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (ListenSocket == INVALID_SOCKET) {
		_ErrorF("socket function failed with error: %u\n", SocketErrno());
#ifdef _WIN32
		WSACleanup();
#endif
		return 1;
	}
#ifdef _WIN32
	int addrBuf;
	my_inet_pton(AF_INET, kHostName, &addrBuf);
	service->sin_family = AF_INET;
	service->sin_addr.s_addr = addrBuf;
	service->sin_port = htons(portno);
	iResult = ::bind(ListenSocket, (SOCKADDR *)service, sizeof(*service));
	if (iResult == SOCKET_ERROR) {
		_ErrorF("bind failed with error %u\n", WSAGetLastError());
		closesocket(ListenSocket);
		WSACleanup();
		return 1;
	}
	else
		_InfoF("bind returned success\n");
#else
	struct hostent *server;
	server = gethostbyname(kHostName);
	if (server==NULL) {
		_Error("cant init socket\n");
		return 1;
	}
	memset((char*)service, 0, sizeof(*service));
	service->sin_family = AF_INET;
	memcpy((char*)&(service->sin_addr.s_addr),(char*)server->h_addr, server->h_length);
	service->sin_port=htons(portno);
	int res = 0;
	int size = sizeof(sockaddr_in);
	res = ::bind(ListenSocket, (sockaddr*)service, size);
	if ( res < 0 ) {
		_Error("cannot bind");
		return 1;
	}
#endif
	listen(ListenSocket, 200);
	return ListenSocket;
}

void setSocketBufferSize(int sock, int size){
	int result = 0;
	result = setsockopt(sock, SOL_SOCKET, SO_SNDBUF, (char *)&size, sizeof(size));
	result = setsockopt(sock, SOL_SOCKET, SO_RCVBUF, (char *)&size, sizeof(size));
}

SOCKET acceptSocket(int listenSocket, sockaddr_in *service) {
	_Info("in acceptSocket()");
	socklen_t addrLen = sizeof(sockaddr_in);
	int sockFd = accept(listenSocket, (struct sockaddr *) service, &addrLen);
	if (sockFd<0) {
		_ErrorF("accept() returned %d, error is %d", SocketErrno());
		return 0;
	}
	struct timeval tv;
	tv.tv_sec = 0;
	tv.tv_usec = kSocketTimeoutMicrosec;  // Not init'ing this can cause strange errors
	int ret = setsockopt(sockFd, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv, sizeof(struct timeval));
	if (ret) {
		_ErrorF("setsockopt returned %d", ret);
		return 0;
	}
	DWORD iMode = 1;
	int iResult2 = ioctlsocket(sockFd, FIONBIO, &iMode);
	if (iResult2 != NO_ERROR)
	{
		_ErrorF("ioctlsocket failed with error: %d", iResult2);
		return 0;
	}
	int flag = 1;
	setsockopt(sockFd, IPPROTO_TCP, TCP_NODELAY, (char *)&flag, sizeof(int));
	setSocketBufferSize(sockFd, kSocketBufferSize);
	return sockFd;
}

int writeSocket(int sockidOut, char *buf) {
	if (buf && strlen(buf)) {
		return send(sockidOut, buf, strlen(buf) + 1, 0);
	}
	return 0;
}

int getNextSocketChar(int sockfdIn, char* buf, bool blocking) {
	int flag;
	blocking ? flag = MSG_WAITALL : flag = 0;
	return recv(sockfdIn, buf, 1, flag);
}

typedef char*(CommandCallback)(char*, void *obj);

void runCommandLoop(SOCKET inSocket, CommandProcessor *obj) {
	char c[2];
	c[1] = 0;
	do
	{
		char error[512];
		socklen_t len = sizeof(error);
		int retval = getsockopt(inSocket, SOL_SOCKET, SO_ERROR, (char*)error, &len);
		if (retval != 0) {
			return;
		}
		char command[1024];

		memset(command, 0, 1024);
		Sleep(1);
		// get first char as nonblocking
		if (getNextSocketChar(inSocket, (char*)&c[0], false) > 0) {
			strcat_s(command, 1023, c);
			// now get all subsequent chars in blocking mode
			while (true) {
				// if transmission gets slow, wait
				while (getNextSocketChar(inSocket, (char*)&c[0], false) <= 0) { Sleep(1); };
				if (c[0] != '|') {
					strcat_s(command, 1023, c);
				}
				else
					break;
			}
		}
		if (command[0] != 0) {
			_DebugF("new command >%s<", command);
		}
		if (obj->processExternalCommand((char*)command, inSocket) == -1) {
			break;
		}
	} while (true);
}

int ConnectToServer(int portno) {
	int fd = 0;
	struct hostent* server;
	struct sockaddr_in serv_addr;
	fd = socket(AF_INET, SOCK_STREAM, 0);
	if (fd < 0) {
		_ErrorF("Unable to create socket, sockfd = %d, error = %d", fd, SocketErrno());
		return 0;
	}
	server = gethostbyname("127.0.0.1");

	memset((char *)&serv_addr, 0,sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	memcpy((char *)&serv_addr.sin_addr.s_addr, (char *)server->h_addr, server->h_length);
	serv_addr.sin_port = htons(portno);

	int ret = connect(fd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
	if (ret < 0) {
		_ErrorF("Unable to connect, ret = %d, error = %d", ret, SocketErrno());
		return 0;
	}
	/*DWORD iMode = 1;
	int iResult2 = ioctlsocket(fd, FIONBIO, &iMode);
	if (iResult2 != NO_ERROR)
	{
		_ErrorF("ioctlsocket failed with error: %d", iResult2);
		return 0;
	}*/
	int flag = 1;
	setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (char *)&flag, sizeof(int));

	struct timeval tv;
	tv.tv_sec = 0;
	tv.tv_usec = kSocketTimeoutMicrosec;  // Not init'ing this can cause strange errors
	ret = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv, sizeof(struct timeval));

	//setSocketBufferSize(fd, 4 * 1024 * 1024);
	return fd;
}

#endif
