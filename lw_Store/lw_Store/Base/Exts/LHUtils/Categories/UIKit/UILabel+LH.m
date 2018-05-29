//
//  UILabel+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UILabel+LH.h"

@implementation UILabel (LH)

/**
 *  初始化
 *
 *  @param frame           大小
 *  @param text            文本
 *  @param textColor       文本颜色
 *  @param font            字体
 *  @param textAlignment   文本对齐方式
 *  @param backgroundColor 背景颜色
 *
 *  @return 实例
 */
+ (UILabel *)lh_labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor
{
    UILabel *label        = [[UILabel alloc] initWithFrame:frame];
    label.text            = text;
    label.textColor       = textColor;
    label.font            = font;
    label.textAlignment   = textAlignment;
    label.backgroundColor = backgroundColor;
    
    return label;
}

/**
 *  创建自适应高度的label，frame的高度将会被忽略
 *
 *  @param frame         大小
 *  @param text          文本
 *  @param textColor     文本颜色
 *  @param font          字体
 *  @param textAlignment 文本对齐方式
 *
 *  @return 实例
 */
+ (UILabel *)lh_labelAdaptionWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    // 测量高度
    CGSize measureSize = [text lh_sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, MAXFLOAT)];
    frame.size.height = measureSize.height;
    
    UILabel *label = [self lh_labelWithFrame:frame text:text textColor:textColor font:font textAlignment:textAlignment backgroundColor:[UIColor clearColor]];
    label.numberOfLines = 0;
    
    return label;
}

@end


#pragma mark - 对齐样式

@implementation UILabel (VerticalAlign)

- (int)lh_newLinesToPad {
    NSDictionary *attrs = @{NSFontAttributeName: self.font};
    CGSize fontSize =[self.text sizeWithAttributes:attrs];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    
    return newLinesToPad;
}

/**
 *  顶部对齐
 */
-(void)lh_alignTop {
    int newLinesToPad = [self lh_newLinesToPad];
    for(int i=0; i < newLinesToPad; i++)
        self.text =[self.text stringByAppendingString:@"\n "];
}

/**
 *  底部对齐
 */
-(void)lh_alignBottom {
    int newLinesToPad = [self lh_newLinesToPad];
    for(int i=0; i < newLinesToPad; i++)
        self.text =[NSString stringWithFormat:@" \n%@",self.text];
}

/**
 添加下划线
 */
- (NSMutableAttributedString *)lh_addUnderlineAtContent:(NSString *)content rangeStr:(NSString *)rangeStr color:(UIColor *)color{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange contentRange = [content rangeOfString:rangeStr];
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:contentRange];

    return attributedString;
}
@end
