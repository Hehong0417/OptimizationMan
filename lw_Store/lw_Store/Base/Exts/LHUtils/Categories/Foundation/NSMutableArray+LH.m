//
//  NSMutableArray+LH.m
//  Ddsc
//
//  Created by zhipeng-mac on 16/1/23.
//  Copyright (c) 2016年 hejing. All rights reserved.
//

#import "NSMutableArray+LH.h"

@implementation NSMutableArray (LH)

- (void)lh_replaceObjectInOneIndex:(NSUInteger)oneIndex allWithNewObj:(id)newObj {
    
    [self enumerateObjectsUsingBlock:^(NSArray *twoIndexArr, NSUInteger idx, BOOL *stop) {
        
        if (idx == oneIndex) {
            
            NSMutableArray *m_twoIndexArr = [NSMutableArray array];
            
            [twoIndexArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [m_twoIndexArr addObject:newObj];
            }];
            
            [self replaceObjectAtIndex:idx withObject:m_twoIndexArr];
        }
    }];
}

- (void)lh_addObjectInOneIndex:(NSUInteger)oneIndex oneKey:(NSString *)oneKey WithObj:(id)obj{
    
    [self enumerateObjectsUsingBlock:^(NSArray *twoIndexArr, NSUInteger idx, BOOL *stop) {
        
        if (idx == oneIndex) {
            
            NSMutableArray *m_twoIndexArr = [twoIndexArr mutableCopy];
            [m_twoIndexArr addObject:obj];
            
            [self replaceObjectAtIndex:idx withObject:m_twoIndexArr];
        }
    }];
}

- (void)lh_replaceObjectInOneIndex:(NSUInteger)oneIndex twoIndex:(NSUInteger)twoIndex WithObj:(id)obj {
    //leftSelectArr
    [self enumerateObjectsUsingBlock:^(NSArray *twoIndexArr, NSUInteger idx, BOOL *stop) {
        
        if (idx == oneIndex) {
            
            NSMutableArray *m_twoIndexArr = [twoIndexArr mutableCopy];
            [m_twoIndexArr replaceObjectAtIndex:twoIndex withObject:obj];
            
            [self replaceObjectAtIndex:idx withObject:m_twoIndexArr];
        }
    }];
}

- (id)lh_getObjectWithOndeListKey:(NSString *)oneListKey oneListValue:(id)ondeListValue twoListKey:(NSString *)twoListKey twoListIndexKey:(NSString *)twoListIndexKey twoListValue:(id)twoListValue threeListKey:(NSString *)threeListKey threeListIndexKey:(NSString *)threeListIndexKey threeListValue:(id)threeListValue{
    
    __block id returnObj;
    //一级遍历开始
    [self enumerateObjectsUsingBlock:^(NSDictionary *oneDict, NSUInteger idx, BOOL *stop) {
        
        if ([[oneDict objectForKey:oneListKey]isEqual:ondeListValue]) {
            
            //二级遍历开始
            NSArray *twoList = [oneDict objectForKey:twoListIndexKey];
            [twoList enumerateObjectsUsingBlock:^(NSDictionary *twoDict, NSUInteger idx, BOOL *stop) {
                
                if ([[twoDict objectForKey:twoListKey]isEqual:twoListValue]) {
                    
                    //三级遍历开始
                    NSArray *threeList = [twoDict objectForKey:threeListIndexKey];
                    
                    [threeList enumerateObjectsUsingBlock:^(NSDictionary *threeDict, NSUInteger idx, BOOL *stop) {
                        
                        if ([[threeDict objectForKey:threeListKey]isEqual:threeListValue]) {
                            
                            returnObj = threeDict;
                            
                            *stop = YES;
                        }
                    }];
                    
                    *stop = YES;//二级遍停止
                }
                
            }];
            
            *stop = YES;//一级遍历停止
        }
    }];
    
    return returnObj;
}

@end
