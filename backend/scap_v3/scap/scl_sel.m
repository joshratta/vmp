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
float getScale();
unsigned int * imgData;
uint32_t* s_result;
bool s_needSelector=true;

#define box_size 7

extern void macCallback();

volatile sig_atomic_t atomic_quit;

@interface WindowController : NSObject <NSWindowDelegate>
@end

// the view for a box that shows

@interface CountdownView : NSTextField
{
}
@end

@implementation CountdownView
- (BOOL)becomeFirstResponder {return NO;}
- (BOOL)canBecomeKeyWindow {return NO;}
@end

// the view for the main selector box

@interface MyView : NSTextField
{
    NSPoint origDragPoint;
    NSPoint startDragPoint;
    NSPoint increment;
}
@end


@interface MyWindow : NSWindow
{
    MyView *m_view;
}
@end

MyWindow *s_window;

@implementation MyView
- (BOOL)becomeFirstResponder {return YES;}
- (BOOL)canBecomeKeyWindow {return YES;}
- (BOOL)canBecomeMainWindow {return YES;}
- (BOOL)acceptsFirstMouse {return YES;}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation];
    startDragPoint = origDragPoint = mouseLoc;
    increment.x=0;
    increment.y=0;
}

- (BOOL)hit: (NSPoint) p: (NSRect) r
{
    if (p.x>r.origin.x && p.x<r.origin.x+r.size.width &&
        p.y>r.origin.y && p.y<r.origin.y+r.size.height) {
        return TRUE;
    } else {
        return FALSE;
    }
        
}

- (NSRect) getBox: (NSRect)f : (int) n
{
    NSRect res;
    res.size.width=getScale()*box_size;
    res.size.height=getScale()*box_size;
    // left column
    if (n==0 || n==3 || n==5) {
        res.origin.x=0;
    }
    // right column
    if (n==2 || n==4 || n==7) {
        res.origin.x=f.size.width-res.size.width;
    }
    // middle column
    if (n==1 || n==6) {
        res.origin.x=f.size.width/2-res.size.width/2;
    }
    // bottom row
    if (n==0 || n==1 || n==2) {
        res.origin.y=0;
    }
    // middle row
    if (n==3 || n==4) {
        res.origin.y=f.size.height/2-res.size.height/2;
    }
    // top row
    if (n==5 || n==6 || n==7) {
        res.origin.y=f.size.height-res.size.height;
    }
    res.origin.x+=f.origin.x;
    res.origin.y+=f.origin.y;
    return res;
}


- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation];
    NSRect f = [s_window frame];
    
    double dX = mouseLoc.x-startDragPoint.x;
    double dY = mouseLoc.y-startDragPoint.y;
    for (int i=0;i<8;i++) {
        if ([self hit :origDragPoint: [self getBox :f: i]]) {
            increment.x+=dX;
            increment.y+=dY;
        }
    }
    startDragPoint = mouseLoc;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSRect f = [s_window frame];
    for (int i=0;i<8;i++) {
        if ([self hit :origDragPoint: [self getBox :f: i]]) {
            switch(i) {
                case 0:    f.origin.x+=increment.x;
                    f.origin.y+=increment.y;
                    f.size.width-=increment.x;
                    f.size.height-=increment.y;
                    break;
                case 1:
                    f.origin.y+=increment.y;
                    f.size.height-=increment.y;
                    break;
                case 2:    f.size.width+=increment.x;
                    f.origin.y+=increment.y;
                    f.size.height-=increment.y;
                    break;
                case 3: f.origin.x+=increment.x;
                    f.size.width-=increment.x;
                    break;
                case 4: f.size.width+=increment.x;
                    break;
                case 5: f.origin.x+=increment.x;
                    f.size.width-=increment.x;
                    f.size.height+=increment.y;
                    break;
                case 6: f.size.height+=increment.y;
                    break;
                case 7: f.size.width+=increment.x;
                    f.size.height+=increment.y;
                    break;

            }
        }
    }

    [s_window setFrame:f display:YES animate:NO];
}

