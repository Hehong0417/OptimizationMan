//
//  BaseAPI.h
//  Bsh
//
//  Created by lh on 15/12/21.
//  Copyright © 2015年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "NetworkClient.h"
#import "MBProgressHUD.h"
/**
 *  父 API
 */
@interface BaseAPI : NSObject

@property (nonatomic, assign) NSInteger State;

//@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSString *Msg;

//@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSMutableDictionary *parameters;

@property (nonatomic, strong) id  Data;
@property (nonatomic, strong) id  List;
@property (nonatomic, strong) id  Path;

//@property (nonatomic, strong) id  data;

@property (nonatomic, strong) NSArray *uploadFile;

@property (nonatomic, copy) NSString *subUrl;

- (NetworkClient *)netWorkClient;

@end

@interface BaseAPI (HUD)

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UIView *containerView;

/**
 *  Default YES...
 */
@property (nonatomic, assign, getter=isShowErrorMsg) BOOL showErrorMsg;

/**
 *  Default YES...
 */
@property (nonatomic, assign, getter=isShowFailureMsg) BOOL showFailureMsg;

/**
 *  Default YES...
 */
@property (nonatomic, assign, getter=isParametersAddToken) BOOL parametersAddToken;


- (void)showHUDWhileRequest:(UIView *)containerView;

- (void)hideHUDWhileFinish;

- (void)showMsgWhileJSONError;

/**
 *  @author hejing
 *
 *  请求成功，但返回code不是成功状态提示错误信息
 *
 *  @param msg 错误信息
 */
- (void)showMsgWhileRequestFailure:(NSString *)msg;

- (void)showMsgWhileTokenExpire:(NSString *)msg;

/**
 *  @author hejing
 *
 *  请求错误，提示失败信息
 *
 *  @param msg 请求错误信息
 */
- (void)showMsgWhileRequestError:(NSString *)msg;


#pragma mark - LocalResponse

- (NSString *)localResponseDataPath;

- (NSDictionary *)localResponseJSON;

- (void)retrunCodeEqualToSuccessDoNextStep:(voidBlock)nextStep;

- (void)retrunMsgEqualTo:(NSString *)msg doNextStep:(voidBlock)nextStep;

@end

