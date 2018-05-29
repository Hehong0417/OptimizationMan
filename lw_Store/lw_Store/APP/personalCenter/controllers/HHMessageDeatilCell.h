//
//  HHMessageDeatilCell.h
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEvaluationListModel.h"

@interface HHMessageDeatilCell : UITableViewCell<UIWebViewDelegate>

@property (strong, nonatomic)  UILabel *msg_titleLabel;
@property (strong, nonatomic)  UIWebView *msg_contentWebView;
@property (strong, nonatomic)  UILabel *dateTimeLabel;
@property (strong, nonatomic)  UINavigationController *nav;
@property (strong, nonatomic)  UILabel *line;



@property(nonatomic,strong) HHMineModel *model;

- (void)setShadowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(HHMineModel *)model;

@end
