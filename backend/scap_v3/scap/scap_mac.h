#ifndef _WIN32
#include "../../common/utils.h"

#import <CoreFoundation/CoreFoundation.h>
#import <ApplicationServices/ApplicationServices.h>

#ifdef __cplusplus
extern "C" {
#endif
    CGImageRef appendCursor(CGImageRef img, BOOL highlight);
#ifdef __cplusplus
}
#endif

class ScreenCapMac : public ScreenCap {
public:
	ScreenCapMac() {
		m_pixel_data = NULL;
        m_sub_pixel_data = NULL;
		CGImageRef image_ref = CGDisplayCreateImage(CGMainDisplayID());
		m_width = (int)CGImageGetWidth(image_ref);
		m_height = (int)CGImageGetHeight(image_ref);
	}
    ~ScreenCapMac() {
    
    }

	// no terminate command
	bool GetFlag() {
		return false;
	}

	void SwitchToRecordMode() {

	}

	void Unhook() {

	}

	void HandleEvents() {

	}

	void SetKeyboardHook(int keycode) {

	}

	int GetWidth() {
		return m_width;
	}

	int GetHeight() {
		return m_height;
	}

	AVFrame *GetNextFrame(VMPRect r, BOOL highlight) {
        _DebugF("%d,%d,%d,%d",r.x,r.y,r.w,r.h);
		CGImageRef image_ref = CGDisplayCreateImage(CGMainDisplayID());
        
        CGImageRef image_ref_cursor = appendCursor(image_ref, highlight);
        CGDataProviderRef provider_cursor = CGImageGetDataProvider(image_ref_cursor);
        CFDataRef dataref_cursor = CGDataProviderCopyData(provider_cursor);
        
        
		CGDataProviderRef provider = CGImageGetDataProvider(image_ref);
		CFDataRef dataref = CGDataProviderCopyData(provider);

		size_t width, height;
		width = CGImageGetWidth(image_ref);
		height = CGImageGetHeight(image_ref);

		m_width = (int)width;
		m_height = (int)height;

		size_t bpp = CGImageGetBitsPerPixel(image_ref) / 8;

		if (!m_pixel_data) {
			m_pixel_data = (uint8_t*)malloc(width * height * bpp);
            m_sub_pixel_data = (uint8_t*)malloc(r.w * r.h * bpp);
		}
		memcpy(m_pixel_data, CFDataGetBytePtr(dataref_cursor), width * height * bpp);
        CGImageRelease(image_ref_cursor);
		CGImageRelease(image_ref);
        CFRelease(dataref_cursor);
        CFRelease(dataref);
		AVFrame *f = av_frame_alloc();
        
        for (int i=0;i<r.h;i++) {
            memcpy(m_sub_pixel_data+r.w*bpp*i, m_pixel_data+width*bpp*(i+r.y)+bpp*r.x, r.w*bpp);
        }
        
		avpicture_fill((AVPicture *)f, m_sub_pixel_data, AV_PIX_FMT_RGB32, r.w, r.h);
		f->format = AV_PIX_FMT_RGB32;
		f->width = r.w;
		f->height = r.h;
		return f;
	}

	VMPRect SelectArea() override {
		VMPRect rect;
		rect.x=0;
		rect.y=0;
		rect.w=m_width;
		rect.h=m_height;
		return rect;
	}

protected:
	uint8_t *m_pixel_data;
    uint8_t *m_sub_pixel_data;
};

#endif
