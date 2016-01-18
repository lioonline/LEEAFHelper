//
//  LEEAFClient.h
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/25.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface LEEAFClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

