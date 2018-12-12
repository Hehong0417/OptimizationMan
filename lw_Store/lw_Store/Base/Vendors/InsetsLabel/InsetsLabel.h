//
//  InsetsLabel.h
//  springDream
//
//  Created by User on 2018/12/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets edgeInsets;
-(id) initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
