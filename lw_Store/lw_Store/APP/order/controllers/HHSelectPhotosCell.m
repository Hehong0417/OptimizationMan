//
//  HHSelectPhotosCell.m
//  lw_Store
//
//  Created by User on 2018/5/2.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSelectPhotosCell.h"
#import "TZImagePickerController.h"
#import "CollectionViewCell.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

typedef   void (^completeHandle)();

@interface HHSelectPhotosCell ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YYTextViewDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
    MBProgressHUD  *hud;
}
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) YYTextView  *textView;

@property BOOL isSelectOriginalPhoto;
@end

@implementation HHSelectPhotosCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //textView
        self.textView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, WidthScaleSize_H(150))];
        self.textView.placeholderText = @"点击输入你对宝贝的看法，宝贝们满足您的期待嘛？说说你的使用心得，分享给想买它们的人吧～";
        self.textView.placeholderFont = FONT(14);
        self.textView.delegate = self;
        self.textView.font = FONT(14);
        [self.contentView addSubview:self.textView];

        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.scrollEnabled = NO;
        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
}
- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (NSMutableArray *)assestArray{
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _margin = 4;
        _itemWH = (self.contentView.bounds.size.width - 2 * _margin - 4) / 3 - _margin;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake((Kwidth - 50)/ 4, (Kwidth - 50)/ 4);
        flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, WidthScaleSize_H(150), Kwidth, WidthScaleSize_H(100)) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //self.collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidEndEditing:(YYTextView *)textView{
    
    HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    HHproductEvaluateModel  *evaluate_m  = oEvaluateItem.productEvaluate[self.section];
    evaluate_m.content = textView.text;
    [oEvaluateItem write];
    
    NSLog(@"textViewDidEndEditing");
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 11 && range.length!=1){
        textView.text = [toBeString substringToIndex:11];
        return NO;
    }
    return YES;
}
- (void)checkLocalPhoto{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    [self.vc presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    //上传多张图片
    [self uploadPhotosWithPhotos:photos completeHandle:^{
        [hud hideAnimated:YES];
        self.photosArray = [NSMutableArray arrayWithArray:photos];
        self.assestArray = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        [_collectionView reloadData];
        
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photosArray.count) {
        [self checkLocalPhoto];
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            //上传多张图片
            [self uploadPhotosWithPhotos:photos completeHandle:^{
                _photosArray = [NSMutableArray arrayWithArray:photos];
                _assestArray = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_photosArray.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            
           
        }];
        [self.vc presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

        return _photosArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == _photosArray.count) {
        cell.imagev.image = [UIImage imageNamed:@"add_pic"];
        //cell.imagev.backgroundColor = [UIColor redColor];
        cell.deleteButton.hidden = YES;
        
    }else{
        cell.imagev.image = _photosArray[indexPath.row];
        cell.deleteButton.hidden = NO;
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
#pragma mark- 上传多张图片

- (void)uploadPhotosWithPhotos:(NSArray *)photos completeHandle:(completeHandle)completeHandle{
    
    hud = [MBProgressHUD showHUDAddedTo:self.vc.view animated:YES];
    hud.color = KA0LabelColor;
    hud.detailsLabelText = @"完成中";
    hud.detailsLabelColor = kWhiteColor;
    hud.detailsLabelFont = FONT(14);
    hud.activityIndicatorColor = kWhiteColor;
    [hud show:YES];
    
    NSMutableArray *photo_datas = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [photo_datas addObject:imageData];
    }];
    
    [[[HHMineAPI postUploadManyImageWithimageDatas:photo_datas] netWorkClient] uploadFileInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        [hud hideAnimated:YES];
        if (!error) {
            if (api.State == 1) {
                
              HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
                if (oEvaluateItem.productEvaluate>0) {
                    HHproductEvaluateModel  *evaluate_m  = oEvaluateItem.productEvaluate[self.section];
                    evaluate_m.pictures = api.Path;
                    
                    [oEvaluateItem write];
                    completeHandle();
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
- (void)deletePhotos:(UIButton *)sender{
    
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
@end
