//
//  HXTextfieldItem.m
//  mengyaProject
//
//  Created by n on 2017/6/14.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HHTextfieldcell.h"

@implementation HHTextfieldcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if ([reuseIdentifier isEqualToString:@"imageIcon"]) {
            
            [self .contentView addSubview:self.imageIcon];

        }else if ([reuseIdentifier isEqualToString:@"titleLabel"]){
        
            [self.contentView addSubview:self.titleLabel];
        }
        
            [self.contentView addSubview:self.inputTextField];
        
    }

    return self;
}
- (UITextField *)inputTextField {

    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, SCREEN_WIDTH - CGRectGetMaxX(self.titleLabel.frame)-20, WidthScaleSize_H(50))];
        _inputTextField.font = FONT(15);
    }
    return _inputTextField;
}

- (UIImageView *)imageIcon {

    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WidthScaleSize_W(20), 0, 40, WidthScaleSize_H(50))];
        _imageIcon.contentMode = UIViewContentModeCenter;
    }
    return _imageIcon;

}
- (UILabel *)titleLabel {

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WidthScaleSize_W(18), 0, WidthScaleSize_W(100), WidthScaleSize_H(50))];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.font = FONT(15);
    }
    return _titleLabel;
    
}
@end