- (void)drawRect:(NSRect)rect
{
    NSColor *myColor = [NSColor colorWithCalibratedRed:0.5f green:0.5f blue:0.5f alpha:0.7f];
    [ myColor set];
    NSRectFill( rect );
    
    
    NSColor *myColor2 = [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    [ myColor2 set];
    
    for (int i=0;i<8;i++) {
        NSRect r = [self getBox :rect: i];
        NSRectFill(r);
    }
}

@end

// an invisible window which is only used as a placeholder for mouse cursor operations

@interface Aux : NSWindow
{
}
@end

@implementation Aux

+(CGImageRef)appendMouseCursor:(CGImageRef)pSourceImage :(BOOL)highlight {
    // get the cursor image
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation]; //get cur
    
    //NSLog(@"Mouse location is x=%d,y=%d",(int)mouseLoc.x,(int)mouseLoc.y);
    
    // get the mouse image
    NSImage *overlay    =   [[[NSCursor arrowCursor] image] copy];
    
    //NSLog(@"Mouse location is x=%d,y=%d cursor width = %d, cursor height = %d",(int)mouseLoc.x,(int)mouseLoc.y,(int)[overlay size].width,(int)[overlay size].height);
    
    float scale = getScale();
  
    int x = scale*(int)mouseLoc.x;
    int y = scale*(int)mouseLoc.y;
    int w = scale*(int)[overlay size].width;
    int h = scale*(int)[overlay size].height;
    y-=h;
    int org_x = x;
    int org_y = y;
    int radius = scale*16;
    
    size_t height = CGImageGetHeight(pSourceImage);
    int width =  (int)CGImageGetWidth(pSourceImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(pSourceImage);
    if (!imgData) imgData = (unsigned int*)malloc(height*bytesPerRow);
    
    // have the graphics context now,
    CGRect bgBoundingBox = CGRectMake (0, 0, width,height);
    
    CGContextRef context =  CGBitmapContextCreate(imgData, width,
                                                  height,
                                                  8, // 8 bits per component
                                                  bytesPerRow,
                                                  CGImageGetColorSpace(pSourceImage),
                                                  CGImageGetBitmapInfo(pSourceImage));
    
    // first draw the image
    CGContextDrawImage(context,bgBoundingBox,pSourceImage);
    
    // then mouse cursor
    CGContextDrawImage(context,CGRectMake(0, 0, width,height),pSourceImage);
    
    // then mouse cursor
    CGContextDrawImage(context,CGRectMake(org_x, org_y, w,h),[overlay CGImageForProposedRect: NULL context: NULL hints: NULL] );
    
    
    if (highlight) {
        [Aux applyMouseHighlight:x:(int)height-y-h:radius:width:height:(UInt8*)imgData];
    }
    
    // assuming both the image has been drawn then create an Image Ref for that
    
    CGImageRef pFinalImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    return pFinalImage;
}

+(void)applyMouseHighlight:(int)xm :(int)ym :(int)radius :(int)width :(int)height :(UInt8*) ptr{
    // draw circle around the mouse)
    for (int i = xm - radius; i<xm+radius; i++) {
        for (int j = ym - radius; j < ym + radius; j++) {
            double R = sqrt(pow((double)xm - (double)(i) + 0.5, 2) +
                            pow((double)ym - (double)(j) + 0.5, 2));
            
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
            if (coef > 0 && j>0 && i>0 && i<width && j<height) {
                UInt8 r = ptr[i*4+j*4*width+2];
                UInt8 g = ptr[i*4+j*4*width+1];
                UInt8 b = ptr[i*4+j*4*width+0];
                
                double yCoef = 0.75*coef;
                double rCoef = 1.00 - yCoef;
                r = (UInt8)((double)(r)*rCoef + 255.0*yCoef);
                g = (UInt8)((double)(g)*rCoef + 247.0*yCoef);
                b = (UInt8)((double)(b)*rCoef);
                ptr[i*4+j*4*width+2]=r;
                ptr[i*4+j*4*width+1]=g;
                ptr[i*4+j*4*width+0]=b;
            }
            
        }
    }
    
}

@end

@interface CountdownWindow : NSWindow
{
    CountdownView *m_view;
    NSTextField *textField;
    NSTextField *textField2;
    NSTextField *textField3;
    WindowController *winController;
}
@end

NSApplication *app;
CountdownWindow *s_countdown_window;
NSRect s_rect;
EventHotKeyRef  hotKeyRef;
EventHotKeyRef  hotKeyRef2;

OSStatus mbHotKeyHandler2(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
    // Your hotkey was pressed!
    UnregisterEventHotKey(hotKeyRef2);
    hotKeyRef2 = nil;
    atomic_quit = 1;
    [app abortModal];
    return noErr;
}

@implementation CountdownWindow


- (void) play321
{
    NSThread* evtThread = [ [NSThread alloc] initWithTarget:self
                                                   selector:@selector( saySomething )
                                                     object:nil ];
    
    [ evtThread start ];
}

- (void) saySomething
{
     NSLog(@"starting thread ");
    // get the results
    if (s_needSelector) {
        NSLog(@"need a selector");
        float scale = getScale();
        s_result[0] = scale*s_rect.origin.x;
        s_result[1] = scale*(s_height-s_rect.origin.y-s_rect.size.height);
        s_result[2] = scale*(s_rect.size.width);
        s_result[3] = scale*(s_rect.size.height);
    } else
        NSLog(@"do not need a selector");
    NSLog(@"%d, %d, %d, %d", s_result[0], s_result[1], s_result[2], s_result[3]);
    [textField setStringValue:@"Recording begins in"];
    [textField2 setStringValue:@"3"];
    [textField3 setStringValue:@"Press F10 or Fn+F10 to stop recording"];
    usleep(1000000);
    NSLog(@"2");
    [textField2 setStringValue:@"2"];
    usleep(1000000);
    NSLog(@"1");
    [textField2 setStringValue:@"1"];
    usleep(1000000);
    [textField2 setStringValue:@"0"];
    NSLog(@"0");
    usleep(1000000);
    [s_window orderOut:self];
    [s_countdown_window orderOut:self];
    [s_countdown_window release];
    
    EventHotKeyID   hotKeyId;
    EventTypeSpec   eventType;
    eventType.eventClass    = kEventClassKeyboard;
    eventType.eventKind     = kEventHotKeyPressed;
    InstallApplicationEventHandler(&mbHotKeyHandler2, 1, &eventType, NULL, NULL);
    hotKeyId.signature  = 'spbx';
    hotKeyId.id         = 2;
    RegisterEventHotKey( kVK_F10,0, hotKeyId, GetApplicationEventTarget(), 0, &hotKeyRef2);
    
    // signals caller thread that a selection have been made
    NSLog(@"running callback");
    macCallback();
}

- (void)setParameters
{
    if (self) {
    NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
    NSRect windowRect = NSMakeRect(mainDisplayRect.size.width/2-150,
                                   mainDisplayRect.size.height/2-50,
                                   300,100);
    
    NSUInteger windowStyle = 0;

    [self initWithContentRect:windowRect styleMask:windowStyle backing:NSBackingStoreBuffered defer:NO];
    [self setOpaque:NO];
    [self setHasShadow:YES];
    [self setPreferredBackingLocation:NSWindowBackingLocationVideoMemory];
    [self setHidesOnDeactivate:NO];
    
    m_view = [[CountdownView alloc] initWithFrame: windowRect];
    
    [self setContentView: m_view];
    [self makeFirstResponder: m_view];
    [self makeKeyAndOrderFront: nil];
    [self setLevel:NSStatusWindowLevel+1];
    
    textField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 280, 17)];
    [textField setStringValue:@"Select screen area to capture"];
    [textField setAlignment:NSCenterTextAlignment];
    [textField setDrawsBackground:YES];
    [textField setBezeled:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [m_view addSubview:textField];
    
    textField2 = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 27, 280, 40)];
    [textField2 setStringValue:@""];
    [textField2 setAlignment:NSCenterTextAlignment];
    [textField2 setDrawsBackground:YES];
    [textField2 setBezeled:NO];
    [textField2 setEditable:NO];
    [textField2 setFont:[NSFont fontWithName:@"Menlo" size:27]];
    [textField2 setSelectable:NO];
    [m_view addSubview:textField2];
    
    textField3 = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 70, 280, 17)];
    [textField3 setStringValue:@"Press Space Bar to Record"];
    [textField3 setAlignment:NSCenterTextAlignment];
    [textField3 setDrawsBackground:YES];
    [textField3 setBezeled:NO];
    [textField3 setEditable:NO];
    [textField3 setSelectable:NO];
    [m_view addSubview:textField3];
    
    winController = [[WindowController alloc] init];
    [self setDelegate: winController];
    }
}

