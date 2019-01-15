//
//  GFAddressPicker.m
//  地址选择器
//
//  Created by 1暖通商城 on 2017/5/10.
//  Copyright © 2017年 1暖通商城. All rights reserved.
//

#import "GFAddressPicker.h"
#import "HHAddressAPI.h"
#import "HHAddressModel.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface GFAddressPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *provinceIdsArray;

@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *cityIdsArray;

@property (strong, nonatomic) NSMutableArray *townArray;
@property (strong, nonatomic) NSMutableArray *townIdsArray;

@property (strong, nonatomic) NSString *provinceId;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *townId;
@property (strong, nonatomic) UIPickerView *pickView;
@end
@implementation GFAddressPicker


- (NSMutableArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
        
    }
    return _provinceArray;
}
- (NSMutableArray *)provinceIdsArray {
    if (!_provinceIdsArray) {
        _provinceIdsArray = [NSMutableArray array];
        
    }
    return _provinceIdsArray;
    
}
- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
    
}
- (NSMutableArray *)cityIdsArray{
    if (!_cityIdsArray) {
        _cityIdsArray = [NSMutableArray array];
    }
    return _cityIdsArray;
}
- (NSMutableArray *)townArray {
    if (!_townArray) {
        _townArray = [NSMutableArray array];
    }
    return _townArray;
}
- (NSMutableArray *)townIdsArray{
    
    if (!_townIdsArray) {
        _townIdsArray = [NSMutableArray array];
        
    }
    return _townIdsArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self getProvinceInformation];
        [self setBaseView];
    }
    return self;
}
//获取省份
- (void)getProvinceInformation {

    //获取省份
    [[[HHAddressAPI GetProVince] netWorkClient] getRequestInView:nil finishedBlock:^(HHAddressAPI *api, NSError *error) {
       
        if (!error) {
            if (api.State == 1) {
                
                [api.Data enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HHAddressModel *model = [HHAddressModel mj_objectWithKeyValues:dic];
                    [self.provinceArray addObject:model.Name];
                    [self.provinceIdsArray addObject:model.Id];
                    *stop = NO;
                }];
                
               NSInteger index = [self.pickView selectedRowInComponent:0];
                
               NSString *id_str =  [self.provinceIdsArray objectAtIndex:index];
                if (id_str.length >0) {
                    
                    [self getCityInfomationWithId:id_str];
                }
            }
        }
        
    }];
    
}
//获取城市或地区
- (void)getCityInfomationWithId:(NSString *)Id{
    
    [self.cityArray removeAllObjects];
    [self.cityIdsArray removeAllObjects];

    [[[HHAddressAPI GetChildsWithId:Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHAddressAPI *api, NSError *error) {
      
        if (!error) {
            if (api.State == 1) {
                
                [api.Data enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HHAddressModel *model = [HHAddressModel mj_objectWithKeyValues:dic];
                    [self.cityArray addObject:model.Name];
                    [self.cityIdsArray addObject:model.Id];
                    *stop = NO;
                }];
                NSInteger index = [self.pickView selectedRowInComponent:1];
                
                NSString *id_str =  [self.cityIdsArray objectAtIndex:index];
                if (id_str.length >0) {
                  [self getTownInfomationWithId:id_str];
                }
            }
        }
        
    }];
    
}
//获取城市或地区
- (void)getTownInfomationWithId:(NSString *)Id{
    
    [self.townArray removeAllObjects];
    [self.townIdsArray removeAllObjects];

    [[[HHAddressAPI GetChildsWithId:Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHAddressAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                [api.Data enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HHAddressModel *model = [HHAddressModel mj_objectWithKeyValues:dic];
                    [self.townArray addObject:model.Name];
                    [self.townIdsArray addObject:model.Id];
                    *stop = NO;
                }];
                
                [self.pickView reloadAllComponents];
            }
        }
        
    }];
    
}

