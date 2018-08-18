//
//  HHSelectPhotosCell.h
//  lw_Store
//
//  Created by User on 2018/5/2.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSelectPhotosCell : UITableViewCell

@property (nonatomic ,strong) UIViewController *vc;
@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;
@property (nonatomic ,assign) NSInteger section;

@end
