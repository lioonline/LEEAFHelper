//
//  LEEAFNetworkingHelper.h
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/24.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEEAFNetworkingHelper : NSObject

/**
 *  网络请求
 *
 *  @param path     接口路径
 *  @param params   请求参数
 *  @param method   请求方式
 *  @param useSSL   https:YES http:NO
 *  @param response 请求成功block
 *  @param error    请求失败block
 */
+ (NSURLSessionDataTask*_Nonnull)requestWithAFNetWorkingWithPath:(nullable NSString *)path
                                 params:(nullable NSMutableDictionary *)params
                             httpMethod:(nullable NSString *)method
                                    ssl:(BOOL) useSSL
                        completeHandler:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task ,id  _Nonnull responese))complete
                           errorHandler:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task ,  NSError * _Nonnull error))fail;




/**
 *  下载请求
 *
 *  @param path                  接口路径
 *  @param params                请求参数
 *  @param filePath              文件路径
 *  @param complete              请求成功
 *  @param error                 请求失败
 *  @param downloadProgressBlock 下载进度
 */
+ (NSURLSessionDownloadTask*_Nonnull)downloadDocumentFromPath:(nullable NSString *)completeURLPath
                                                   params:(nullable NSMutableDictionary *)params
                                                 filePath:(nullable NSString *)filePath
                                        completionHandler:(void (^_Nonnull)(id _Nonnull response))complete
                                             errorHandler:(void (^_Nonnull)(NSError* _Nonnull error))fail
                                         downloadProgress:(void(^_Nonnull)(int64_t,int64_t))downloadProgressBlock;





/**
 *  上传
 *
 *  @param path                路径
 *  @param params              参数
 *  @param filePath           文件路径
 *  @param method              请求方法
 *  @param useSSL              ssl
 *  @param response            成功
 *  @param error               失败
 *  @param uploadProgressBlock 进度
 */
+ (NSURLSessionUploadTask*_Nonnull)uploadDocumentFromPath:(nullable NSString *)path
                        params:(nullable NSMutableDictionary *)params
                     filePath:(nullable NSString *)filePath
                    httpMethod:(nullable NSString *)method
                           ssl:(BOOL)useSSL
             completionHandler:(void (^ _Nonnull)(NSURLResponse* _Nonnull ,id _Nonnull responseObject))complete
                  errorHandler:(void (^  _Nonnull)(NSError * _Nonnull))fail
              onUploadProgress:(void (^_Nonnull)(int64_t,int64_t))uploadProgressBlock;







@end
