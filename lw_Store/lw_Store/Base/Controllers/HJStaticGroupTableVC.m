//
//  HJGroupTableVC.m
//  Bsh
//
//  Created by zhipeng-mac on 15/12/17.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "HJStaticGroupTableVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HXRecordVideoVC.h"

static const CGFloat kNormalTableSectionHeaderViewHeight = 30;
static const CGFloat kNormalGroupSpacing = 5;
static const CGFloat kNormalCellHeight = 44;

@interface HJStaticGroupTableVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, copy) idBlock finshiSelectedPhoto;
@end
@implementation HJStaticGroupTableVC

- (void)loadView {
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tableV = [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-49-NAVBAR_HEIGHT-Status_HEIGHT) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tableV.backgroundColor = kClearColor;
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedRowHeight = 0;

    [self.view addSubview:self.tableV];
    self.tableV.tableFooterView = [UIView new];

}
-(void)viewDidLoad {
    [super viewDidLoad];
    //tableView数据源设置
    [self setGroups];
    
}
- (void)setGroups{
    
    __block NSMutableArray *groups = [NSMutableArray array];
    
    [self.groupTitles enumerateObjectsUsingBlock:^(NSArray *itemTitles, NSUInteger idx, BOOL *stop) {
        
        // 创建组模型
        HJGroupItem *group = [[HJGroupItem alloc]init];
        // 创建行模型
        NSMutableArray *items = [NSMutableArray array];
        
        NSArray *itemIcons = [self.groupIcons objectAtIndex:idx];
        NSArray *itemDetails = [self.groupDetials objectAtIndex:idx];
        [itemTitles enumerateObjectsUsingBlock:^(NSString *itemTitle, NSUInteger idx, BOOL *stop) {
            
            HJSettingItem *settingItem = [HJSettingItem itemWithtitle:itemTitle image:itemIcons[idx]];
            settingItem.detailTitle = itemDetails[idx];
            [items addObject:settingItem];
        }];
        
        group.items = items;
        
        [groups addObject:group];
        
    }];
    
    self.groups = [groups mutableCopy];
}

- (HJSettingItem *)settingItemInIndexPath:(NSIndexPath *)indexPath {
    
    HJGroupItem *groupItem = [self.groups objectAtIndex:indexPath.section];
    
    return  [groupItem.items objectAtIndex:indexPath.row];
}

- (void)updateIco:(UIImage *)image {
    
    self.cellHeadImageView.image = image;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    HJGroupItem *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     静态cell不去重用队列获取
     */
      UITableViewCell  *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = self.cellSelectionStyle;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    HJGroupItem *group = self.groups[indexPath.section];
    HJSettingItem *item = group.items[indexPath.row];
    
    cell.textLabel.textColor = self.titleLabelFontAttributes.fontColor;
    cell.textLabel.font = self.titleLabelFontAttributes.font;
    cell.textLabel.text = item.title;
    
    //
    if (item.image.length>0) {
        
        cell.imageView.image = [UIImage imageNamed:item.image];
    }
    //
    
    cell.detailTextLabel.text = item.detailTitle;
    cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.textColor = self.detailLabelFontAttributes.fontColor;
    if (self.isSettingIndicator) {
        
        // 设置Cell右边的小箭头
        if (item.detailTitle.length > 0) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        //detailTitle有值时可以设置箭头此时仍然存在
        if (self.indicatorIndexPaths) {
            
            [self.indicatorIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indicatorIndexPath, NSUInteger idx, BOOL *stop) {
                
                if ([indicatorIndexPath isEqual:indexPath]) {
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }];
        }
    }
    
    //右边按钮是UISwitch类型
    if (self.rightViewSwitchIndexPaths) {
        
        [self.rightViewSwitchIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indicatorIndexPath, NSUInteger idx, BOOL *stop) {
            
            if ([indicatorIndexPath isEqual:indexPath]) {
                
                cell.accessoryView = [UISwitch new];
            }
        }];
    }
    
    //头像cell
    if ([indexPath isEqual:self.headImageCellIndexPath]) {
        
        CGFloat imageViewSizeW = self.imageViewSizeW?self.imageViewSizeW:AdapationLabelHeight(60);
        CGFloat imageViewSizeH = self.imageViewSizeH?self.imageViewSizeH:AdapationLabelHeight(60);
        
        CGFloat imageViewX = SCREEN_WIDTH-imageViewSizeW - 35;

        if (self.headImageInLeft) {
            
            imageViewX = AdapationLabelHeight(105);
        }
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:self.headImageCellIndexPath];
        
        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, (height-imageViewSizeH)/2.0, imageViewSizeW, imageViewSizeH)];
        if (self.setRoundImage) {
            [headImageView lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
        }
        DLog(@"*******%.2f",height);
        [headImageView setBackgroundColor:[UIColor lightGrayColor]];
//        [headImageView setRoundImageViewWithBorderWidth:0];
        self.cellHeadImageView = headImageView;
        [cell.contentView addSubview:headImageView];
        
    }
    
    //textfield
    if (self.textFieldCellIndexPaths) {
        
        [self.textFieldCellIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indicatorIndexPath, NSUInteger idx, BOOL *stop) {
            
            if ([indicatorIndexPath isEqual:indexPath]) {
                
                UITextField *textFiled = [UITextField lh_textFieldWithFrame:CGRectMake(114, 0, SCREEN_WIDTH-44, AdapationLabelHeight(44)) placeholder:self.textFieldPlaceholders[indexPath.row - 1] font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
                textFiled.delegate = self;
                textFiled.tag = indexPath.row;
                if (indexPath.row == 2) {
                    textFiled.keyboardType = UIKeyboardTypeNumberPad;
                }
                self.cellTextField = textFiled;
                [cell.contentView addSubview:textFiled];
            }
        }];
        
    }
    return cell;
}

