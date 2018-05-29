//
//  HXTabControl.m
//  HXBudsProject
//
//  Created by n on 2017/5/10.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HXTabControl.h"
#import "HXTabControlCell.h"


@interface HXTabControl ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation HXTabControl

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
//        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 25)];
//        [self addSubview:self.titleLab];
//        self.moneyArr = @[@"20",@"50",@"100",@"200",@"300",@"500"];
//        self.collectionView.frame = CGRectMake(0, 41, SCREEN_WIDTH, frame.size.height - 41);
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = kWhiteColor;
        [self addSubview:_collectionView];
        [self.collectionView registerClass:[HXTabControlCell class] forCellWithReuseIdentifier:@"HXTabControlCell"];
    }

    return self;
}
- (void)setTitleStr:(NSString *)titleStr {

    _titleStr = titleStr;
    
    self.titleLab.text = titleStr;
    
}
- (void)setMoneyArr:(NSArray *)moneyArr {

    _moneyArr = moneyArr;
    [self.collectionView reloadData];
}
- (UICollectionView *)collectionView {

    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 8;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 5*15 )/4, WidthScaleSize_H(35));
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HXTabControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXTabControlCell" forIndexPath:indexPath];
    [cell  lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];


    NSString *priceStr = self.moneyArr[indexPath.row];
    cell.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",priceStr.floatValue] ;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(WidthScaleSize_H(15), WidthScaleSize_W(15), WidthScaleSize_H(0), WidthScaleSize_W(15));
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HXTabControlCell *cell = (HXTabControlCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = APP_COMMON_COLOR;
    cell.moneyLab.textColor = kWhiteColor;
    if (self.selectTabControlBlock) {
        self.selectTabControlBlock(self.moneyArr[indexPath.row]);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    HXTabControlCell *cell = (HXTabControlCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    cell.moneyLab.textColor = APP_COMMON_COLOR;
}

@end
