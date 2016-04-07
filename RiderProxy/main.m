//
//  main.m
//  RiderProxy
//
//  Created by Tim Keating on 5/18/13.
//  Modified by Allan Lavell to allow main menu .xib integration on 07/31/13.
//

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    AppDelegate * delegate = [[AppDelegate alloc] init];
    
    NSApplication * application = [NSApplication sharedApplication];
    [application setDelegate:delegate];
    return NSApplicationMain(argc, (const char **)argv);
}
