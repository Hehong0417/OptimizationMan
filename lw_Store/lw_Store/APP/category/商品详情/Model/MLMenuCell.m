//
//  MLMenuCell.m
//  MLMenuDemo
//
//  Created by 戴明亮 on 2018/4/20.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "MLMenuCell.h"

@interface MLMenuCell ()
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIView *viewLine;

@end

@implementation MLMenuCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
    }
    return self;
}
-(void)layoutSubviews{
    
    self.labelPrice.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height/2);
    self.labelTitle.frame = CGRectMake(0, self.contentView.frame.size.height/2, self.contentView.frame.size.width, self.contentView.frame.size.height/2);
    self.viewLine.frame = CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 1);

}
- (void)setSubViews
{
    
    self.labelPrice = [[UILabel alloc] init];
    self.labelPrice.font = [UIFont systemFontOfSize:14];
    self.labelPrice.textColor = [UIColor whiteColor];
    self.labelPrice.textAlignment = NSTextAlignmentCenter;
    self.labelPrice.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.labelPrice];
    
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.font = [UIFont systemFontOfSize:14];
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.labelTitle];
    
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = kWhiteColor;
    [self.contentView addSubview:self.viewLine];
    
}

- (void)setMenuItem:(HHActivityModel *)menuItem
{
    _menuItem = menuItem;
   
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",menuItem.Price];

    if ([menuItem.Mode isEqual:@2]) {
        //拼团
        self.labelTitle.text = [NSString stringWithFormat:@"%@人团",menuItem.Count];
    }else if ([menuItem.Mode isEqual:@8]){
        self.labelTitle.text = @"送礼";
    }else if ([menuItem.Mode isEqual:@32]){
        self.labelTitle.text = @"降价团";
    }else if ([menuItem.Mode isEqual:@4096]){
        
        self.labelTitle.text = @"砍价";
    }

}

@end
