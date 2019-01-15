//
//  HHActivityView.h
//  lw_Store
//
//  Created by User on 2019/1/9.
//  Copyright © 2019年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHActivityView : UIView

@property(nonatomic,strong)  UILabel *titleLabel;
@property(nonatomic,strong)  UIView *contentImageView;
@property(nonatomic,strong)  HHCategoryModel *gift_Model;
@property(nonatomic,strong)  UILabel *namelabel;
@property(nonatomic,strong)  UIButton *ReceiveButton;

@end

NS_ASSUME_NONNULL_END
