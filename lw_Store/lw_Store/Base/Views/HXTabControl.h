//
//  HXTabControl.h
//  HXBudsProject
//
//  Created by n on 2017/5/10.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didselectTabControlItem)(NSString *money);

@interface HXTabControl : UIView

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *moneyArr;

@property(nonatomic,copy)didselectTabControlItem  selectTabControlBlock;

@property(nonatomic,strong)NSString *titleStr;

@property(nonatomic,strong)UILabel *titleLab;

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
