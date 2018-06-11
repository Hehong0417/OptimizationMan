//
//  HHnormalSuccessVC.h
//  lw_Store
//
//  Created by User on 2018/5/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HHnormalSuccessVC : UIViewController

@property (strong, nonatomic) NSString *title_str;
@property (strong, nonatomic) NSString *discrib_str;
@property (strong, nonatomic) NSString *title_label_str;
@property (copy, nonatomic) voidBlock backBlock;
@property(nonatomic,assign) NSInteger enter_Num;

@end
