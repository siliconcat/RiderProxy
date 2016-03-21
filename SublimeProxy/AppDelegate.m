//
//  AppDelegate.m
//  VSCProxy
//
//  Originally Created by Tim Keating to register an apple event handler, and NSLog the output on 5/18/13.
//  Modified by Allan Lavell to open Sublime Text 2 at the correct line location on 31st 07/31/13.
//  Modified by Wallace Huang to open Visual Studio Code v0.5.0 July 10, 2015

#import "AppDelegate.h"

@implementation AppDelegate

//NSString *const APP_PATH = @"/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl";
//NSString *const LINE_FORMAT = @"%@:%d;
NSString *const APP_PATH = @"/usr/local/bin/rider";
NSString *const LINE_FORMAT = @"%@:%d";
NSString *const SLN_FORMAT = @"%@%@-csharp.sln";

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    [[NSAppleEventManager sharedAppleEventManager]
     setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:)
     forEventClass:'aevt' andEventID:'odoc'];
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:APP_PATH];
    
    NSData *eventData = [event data];
    
    unsigned char *buffer = malloc(sizeof(UInt16));
    [eventData getBytes: buffer range:NSMakeRange(422, sizeof(UInt16))];
    UInt16 x = *(UInt16 *)buffer;
    if (x == ((UInt16)65534)) {
        x = 0;
    }
    x += 1;
    
    const AEKeyword filekey  = '----';
    NSString *filepath = [[[event descriptorForKeyword:filekey] stringValue] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSString *filepathWithLine = [NSString stringWithFormat:LINE_FORMAT, filepath, x];
    filepathWithLine = [filepathWithLine stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *arguments;
    
    // km: parsing the file name to figure out the sln file to open
    NSArray *pathItems = [filepathWithLine componentsSeparatedByString:@"Assets"];
    NSString *basePath = pathItems[0];
    
    NSArray *basePathItems = [basePath componentsSeparatedByString:@"/"];
    NSString *baseFolderName = basePathItems[[basePathItems count] - 2];
    
    NSString *slnFile = [NSString stringWithFormat:SLN_FORMAT, basePath, baseFolderName];
    
    // wh: had to add more flags to the arguments array
    arguments = [NSArray arrayWithObjects: slnFile, filepathWithLine, nil];
    [task setArguments: arguments];
    
    [task launch];
    
    [[NSApplication sharedApplication] terminate:nil];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    return TRUE;
}

@end
