//
//  ViewController.m
//  LEEAFNetworkingHelperDemo
//
//  Created by Cocoa Lee on 15/11/24.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//


#define downloadTestApi @"https://coding.net/u/coding/p/Coding-iOS/git/archive/master"
#define uploadTestApi   @"http://rpup.sinaapp.com/"//@"https://sm.ms/api/upload"//



#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "LEEAFBaseModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _downloadProgress.progress = 0.0;
    _uploadProgress.progress = 0.0;
    
 
}

- (IBAction)Get:(UIButton *)sender {
    
    [LEEAFBaseModel sendDataResponsePath:@"api/topics/hot.json" httpMethod:@"GET"  params:nil networkHUD:1 target:nil success:^(id data) {
        
    }];
    
}
- (IBAction)download:(UIButton *)sender {
    _downloadProgress.progress = 0.0;
    sender.userInteractionEnabled = NO;
    
    [LEEAFBaseModel downloadDocumentFromPath:downloadTestApi params:nil filePath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0]  onCompletion:^(id data) {
        
    } downloadProgress:^(int64_t progressValue, int64_t totalBytesExpectedValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double value = [[NSString stringWithFormat:@"%lld",progressValue] doubleValue] / totalBytesExpectedValue;
            [_downloadProgress setProgress:value animated:YES ];
            _downloadLabel.text = [NSString stringWithFormat:@"%.2f ％",value * 100];
            

        });
        
        if (progressValue == totalBytesExpectedValue) {
            sender.userInteractionEnabled = YES;
        }
        
    }];
  
}
- (IBAction)upload:(UIButton *)sender {
    _uploadProgress.progress = 0.0;
    sender.userInteractionEnabled = NO;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"uploadTest" ofType:@"pkg"];
    [LEEAFBaseModel uploadDocumentFromPath:uploadTestApi params:nil filePath:path onCompletion:^(id data) {
        
        NSLog(@"date ==== %@",data);
        
    } uploadProgress:^(int64_t progressValue , int64_t  totalBytesExpectedValue) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           double value = [[NSString stringWithFormat:@"%lld",progressValue] doubleValue] / totalBytesExpectedValue;
            _uploadProgress.progress = value;
            _uploadLabel.text = [NSString stringWithFormat:@"%.2f ％",value * 100];
        });
        
        if (progressValue == totalBytesExpectedValue) {
            sender.userInteractionEnabled = YES;
        }
    }];
    
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
