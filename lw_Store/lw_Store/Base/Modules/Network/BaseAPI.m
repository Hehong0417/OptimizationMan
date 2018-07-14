//
//  BaseAPI.m
//  Bsh
//
//  Created by lh on 15/12/21.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "BaseAPI.h"

@interface BaseAPI ()

@end

@implementation BaseAPI

- (NSString *)description {
    NSArray *keys = @[
                             @"State",
                             @"Msg",
                             @"Data",
                             @"List"
                             ];
    
    return [NSString stringWithFormat:@"%@\n%@", [super description], [self mj_keyValuesWithKeys:keys]];
}
//???: 没执行
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (oldValue == nil || oldValue == [NSNull null]) {
        return @"";
    }
    return oldValue;
}

- (NetworkClient *)netWorkClient {
    
    return [NetworkClient networkClientWithSubUrl:self.subUrl parameters:self.parameters files:self.uploadFile baseAPI:self];
}

- (NSMutableDictionary *)parameters {
    
    if (!_parameters) {
        
        _parameters = [NSMutableDictionary dictionary];
    }
    
    return _parameters;
}

@end

@implementation BaseAPI (HUD)

@dynamic containerView;
@dynamic HUD;
@dynamic showErrorMsg;

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.showErrorMsg = YES;
        self.showFailureMsg = YES;
        self.parametersAddToken = YES;
    }
    return self;
}

#pragma mark - Getter

- (UIView *)containerView {
    //_cmd 直接使用该方法的名称 containerView
    UIView *containerView = objc_getAssociatedObject(self, _cmd);

    return containerView ?: [UIApplication sharedApplication].keyWindow;
}

- (MBProgressHUD *)HUD {

    MBProgressHUD *hud = objc_getAssociatedObject(self, _cmd);
    
    return hud;
}

- (BOOL)isShowErrorMsg {
    NSNumber *isShowErrorMsg = objc_getAssociatedObject(self, _cmd);
    
    return isShowErrorMsg.boolValue;
}

- (BOOL)isShowFailureMsg {
    NSNumber *isShowFailureMsg = objc_getAssociatedObject(self, _cmd);
    
    return isShowFailureMsg.boolValue;
}

- (BOOL)isParametersAddToken {
    NSNumber *isParametersAddToken = objc_getAssociatedObject(self, _cmd);
    
    return isParametersAddToken.boolValue;
}

#pragma mark - Setter

- (void)setContainerView:(UIView *)containerView {
    objc_setAssociatedObject(self, @selector(containerView), containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    
    objc_setAssociatedObject(self, @selector(HUD), HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setShowErrorMsg:(BOOL)showErrorMsg {
    objc_setAssociatedObject(self, @selector(isShowErrorMsg), @(showErrorMsg), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setShowFailureMsg:(BOOL)showFailureMsg {
    objc_setAssociatedObject(self, @selector(isShowFailureMsg), @(showFailureMsg), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setParametersAddToken:(BOOL)parametersAddToken {
    objc_setAssociatedObject(self, @selector(isParametersAddToken), @(parametersAddToken), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - MBProgressHUD

- (void)mbShowIndeterminate {
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    self.HUD.color = KA0LabelColor;
    self.HUD.bezelView.frame = CGRectMake(0, 0, 25, 25);
    self.HUD.detailsLabelText = @"加载中...";
    self.HUD.detailsLabelColor = kWhiteColor;
    self.HUD.detailsLabelFont = FONT(14);
    self.HUD.activityIndicatorColor = kWhiteColor;
    [self.HUD show:YES];
    
}

- (void)mbShowText:(NSString *)text {
    if (!self.isShowErrorMsg) {
        [self hideHUDWhileFinish];
        return;
    }
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.detailsLabelText = text;
    self.HUD.color = KA0LabelColor;
    self.HUD.detailsLabelFont = FONT(14);
    self.HUD.detailsLabelColor = kWhiteColor;
    [self.HUD show:YES];
    
    [self hideHUDWhileFinishAfterDelay:2.0];
}
#pragma mark - HUD

- (void)showHUDWhileRequest:(UIView *)containerView {
    
    self.containerView = containerView;
    [self mbShowIndeterminate];
}

- (void)hideHUDWhileFinish {
    [self hideHUDWhileFinishAfterDelay:0];
}

- (void)hideHUDWhileFinishAfterDelay:(NSTimeInterval)delay {
    
    [self.HUD hide:YES afterDelay:delay];
    
#ifdef kNCLoaclResponse
    NSLog(@"加载本地数据文件 -----  __%@__   -----", self.class);
#endif
}

- (void)showMsgWhileJSONError {
    [self mbShowText:@"服务器错误"];
}

- (void)showMsgWhileRequestFailure:(NSString *)msg {
    [self mbShowText:msg];
}

- (void)showMsgWhileTokenExpire:(NSString *)msg {
    [self hideHUDWhileFinish];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTokenExpire object:msg];
    // mb显示不了
    [self mbShowText:msg];
}

- (void)showMsgWhileRequestError:(NSString *)msg {
    
    [self mbShowText:msg];
    
}


#pragma mark - LocalResponse

- (NSString *)localResponseDataPath {
    NSString *filename = [NSString stringWithFormat:@"__%@__", NSStringFromClass(self.class)];
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:@"LocalResponse/Data"];
    
    return dataPath;
}

- (NSDictionary *)localResponseJSON {
    NSString *dataPath = [self localResponseDataPath];
    if (dataPath) {
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        return json;
    }

    return nil;
}

- (void)retrunCodeEqualToSuccessDoNextStep:(voidBlock)nextStep {
    
    if (self.State == NetworkCodeTypeSuccess) {
        
        nextStep();
    }
}

- (void)retrunMsgEqualTo:(NSString *)msg doNextStep:(voidBlock)nextStep {
    
    if ([self.Msg isEqualToString:msg]) {
        
        nextStep();
    }
}

@end
