//
//  HJLog.m
//  Apws
//
//  Created by zhipeng-mac on 15/12/21.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJLog.h"
#import "HJLogFormatter.h"
#import <CocoaLumberjack/DDASLLogger.h>


@implementation HJLog

+ (void)load {
    
    [self setupDDLog];
}

/**
 *  开启 DDLog
 */
+ (void)setupDDLog {
    
    // Enable XcodeColors
    setenv("XcodeColors", "YES", 0);
    
    HJLogFormatter *formatter = [[HJLogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    // And then enable colors
//    [[DDASLLogger sharedInstance] setColorsEnabled:YES];
    
    // Check out default colors:
    // Error : Red
    // Warn  : Orange
    
//    DDLogError(@"Paper jam");                              // Red
//    DDLogWarn(@"Toner is low");                            // Orange
//    DDLogInfo(@"Warming up printer (pre-customization)");  // Default (black)
//    DDLogVerbose(@"Intializing protcol x26");              // Default (black)
//    
    // Now let's do some customization:
    // Info  : Pink
    
#if TARGET_OS_IPHONE
    UIColor *pink = [UIColor colorWithRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
#else
    NSColor *pink = [NSColor colorWithCalibratedRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
#endif
     int  DDLogFlagInfo = 1;
//    [[DDASLLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:DDLogFlagInfo];
    
//    DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
    
    // Now let's get crazy
    
    //    [self demoColorTags];
    
    //    [self detectXcodeColors];
}

/// 检测是否安装 XcodeColors
+ (void)detectXcodeColors {
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors)
    {
        if (strcmp(xcode_colors, "YES") == 0) {
            NSLog(@"XcodeColors enabled");
        }
        else {
            NSLog(@"XcodeColors disabled");
        }
    }
    else
    {
        NSLog(@"XcodeColors not detected");
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Lumberjack is extermely flexible.
 *
 * Below we're going to make a straight NSLog replacement that prints in color.
 * We're also going to demonstrate that log levels are not a requirement to use Lumberjack.
 **/

static NSString *const PurpleTag = @"PurpleTag";

#define DzDLogPurple(frmt, ...) LOG_MACRO(NO, 1, 1, 0, PurpleTag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)


+ (void)demoColorTags
{
#if TARGET_OS_IPHONE
    UIColor *purple = [UIColor colorWithRed:(64/255.0) green:(0/255.0) blue:(128/255.0) alpha:1.0];
#else
    NSColor *purple = [NSColor colorWithCalibratedRed:(64/255.0) green:(0/255.0) blue:(128/255.0) alpha:1.0];
#endif
    
//    [[DDASLLogger sharedInstance] setForegroundColor:purple backgroundColor:nil forTag:PurpleTag];
    
    //    DDLogPurple(@"I'm a purple log message.");
}

@end