@end

@implementation MyWindow

- (BOOL)becomeFirstResponder {return YES;}
- (BOOL)canBecomeKeyWindow {return YES;}
- (BOOL)canBecomeMainWindow {return YES;}

- (void)setParameters
{
    if(self)
    {
        // total *main* screen frame size //
        NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
         s_height = mainDisplayRect.size.height;
        // calculate the window rect to be half the display and be centered //
        NSRect windowRect = NSMakeRect(mainDisplayRect.origin.x + (mainDisplayRect.size.width) * 0.25,
                                       mainDisplayRect.origin.y + (mainDisplayRect.size.height) * 0.25,
                                       mainDisplayRect.size.width * 0.5,
                                       mainDisplayRect.size.height * 0.5);
        NSUInteger windowStyle =
        NSResizableWindowMask | NSMiniaturizableWindowMask;
        
        // set the window level to be on top of everything else //
        NSInteger windowLevel = NSMainMenuWindowLevel + 2;
        
        // initialize the window and its properties // just examples of properties that can be changed //
        [self initWithContentRect:windowRect styleMask:windowStyle backing:NSBackingStoreBuffered defer:NO];
        [self setLevel:windowLevel];
        [self setOpaque:YES];
        [self setHasShadow:NO];
        [self setPreferredBackingLocation:NSWindowBackingLocationVideoMemory];
        [self setHidesOnDeactivate:NO];
        
        NSColor *semiTransparentBlue =
        [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        [self setBackgroundColor:semiTransparentBlue];
        [self setAlphaValue: 0.7];
		
		[self makeKeyAndOrderFront:nil];
		[self setLevel:NSStatusWindowLevel];
        
        [self setAcceptsMouseMovedEvents:TRUE];
		
		m_view = [[MyView alloc] initWithFrame: windowRect];
		[m_view setEditable:NO];
		[m_view setBackgroundColor:semiTransparentBlue];
            [self setContentView: m_view];
		[self makeFirstResponder: m_view];
        
        EventHotKeyID   hotKeyId;
        EventTypeSpec   eventType;
        
        eventType.eventClass    = kEventClassKeyboard;
        eventType.eventKind     = kEventHotKeyPressed;
        
        InstallApplicationEventHandler(&mbHotKeyHandler, 1, &eventType, NULL, NULL);
        
        hotKeyId.signature  = 'spbq';
        hotKeyId.id         = 1;
        s_window = self;
        
        [self setStyleMask:[self styleMask] & ~NSResizableWindowMask];
        
        if (s_needSelector) {
            RegisterEventHotKey( kVK_Space,0, hotKeyId, GetApplicationEventTarget(), 0, &hotKeyRef);
        } else {
            [s_window orderOut:self];
            [s_countdown_window play321];
        }
    }
}

OSStatus mbHotKeyHandler(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
    // Your hotkey was pressed!
    s_rect = [s_window frame];
    UnregisterEventHotKey(hotKeyRef);
    hotKeyRef = nil;
    [s_countdown_window play321];
    return noErr;
}

@end

@implementation WindowController

- (void)windowDidUpdate:(NSNotification *)notification
{
   // NSLog(@"updated");
    NSRect frame = [s_window frame];
    NSRect aFrame;
    aFrame.origin.x=frame.origin.x+frame.size.width/2-150;
    aFrame.origin.y=frame.origin.y+frame.size.height/2-50;
    aFrame.size.width=300;
    aFrame.size.height=100;
    [s_countdown_window setFrame: aFrame display: YES animate: NO];
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
        s_countdown_window = [CountdownWindow alloc];
        [s_countdown_window setParameters];
        
        m_window = [MyWindow alloc];
        [m_window setParameters];
        [m_window setContentBorderThickness:10.0f forEdge:CGRectMinYEdge];
        //[m_window setContentBorderThickness:10.0f forEdge:CGRectMinXEdge];
        //[m_window setContentBorderThickness:40.0f forEdge:CGRectMaxXEdge];
        //[m_window setContentBorderThickness:40.0f forEdge:CGRectMaxYEdge];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    
}

- (void)dealloc
{
    [m_window release];
    [super dealloc];
}
@end

float getScale() {
    float displayScale = 1;
    if ([[NSScreen mainScreen] respondsToSelector:@selector(backingScaleFactor)]) {
        NSArray *screens = [NSScreen screens];
        for (int i = 0; i < [screens count]; i++) {
            float s = [[screens objectAtIndex:i] backingScaleFactor];
            if (s > displayScale)
                displayScale = s;
        }
    }
    return displayScale;
}

bool inited = false;

void appInit() {
    NSLog(@"appInit()");
    if (!inited) {
        NSLog(@"appInit()2");
        inited=true;
        app = [NSApplication sharedApplication];
    }
}

CGImageRef appendCursor(CGImageRef img, BOOL highlight) {
    appInit();
    return [Aux appendMouseCursor:img:highlight];
}

void signal_handler(int sig)
{
    signal(sig, signal_handler);
    NSLog(@"Break signaled by user");
    atomic_quit = 1;
}

void appRun(uint32_t* result, bool need_selector)
{
    NSLog(@"starting app");
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    s_result = result;
    s_needSelector = need_selector;
    appInit();
    [app setDelegate:[[MyAppDelegate alloc] init]]    ;
    if (need_selector)
        [app runModalForWindow:s_window];
    else
        [app runModalForWindow:s_countdown_window];
    NSLog(@"out from app");
    [s_window release];
    NSLog(@"exiting");
}

