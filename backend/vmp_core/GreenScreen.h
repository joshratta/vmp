#ifndef VMP_CORE_GREEN_SCREEN_H_
#define VMP_CORE_GREEN_SCREEN_H_

#include "../common/stdafx.h"
#include "../common/utils.h"
#include "../common/const.h"

#ifdef _WIN32
#include <process.h>
#endif

int cmpfunc(const void * a, const void * b)
{
	return (*(int*)a - *(int*)b);
}

class GreenScreen {
public:
	int m_width;
	int m_height;
	int m_greenScreenU;
	int m_greenScreenV;
	bool m_flag;

	GreenScreen() {
		m_AlphaFrame = NULL;
		memset(m_msg, 0, 512);
		m_flag = false;
		m_tola = 500;
		m_tolb = 5000;
		m_mode = G_OFF;
		m_width=0;
		m_height=0;
		m_greenScreenU=0;
		m_greenScreenV=0;
	}

	void init(GSMode mode, int u, int v, int tola, int tolb, AVFrame *af, bool reset_flag) {
		m_mode = mode;
		m_tola = tola;
		m_tolb = tolb;
		m_greenScreenU = u;
		m_greenScreenV = v;
		memset(m_msg, 0, 512);
		m_AlphaFrame = af;
		if (reset_flag) {
			m_flag = false;
		}
	}

	int sqr(int val)
	{
		return val*val;
	}
	
	AVFrame *m_AlphaFrame;

	AVFrame *GetAlphas() {
		return m_AlphaFrame;
	}

	int m_tola;
	int m_tolb;

	int m_mode;

	char m_msg[512];

	char *GetMsg() {
		if (m_msg[0]) {
			return (char*)m_msg;
		}
		m_msg[0] = 0;
		return NULL;
	}

	int GetColorDistance(int u, int v) {
		return sqr(u - m_greenScreenU) + sqr(v - m_greenScreenV);
	}
	
	inline float CheckGreenScreen(int u, int v) {
		int d = GetColorDistance(u, v);
		if (d < m_tola)
		{
			return 0.0;
		}
		else if (d < m_tolb)
		{
			return ((float)d - (float)m_tola) / ((float)m_tolb - (float)m_tola);
		}
		else
		{
			return 1.0;
		}
	}
	
	void CalcGreenScreenColor(uint8_t** curBuf)
	{
		int U[256];
		int V[256];

		int uMax[kGSColorsToPick];
		int vMax[kGSColorsToPick];

		memset(U, 0, sizeof(int) * 256);
		memset(V, 0, sizeof(int) * 256);

		memset(uMax, 0, sizeof(int)*kGSColorsToPick);
		memset(vMax, 0, sizeof(int)*kGSColorsToPick);

		int x = 0;
		int y = 0;
		for (x = 0; x<m_width / 8; x++)
		{
			for (y = 0; y<m_height / 8; y++)
			{
				U[curBuf[1][x*4 + y*4*m_width / 2]]++;
				V[curBuf[2][x*4 + y*4*m_width / 2]]++;
			}
		}

		int i = 0;
		int j = 0;
		for (i = 0; i<256; i++)
		{
			for (j = 0; j<kGSColorsToPick; j++)
			{
				if (U[i]>U[uMax[j]])
				{
					uMax[j] = i;
					qsort(uMax, kGSColorsToPick, sizeof(int), cmpfunc);
				}
			}
		}

		for (i = 0; i<256; i++)
		{
			for (j = 0; j<kGSColorsToPick; j++)
			{
				if (V[i]>V[vMax[j]])
				{
					vMax[j] = i;
					qsort(vMax, kGSColorsToPick, sizeof(int), cmpfunc);
				}
			}
		}

		m_greenScreenU = uMax[kGSColorsToPick - 1];
		m_greenScreenV = vMax[kGSColorsToPick - 1];

		for (i = kGSColorsToPick - 1; i >= 0; i--) {
			for (j = kGSColorsToPick - 1; j >= 0; j--) {
				char tmp[512];
				memset(tmp, 0, 512);
				sprintf_s(tmp, 512, "GREENSCREENDATA;%d;%d\n\r", uMax[i], vMax[i]);
				strcat_s(m_msg, 512, tmp);
			}
		}
	}

	// generate an output frame of given size containing only alphas
	// as a fake greyscale image, to simplify application of 
	// alpha
	void PutVideo(AVFrame *f) {
		uint8_t** curBuf = f->data;
		m_width = f->width;
		m_height = f->height;
		uint8_t* outBuf = m_AlphaFrame->data[0];
		memset(outBuf, 0, m_width * m_height);
		if (this->m_mode == G_AUTO && !m_flag) {
			m_flag = true;
			CalcGreenScreenColor(curBuf);
		}
		_InfoF("Green Screen U: %d, V: %d, tola: %d, tolb: %d", m_greenScreenU, m_greenScreenV, m_tola, m_tolb);

		int max = m_width * m_height / 4;
		uint8_t alpha = 1;
		int d = 0;

		int octr = 0;
		int step = m_width;
		for (int i = 0; i < max; i++) { 
			d = sqr(curBuf[1][i] - m_greenScreenU) + sqr(curBuf[2][i] - m_greenScreenV);
			if (d < m_tola)
			{
				alpha = 0;
			}
			else if (d < m_tolb)
			{
				alpha= (uint8_t)(255*((float)d - (float)m_tola) / ((float)m_tolb - (float)m_tola));
			}
			else
			{
				alpha= 255;
			}
			outBuf[octr] = alpha;
			outBuf[octr+1] = alpha;
			outBuf[octr+step] = alpha;
			outBuf[octr+step+1] = alpha;
			octr += 2;
			if (octr%step == 0) octr += step;
		}
		RemakeFrame(m_AlphaFrame, m_width, m_height, AV_PIX_FMT_GRAY8);
	}

};

#endif