- (void)setBaseView {
    
    UIView *shadow = [UIView lh_viewWithFrame:self.bounds backColor:kBlackColor];
    shadow.alpha = 0.5;
    shadow.userInteractionEnabled = YES;
    [shadow setTapActionWithBlock:^{
    
        [self hidePickViewComplete:nil];
   
    }];
    [self addSubview:shadow];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, height - AdapationLabelHeight(244), width, AdapationLabelHeight(244))];
    contentView.backgroundColor = [UIColor whiteColor];
    self.contentView = contentView;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, AdapationLabelHeight(44))];
    selectView.backgroundColor = kWhiteColor;
    [contentView addSubview:selectView];
    [self addSubview:contentView];
    [selectView lh_setCornerRadius:0 borderWidth:1 borderColor:LineLightColor];

//
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"完成" forState:0];
    [ensureBtn setTitleColor:APP_COMMON_COLOR forState:0];
    ensureBtn.frame = CGRectMake(width - 60, 0, 60, AdapationLabelHeight(44));
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    ensureBtn.titleLabel.font = FONT(16);
    [selectView addSubview:ensureBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:APP_COMMON_COLOR forState:0];
    cancelBtn.frame = CGRectMake(0, 0, 60, AdapationLabelHeight(44));
    [cancelBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = FONT(16);
    [selectView addSubview:cancelBtn];
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, AdapationLabelHeight(44), SCREEN_WIDTH,  AdapationLabelHeight(200))];
    self.pickView.delegate   = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:self.pickView];
    [self.pickView reloadAllComponents];
}

- (void)showPickViewAnimation:(BOOL)animated{
    
    self.animated = animated;
    [self addsuperView];
    if (animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.contentView.lh_top = self.lh_bottom - AdapationLabelHeight(244);
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
}
- (void)addsuperView{
    
    [kKeyWindow addSubview:self];
    
    
}
- (void)dateCancleAction {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(GFAddressPickerCancleAction)]) {
//        [self.delegate GFAddressPickerCancleAction];
//    }
    [self hidePickViewComplete:nil];

}

- (void)dateEnsureAction {
    
        [self hidePickViewComplete:nil];
        [self updateAddress];
        if(self.selectedSexItem){
            if (self.townId.length>0) {
                self.completeBlock(self.selectedSexItem,self.townId);
            }else if (self.cityId.length>0){
                self.completeBlock(self.selectedSexItem,self.cityId);
                
            }else if (self.provinceId.length>0){
                self.completeBlock(self.selectedSexItem,self.provinceId);
            }else{
                self.completeBlock(self.selectedSexItem,@"");
            }
        }
}
- (void)hidePickViewComplete:(void (^)())completeBlock {
    
    if (self.animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.contentView.lh_top = self.lh_bottom;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        pickerLabel.textColor = kBlackColor;
        [pickerLabel setFont:self.font?:[UIFont boldSystemFontOfSize:AdapationLabelHeight(20)]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 37;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    if (component == 0) {

        NSString *id_str  = self.provinceIdsArray[row];
        [self getCityInfomationWithId:id_str];

    }
    if (component == 1) {

        NSString *id_str  = self.cityIdsArray[row];
        [self getTownInfomationWithId:id_str];

    }
    if (component == 2) {

    }
}

- (void)updateAddress {
    
    self.provinceId = nil;
    self.cityId = nil;
    self.townId = nil;

    NSInteger index0 = [self.pickView selectedRowInComponent:0];
    self.province = [self.provinceArray objectAtIndex:index0]?[self.provinceArray objectAtIndex:index0]:[self.provinceArray objectAtIndex:0];
    self.provinceId = [self.provinceIdsArray objectAtIndex:index0];
    
    NSInteger index1 = [self.pickView selectedRowInComponent:1];
    self.city  = [self.cityArray objectAtIndex:index1]?[self.cityArray objectAtIndex:index1]:[self.cityArray objectAtIndex:0];
    self.cityId = [self.cityIdsArray objectAtIndex:index1];

    
    NSInteger index2 = [self.pickView selectedRowInComponent:2];
    self.area  = [self.townArray objectAtIndex:index2]?[self.townArray objectAtIndex:index2]:[self.townArray objectAtIndex:0];
    self.townId = [self.townIdsArray objectAtIndex:index2];
    
    self.selectedSexItem = [NSString stringWithFormat:@"%@ %@ %@",self.province.length>0?self.province:@"",self.city?self.city:@"",self.area?self.area:@""];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
