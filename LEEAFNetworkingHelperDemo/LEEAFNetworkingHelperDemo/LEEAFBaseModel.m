//
//  LEEAFBaseModel.m
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/24.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//



#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self;

#import "LEEAFBaseModel.h"
#import "LEEAFNetworkingHelper.h"
@implementation LEEAFBaseModel

+ (NSURLSessionDataTask *) sendDataResponsePath:(NSString *)path
                   httpMethod:(NSString*)method
                      params:(NSMutableDictionary *)params
                  networkHUD:(NetworkHUD)networkHUD
                      target:(id)target
                     success:(void (^)(id data))success {
    
    WS(weakSelf);
  NSURLSessionDataTask *dataTask =
    [LEEAFNetworkingHelper requestWithAFNetWorkingWithPath:path
                                                    params:params
                                                httpMethod:method
                                                       ssl:YES completeHandler:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responeseObj) {
                                                           if (success) {
                                                               success (responeseObj);
                                                               NSLog(@"responseObject == %@",responeseObj);
                                                           }
                                                       } errorHandler:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                           NSLog(@"error :%@",error);
                                                           [weakSelf errorHandlingWithError:error];
                                                       }];
    return dataTask;
}



+ (NSURLSessionDownloadTask*)downloadDocumentFromPath:(NSString *)path
                                         params:(NSMutableDictionary *)params
                                       filePath:(NSString *)filePath
                                   onCompletion:(void (^)(id data))completionBlock
                               downloadProgress:(void (^)(int64_t, int64_t))downloadProgressBlock {
    
    WS(weakSelf);
   NSURLSessionDownloadTask *downloadTesk =
    [LEEAFNetworkingHelper downloadDocumentFromPath:path
                                             params:params
                                           filePath:filePath
                                  completionHandler:^(id  _Nonnull response) {
                                    //待处理数据
                                      completionBlock (response);

                                  }
                                       errorHandler:^(NSError * _Nonnull error) {
                                           [weakSelf errorHandlingWithError:error];
                                       }
                                   downloadProgress:^(int64_t progressValue,int64_t  totalBytesExpectedValue) {
                                       NSLog(@"download progressValue == %lld   total == %lld",progressValue,totalBytesExpectedValue);
                                       downloadProgressBlock(progressValue,totalBytesExpectedValue);
                                   }];
    
    return downloadTesk;
}


+ (NSURLSessionUploadTask *)uploadDocumentFromPath:(NSString *)path
                                            params:(NSMutableDictionary *)params
                                          filePath:(NSString *)filePath
                                      onCompletion:(void (^)(id))completionBlock
                                    uploadProgress:(void (^)(int64_t, int64_t))uploadProgressBlock {

    WS(weakSelf);
    NSURLSessionUploadTask *uploadTask =
    [LEEAFNetworkingHelper uploadDocumentFromPath:path
                                           params:params
                                         filePath:filePath
                                       httpMethod:@"POST"
                                              ssl:NO
                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
                                    //待处理数据
                                    completionBlock(responseObject);
                                    
                                } errorHandler:^(NSError * _Nonnull error) {
                                    
                                    [weakSelf errorHandlingWithError:error];
                                    
                                } onUploadProgress:^(int64_t progressValue,int64_t  totalBytesExpectedValue) {
                                    
                                    NSLog(@"upload progressValue == %lld  tota == %lld",progressValue,totalBytesExpectedValue);
                                    uploadProgressBlock(progressValue,totalBytesExpectedValue);

                                }];
    
    return uploadTask;
}





#pragma mark 错误处理
+ (void)errorHandlingWithError:(NSError *)error {
    NSLog(@"error : %@",error.localizedDescription);
}
@end
