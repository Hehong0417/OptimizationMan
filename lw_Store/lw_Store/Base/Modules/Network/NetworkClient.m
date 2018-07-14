//
//  APIClient.m
//  Bsh
//
//  Created by lh on 15/12/21.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "NetworkClient.h"
#import "HJUser.h"
#import "BaseAPI.h"

#import "DES3Util.h"
#import "MD5Encryption.h"


#define kTimeoutInterval 60.0

@interface NetworkClient ()

/// 请求子网址
@property (nonatomic, copy) NSString *subUrl;

/// 请求参数
@property (nonatomic, strong) NSDictionary *parameters;

/// 容器，HUD父视图
@property (strong, nonatomic) UIView *containerView;

@property (nonatomic, strong) NSArray *files;

@end

@implementation NetworkClient

/*
+ (instancetype)sharedAPIClient {
    static APIClient *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{    
        _instance = [[self alloc] init];
    });
    return _instance;
}
 */


#pragma mark - Init

- (void)defaultInit {
    self.hudCenter = YES;
}

+ (instancetype)networkClientWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters baseAPI:(BaseAPI *)baseAPI {
    
    return [self networkClientWithSubUrl:subUrl parameters:parameters files:nil baseAPI:baseAPI];
}

+ (instancetype)networkClientWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters files:(NSArray *)files baseAPI:(BaseAPI *)baseAPI {
    
    NetworkClient *client = [NetworkClient new];
    client.subUrl = subUrl;
    client.parameters = parameters;
    client.files = files;
    client.baseAPI = baseAPI;
    
    [client defaultInit];
    
    return client;
}


#pragma mark - Getter

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_HOST]];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", NULL];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        HJUser *user = [HJUser sharedUser];
        NSString *token = user.token;
        
//        NSString *token = @"15EF2D3994C2DA5B38BBBB40BA8B69BCE51797808E9FA762D18E7A847719E0A2A38178C6BE3103E7F494FE93934AA7679E14736E5CB90DEBF075E2BAD612E176D8A01923FD203CA0FF53343CEB8F4F8001775A283C6E54D99C0B6D567CF634B0B68387753FEB32658F66D944C4826D49C2A40587565A238255D5E41160BE6F4D97891D265FA55BEC58585E0AB758E3557ACDAF9F53335C1889F1EF79BFCFCED64A64D1B05A8B66580A9DF0315ACDD430142FC8C3D58CB65388DA88E0B01E2BA25B263A620A6BB4ACF4026CBE00D86DA704EAAF428BFA43FD824A8B7CBEF8FE61D0735848129954022AD911EE9D104854A9D287D5D2CEA08CCE115C7D26AAAFBD261C305025F3FAF850C48BBE1348AEC1EBF32C9782B73DA8BEDC6E331FB547BDE1AFACD43C6F38C890CC112834D9EDF6006A114F5A9A362E5585A46C0215AB5E23415038D4F179464537DF9B057BE5D6076E0F0A01F44C92F12EFAC27A4BB3C597C7FF9CA02617E6C2E83E72249F846D77BAC9B653F9219C9E875E7B4976818553DF194A3E18F1B4F17618767B376E837E79C13AB41B6544A1A9CD2FB1216CE577BF9648DA00782431C71788C534BC162427A44D73D29D6549C0D21A44925FBD7FA65B0BEC18760FA0293020D112BF83";
        [_manager.requestSerializer setValue:token  forHTTPHeaderField:@"Authorize"];
    }
    
    return _manager;
}
#pragma mark - Log

/**
 *  请求完成后打印
 *
 *  @param response 返回对象
 *  @param error    错误
 */
- (void)logFinished:(NSDictionary*)response error:(NSError*)error {
    
#ifdef DEBUG
    /*
     // 一行格式
    NSMutableString *paramStr = [NSMutableString stringWithString:@"?"];
    [_parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramStr appendFormat:@"%@=%@&", key, obj];
    }];
    [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
     */
    
    // 字典格式
    NSString *paramStr = [NSString stringWithFormat:@"\n%@", self.parameters];
    
    if (!error) {
        NSLog(@"------------接口地址：------------\n%@\n请求参数：%@\n拼接url：%@\n------------请求成功：------------\n %@\n",self.subUrl, paramStr,[self urlStringAppendingParameters],response);
    }
    else {
        NSLog(@"------------接口地址：------------\n%@\n请求参数：%@\n拼接url：%@\n------------请求失败：------------\n%@",self.subUrl, paramStr,[self urlStringAppendingParameters] ,error);
    }
    
#endif
}

