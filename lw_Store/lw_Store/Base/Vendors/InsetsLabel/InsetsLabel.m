//
//  InsetsLabel.m
//  springDream
//
//  Created by User on 2018/12/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

@synthesize edgeInsets=_edgeInsets;
-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
