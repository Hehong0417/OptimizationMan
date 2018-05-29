//
//  NSDate+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSDate+LH.h"

@implementation NSDate (LH)

/**
 *  获取日期格式化器
 *
 *  @param dateFormat 指定日期格式
 *
 *  @return 日期格式化器
 */
- (NSDateFormatter *)lh_private_dateFormatter:(NSString *)dateFormat {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale currentLocale];
    df.dateFormat = dateFormat;
    
    return df;
}

/**
 *  获取指定格式字符串
 *
 *  @param dateFormat 日期格式
 *
 *  @return 指定格式字符串
 */
- (NSString *)lh_private_stringWithFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [self lh_private_dateFormatter:dateFormat];
    
    return [dateFormatter stringFromDate:self];
}

/**
 *  获取指定格式的显示时间
 *
 *  @param dateFormat 日期格式，比如：yyyy-MM-dd HH:mm:ss
 *
 *  @return 日期字符串
 */
- (NSString *)lh_stringWithFormat:(NSString *)dateFormat {

    return [self lh_private_stringWithFormat:dateFormat];
}

/**
 *  获取 日期+星期 字符串，比如：2011年4月4日 星期一
 *
 *  @return 日期+星期 字符串
 */
- (NSString *)lh_string_yyyyMMdd_EEEE {
    NSString *dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
    
    return [self lh_private_stringWithFormat:dateFormat];
}
/**
 *  获取 日期 字符串，比如：2011年4月4日
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_yyyy_MM_dd{

    NSString *dateFormat = @"yyyy'年'MM'月'dd'日'";
    
    return [self lh_private_stringWithFormat:dateFormat];

}
/**
 *  获取 日期 字符串，比如：2011年4月
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_yyyy_MM{
    
    NSString *dateFormat = @"yyyy'年'MM'月'";
    
    return [self lh_private_stringWithFormat:dateFormat];
    
}
/**
 *  获取 日期 字符串，比如：4月4日
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_MM_dd{
    
    NSString *dateFormat = @"MM'月'dd'日'";
    
    return [self lh_private_stringWithFormat:dateFormat];
    
}


/**
 *  获取 日期 字符串，比如：2011-4-4
 *
 *  @return 日期 字符串
 */
- (NSString *)lh_string_yyyyMMdd {
    NSString *dateFormat = @"yyyy-MM-dd";
    
    return [self lh_private_stringWithFormat:dateFormat];
}

/**
 *  获取 日期时间 字符串，比如：20151107142223
 *
 *  @return 日期时间 字符串
 */
- (NSString *)lh_string_yyyyMMddHHmmss {
    NSString *dateFormat = @"yyyyMMddHHmmss";
    
    return [self lh_private_stringWithFormat:dateFormat];
}

/**
 *  获取 日期+时间 字符串，比如：2015-11-07 14:22:23
 *
 *  @return 日期+时间 字符串
 */
- (NSString *)lh_string_yyyyMMdd_HHmmss {
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [self lh_private_stringWithFormat:dateFormat];
}

#warning new
+ (NSString *)getCurrentTimeWithType:(NSString *)type{
    
    // 得到当前系统日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:type];
    // 定义一个字符串，将日期转为字符串
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];
    
    return dateStr;
}

+ (NSString *)whatDayisToday:(NSString *)week{
    
    NSArray *dayEnglishArray = @[@"Monday",
                                 @"Tuesday",
                                 @"Wednesday",
                                 @"Thursday",
                                 @"Friday",
                                 @"Saturday",
                                 @"Sunday"];
    
    NSArray *dayChineseArray = @[@"星期一",
                                 @"星期二",
                                 @"星期三",
                                 @"星期四",
                                 @"星期五",
                                 @"星期六",
                                 @"星期日"];
    
    for (NSInteger i = 0; i<dayEnglishArray.count; i++) {
        
        if ([week isEqualToString:dayEnglishArray[i]]) {
            
            return [dayChineseArray objectAtIndex:i];
        }
    }
    return nil;
}


/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)format{
   
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    
         NSArray *array = [format componentsSeparatedByString:@"-"];
    
            NSInteger year = [[array objectAtIndex:0]integerValue];
            
            NSInteger month = [[array objectAtIndex:1]integerValue];
            
            NSInteger day = [[array objectAtIndex:2]integerValue];
            
            [comps setYear:year];
            
            [comps setMonth:month];
            
            [comps setDay:day];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *_date = [gregorian dateFromComponents:comps];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    
    NSInteger week = [weekdayComponents weekday];
    
    
    switch(week) {
            
        case 1:
            
            weekDayStr = @"星期日";
            
            break;
            
        case 2:
            
            weekDayStr = @"星期一";
            
            break;
            
        case 3:
            
            weekDayStr = @"星期二";
            
            break;
            
        case 4:
            
            weekDayStr = @"星期三";
            
            break;
            
        case 5:
            
            weekDayStr =@"星期四";
            
            break;
            
        case 6:
            
            weekDayStr = @"星期五";
            
            break;
            
        case 7:
            
            weekDayStr = @"星期六";
            
            break;
            
        default:
            
            weekDayStr = @"";
            
            break;
            
    }
    
    return weekDayStr;
}



+ (NSDate *)getCustomDateWithHour:(NSInteger)hour minute:(NSInteger)minute {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
+ (NSString *)getGoodsTimeBetweenFromHour:(NSInteger)fromHour fromMinute:(NSInteger)fromMinute toHour:(NSInteger)toHour  toMinute:(NSInteger)toMinute{
    NSDate *date1 = [NSDate getCustomDateWithHour:fromHour minute:fromMinute];
    NSDate *date2 = [NSDate getCustomDateWithHour:toHour minute:toMinute];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:date1]==NSOrderedDescending && [currentDate compare:date2]==NSOrderedAscending)
    {
        return [NSString stringWithFormat:@"在%ld:%ld-%ld:%ld之间",(long)fromHour,fromMinute,toHour,toMinute];
    }
    if ([currentDate compare:date1]==NSOrderedAscending ) {
        return [NSString stringWithFormat:@"早于%ld:%ld",(long)fromHour,fromMinute];
    }
    if ([currentDate compare:date2]==NSOrderedDescending) {
        return [NSString stringWithFormat:@"晚于%ld:%ld",(long)toHour,toMinute];;
    }
    return @"******";
}
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}
+ (NSInteger)getAgeFromBirthDay:(NSDate *)birthday{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *birthDate = birthday;
    
    unsigned int unitFlags =  NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *componnents = [calendar components:unitFlags fromDate:birthDate toDate:[NSDate date] options:0];
    if (componnents.year > 0) {
        
        return componnents.year;
        
    }
    return 0;
}
@end