#pragma mark - post请求时url字符串和参数拼接

- (NSString *)urlStringAppendingParameters {
    
    //请求参数为空
    if (!self.parameters) {
        
        return self.subUrl;
    }
    NSString *urlStr = [self.subUrl stringByAppendingString:@"?"];
    //------参数拼接------//
    for (int i=0; i<self.parameters.count; i++) {
        //
        id key = [[self.parameters allKeys]objectAtIndex:i];
        id obj = [self.parameters objectForKey:key];
        
        NSString *key_obj_param = [[[self stringFromObejct:key] stringByAppendingString:@"="]stringByAppendingString:[self stringFromObejct:obj]];
        
        if (self.parameters.count == 1) {
            
          return  urlStr = [urlStr stringByAppendingString:key_obj_param];
        }
        
        if (self.parameters.count >1) {
            
            if (i == self.parameters.count-1) {
                
            urlStr = [urlStr stringByAppendingString:key_obj_param];
            }
            else {
                
            urlStr = [urlStr stringByAppendingString:[key_obj_param stringByAppendingString:@"&"]];
            }
            
        }
     }
    //-------end--------//

//    
    return urlStr;
}
- (NSString *)urlStringAppendingSign {
//    HJLoginModel *userModel = [HJUser sharedUser].loginModel;
//    if (userModel) {
//        
//        NSLog(@"pwd=%@",userModel.pwd);
//        NSString *pwd = [userModel.pwd substringWithRange:NSMakeRange(8, 16)];
//        NSLog(@"subPwd=%@",pwd);
//        NSString *parame = @"";
//        for (int i=0; i<self.parameters.count; i++)
//        {
//            //
//            id key = [[self.parameters allKeys]objectAtIndex:i];
//            id obj = [self.parameters objectForKey:key];
//            
//            NSString *key_obj_param = [[self stringFromObejct:key] stringByAppendingString:[self stringFromObejct:obj]];
//            
//            if (self.parameters.count == 1) {
//                parame = [[[parame stringByAppendingString:key_obj_param] stringByAppendingString:@"|"] stringByAppendingString:pwd];
//            }else if (self.parameters.count >1) {
//                
//                if (i == self.parameters.count-1) {
//                    if (pwd) {
//                        parame = [[[parame stringByAppendingString:key_obj_param] stringByAppendingString:@"|"] stringByAppendingString:pwd];
//                    }
//                }
//                else {
//                    
//                    parame = [parame stringByAppendingString:[key_obj_param stringByAppendingString:@"|"]];
//                    if (pwd) {
//                        [[parame stringByAppendingString:@"|"] stringByAppendingString:pwd];
//                    }
//                    
//                }
//            }
//        }
//        
//        return parame;
//    }
//    
    return @"";
//
}
- (NSString *)stringFromObejct:(id)obj {
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        return obj;
    }
    return [NSString stringWithFormat:@"%@",obj];
}

/**
 *  获取请求完成后block
 *
 *  @return 请求完成后block
 */
- (APIFinishedBlock)requestFinishedBlock {
    APIFinishedBlock aReqFinishedBlock = ^(NSDictionary *response, NSError *error) {
        
        // 去掉HUD
//        [self.bAPI hideHUDWhileFinish];
        
        // DEBUG模式下打印
#if DEBUG
        [self logFinished:response error:error];
#endif
    };
    
    return aReqFinishedBlock;
}

#pragma mark - Request

- (void)addUserIdAndToken {
    HJLoginModel *userModel = [HJUser sharedUser].pd;
    if (userModel) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
        dic[@"users_id"] = userModel.users_id;
        dic[@"token"] = userModel.token;
        self.parameters = dic;
    }
}

