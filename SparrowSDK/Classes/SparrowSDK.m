//
//  SparrowSDK.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/22.
//

#import "SparrowSDK.h"
#import "SPRURLProtocol.h"
#import "SPRManager.h"
#import "SPRCommonData.h"
#import "SPRControlCenterViewController.h"

@implementation SparrowSDK

+ (void)startWithOption:(SPROptions *)options {
    [SPRManager startWithOption:options];
}

+ (void)stop {
    [SPRManager stop];
}

+ (void)showControlPage {
    [SPRManager showControlPage];
}

+ (void)dismissControlPage {
    [SPRManager dismissControlPage];
}

@end
