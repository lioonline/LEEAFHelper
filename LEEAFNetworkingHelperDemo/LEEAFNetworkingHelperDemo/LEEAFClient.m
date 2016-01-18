//
//  LEEAFClient.m
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/25.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//
//可不是用此类

#import "LEEAFClient.h"
static NSString * const LEEClientAPIBaseURLString = @"https://www.v2ex.com/";


@implementation LEEAFClient

+ (instancetype)sharedClient {
    static LEEAFClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedClient = [[LEEAFClient alloc] initWithBaseURL:[NSURL URLWithString:LEEClientAPIBaseURLString]];
    });
    return _sharedClient;
}

@end
