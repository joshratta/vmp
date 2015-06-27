#ifndef VMP_SCAP_WIN_UTIL_H_
#define VMP_SCAP_WIN_UTIL_H_

#include <windows.h>
#include <windowsx.h>
#include <stdio.h>
#include <gdiplus.h>

using namespace Gdiplus;

int x_init = 0;
int y_init = 0;
int xe = 0;
int ye = 0;
int sec_rem = 3;
bool done;

HWND hwnd=NULL;
HWND hwnd_box = NULL;

HWND static_top;
HWND static_bottom;

WNDCLASSEX wc = {};
WNDCLASSEX wc_box = {};
MSG Msg;

// 0 = "Hit spacebar to start"
// 1 = "Hit F10 to stop"
int state = 0;

bool box_displayed = false;

const char g_szClassName[] = "VMPWindowClass";
const char g_szClassNameBox[] = "VMPBoxClass";

HBRUSH hbrBkgnd = NULL;
POINT pt;

LRESULT CALLBACK BoxWndProc(HWND hw, UINT msg, WPARAM wParam, LPARAM lParam) {
	switch (msg)
	{
	case WM_CLOSE:
		DestroyWindow(hw);
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	case WM_PAINT:
	{
		PAINTSTRUCT ps;
		HDC hdc = BeginPaint(hw, &ps);
		Graphics gr(hdc);
		Font font(&FontFamily(L"Arial"), 12, 1);
		SolidBrush  brush(Color(255, 255, 255, 255));
		SolidBrush  red_brush(Color(255, 255, 0,0));
		RectF r;
		r.X = 10;
		r.Y = 10;
		r.Width = 180;
		r.Height = 30;
		StringFormat format;
		format.SetAlignment(StringAlignmentCenter);
		TCHAR* s1_1 = "Ready to Record";
		TCHAR* s2_1 = "";
		TCHAR* s3_1 = "Hit Spacebar to start recording";

		TCHAR* s1_2 = "Recording starts in";
		TCHAR s2_2[20];
		memset(s2_2, 0, 20);
		_snprintf_s(s2_2, 20, 19, "%d", sec_rem);
		TCHAR* s3_2 = "Hit F10 to end recording";
 
		TCHAR *s1 = s1_1;
		TCHAR *s2 = s2_1;
		TCHAR *s3 = s3_1;
		if (state) {
			s1 = s1_2;
			s2 = s2_2;
			s3 = s3_2;
		}

		wchar_t wcs_1[512];
		wchar_t wcs_2[512];
		wchar_t wcs_3[512];
		memset(wcs_1, 0, sizeof(wchar_t) * 512);
		memset(wcs_2, 0, sizeof(wchar_t) * 512);
		memset(wcs_3, 0, sizeof(wchar_t) * 512);

		// Convert char* string to a wchar_t* string.
		size_t convertedChars = 0;
		mbstowcs_s(&convertedChars, wcs_1, 512, s1, _TRUNCATE);
		mbstowcs_s(&convertedChars, wcs_2, 512, s2, _TRUNCATE);
		mbstowcs_s(&convertedChars, wcs_3, 512, s3, _TRUNCATE);
		if (!state) r.Y += 10;
		Status st = gr.DrawString(wcs_1, -1, &font, r, &format, &brush);
		assert(st == Ok);
		Font font2(&FontFamily(L"Times New Roman"), 20, 1);
		RectF r2;
		r2.X = 10;
		r2.Y = 30;
		r2.Width = 180;
		r2.Height = 40;
		st = gr.DrawString(wcs_2, -1, &font2, r2, &format, &brush);
		assert(st == Ok);
		Font font3(&FontFamily(L"Times New Roman"), 9, 1);
		RectF r3;
		r3.X = 10;
		r3.Y = 70;
		r3.Width = 180;
		r3.Height = 20;
		if (!state) r3.Y -= 10;
		st = gr.DrawString(wcs_3, -1, &font3, r3, &format, &red_brush);
		assert(st == Ok);

		SetForegroundWindow(hwnd);
		break;
	}
	default:
		return DefWindowProc(hw, msg, wParam, lParam);
	}
	return 0;
}

LRESULT CALLBACK VMPWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	switch (uMsg) {
	case WM_MOVE:
	case WM_SIZE:
		RECT r;
		GetWindowRect(hWnd, &r);
		SetWindowPos(hwnd_box, NULL, ((r.left+r.right)/2-100), (r.top+r.bottom)/2-50,200,100, 0);
		UpdateWindow(hwnd_box);
		DefWindowProc(hWnd, uMsg, wParam, lParam);
		SetForegroundWindow(hwnd);
		return 0;
		break;
	case WM_KEYDOWN: {
		if (wParam == 32) {
			done = 1;
		}
	}
	case WM_PAINT:
	{
		PAINTSTRUCT ps;
		HDC hdc = BeginPaint(hWnd, &ps);

		RECT r;
		GetWindowRect(hWnd, &r);

		Graphics graphics(hdc);
		SolidBrush redBrush(Color(255, 255, 0, 0));
		Pen      pen(Color(255, 0, 0, 255));
		graphics.FillRectangle(&redBrush, 0,0,r.right,r.bottom);
		
		//DrawText(hdc, TEXT("Hit spacebar to start recording"), -1, &r,
		//	DT_SINGLELINE | DT_LEFT | DT_TOP);

		EndPaint(hWnd, &ps);
		break;
	}
	case WM_GETMINMAXINFO:
	{
		MINMAXINFO* mmi = (MINMAXINFO*)lParam;
		mmi->ptMinTrackSize.x = 220;
		mmi->ptMinTrackSize.y = 120;
		return 0;
	}
	default:
		return DefWindowProc(hWnd, uMsg, wParam, lParam);
	}
	return 0;
}

