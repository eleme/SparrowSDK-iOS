//
//  SPRFloatBallWindow.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRManager.h"
#import "SPRFloatingBall.h"
#import "SPRWindow.h"
#import "SPRControlCenterViewController.h"
#import "SPRLoginViewController.h"
#import "SPRProjectsData.h"
#import "SPRCommonData.h"
#import "SPRCacheManager.h"
#import "SPRProject.h"
#import "SPRProgressHUD.h"
#import "SPRHTTPSessionManager.h"
#import "SPRApi.h"
#import "SPROptions.h"
#import "SPRURLProtocol.h"
#import "SPRAccount.h"

@interface SPRManager ()

@property (nonatomic, copy) void (^ballClickedCustomCallback)(void);
@property (nonatomic, assign) BOOL showedManagerVC;
@property (nonatomic, strong) SPRFloatingBall *floatingBall;
@property (nonatomic, strong) SPROptions *options;
@end

@implementation SPRManager

+ (instancetype)sharedInstance {
    static SPRManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SPRManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginSuccess:)
                                                     name:kSPRnotificationLoginSuccess
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(motionEnd:)
                                                     name:kSPRnotificationMotionEvent
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

+ (void)startWithOption:(SPROptions *)options {
    [[self sharedInstance] setOptions:options];
    // 设置 Host
    if (options.hostURL != nil) {
        [SPRCommonData setSparrowHost:options.hostURL];
    }
    // 启动过滤器
    [SPRURLProtocol start];

    [self showFloatingBallWindow];
    if (options.sytle == SPROptionsSytleFloatingBall) {
        [[self sharedInstance] addFloatBall];
    }
}

+ (void)stop {
    // 关闭过滤器
    [SPRURLProtocol end];
    [[self sharedInstance] dismissFloatingBallWindow];
}

+ (void)showLoginPage {
    [[SPRManager sharedInstance] showLoginPage];
}

+ (void)showControlPage {
    [[SPRManager sharedInstance] showControlPage];
}

+ (void)dismissControlPage {
    [[SPRManager sharedInstance] dismissControlPage];
}

#pragma mark - Private

- (void)showControlPage {
    SPRControlCenterViewController *vc = [[SPRControlCenterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.controlCenterVC = vc;
    [self.window.rootViewController
     presentViewController:nav
     animated:YES
     completion:nil];
}

- (void)dismissControlPage {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginSuccess:(NSNotification *)notification {
    
}

-(void)motionEnd:(NSNotification *)notification {
    [self refreshApis];
}

+ (void)showFloatingBallWindow {
    [[self sharedInstance] window].hidden = NO;
    [[self sharedInstance] window].rootViewController.view.userInteractionEnabled = YES;
}

- (void)dismissFloatingBallWindow {
    self.window = nil;
}

- (void)refreshApis {
    __weak __typeof(self)weakSelf = self;

    NSSet *projects = [SPRCacheManager getProjectsFromCache];
    if (projects == nil || projects.count == 0) {
        [SPRToast showWithMessage:@"请先选择项目" from:self.window.rootViewController.view];
        return;
    }

    NSMutableArray *projectIds = [NSMutableArray array];
    for (SPRProject *project in projects) {
        [projectIds addObject:@(project.project_id)];
    }
    [SPRProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    [SPRHTTPSessionManager GET:@"/frontend/api/fetch"
                    parameters:@{@"project_id": projectIds}
                       success:^(NSURLSessionDataTask *task, SPRResponse *response) {
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           if (strongSelf) {
                               [SPRProgressHUD hideHUDForView:strongSelf.window.rootViewController.view animated:YES];
                               NSMutableArray *apis = [SPRApi apisWithDictArray:response.data];
                               if (apis.count != 0) {
                                   [SPRCacheManager cacheApis:apis];
                                   [SPRToast showWithMessage:@"刷新数据成功" from:strongSelf.window.rootViewController.view];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kSPRnotificationNeedRefreshData object:nil];
                               }
                           }
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           SPRLog(@"%@", error);
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           if (strongSelf) {
                               [SPRProgressHUD hideHUDForView:strongSelf.window.rootViewController.view animated:YES];
                               [SPRToast showWithMessage:@"拉取 API 失败" from:strongSelf.window.rootViewController.view];
                           }
                       }];
}

- (void)showLoginPage {
    UIViewController *vc = [[SPRLoginViewController alloc] init];
    UIViewController *rootVC = [SPRManager sharedInstance].window.rootViewController;
    UIViewController *presentationVC;
    if (rootVC.presentedViewController) {
        presentationVC = rootVC.presentedViewController;
    } else {
        presentationVC = rootVC;
    }
    [presentationVC presentViewController:vc animated:YES completion:nil];
}

- (void)addFloatBall {
    __weak __typeof(self)weakSelf = self;
    self.floatingBall = [[SPRFloatingBall alloc] initWithCallBack:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.ballClickedCustomCallback) {
                strongSelf.ballClickedCustomCallback();
                return;
            }
            if (strongSelf.showedManagerVC == NO) {
                SPRControlCenterViewController *vc = [[SPRControlCenterViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                strongSelf.controlCenterVC = vc;
                [strongSelf.window.rootViewController
                 presentViewController:nav
                 animated:YES
                 completion:nil];
            } else {
                [strongSelf.window.rootViewController.presentedViewController
                 dismissViewControllerAnimated:YES
                 completion:^{
                     [strongSelf.window.rootViewController
                      dismissViewControllerAnimated:YES
                      completion:nil];
                 }];
            }
            self.showedManagerVC = !strongSelf.showedManagerVC;
        }
    }];
    self.floatingBall.frame = CGRectMake(0, 20, 50, 50);
    [self.window.rootViewController.view addSubview:self.floatingBall];
}

#pragma mark - Getter Setter

- (UIWindow *)window {
    if (_window == nil) {
        _window = [[SPRWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = CGFLOAT_MAX;

        UIViewController *rootVC = [UIViewController new];

        _window.rootViewController = rootVC;
        _window.rootViewController.view.backgroundColor = [UIColor clearColor];
        _window.rootViewController.view.userInteractionEnabled = NO;
        _window.hidden = YES;
        _window.userInteractionEnabled = YES;
    }
    return _window;
}

@end
