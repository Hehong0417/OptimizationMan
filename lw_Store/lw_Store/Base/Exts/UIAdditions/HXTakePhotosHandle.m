//
//  HXTakePhotosHandle.m
//  mengyaProject
//
//  Created by n on 2017/6/22.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HXTakePhotosHandle.h"
#import "GetFilePath.h"
#import "HXRecordVideoVC.h"

@implementation HXTakePhotosHandle

+ (instancetype)shareManager{

    static HXTakePhotosHandle  *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HXTakePhotosHandle alloc]init];
    });
    
    return _manager;
}

- (void)showPhotoSheetActionWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto {
    
    self.finishSelectedPhoto = finshiSelectedPhoto;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [self.vc presentViewController:alertC animated:YES completion:nil];
    
}

//录制视频

- (void)recordVideoAction:(idBlock)finshiSelectedPhoto{
    
    self.finishSelectedPhoto = finshiSelectedPhoto;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        HXRecordVideoVC *ipc = [[HXRecordVideoVC alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.mediaTypes = [ UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
        ipc.videoMaximumDuration = 180.0;
        ipc.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        ipc.navigationBar.opaque = true;
        ipc.automaticallyAdjustsScrollViewInsets = YES;
        [self.vc presentViewController:ipc animated:YES completion:nil];
    }else {
    
        [UIAlertView lh_showWithMessage:@"当前设备不支持拍摄功能"];

    }

}
//选择视频上传
- (void)selectVideoWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto{

    self.finishSelectedPhoto = finshiSelectedPhoto;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes = @[@"public.movie"];
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self.vc presentViewController:ipc animated:YES completion:nil];
    }

}
//选择照片
- (void)selectImageWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto{

    self.finishSelectedPhoto = finshiSelectedPhoto;

    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];

    
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            HXRecordVideoVC *ipc = [[HXRecordVideoVC alloc] init];
            ipc.sourceType = sourceType;
            ipc.allowsEditing = YES;
            ipc.delegate = self;
            [self.vc presentViewController:ipc animated:YES completion:nil];
        }else{
            
           UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = sourceType;
            ipc.allowsEditing = YES;
            ipc.delegate = self;
            [self.vc presentViewController:ipc animated:YES completion:nil];
        }
    }else {
        [UIAlertView lh_showWithMessage:@"当前设备不支持拍摄功能"];
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = info[UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
            self.finishSelectedPhoto(image);
            
        }];
    }else if([type isEqualToString:@"public.movie"]){
        
        
        NSString *videoPath = [GetFilePath getSavePathWithFileSuffix:@".mp4"];
        
//        NSFileManager *manager = [NSFileManager defaultManager];
//      
//        BOOL success = [manager fileExistsAtPath:videoPath];
//        if (success) {
//            [manager removeItemAtPath:videoPath error:nil];
//        }
        
        NSURL *inputURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSLog(@"原视频时长:%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:inputURL]]);
        NSLog(@"原视频大小:%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[inputURL path]]]);
        CGFloat second = [self getVideoLength:inputURL];
        if ([self.talentVideo isEqualToString:@"talentVideo"]) {
            
            if (second>300) {
                
                [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                [SVProgressHUD showInfoWithStatus:@"视频大于5分钟，请重新选择"];
                
                return ;
            }
            
        }else{
           if (second > 180) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD showInfoWithStatus:@"视频大于3分钟，请重新选择"];
            
            return ;
           }
        }
        NSURL *outputUrl = [NSURL fileURLWithPath:videoPath];
        
//        NSData *videoData = [NSData dataWithContentsOfURL:outputUrl];
//        BOOL save =  [videoData writeToFile:videoPath atomically:YES];
//        if (save) {
//
//        }
        
        UIImage *image;
        if (inputURL) {
            
          image = [GetFilePath getImage:[inputURL path]];
            NSLog(@"缩略图：%@",image);
            //        if (image.size.width < 500) {
            
            UIImage *cutImage = nil;
            //裁剪
            cutImage =  [image cutPictureWithRect:CGRectMake(0, 80, image.size.width, image.size.width*388/690) image:image];
            
            //压缩视频
            [self convertVideoQuailtyWithInputURL:inputURL outputURL:outputUrl completeHandler:nil];
            
            [self.vc dismissViewControllerAnimated:YES completion:^{
                
                self.finishSelectedPhoto(cutImage);
            }];

        }else{
        
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD showInfoWithStatus:@"视频有问题，请重新上传！"];
        }
    }
    
}
//*******************************//
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    NSLog(@"inputURL:%@",[NSString stringWithFormat:@"%@", inputURL]);
    NSLog(@"outputURL:%@", [NSString stringWithFormat:@"%@", outputURL]);
    
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"视频时长:%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 NSLog(@"视频大小:%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
//                 UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 
                 [self uploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
}
-(void)uploadVideo:(NSURL*)URL{
    
    NSData *data = [NSData dataWithContentsOfURL:URL];
    if (self.finishCompressVideoData) {
        self.finishCompressVideoData(data,URL);
    }
    
}
//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

//此方法可以获取视频文件的时长。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

//******************************//
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    picker.delegate = nil;
    picker = nil;
}


@end
