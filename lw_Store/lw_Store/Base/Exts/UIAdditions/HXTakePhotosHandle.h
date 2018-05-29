//
//  HXTakePhotosHandle.h
//  mengyaProject
//
//  Created by n on 2017/6/22.
//  Copyright © 2017年 n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXTakePhotosHandle : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIViewController *vc;


@property (nonatomic, copy) idBlock finishSelectedPhoto;

@property (nonatomic, copy) idBlock2 finishCompressVideoData;

@property (nonatomic, strong) NSString *talentVideo;





+ (instancetype)shareManager;

/**
 *  @author hejing
 *
 *   打开拍照和相册选择底部弹框
 */
- (void)showPhotoSheetActionWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto;


/**
    录制视频
 */
- (void)recordVideoAction:(idBlock)finshiSelectedPhoto;

/**
 *  @author hejing
 *
 *   打开相册选择视频
 */
- (void)selectVideoWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto;


/**
 *  @author hejing
 *
 *   打开相册选择照片
 */
- (void)selectImageWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto;




@end
