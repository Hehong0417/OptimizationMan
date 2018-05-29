//
//  LHTools.m
//  Test
//
//  Created by lh on 15/11/29.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "LHTools.h"

@implementation LHTools


//+ (void)load {
//    // 程序默认启动
//    [DDLog lh_setupDDLog];
//}

/**
 *  获取手机唯一标示，手机重置后会不一样
 *
 *  @return 手机唯一标示
 */
+ (NSString *)phoneId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/**
 *  拨打电话号码，直接拨打
 */
- (void)telWithPhoneNumber:(NSString *)phoneNumber {
    NSString * str = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


/**
 * 获取视频第一帧
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
    
}
//此方法可以获取视频文件的时长。
+ (NSString *) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    //duration 总时长
    int durMin   = second / 60;//总分钟
    int durSec   = second % 60;//总秒
    
    NSString *durMinStr;
    
    if (durMin<10) {
    
        durMinStr = [NSString stringWithFormat:@"0%d",durMin];
    
    }else{
        
       durMinStr = [NSString stringWithFormat:@"%d",durMin];
        
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@:%d",durMinStr,durSec];

    return timeStr;
}
@end
