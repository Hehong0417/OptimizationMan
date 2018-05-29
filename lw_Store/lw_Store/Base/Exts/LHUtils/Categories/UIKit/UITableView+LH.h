//
//  UITableView+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LH)

/**
 *  初始化
 *
 *  @param frame          大小
 *  @param tableViewStyle 表格样式
 *  @param delegate       代理
 *  @param dataSource     数据源
 *
 *  @return 实例
 */
+ (UITableView *)lh_tableViewWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)tableViewStyle delegate:(id<UITableViewDelegate>)delegate dataSourec:(id<UITableViewDataSource>)dataSource;

/**
 *  设置分割线为0，iOS8以上还需要实现代理方法 willDisplayCell
 */
- (void)lh_setSeparatorInsetZero;

@end
