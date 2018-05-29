//
//  NSMutableArray+LH.h
//  Ddsc
//
//  Created by zhipeng-mac on 16/1/23.
//  Copyright (c) 2016年 hejing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LH)

- (void)lh_replaceObjectInOneIndex:(NSUInteger)oneIndex allWithNewObj:(id)newObj;

- (void)lh_addObjectInOneIndex:(NSUInteger)oneIndex oneKey:(NSString *)oneKey WithObj:(id)obj;

- (void)lh_replaceObjectInOneIndex:(NSUInteger)oneIndex twoIndex:(NSUInteger)twoIndex WithObj:(id)obj;

-  (id)lh_getObjectWithOndeListKey:(NSString *)oneListKey oneListValue:(id)ondeListValue twoListKey:(NSString *)twoListKey twoListIndexKey:(NSString *)twoListIndexKey twoListValue:(id)twoListValue threeListKey:(NSString *)threeListKey threeListIndexKey:(NSString *)threeListIndexKey threeListValue:(id)threeListValue;

@end
