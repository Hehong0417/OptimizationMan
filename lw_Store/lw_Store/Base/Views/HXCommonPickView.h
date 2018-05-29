//
//  HXCommonPickView.h
//  HXBudsProject
//
//  Created by n on 2017/3/6.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum : NSUInteger {
    HXCommonPickViewStyleDate,
    HXCommonPickViewStyleSex,
    HXCommonPickViewStyleDIY
    
} HXCommonPickViewStyle;

@interface HXCommonPickView : UIView

@property(nonatomic,assign)  HXCommonPickViewStyle style;

@property(nonatomic,strong)  UIView *contentView;

@property (assign, nonatomic) BOOL animated;

@property(nonatomic,strong)  NSString *selectedItem;

@property(nonatomic,strong)  UIDatePicker *datePick;

@property(nonatomic,assign)  NSInteger selectIndex;

@property(nonatomic,copy)  stringBlock completeBlock;

@property(nonatomic,copy)  idBlock completeBlock2;

- (void)setStyle:(HXCommonPickViewStyle)style titleArr:(NSArray *)titleArr;
- (void)setStyle:(HXCommonPickViewStyle)style minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate titleArr:(NSArray *)titleArr;

- (void)showPickViewAnimation:(BOOL)animated;
- (void)hidePickViewComplete:(void(^)())completeBlock;

@end
