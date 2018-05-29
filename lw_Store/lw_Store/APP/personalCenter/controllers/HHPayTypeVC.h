//
//  HHPayTypeVC.h
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol payTypeDelegate <NSObject>

- (void)commitActionWithBtn:(UIButton *)btn;

@end
@interface HHPayTypeVC : UITableViewController

@property(nonatomic,copy) id<payTypeDelegate> delegate;

@end