- (void)readyForRequest:(UIView *)containerView {
    
    // 添加 UserId 和 Token
//    if (self.baseAPI.parametersAddToken) {
//
//        [self addUserIdAndToken];
//    }
//
//    //添加sign字段
//    NSString *paramesStr = [self urlStringAppendingSign];
//    //NSLog(@"paramesStr=%@",paramesStr);
//    
//    NSArray *paramesArr = [paramesStr componentsSeparatedByString:@"|"];
//    NSMutableArray *paramesMArr = [NSMutableArray arrayWithArray:paramesArr];
//    [paramesMArr removeLastObject];
//    //排序
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
//    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
//    NSArray *myDataArray = [NSArray arrayWithArray:paramesMArr];
//    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
//    
//   // NSLog(@"resultArray=%@\n", resultArray);
//    
//    NSString *pwd = [paramesArr lastObject];
//    NSString *desRedyStr = [[resultArray componentsJoinedByString:@"|"] stringByAppendingFormat:@"|%@",pwd];
//    //
//   // NSLog(@"desRedyStr=%@\n", desRedyStr);
//    
//    NSString *des3Str = [DES3Util encrypt:desRedyStr];
//    //NSLog(@"des3Str=%@\n\n",des3Str);
//    NSString *signMd5Str = [MD5Encryption md5by32:des3Str];
//   // NSLog(@"signMd5Str=%@\n\n",signMd5Str);
//    //
//    [self.parameters setValue:signMd5Str forKey:@"sign"];
    
    // 添加 HUD
    if (containerView) {
        UIView *tmpContainerView = containerView;
        if ([containerView isKindOfClass:[UIScrollView class]]) {
            if (self.hudCenter) {
                tmpContainerView = [UIApplication sharedApplication].keyWindow;
            }
        }
        
        self.containerView = tmpContainerView;
        [self.baseAPI showHUDWhileRequest:tmpContainerView];
    }
}
- (BaseAPI *)dealWhileSuccess:(id)responseObject {
    
    // 请求完成后block
    APIFinishedBlock reqFinishedBlock = [self requestFinishedBlock];
    reqFinishedBlock(responseObject, nil);
    
    BaseAPI *bAPIModel = [self.baseAPI.class mj_objectWithKeyValues:responseObject];
    NSInteger code = bAPIModel.State;
    NSString *msg = bAPIModel.Msg;
    
    if (!responseObject) {
        [self.baseAPI showMsgWhileJSONError];
    }
    else if (code == NetworkCodeTypeTokenInvalid) {
        // token过期，直接退出
        [self.baseAPI showMsgWhileTokenExpire:msg];
        
        return nil;
    }
    else if (code != NetworkCodeTypeSuccess) {
        //返回code不为成功是否显示返回msg信息
        if (self.baseAPI.showFailureMsg) {
           
            [self.baseAPI showMsgWhileRequestFailure:msg];
        }
    }
    else {
        // 成功获取数据后，去掉HUD
        [self.baseAPI hideHUDWhileFinish];
    }
    
    return bAPIModel;
}

- (void)dealWhileFailure:(NSError *)error {
    
    // 请求完成后block
    APIFinishedBlock reqFinishedBlock = [self requestFinishedBlock];
    reqFinishedBlock(nil, error);
    
    // 获取数据失败，去掉HUD
    if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
        
        [self.baseAPI showMsgWhileRequestError:@"网络不给力，请稍后重试"];
 
    }else{
        
         [self.baseAPI showMsgWhileRequestError:error.localizedDescription];
        
    }
}

- (void)requestSucces:(id)responseObject finishedBlock:(APIFinishedBlock)finishedBlock {
    
    if (finishedBlock) {
        
        if (!responseObject) {
            return;
        }
        
        // 成功获取数据后，去掉HUD
        [self.baseAPI hideHUDWhileFinish];
//
        APIFinishedBlock reqFinishedBlock = [self requestFinishedBlock];
        reqFinishedBlock(responseObject, nil);
        
        finishedBlock(responseObject, nil);

    }
}

- (void)requestSucces:(id)responseObject successBlock:(APISuccessBlock)successBlock {
    BaseAPI *bAPIModel = [self dealWhileSuccess:responseObject];
    if (!bAPIModel) {
        return;
    }
    if (successBlock) {
        successBlock(responseObject);
    }
}

- (void)requestSucces:(id)responseObject successJCBlock:(APISuccessJushCodeBlock)successJCBlock {
    
    
    BaseAPI *bAPIModel = [self dealWhileSuccess:responseObject];
    if (!bAPIModel || bAPIModel.State != NetworkCodeTypeSuccess) {
        return;
    }
    
    if (successJCBlock) {
        successJCBlock(bAPIModel);
    }
    
//    !successJCBlock ?: ;
}

