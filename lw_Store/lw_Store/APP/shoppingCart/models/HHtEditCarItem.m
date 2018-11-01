//
//  HHtEditCarItem.m
//  Store
//
//  Created by User on 2018/1/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHtEditCarItem.h"

@implementation HHtEditCarItem

+(instancetype)shopCartGoodsList:(NSArray *)shopCartGoodsList selectionArr:(NSArray *)selectionArr{
    
    __block NSMutableArray *productsArr = [NSMutableArray array];
    
    [shopCartGoodsList enumerateObjectsUsingBlock:^(HHproductsModel  *productModel, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [selectionArr enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger twoIdx, BOOL * _Nonnull stop) {
            if ([index isEqual:@1]) {
                if (twoIdx == idx) {
                    [productsArr addObject:productModel];
                }
            }
        }];
        
    }];
    HHtEditCarItem *editCarItem  = [HHtEditCarItem settleGoodsModelWithGoodsList:productsArr];

    __block BOOL allSelect = YES;
    [selectionArr enumerateObjectsUsingBlock:^(NSNumber *select, NSUInteger idx, BOOL * _Nonnull stop) {
        if (select.boolValue == NO) {
             allSelect = NO;
            *stop = YES;
        }
    }];
     editCarItem.settleAllSelect = allSelect;
    
    return  editCarItem;
}

+ (instancetype)settleGoodsModelWithGoodsList:(NSArray *)goodsList{
    
    if (goodsList.count>0) {
        HHtEditCarItem *editCarItem = [HHtEditCarItem new];

        __block  CGFloat totalPrice = 0;
        
        [goodsList enumerateObjectsUsingBlock:^(HHproductsModel  *productsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat price_total = productsModel.price.floatValue;
            totalPrice +=price_total;
        }];
        editCarItem.total_Price = totalPrice;
        return  editCarItem;
    }else {
        HHtEditCarItem *editCarItem = [HHtEditCarItem new];
        editCarItem.total_Price = 0;
        return editCarItem;
    }
    
}

@end