HWND CreateLabel(const TCHAR * text, int x, int y, int w, int h, HMENU id, HWND parent)
{
	return ::CreateWindow(
		"static", text, WS_CHILD | WS_VISIBLE, x, y, w, h, parent, id, GetModuleHandle(NULL), NULL);
}

void DisplayBox() {
	if (box_displayed) return;

	wc_box.cbSize = sizeof(WNDCLASSEX);
	wc_box.style = 0;
	wc_box.lpfnWndProc = BoxWndProc;
	wc_box.cbClsExtra = 0;
	wc_box.cbWndExtra = 0;
	wc_box.hInstance = GetModuleHandle(NULL);
	wc_box.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc_box.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc_box.hbrBackground = (HBRUSH)CreateSolidBrush(RGB(0x40, 0x40, 0x40));
	wc_box.lpszMenuName = NULL;
	wc_box.lpszClassName = g_szClassNameBox;
	wc_box.hIconSm = LoadIcon(NULL, IDI_APPLICATION);

	if (!RegisterClassEx(&wc_box))
	{
		MessageBox(NULL, "Box Window Registration Failed!", "Error!",
			MB_ICONEXCLAMATION | MB_OK);
		return;
	}


	hwnd_box = CreateWindow(g_szClassNameBox, 0, (WS_BORDER | WS_POPUP), 200, 300, 200, 100, NULL, NULL, GetModuleHandle(NULL), NULL);
	SetWindowRgn(hwnd_box, CreateRoundRectRgn(0, 0, 200, 100, 20, 20), true);
	SetWindowLong(hwnd_box, GWL_STYLE, WS_POPUP);  // With 1 point border
	SetWindowPos(hwnd_box, 0, 400, 500, 200, 100, SWP_FRAMECHANGED);
	SetWindowLong(hwnd_box, GWL_EXSTYLE, GetWindowLong(hwnd_box, GWL_EXSTYLE) | WS_EX_TOOLWINDOW);
	ShowWindow(hwnd_box, SW_SHOWNOACTIVATE);
	RedrawWindow(hwnd_box, 0, 0, RDW_UPDATENOW);
	box_displayed = true;
}

void SwitchToRecMode() {
	state = 1;
	DisplayBox();
	int w = GetSystemMetrics(SM_CXSCREEN);
	int h = GetSystemMetrics(SM_CYSCREEN);
	SetWindowPos(hwnd_box, NULL, w/2 - 200, h/2 - 100, 200,100,0);
	RedrawWindow(hwnd_box, 0, 0, RDW_UPDATENOW);
	InvalidateRect(hwnd_box, 0, true);
	size_t time_start = TimeMs();
	while (1) {
		if (PeekMessage(&Msg, NULL, 0, 0, PM_REMOVE) > 0) {
			TranslateMessage(&Msg);
			DispatchMessage(&Msg);
		}
		Sleep(1);
		size_t time_now = TimeMs();
		if ((time_now - time_start) > 1000) {
			time_start += 1000;
			sec_rem--;
			if (sec_rem == -1) {
				ShowWindow(hwnd_box, SW_HIDE);
				break;
			}
			RedrawWindow(hwnd_box, 0, 0, RDW_UPDATENOW);
			InvalidateRect(hwnd_box, 0, true);
		}
	}
}

void InitEvents() {
	done = false;
	x_init = -1;

	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = 0;
	wc.lpfnWndProc = VMPWndProc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = GetModuleHandle(NULL);
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wc.lpszMenuName = NULL;
	wc.lpszClassName = g_szClassName;
	wc.hIconSm = LoadIcon(NULL, IDI_APPLICATION);

	if (!RegisterClassEx(&wc))
	{
		MessageBox(NULL, "Window Registration Failed!", "Error!",
			MB_ICONEXCLAMATION | MB_OK);
		return;
	}

	hwnd = CreateWindow(g_szClassName, 0, (WS_BORDER | WS_POPUP), 0, 0, 100, 100, NULL, NULL, GetModuleHandle(NULL), NULL);
	SetWindowPos(hwnd, 0, 150, 100, 250, 250, SWP_FRAMECHANGED);

	SetWindowLong(hwnd, GWL_STYLE, WS_SIZEBOX | WS_BORDER | WS_POPUP);  // With 1 point border
	SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) | WS_EX_LAYERED | WS_EX_TOOLWINDOW);
	bool r2 = (bool)SetLayeredWindowAttributes(hwnd, RGB(255, 0, 0), 255, LWA_COLORKEY);
	ShowWindow(hwnd, SW_SHOW);
	SetForegroundWindow(hwnd);

	DisplayBox();
	// Step 3: The Message Loop
	while (GetMessage(&Msg, NULL, 0, 0) > 0)
	{
		TranslateMessage(&Msg);
		DispatchMessage(&Msg);
		if (done) break;
	}

	RECT r;
	GetWindowRect(hwnd, &r);
	x_init = r.left;
	y_init = r.top;
	xe = r.right;
	ye = r.bottom;
	ShowWindow(hwnd, SW_HIDE);
}


void GetEvent() {
}

void ResetEvents() {

}

#endif