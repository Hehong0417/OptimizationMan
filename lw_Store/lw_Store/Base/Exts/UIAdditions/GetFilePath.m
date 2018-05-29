//
//  GetFilePath.m
//  mengyaProject
//
//  Created by n on 2017/6/22.
//  Copyright © 2017年 n. All rights reserved.
//

#import "GetFilePath.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation GetFilePath

+(NSString *)getSavePathWithFileSuffix:(NSString *)suffix{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSDate *date = [NSDate date];
    //获取当前时间
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmms"];
    NSString *currentDateAndTime = [dateFormat stringFromDate:date];
    //获取用户Id
//    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:]
   //命名文件
    NSString *fileName = [NSString stringWithFormat:@"%@%@",currentDateAndTime,suffix];
    //指定文件路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

//获取录像的缩略图
+ (UIImage *)getVideoTumbnailWithFilepath:(NSString *)filePath{

    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:filePath]];
    moviePlayer.shouldAutoplay = NO;
    UIImage *image = [moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    return image;
   }
+(UIImage *)getImage:(NSString *)filePath{

    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:url options:options];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(0, 0);
    CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    return image;
}


@end
