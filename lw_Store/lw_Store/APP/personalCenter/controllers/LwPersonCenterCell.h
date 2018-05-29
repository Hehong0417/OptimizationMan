//
//  LwPersonCenterCell.h
//  lw_Store
//
//  Created by User on 2018/4/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPersonCenterView.h"

@interface LwPersonCenterCell : UITableViewCell

@property (nonatomic, strong)   HHPersonCenterView *section1;
@property (nonatomic, strong)   HHPersonCenterView *section2;
@property (nonatomic, strong)   HHPersonCenterView *section3;
@property (nonatomic, strong)   UINavigationController *nav;

- (void)setCellWithUsableComm:(NSString *)usableComm fanscount:(NSString *)fanscount saletotal:(NSString *)saletotal;

@end
