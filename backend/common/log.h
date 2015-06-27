#ifndef VMP_COMMON_LOG_H_
#define VMP_COMMON_LOG_H_

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <mutex>
#include <thread>
#include <fstream>
#include <iomanip>

#include "compatibility.h"

#define __FILENAME__ (strrchr(__FILE__, DIR_SLASH[0]) ? strrchr(__FILE__, DIR_SLASH[0]) + 1 : __FILE__)

#ifndef NAME_MAX
#define NAME_MAX 128
#endif
#ifndef PATH_MAX
#define PATH_MAX 1024
#endif
#ifndef RC_OK
#define RC_OK 0
#endif

enum LogLevel { LOG_FAIL, LOG_ERROR, LOG_INFO, LOG_DEBUG };
#define LOG_LEVEL_DEBUG ">DEBUG<"
#define LOG_LEVEL_INFO  ">INFO< "
#define LOG_LEVEL_ERROR ">ERROR<"
#define LOG_LEVEL_FAIL  ">FAIL< "

class Log
{
public:
	Log(LogLevel level = LogLevel::LOG_FAIL, const char* path = "", const char* log_name = "")
	{
		m_ctr = 0;
		m_log_name = (char*)calloc(NAME_MAX, sizeof(char));
		m_log_path = (char*)calloc(PATH_MAX, sizeof(char));
		m_log_fullname = (char*)calloc(PATH_MAX + NAME_MAX, sizeof(char));

		if (strcmp(log_name, ""))
			strcpy(m_log_name, log_name);
		else
			strcpy(m_log_name, "vmp_core.log");

		if (strcmp(path, ""))
			strcpy(m_log_path, path);
		else
#ifdef _WIN32
			strcpy(m_log_path, LogDirectory());
#else
		strcpy(m_log_path, HomeDir());
#endif

		strcat(m_log_fullname, m_log_path);
		if (m_log_fullname[strlen(m_log_fullname) - 1] != DIR_SLASH[0])
			strcat(m_log_fullname, DIR_SLASH);
		strcat(m_log_fullname, m_log_name);

		m_log_level = level;

		unlink(m_log_fullname);
	}

	~Log()
	{
		free(m_log_name);
		free(m_log_path);
		free(m_log_fullname);
	}

	int WriteMsg(LogLevel level, const int line_number, const char* from_file, const char* msg, ...)
	{
		// write first 1000 records whatever the loglevel is - to make first few seconds 
		// very verbose, so a crash on startup and be debugged in deep detail
		if (m_log_level < level && m_ctr>1000)
			return RC_OK;

		m_ctr++;
		m_mutex.lock();

		std::ofstream log_stream;
		char time_buffer[NAME_MAX];
		time_t now = time(NULL);
		struct tm* today = localtime(&now);
		char str_level[NAME_MAX];

		sprintf(time_buffer,
			"%04d%02d%02d %02d:%02d:%02d",
			today->tm_year + 1900,
			today->tm_mon + 1,
			today->tm_mday,
			today->tm_hour,
			today->tm_min,
			today->tm_sec);

		switch (level)
		{
		case LOG_DEBUG:
			strcpy(str_level, LOG_LEVEL_DEBUG);
			break;
		case LOG_INFO:
			strcpy(str_level, LOG_LEVEL_INFO);
			break;
		case LOG_ERROR:
			strcpy(str_level, LOG_LEVEL_ERROR);
			break;
		case LOG_FAIL:
			strcpy(str_level, LOG_LEVEL_FAIL);
			break;
		}

		char buf[1024];
		va_list arg;
		va_start(arg, msg);
		_vsnprintf(buf, sizeof(buf), msg, arg);
		va_end(arg);

        std::thread::id this_id = std::this_thread::get_id();
        auto myid = this_id;
        stringstream ss;
        ss << myid;
        string mystring = ss.str();
        
        log_stream.open(m_log_fullname, std::ios_base::out | std::ios_base::app);
		log_stream << mystring << ' ' << std::dec;
		log_stream << time_buffer << ' ' << str_level << from_file << ':' << line_number << ' ' << buf << "\n";
		log_stream.close();

		m_mutex.unlock();

		return RC_OK;
	}

private:
	char* m_log_name;
	char* m_log_path;
	char* m_log_fullname;
	int m_ctr;
	LogLevel m_log_level;
	std::mutex m_mutex;
};

#define _InfoF(s, ...) _log.WriteMsg(LogLevel::LOG_INFO, __LINE__, __FILENAME__, s, __VA_ARGS__)
#define _DebugF(s, ...) _log.WriteMsg(LogLevel::LOG_DEBUG, __LINE__, __FILENAME__, s, __VA_ARGS__)
#define _ErrorF(s, ...) _log.WriteMsg(LogLevel::LOG_ERROR, __LINE__, __FILENAME__, s, __VA_ARGS__)
#define _FailF(s, ...) _log.WriteMsg(LogLevel::LOG_FAIL, __LINE__, __FILENAME__, s, __VA_ARGS__); ExitProcess(1);

#define _Info(s) _log.WriteMsg(LogLevel::LOG_INFO, __LINE__, __FILENAME__, s)
#define _Debug(s) _log.WriteMsg(LogLevel::LOG_DEBUG, __LINE__, __FILENAME__, s)
#define _Error(s) _log.WriteMsg(LogLevel::LOG_ERROR, __LINE__, __FILENAME__, s)
#define _Fail(s) _log.WriteMsg(LogLevel::LOG_FAIL, __LINE__, __FILENAME__, s); ExitProcess(1);

#endif
