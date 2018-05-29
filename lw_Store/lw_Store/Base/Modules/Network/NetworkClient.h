//
//  APIClient.h
//  Bsh
//
//  Created by lh on 15/12/21.
//  Copyright © 2015年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@class BaseAPI;

#if DEBUG

//#define kNCLoaclResponse

#endif

#pragma mark - 网络配置信息

typedef NS_ENUM(NSInteger, NetworkCodeType) {
    /// 失败
    NetworkCodeTypeFail = 0,
    /// 成功
    NetworkCodeTypeSuccess = 1,
    /// 服务繁忙
    NetworkCodeTypeServiceBusy = -1,
    /// Token无效
    NetworkCodeTypeTokenInvalid = 40000,
};


/**
 *  请求成功block
 */
typedef void (^APISuccessBlock)(id responseObject);


/**
 *  请求进度block
 */
typedef void (^APIProgressBlock)(NSProgress *uploadProgress);

/**
 *  请求失败block
 */
typedef void (^APIFailureBlock) (NSError *error);

/**
 *  请求成功 且 code == NetworkCodeTypeSuccess block
 */
typedef void (^APISuccessJushCodeBlock)(id responseObject);

/**
 *  请求完成block
 */
typedef void(^APIFinishedBlock)(id responseObject, NSError *error);


#pragma mark-- Network客户端

@interface NetworkClient : NSObject

/**
 *  @author hejing
 *
 *  AFHTTPRequestOperationManager对象，负责管理和调度网络请求
 */

@property (nonatomic, strong) AFHTTPSessionManager *manager;
/**
 *  @author hejing
 *
 *  服务器返回Json数据映射模型
 */
@property (nonatomic, strong) BaseAPI *baseAPI;

/**
 *  默认为YES,加载等待view居中
 */
@property (nonatomic, assign) BOOL hudCenter;

/**
 *  @author hejing
 *
 *  获取NetworkClient实例
 *
 *  @param subUrl     请求对应的url
 *  @param parameters url请求所需的参数
 *  @param baseAPI    返回数据所要映射的API模型
 *
 *  @return NetworkClient实例
 */
+ (instancetype)networkClientWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters baseAPI:(BaseAPI *)baseAPI;

/**
 *  @author hejing
 *
 *  获取NetworkClient实例
 *
 *  @param subUrl     请求对应的url
 *  @param parameters url请求所需的参数
 *  @param files      上传文件
 *  @param baseAPI    返回数据所要映射的API模型
 *
 *  @return NetworkClient实例
 */
+ (instancetype)networkClientWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters files:(NSArray *)files baseAPI:(BaseAPI *)baseAPI;


- (NSURLSessionDataTask *)getRequestInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock;

- (NSURLSessionDataTask *)postRequestInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock;

- (void)postRequestInView:(UIView *)containerView successBlock:(APISuccessBlock)successBlock;

// only code == NetworkCodeTypeSuccess => successBlock
- (void)postRequestInView:(UIView *)containerView successJCBlock:(APISuccessJushCodeBlock)successJCBlock;


- (void)uploadFileInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock;

//视频
- (void)uploadVideoFileInView:(UIView *)containerView finishedBlock:(APIFinishedBlock)finishedBlock  progressBlock:(APIProgressBlock)progressBlock;

@end

#pragma mark - 上传文件类

@interface NetworkClientFile : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *fileData;

/**
 *  服务器接收参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;


+ (instancetype)imageFileWithFileData:(NSData *)fileData name:(NSString *)name;


+ (instancetype)videoFileWithFileData:(NSData *)fileData name:(NSString *)name;

@end

