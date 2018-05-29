//
//  HJLog.h
//  Apws
//
//  Created by zhipeng-mac on 15/12/21.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#define EnableCocoaLumberjack


#ifdef EnableCocoaLumberjack


#ifdef DEBUG

//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#define MethodTag @"MethodTag"
//
//#define LHLog(xx, ...)  DDLogInfo(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define LHLogWarn(xx, ...)  DDLogWarn(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define LHLogError(xx, ...)  DDLogError(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define LHLogMethod() LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, MethodTag, __PRETTY_FUNCTION__, @"%s(%d) ----- class = %@", __PRETTY_FUNCTION__, __LINE__, self)

//#else
//
//static const DDLogLevel ddLogLevel = DDLogLevelOff;

//#define LHLog(xx, ...)  ((void)0)
//#define LHLogWarn(xx, ...)  ((void)0)
//#define LHLogError(xx, ...)  ((void)0)
//#define LHLogMethod()  ((void)0)

#endif

@interface HJLog : NSObject

@end

#endif
