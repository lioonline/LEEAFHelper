//
//  LEEAFNetworkingHelper.m
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/24.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//
//用于请求，下载，上传

#import "LEEAFNetworkingHelper.h"
#import "LEEAFClient.h"
#import "AFNetworking.h"

#warning 设置Base_URL 在实际情况中须修改
static NSString * const LEEClientAPIBaseURLString = @"https://www.v2ex.com/";

@implementation LEEAFNetworkingHelper
//http,https网络请求

+ (NSURLSessionDataTask *)requestWithAFNetWorkingWithPath:(nullable NSString *)path
                                 params:(nullable NSMutableDictionary *)params
                             httpMethod:(nullable NSString *)method
                                    ssl:(BOOL) useSSL
                        completeHandler:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task ,id  _Nonnull responese))complete
                           errorHandler:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task ,  NSError * _Nonnull error))fail {
    
    NSParameterAssert(path);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //1 设置manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:LEEClientAPIBaseURLString]              sessionConfiguration:configuration];

    NSURLSessionDataTask *dataTask;
    // 请求
    if ([method isEqualToString:@"GET"]) {
       dataTask =  [manager GET:path
                      parameters:params
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                           //请求成功回传数据
                            if (complete) {
                                complete(task,responseObject);
                            }
                         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                            if (fail) {
                                fail(task,error);
                            }
                        }];
    }
    else if ([method isEqualToString:@"POST"]) {
         dataTask =     [manager    POST:path
                          parameters:params
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                 //请求成功回传数据
                                 if (complete) {
                                     complete(task,responseObject);
                                 }
                             } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                 if (fail) {
                                     fail(task,error);
                                 }
                             }];
    }
    else {
        NSAssert(nil, @"警告:如需其他 httpMethod 可在[LEEAFNetworkingHelper requestWithAFNetWorkingWithPath: params: httpMethod:  ssl: completeHandler: errorHandler:]");
#warning TODO  如需其他 httpMethod 可在此处添加
    }
    return dataTask;
}

//下载文件
+ (NSURLSessionDownloadTask*)downloadDocumentFromPath:(NSString *)completeURLPath
                          params:(NSMutableDictionary *)params
                        filePath:(NSString *)filePath
               completionHandler:(void (^)(id _Nonnull))complete
                    errorHandler:(void (^)(NSError * _Nonnull))fail
                downloadProgress:(void(^)(int64_t,int64_t))downloadProgressBlock {
    
    NSParameterAssert(completeURLPath);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
   
    // 定义一个NSProgress指针
    NSProgress *progress;
    
    NSURL *URL = [NSURL URLWithString:completeURLPath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:&progress
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL;
        if (filePath) {
             documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:[NSURL URLWithString:filePath] create:NO error:nil];
        }
        else {
           documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        }
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];

    } completionHandler:^(NSURLResponse *response, NSURL *downloadFilePath, NSError *error) {
        if (error) {
            if (fail) {
                fail(error);
            }
        }
        else {
            if (complete) {
                complete(response);
            }
        }
        NSLog(@"File downloaded to: %@", downloadFilePath);
        
    }];
    //激活任务
    [downloadTask resume];
    //下载进度
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        downloadProgressBlock(totalBytesWritten,totalBytesExpectedToWrite);
    }];
    
    return downloadTask;
}

//上传文件
+ (NSURLSessionUploadTask *)uploadDocumentFromPath:(NSString *)path
                        params:(NSMutableDictionary *)params
                     filePath:(NSString *)filePath
                    httpMethod:(NSString *)method
                           ssl:(BOOL)useSSL
             completionHandler:(void (^)(NSURLResponse*  _Nonnull responese,id _Nonnull responseObject))complete
                  errorHandler:(void (^)(NSError * _Nonnull))fail
              onUploadProgress:(void(^)(int64_t,int64_t))uploadProgressBlock {
    
    NSParameterAssert(path);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 10;
    configuration.timeoutIntervalForRequest = 60.0;
    configuration.timeoutIntervalForResource = 90.0;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
#warning 测试接口需要此处 Serializer 设为 XML 请根据实际情况调整
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    AFHTTPResponseSerializer *se = manager.responseSerializer;

    se.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 定义一个NSProgress指针
    NSProgress *progress;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = method;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request
                                                               fromFile:[NSURL URLWithString:filePath]
                                                               progress:&progress
                                                      completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (fail) {
                if ([error code] == -1005) {
                    
                }
                else{
                    fail(error);
                }
            }
        } else {
            if (complete) {
                complete (response,responseObject);
            }
            NSLog(@"Success: %@   responseObject   %@", response, responseObject);
        }
    }];
    //激活任务
    [uploadTask resume];
    //上传进度
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        uploadProgressBlock(totalBytesSent,totalBytesExpectedToSend);
    }];
    return uploadTask;
    
}




@end