#pragma  mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
//    if (!self.tableSectionHeaderViewTitle) {
//        
//        if (section == 0 && self.firstGroupSpacing > 0) {
//            
//            
//            return self.firstGroupSpacing;
//        }
//        
//        return kNormalGroupSpacing;
//    }else {
//        
//       NSString *tableSectionTitle = [self.tableSectionHeaderViewTitle objectAtIndex:section];
//        
//        if (tableSectionTitle.length >0) {
//            
//            return kNormalTableSectionHeaderViewHeight;
//        }else {
//            
//            if (self.firstGroupSpacing>0 && section ==0) {
//                
//                return self.firstGroupSpacing;
//            }
                if (section == 0) {
                    
                 return 0.01;
                    
                }else{
                    return kNormalGroupSpacing;
                }
//        }
//    }
//    return 0.01;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *tableSectionTitle = [self.tableSectionHeaderViewTitle objectAtIndex:section];
    if (tableSectionTitle.length >0) {
        
        UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, self.tableView.lh_width, kNormalTableSectionHeaderViewHeight) backColor:kClearColor];
        
        UILabel *headLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30) text:tableSectionTitle textColor:FontGrayColor font:FontSmallSize textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [headView addSubview:headLabel];
        
        return headView;
        
    }else {
        
        if (section == 0) {
            
            UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, self.tableView.lh_width, self.firstGroupSpacing>0?self.firstGroupSpacing:kNormalGroupSpacing) backColor:kClearColor];

            return headView;
        }
        
        UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, self.tableV.lh_width, kNormalGroupSpacing) backColor:kClearColor];

        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
        return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kNormalCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath isEqual:self.headImageCellIndexPath]) {
        
        [self showPhotoSheetActionWithFinishSelectedBlock:^(UIImage *image) {
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
//   上传头像
            MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.color = KA0LabelColor;
            hud.detailsLabelText = @"头像正在上传中...";
            hud.detailsLabelColor = kWhiteColor;
            hud.detailsLabelFont = FONT(14);
            hud.activityIndicatorColor = kWhiteColor;
            [hud show:YES];
            
            
//
            }];
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    // Prevent the cell from inheriting the Table View's margin settings
//    if (iOS8) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//        // Explictly set your cell's layout margins
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - 拍照 & 相册

- (void)showPhotoSheetActionWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto {
    
    self.finshiSelectedPhoto = finshiSelectedPhoto;
    
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
    [self presentViewController:alertC animated:YES completion:nil];
    
}
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            HXRecordVideoVC *ipc = [[HXRecordVideoVC alloc] init];
            ipc.sourceType = sourceType;
            ipc.allowsEditing = YES;
            ipc.delegate = self;
            [self presentViewController:ipc animated:YES completion:nil];
        }else{
            
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = sourceType;
            ipc.allowsEditing = YES;
            ipc.delegate = self;
            [ipc setModalPresentationStyle:UIModalPresentationFullScreen];
            [ipc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:ipc animated:YES completion:nil];
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

            self.finshiSelectedPhoto(image);
            
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    picker.delegate = nil;
    picker = nil;
}


- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
        
    }
    return _groups;
}

- (NSArray *)groupIcons {
    
    return nil;
}

- (NSArray *)groupTitles {
    
    return nil;
}

- (NSArray *)groupDetials {
    
    return nil;
}

- (NSArray *)indicatorIndexPaths {
    
    return nil;
}

- (NSArray *)rightViewSwitchIndexPaths {
    
    return nil;
}
- (NSArray *)textFieldCellIndexPaths{

    return nil;
}

- (NSArray *)textFieldTitles{

    return nil;

}
- (NSArray *)textFieldPlaceholders{

   return @[@"请输入昵称",@"请输入手机",@"请输入姓名"];
}
- (BOOL)isSettingIndicator {
    
    return YES;
}
- (BOOL)setRoundImage{

    return YES;
}

- (FontAttributes *)titleLabelFontAttributes {
    
    return [FontAttributes fontAttributesWithFontColor:[UIColor blackColor] fontsize:WidthScaleSize_H(14)];
}
- (FontAttributes *)detailLabelFontAttributes {
    
    return [FontAttributes fontAttributesWithFontColor:KLightTitleColor fontsize:WidthScaleSize_H(14)];
}

- (CGFloat)firstGroupSpacing {
    
    return 0;
}

- (NSIndexPath *)headImageCellIndexPath {
    
    return nil;
}

- (UITableViewCellSelectionStyle)cellSelectionStyle {
    
    return UITableViewCellSelectionStyleDefault;
}

- (NSArray *)tableSectionHeaderViewTitle {
    
    return nil;
}
- (CGFloat)imageViewSizeW{

    return 0;
}


- (CGFloat)imageViewSizeH{

    return 0;

}
- (BOOL)headImageInLeft{

    return NO;
}

@end
