#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#include <termios.h>
#include <stdio.h>
#include <unistd.h>

CFMachPortRef eventTap;
CFRunLoopSourceRef runLoopSource;
int s_height;

@interface MyView : NSTextField
{
}
@end

@implementation MyView


- (BOOL)becomeFirstResponder {return YES;}
- (BOOL)canBecomeKeyWindow {return YES;}
@end

@interface MyWindow : NSWindow
{
    //NSTextField *m_view;
    MyView *m_view;
}
@end

MyWindow *s_window;

@implementation MyWindow
- (void)setParameters
{
    if(self)
    {
        // total *main* screen frame size //
        NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
        s_height = mainDisplayRect.size.height;
        // calculate the window rect to be half the display and be centered //
        NSRect windowRect = NSMakeRect(mainDisplayRect.origin.x + (mainDisplayRect.size.width) * 0.1,
                                       mainDisplayRect.origin.y + (mainDisplayRect.size.height) * 0.1,
                                       mainDisplayRect.size.width * 0.5,
                                       mainDisplayRect.size.height * 0.5);
        NSUInteger windowStyle =
        NSResizableWindowMask | NSMiniaturizableWindowMask;
        
        // set the window level to be on top of everything else //
        NSInteger windowLevel = NSMainMenuWindowLevel + 1;
        
        // initialize the window and its properties // just examples of properties that can be changed //
        [self initWithContentRect:windowRect styleMask:windowStyle backing:NSBackingStoreBuffered defer:NO];
        [self setLevel:windowLevel];
        [self setOpaque:NO];
        [self setHasShadow:YES];
        [self setPreferredBackingLocation:NSWindowBackingLocationVideoMemory];
        [self setHidesOnDeactivate:NO];
        
        NSColor *semiTransparentBlue =
        [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        [self setBackgroundColor:semiTransparentBlue];
        [self setAlphaValue: 0.7];
        
        [self makeKeyAndOrderFront:nil];
        [self setLevel:CGShieldingWindowLevel()];
        
        m_view = [[/*NSTextField*/MyView alloc] initWithFrame: windowRect];
        [m_view setEditable:NO];
        [m_view setBackgroundColor:semiTransparentBlue];
        [self setContentView: m_view];
        [self makeFirstResponder: m_view];
        
        EventHotKeyRef  hotKeyRef;
        EventHotKeyID   hotKeyId;
        EventTypeSpec   eventType;
        
        eventType.eventClass    = kEventClassKeyboard;
        eventType.eventKind     = kEventHotKeyPressed;
        
        InstallApplicationEventHandler(&mbHotKeyHandler, 1, &eventType, NULL, NULL);
        
        hotKeyId.signature  = 'spbq';
        hotKeyId.id         = 1;
        s_window = self;
        RegisterEventHotKey( 49,0, hotKeyId, GetApplicationEventTarget(), 0, &hotKeyRef);
    }
}

OSStatus mbHotKeyHandler(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
    // Your hotkey was pressed!
    NSRect s_rect = [s_window frame];
    NSLog(@"%.0f:%.0f:%.0f:%.0f\n\r",s_rect.origin.x,s_height-s_rect.origin.y-s_rect.size.height,
          s_rect.size.width, s_rect.size.height);
    exit(0);
    return noErr;
}


@end

@interface MyAppDelegate : NSObject <NSApplicationDelegate>
{
    MyWindow *m_window;
    bool flag;
}

@end

@implementation MyAppDelegate

-(id) init
{
    self = [super init];
    if(self)
    {
        m_window = [MyWindow alloc];
        [m_window setParameters];
        [m_window makeKeyAndOrderFront:self];
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    /* initialize your code stuff here */
}

- (void)dealloc
{
    // release your window and other stuff //
    [m_window release];
    [super dealloc];
}
@end

NSApplication *app;

void appRun()
{
    app = [NSApplication sharedApplication];
    [app setDelegate:[[MyAppDelegate alloc] init]]    ;
    [app run];
}

int main(int argc, char *argv[]) {
    
    appRun();
    exit(0);
}
