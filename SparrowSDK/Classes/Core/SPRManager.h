//
//  SPRFloatBallWindow.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import <UIKit/UIKit.h>

@class SPRWindow;
@class SPRControlCenterViewController;
@class SPROptions;

@interface SPRManager : NSObject

@property (nonatomic, strong) SPRWindow *window;
@property (nonatomic, strong) SPRControlCenterViewController *controlCenterVC;
@property (nonatomic, strong, readonly) SPROptions *options;

+ (instancetype)sharedInstance;
+ (void)showLoginPage;
+ (void)showControlPage;
+ (void)dismissControlPage;
+ (void)startWithOption:(SPROptions *)options;
+ (void)stop;

@end
