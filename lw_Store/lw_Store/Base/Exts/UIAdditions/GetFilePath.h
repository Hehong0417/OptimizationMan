//
//  GetFilePath.h
//  mengyaProject
//
//  Created by n on 2017/6/22.
//  Copyright © 2017年 n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetFilePath : NSObject

//获取要保存的本地文件路径
+(NSString *)getSavePathWithFileSuffix:(NSString *)suffix;

//获取录像的缩略图
+(UIImage *)getVideoTumbnailWithFilepath:(NSString *)filePath;


+(UIImage *)getImage:(NSString *)filePath;


@end
