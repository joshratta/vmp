#ifndef VMP_CORE_SOURCE_H_
#define VMP_CORE_SOURCE_H_

#include "../common/stdafx.h"
#include "../common/const.h"
#include "GreenScreen.h"

class Source
{
public:
	Source() {
		memset(this, 0, sizeof(Source));
		volume=1.00;
		Y = 256;
		Cb = 256;
		Cr = 256;
	}

	~Source() {
	}

	void SetId(const char *s) {
		memset(id,0,kMaxIdLength);
		int len=strlen(s);
		if (len>kMaxIdLength-1) {
			len=kMaxIdLength-1;
		}
		memcpy(id, s, len);
	}


	void SetPath(char *s) {
		memset(path,0,kMaxIdLength);
		int len=strlen(s);
		if (len>kMaxIdLength-1) {
			len=kMaxIdLength-1;
		}
		memcpy(path, s, len);
	}

	void copy(Source s) {
		memcpy(this, &s, sizeof(Source));
	}

	int x;
	int y;
	int w;
	int h;
	int rawW;
	int rawH;
	int rawFPS;
	double alpha;
	double fadeIn;
	double position;
	double internalPosition;
	double duration;
	double fadein;
	double fadeout;
	double volume;

	int u;
	int v;
	int tola;
	int tolb;
	GSMode mode;

	char path[kMaxIdLength];
	char id[kMaxIdLength];

	unsigned short Y;
	unsigned short Cb;
	unsigned short Cr;
};

#endif
