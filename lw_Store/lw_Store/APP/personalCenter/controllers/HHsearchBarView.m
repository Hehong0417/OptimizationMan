//
//  HHsearchBarView.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHsearchBarView.h"

@interface HHsearchBarView()

@end

@implementation HHsearchBarView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.search_view lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
    
    [self.search_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];

    
}

@end
