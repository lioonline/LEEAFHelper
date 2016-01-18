//
//  LEEAFBaseModel.h
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/24.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//


typedef enum {
    NetworkHUDBackground=0,         // 不锁屏，不提示
    NetworkHUDMsg=1,                // 不锁屏，只要msg不为空就提示
    NetworkHUDError=2,              // 不锁屏，提示错误信息
    NetworkHUDLockScreen=3,         // 锁屏
    NetworkHUDLockScreenAndMsg=4,   // 锁屏，只要msg不为空就提示
    NetworkHUDLockScreenAndError=5, // 锁屏，提示错误信息
    NetworkHUDLockScreenButNavWithMsg=6,  // 锁屏, 但是导航栏可以操作, 只要msg不为空就提示
    NetworkHUDLockScreenButNavWithError=7 // 锁屏, 但是导航栏可以操作, 提示错误信息
} NetworkHUD;

#import <Foundation/Foundation.h>

@interface LEEAFBaseModel : NSObject

/**
 *  基本网络请求
 *
 *  @param path       路径
 *  @param params     参数
 *  @param networkHUD HUD
 *  @param target
 *  @param success    成功的block
 */
+ (NSURLSessionDataTask *)sendDataResponsePath:(NSString *)path
                              httpMethod:(NSString*)method
                                  params:(NSMutableDictionary *)params
                              networkHUD:(NetworkHUD)networkHUD
                                  target:(id)target
                                 success:(void (^)(id data))success;




/**
 *  下载
 *
 *  @param path            路径
 *  @param params          参数
 *  @param filePath        文件存储路径
 *  @param completionBlock 成功的block
 */
+ (NSURLSessionDownloadTask *)downloadDocumentFromPath:(NSString *)path
                          params:(NSMutableDictionary *)params
                        filePath:(NSString *)filePath
                    onCompletion:(void (^)(id data))completionBlock
                    downloadProgress:(void(^)(int64_t,int64_t))downloadProgressBlock;


/**
 *  上传
 *
 *  @param path                路径
 *  @param params              参数
 *  @param fileData            文件数据
 *  @param completionBlock     成功
 *  @param uploadProgressBlock 进度
 */

+ (NSURLSessionUploadTask *)uploadDocumentFromPath:(NSString *)path
                                            params:(NSMutableDictionary *)params
                                          filePath:(NSString *)filePath
                                      onCompletion:(void (^)(id data))completionBlock
                                  uploadProgress:(void(^)(int64_t,int64_t))uploadProgressBlock;;

@end
