//
//  HJGroupTableVC.h
//  Bsh
//
//  Created by zhipeng-mac on 15/12/17.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJStaticGroupTableVC : UITableViewController

@property (strong, nonatomic) NSMutableArray * groups;/**< 组数组 描述TableView有多少组 */
@property (nonatomic, strong) UIImageView *cellHeadImageView;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UITextField *cellTextField;


/**
 *  @author lh
 *
 *  静态cell数据源
 */
- (NSArray *)groupTitles;
- (NSArray *)groupIcons;
- (NSArray *)groupDetials;
- (NSArray *)indicatorIndexPaths;//detailTitle有值时默认不显示箭头，这里可以添加箭头

- (void)setGroups;

- (HJSettingItem *)settingItemInIndexPath:(NSIndexPath *)indexPath;
/**
 *  @author hejing
 *
 *  是否显示箭头,默认显示
 */
- (BOOL)isSettingIndicator;

- (FontAttributes *)titleLabelFontAttributes;
- (FontAttributes *)detailLabelFontAttributes;
/**
 *  @author hejing
 *
 *  第一组的间距
 */
- (CGFloat)firstGroupSpacing;

/**
  setRoundImage
 
 @return yes
 */
- (BOOL)setRoundImage;

/**
 头像的宽

 @return cgfloat
 */
- (CGFloat)imageViewSizeW;


/**
 头像的高

 @return cgfloat
 */
- (CGFloat)imageViewSizeH;


/**
 头像是否在左边
 
 @return cgfloat
 */
- (BOOL)headImageInLeft;

/**
 *  @author hejing
 *
 *  头像cell indexPath
 */
- (NSIndexPath *)headImageCellIndexPath;



/**
 textfiledCell

 @return textfield 数组
 */
- (NSArray *)textFieldCellIndexPaths;


/**
 textFieldTitle

 @return titles数组
 
 */

- (NSArray *)textFieldTitles;


/**
 textFieldPlaceholder

 @return Placeholders 数组
 */
- (NSArray *)textFieldPlaceholders;



/**
 *  @author hejing
 *
 *  点击选中效果
 */
- (UITableViewCellSelectionStyle)cellSelectionStyle;

/**
 *  @author hejing
 *
 *  右边的类型是UISwitch的cell路径
 */
- (NSArray *)rightViewSwitchIndexPaths;

/**
 *  @author hejing
 *
 *  table HeadView 的title
 */
- (NSArray *)tableSectionHeaderViewTitle;

/**
 *  @author hejing
 *
 *   打开拍照和相册选择底部弹框
 */
- (void)showPhotoSheetActionWithFinishSelectedBlock:(idBlock)finshiSelectedPhoto;

@end
