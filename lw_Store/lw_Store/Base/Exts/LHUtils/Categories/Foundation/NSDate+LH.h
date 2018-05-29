//
//  NSDate+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LH)

/**
 *  获取指定格式的显示时间
 *
 *  @param format 日期格式，比如：yyyy-MM-dd HH:mm:ss
 *
 *  @return 日期字符串
 */
- (NSString *)lh_stringWithFormat:(NSString *)format;

/**
 *  获取 日期+星期 字符串，比如：2011年4月4日 星期一
 *
 *  @return 日期+星期 字符串
 */
- (NSString *)lh_string_yyyyMMdd_EEEE;


/**
 *  获取 日期 字符串，比如：2011年4月4日
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_yyyy_MM_dd;

/**
 *  获取 日期 字符串，比如：2011年4月
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_yyyy_MM;

/**
 *  获取 日期 字符串，比如：4月4日
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_MM_dd;


/**
 *  获取 日期 字符串，比如：2011-4-4
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_yyyyMMdd;

/**
 *  获取 日期时间 字符串，比如：20151107142223
 *
 *  @return 日期时间 字符串
 */
- (NSString *)lh_string_yyyyMMddHHmmss;

/**
 *  获取 日期+时间 字符串，比如：2015-11-07 14:22:23
 *
 *  @return 日期+时间 字符串
 */
- (NSString *)lh_string_yyyyMMdd_HHmmss;

#warning 新增
/** 获取时间，设置需要类型*/
+ (NSString *)getCurrentTimeWithType:(NSString *)type;

/** 今天系星期几*/
+ (NSString *)whatDayisToday:(NSString *)week;



/**
 获取未来某个日期是星期几
 
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate;



/**判断早于某个时间段，晚于某个时间段，在某个时间段 */
+(NSString *)getGoodsTimeBetweenFromHour:(NSInteger)fromHour fromMinute:(NSInteger)fromMinute toHour:(NSInteger)toHour  toMinute:(NSInteger)toMinute;

/**获取当天某个点的时间 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour minute:(NSInteger)minute;

//**日期比较**/
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

+ (NSInteger)getAgeFromBirthDay:(NSDate *)birthday;

@end