- (void)requestFailure:(NSError *)error failurBlock:(APIFailureBlock)failurBlock {
    [self dealWhileFailure:error];
    if (failurBlock) {
        failurBlock(error);
    }
//    !failurBlock ?: failurBlock(error);
}

- (void)requestFailure:(NSError *)error finishedBlock:(APIFinishedBlock)finishedBlock {
    
    [self dealWhileFailure:error];

    if (finishedBlock) {
        finishedBlock(nil, error);
    }
}


#pragma mark - Get Request

- (NSURLSessionDataTask *)getRequestInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock {
    
    [self readyForRequest:containerView];
   
    // 开始请求
   return   [self.manager GET:self.subUrl parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BaseAPI *bAPIModel = [BaseAPI mj_objectWithKeyValues:responseObject];

        [self requestSucces:bAPIModel finishedBlock:finishedBlock];
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestFailure:error finishedBlock:finishedBlock];

    }];
}

#pragma mark - Post Request

- (void)postRequestInView:(UIView *)containerView successJCBlock:(APISuccessJushCodeBlock)successJCBlock {
    [self readyForRequest:containerView];
    
#ifdef kNCLoaclResponse
    
    id responseObject = [self.baseAPI localResponseJSON];
    [self requestSucces:responseObject successJCBlock:successJCBlock];
    
#else

    // 开始请求
    [self.manager POST:self.subUrl parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self requestSucces:responseObject successJCBlock:successJCBlock];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestFailure:error failurBlock:nil];

    }];
    
#endif
}

- (void)postRequestInView:(UIView *)containerView successBlock:(APISuccessBlock)successBlock {
    [self readyForRequest:containerView];
    
#ifdef kNCLoaclResponse
    
    id responseObject = [self.bAPI localResponseJSON];
    [self requestSucces:responseObject successBlock:successBlock];
    
#else

    // 开始请求
    [self.manager POST:self.subUrl parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSucces:responseObject successBlock:successBlock];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:error failurBlock:nil];

    }];
    
#endif
}

- (NSURLSessionDataTask *)postRequestInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock {
//    [self readyForRequest:containerView];
    
//#ifdef kNCLoaclResponse
//
//    id responseObject = [self.bAPI localResponseJSON];
//    [self requestSucces:responseObject finishedBlock:finishedBlock];
//
//#else
    // 开始请求
  return  [self.manager POST:self.subUrl parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BaseAPI *bAPIModel = [self.baseAPI.class mj_objectWithKeyValues:responseObject];
        
        [self requestSucces:bAPIModel finishedBlock:finishedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [self requestFailure:error finishedBlock:finishedBlock];

    }];
    
//#endif
}

#pragma mark - Upload Request

- (void)uploadFileInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock{
    [self readyForRequest:containerView];
    
    // 开始请求
    [self.manager POST:self.subUrl parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [self.files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NetworkClientFile *file = obj;
            
            [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BaseAPI *bAPIModel = [self.baseAPI.class mj_objectWithKeyValues:responseObject];

        [self requestSucces:bAPIModel finishedBlock:finishedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestFailure:error finishedBlock:finishedBlock];

    }];

}

- (void)uploadVideoFileInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock  progressBlock:(APIProgressBlock)progressBlock{
    
    [self readyForRequest:containerView];
    
    [self.manager POST:self.subUrl parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [self.files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NetworkClientFile *file = obj;
            
            [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progressBlock(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self requestSucces:responseObject finishedBlock:finishedBlock];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestFailure:error finishedBlock:finishedBlock];

    }];
    
    
}
@end


@implementation NetworkClientFile

+ (instancetype)imageFileWithFileData:(NSData *)fileData name:(NSString *)name {
    NetworkClientFile *file = [NetworkClientFile new];
    file.fileData = fileData;
    file.name = name;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    file.fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
    file.mimeType = @"image/jpeg";
    
    return file;
}
+ (instancetype)videoFileWithFileData:(NSData *)fileData name:(NSString *)name {
    
    NetworkClientFile *file = [NetworkClientFile new];
    file.fileData = fileData;
    file.name = name;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    file.fileName = [NSString stringWithFormat:@"%@.mp4", [formatter stringFromDate:[NSDate date]]];
    file.mimeType = @"video/mp4";
    
    return file;
}

@end

