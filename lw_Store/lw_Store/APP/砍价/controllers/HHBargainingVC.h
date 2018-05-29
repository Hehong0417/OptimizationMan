//
//  HHBargainingVC.h
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    dese_vcType,
    bargaining_vcType
}vcType ;

@interface HHBargainingVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *howToPlayBtn;
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIButton *bargainingBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBargainingBtn;
@property(nonatomic,assign) vcType  vcType;
@property (weak, nonatomic) IBOutlet UIButton *deseBtn;

@end
