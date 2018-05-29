//
//  HHApplyDelegateCell.h
//  lw_Store
//
//  Created by User on 2018/5/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^delegate_btnSelectAction)(NSIndexPath *indexPath,BOOL leftButtonSelected);


@interface HHApplyDelegateCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *delegate_btn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, copy) delegate_btnSelectAction delegate_btnSelectAction;
@property (nonatomic, assign) BOOL btn_selected;
@property (strong, nonatomic) HHMineModel *model;
@property (weak, nonatomic) IBOutlet UILabel *price_label;

@end
