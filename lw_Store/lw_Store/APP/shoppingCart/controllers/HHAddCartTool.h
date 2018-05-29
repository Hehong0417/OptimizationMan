//
//  HHAddCartTool.h
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHAddCartTool : UIView

//购物车图标底图
@property (nonatomic, strong)   UIView *cartIconBg;
//购物车图标
@property (nonatomic, strong)   UIImageView *cartIconImgV;
//加入购物车按钮
@property (nonatomic, strong)   UIButton *addCartBtn;
//立即购买按钮
@property (nonatomic, strong)   UIButton *buyBtn;

@property (nonatomic, copy)   voidBlock  addCartBlock;

@property (nonatomic, copy)   voidBlock  buyBlock;

@end
