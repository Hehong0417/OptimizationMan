//
//  HHPayTypeCell.h
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHPayTypeCellContentType_leftSelectBtn,//左边选择
    HHPayTypeCellContentType_rightSelectBtn//右边选择
} HHPayTypeCellContentType;

@interface HHPayTypeCell : UITableViewCell

@property(nonatomic,strong) UIButton *leftSelect_btn;
@property(nonatomic,strong) UIButton *rightSelect_btn;
@property(nonatomic,strong) UIImageView *icon_View;
@property(nonatomic,strong) UILabel *payType_label;
@property(nonatomic,assign) BOOL ishaveIconView;
@property(nonatomic,assign) HHPayTypeCellContentType ContentType;

@property(nonatomic,strong) HHcouponsModel *couponsModel;

- (instancetype)createCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentType:(HHPayTypeCellContentType)contentType haveIconView:(BOOL)haveIconView;

//选择按钮
@property(nonatomic,assign) BOOL btnSelected;

@end
