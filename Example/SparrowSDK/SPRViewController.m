//
//  SPRViewController.m
//  SparrowSDK
//
//  Created by summertian4 on 03/07/2018.
//  Copyright (c) 2018 summertian4. All rights reserved.
//

#import "SPRViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SparrowSDK/SparrowSDK.h>

@interface SPRViewController ()

@end

@implementation SPRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [SparrowSDK showControlPage];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SparrowSDK dismissControlPage];
//    });


//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SparrowSDK stop];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            SPROptions *options = [SPROptions new];
//            options.hostURL = @"http://alta1-lpd-talaris-team-app-download-1.vm.elenet.me";
//            [SparrowSDK startWithOption:options];
//        });
//    });
}

- (IBAction)getRequest {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak __typeof(self)weakSelf = self;
    [manager GET:@"http://xxx.com/airticle/list"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSData *unicodedStringData = [[responseObject description] dataUsingEncoding:NSUTF8StringEncoding];
             NSString *stringValue =  [[NSString alloc] initWithData:unicodedStringData encoding:NSNonLossyASCIIStringEncoding];
             [weakSelf showAlert:stringValue];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [weakSelf showAlert:error.domain];
         }];
}

- (IBAction)postRequest {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak __typeof(self)weakSelf = self;
    [manager POST:@"http://xxx.com/home/sidebar"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSData *unicodedStringData = [[responseObject description] dataUsingEncoding:NSUTF8StringEncoding];
             NSString *stringValue =  [[NSString alloc] initWithData:unicodedStringData encoding:NSNonLossyASCIIStringEncoding];
             [weakSelf showAlert:stringValue];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [weakSelf showAlert:error.domain];
         }];
}

- (IBAction)putRequest {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak __typeof(self)weakSelf = self;
    [manager PUT:@"https://xxx.com/s"
      parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSData *unicodedStringData = [[responseObject description] dataUsingEncoding:NSUTF8StringEncoding];
          NSString *stringValue =  [[NSString alloc] initWithData:unicodedStringData encoding:NSNonLossyASCIIStringEncoding];
          [weakSelf showAlert:stringValue];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [weakSelf showAlert:error.domain];
      }];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *uiAlertController=
    [UIAlertController alertControllerWithTitle:@""
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [uiAlertController addAction:action];
    [self presentViewController:uiAlertController animated:YES completion:nil];
}

@end
