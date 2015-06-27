// base class for screencapture

#ifndef VMP_SCAP_SCAP_WINDOWS_H_
#define VMP_SCAP_SCAP_WINDOWS_H_

#include "../../common/stdafx.h"
#include "../../common/utils.h"

class ScreenCap {
public:
	
	ScreenCap() {
		m_width = 0;
		m_height = 0;
	}
	
	virtual ~ScreenCap() {

	};

	virtual void SetKeyboardHook(int keycode) = 0;
	virtual bool GetFlag() = 0;
	virtual void Unhook() = 0;
	virtual int GetWidth() = 0;
	virtual int GetHeight() = 0;
	virtual AVFrame *GetNextFrame(VMPRect r, BOOL highlight) = 0;
	virtual VMPRect SelectArea() = 0;
	virtual void HandleEvents() = 0;
	virtual void SwitchToRecordMode() = 0;

protected:
	int m_width;
	int m_height;
};


#endif
