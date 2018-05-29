//
//  HHGoodListVC.h
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HHGoodListVC : UIViewController

@property(nonatomic,strong)   NSNumber *type;
@property(nonatomic,strong)   NSString *categoryId;
@property(nonatomic,strong)   NSString *name;
@property(nonatomic,strong)   NSNumber *orderby;
@property(nonatomic,assign)   HHenter_Type enter_Type;

@end
