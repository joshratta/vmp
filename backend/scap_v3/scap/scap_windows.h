// base class for screencapture

#ifndef VMP_SCAP_SCAP_H_
#define VMP_SCAP_SCAP_H_

#include "scap.h"

#ifdef _WIN32

#include <stdio.h>
#include <windows.h>
#include <winuser.h>
#include <gdiplus.h>
#include <string>

#include "../../common/stdafx.h"
#include "../../common/utils.h"

#include "scap_win_util.h"

using namespace Gdiplus;
using namespace std;

class ScreenCapWindows : public ScreenCap {
public:

	ScreenCapWindows() {
		GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

		int width = GetSystemMetrics(SM_CXSCREEN);
		int height = GetSystemMetrics(SM_CYSCREEN);

		// get the device context of the screen
		hScreenDC = CreateDCA("DISPLAY", NULL, NULL, NULL);
		// and a device context to put it in
		hMemoryDC = CreateCompatibleDC(hScreenDC);

		m_width = GetDeviceCaps(hScreenDC, HORZRES);
		m_height = GetDeviceCaps(hScreenDC, VERTRES);

		// maybe worth checking these are positive values
		hBitmap = CreateCompatibleBitmap(hScreenDC, m_width, m_height);
		m_pixel_data = (uint8_t*)malloc(m_width*m_height * 4);
	}

	~ScreenCapWindows() {
		free(m_pixel_data);
	}
	
	int GetWidth() {
		return m_width;
	}
	
	int GetHeight() {
		return m_height;
	}

	AVFrame *GetNextFrame(VMPRect r, BOOL highlight) {
		// get a new bitmap
		hOldBitmap = (HBITMAP)SelectObject(hMemoryDC, hBitmap);
		
		BitBlt(hMemoryDC, 0, 0, r.w, r.h, hScreenDC, r.x, r.y, SRCCOPY);
		
		HDC cursorDC = CreateCompatibleDC(hMemoryDC);
		CURSORINFO cursorInfo = { 0 };
		cursorInfo.cbSize = sizeof(cursorInfo);
		BOOL r1;
		if (highlight && ::GetCursorInfo(&cursorInfo))
		{
			ICONINFO ii = { 0 };
			GetIconInfo(cursorInfo.hCursor, &ii);
			DeleteObject(ii.hbmColor);
			DeleteObject(ii.hbmMask);
			double radius = 16;
			int xm = cursorInfo.ptScreenPos.x - r.x - ii.xHotspot;
			int ym = cursorInfo.ptScreenPos.y - r.y - ii.yHotspot;
			r1 = ::DrawIcon(hMemoryDC, xm, ym, cursorInfo.hCursor);
			xm += ii.xHotspot;
			ym += ii.yHotspot;
			// draw circle around the mouse)
			for (int i = xm - radius; i<xm+radius; i++) {
				for (int j = ym - radius; j < ym + radius; j++) {
					double R = std::sqrt(std::pow((double)xm - double(i) + 0.5, 2) +
						std::pow((double)ym - double(j) + 0.5, 2));

					double coef = 0.0;
					if (R < radius - 0.5) {
						coef = 1.0;
					}
					else {
						if (R > radius + 0.5) {
							coef = 0;
						}
						else {
							coef = (R - radius - 0.5);
						};
					}
					if (coef > 0) {
						COLORREF c = GetPixel(hMemoryDC, i, j);
						BYTE r = GetRValue(c);
						BYTE g = GetGValue(c);
						BYTE b = GetBValue(c);
						double yCoef = 0.75*coef;
						double rCoef = 1.00 - yCoef;
						r = (BYTE)(double(r)*rCoef + 255.0*yCoef);
						g = (BYTE)(double(g)*rCoef + 247.0*yCoef);
						b = (BYTE)(double(b)*rCoef);
						c = RGB(r, g, b);
						SetPixel(hMemoryDC, i, j, c);
					}

				}
			}

		}


		hBitmap = (HBITMAP)SelectObject(hMemoryDC, hOldBitmap);

		
		// get its pixels out
		BITMAPINFOHEADER bmi = { 0 };
		bmi.biSize = sizeof(BITMAPINFOHEADER);
		bmi.biPlanes = 1;
		bmi.biBitCount = 32;
		bmi.biWidth = r.w;
		bmi.biHeight = -r.h;
		bmi.biCompression = BI_RGB;
		bmi.biSizeImage = 4 * r.w*r.h;
		int res = GetDIBits(hMemoryDC, hBitmap, 0, r.h, m_pixel_data, (BITMAPINFO*)&bmi, DIB_RGB_COLORS);

		AVFrame *f = av_frame_alloc();

		int numBytes = avpicture_get_size(AV_PIX_FMT_RGB32, r.w, r.h);

		avpicture_fill((AVPicture *)f, m_pixel_data, AV_PIX_FMT_RGB32, r.w, r.h);
		f->format = AV_PIX_FMT_RGB32;
		f->width = r.w;
		f->height = r.h;
		return f;
	};

	VMPRect SelectArea() override {
		VMPRect r;
		r.x = 0;
		r.y = 0;
		r.w = 0;
		r.h = 0;
		InitEvents();
		r.x = x_init;
		r.y = y_init;
		r.w = xe - x_init;
		r.h = ye - y_init;
		return r;
	};

protected:
	GdiplusStartupInput gdiplusStartupInput;
	ULONG_PTR gdiplusToken;
	HDC hScreenDC;
	HDC hMemoryDC;
	HBITMAP hBitmap;
	HBITMAP hOldBitmap;
	uint8_t *m_pixel_data;
	
	static std::mutex m_mutex;
	static bool m_flag;
	static HHOOK test1;
	static int m_keycode;

	static LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
	{
		char pressedKey;
		// Declare a pointer to the KBDLLHOOKSTRUCTdsad
		KBDLLHOOKSTRUCT *pKeyBoard = (KBDLLHOOKSTRUCT *)lParam;
		switch (wParam)
		{
		case WM_KEYDOWN: // When the key has been pressed and released
		case WM_KEYUP: // When the key has been pressed and released
		{
			//get the key code
			pressedKey = (char)pKeyBoard->vkCode;
			//do something with the pressed key here
			// 32 is Spacebar
			if (pressedKey == m_keycode) {
				m_mutex.lock();
				m_flag = true;
				m_mutex.unlock();
			}
		}
		break;
		default:
			return CallNextHookEx(NULL, nCode, wParam, lParam);
			break;
		}

		//according to winapi all functions which implement a hook must return by calling next hook
		return CallNextHookEx(NULL, nCode, wParam, lParam);
	}

	void SwitchToRecordMode() {
		SwitchToRecMode();
	}

	void SetKeyboardHook(int keycode) {
		//Set a global Windows Hook to capture keystrokes using the function declared above
		m_flag = false;
		m_keycode = keycode;
		test1 = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, 0, 0);
	}

	bool GetFlag() {
		// Keep this app running until we're told to stop
		m_mutex.lock();
		bool f = m_flag;
		m_mutex.unlock();
		return m_flag;
	}

	void Unhook() {
		UnhookWindowsHookEx(test1);
	}

	void HandleEvents() {
		MSG Msg;
		while (PeekMessage(&Msg, NULL, 0, 0, PM_REMOVE) > 0)
		{
			TranslateMessage(&Msg);
			DispatchMessage(&Msg);
		}
	}

};

std::mutex ScreenCapWindows::m_mutex;
bool ScreenCapWindows::m_flag;
HHOOK ScreenCapWindows::test1;
int ScreenCapWindows::m_keycode;

#endif

#endif