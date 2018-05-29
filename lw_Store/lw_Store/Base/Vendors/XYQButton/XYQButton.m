//
//  MyButton.m
//  逛啊
//
//  Created by zhipeng-mac on 15/10/10.
//  Copyright (c) 2015年 mabo. All rights reserved.
//

#import "XYQButton.h"


@implementation FontAttributes

+(instancetype)fontAttributesWithFontColor:(UIColor *)fontColor fontsize:(CGFloat)fontsize{
    
    FontAttributes *fontAttributes = [FontAttributes new];
    fontAttributes.fontsize = fontsize;
    fontAttributes.fontColor = fontColor;
    return fontAttributes;
}

- (UIFont *)font {
    
    return [UIFont systemFontOfSize:_fontsize];
}

@end

@interface XYQButton ()

@property (nonatomic, unsafe_unretained)CGRect titleRect;

@property (nonatomic, unsafe_unretained)CGRect imageRect;

@end

@implementation XYQButton


#define kTitleImageMargin 5.0f
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)setTitleRectForContentRect:(CGRect)titleRect imageRectForContentRect:(CGRect)imageRect{
    
    self.titleRect=titleRect;
    
    self.imageRect=imageRect;
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return self.titleRect;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return self.imageRect ;
}

+ (XYQButton *)ButtonWithFrame:(CGRect)frame imgaeName:(NSString *)imageName titleName:(NSString *)titleName contentType:(ContentType)contentType buttonFontAttributes:(FontAttributes *)fontAttributes tapAction:(void (^)(XYQButton *))tapAction{
    
    
    XYQButton *button = [XYQButton buttonWithType:UIButtonTypeCustom];
   
//    [button setBackgroundColor:[UIColor redColor]];
    CGSize imageSize = [[UIImage imageNamed:imageName]size];
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    button.contentType = contentType;
    button.imageName = imageName;
    button.titleName = titleName;
//    button.fontAttributes = fontAttributes;
    
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:button.imageName] forState:UIControlStateNormal];
    [button setTitle:button.titleName forState:UIControlStateNormal];
    
    [button setTitleColor:fontAttributes.fontColor forState:UIControlStateNormal];
    [button.titleLabel setFont:FONT(fontAttributes.fontsize)];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    switch (button.contentType) {
            
        case TopImageBottomTitle:
            
        {
            CGFloat vert_padding = (frame.size.height-imageHeight-fontAttributes.fontsize)/2.0;
            CGFloat title_image_padding = 5;
            
        [button setTitleRectForContentRect:CGRectMake(0, imageHeight+vert_padding+title_image_padding, frame.size.width, frame.size.height-imageHeight-2*fontAttributes.fontsize+2) imageRectForContentRect:CGRectMake((frame.size.width-imageWidth)/2.0, vert_padding, imageWidth, imageHeight)];
            
        }
            break;
            
        case LeftImageRightTitle:
        {
            
        CGFloat hori_margin = (frame.size.width - imageWidth - kTitleImageMargin - titleName.length*fontAttributes.fontsize)/2.0;
            
         [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
         [button setTitleRectForContentRect:CGRectMake(hori_margin+imageWidth+kTitleImageMargin, 0, frame.size.width-imageWidth, frame.size.height) imageRectForContentRect:CGRectMake(hori_margin, (frame.size.height-imageHeight)/2.0, imageWidth, imageHeight)];
            
        }
            break;
        case LeftTitleRightImage:{
            
          button.width_x =  [titleName lh_sizeWithFont:[UIFont systemFontOfSize:fontAttributes.fontsize] constrainedToSize:CGSizeMake(0, MAXFLOAT)].width+imageWidth+kTitleImageMargin;
            
            button.width_x = [titleName widthForFont:[UIFont systemFontOfSize:fontAttributes.fontsize]]+imageWidth+kTitleImageMargin;
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [button setTitleRectForContentRect:CGRectMake(0, 0, button.width_x-imageWidth-kTitleImageMargin, frame.size.height) imageRectForContentRect:CGRectMake(button.width_x-imageWidth, (frame.size.height-imageHeight)/2.0, imageWidth, imageHeight)];
            
        }
            break;
        case TopTitleBottomImage:{
            
            CGFloat title_image_padding = 5;
            CGFloat vert_padding = (frame.size.height-imageHeight-fontAttributes.fontsize-title_image_padding)/2.0;
            
            [button setTitleRectForContentRect:CGRectMake(0, vert_padding+2, frame.size.width,fontAttributes.fontsize)  imageRectForContentRect:CGRectMake((frame.size.width-imageWidth)/2.0, fontAttributes.fontsize + vert_padding+title_image_padding, imageWidth, imageHeight)];
        }
            break;
        default:
            break;
        
    }
    if (tapAction) {
        
        [button setTapActionWithBlock:^{
            tapAction(button);
        }];
 
    }
    
    return button;
}

- (void)setTitleName:(NSString *)titleName {

    _titleName = titleName;
    
}
@end
