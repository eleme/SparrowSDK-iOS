//
//  SPRLoginViewController.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/4/8.
//

#import "SPRLoginViewController.h"
#import "SPRHTTPSessionManager.h"
#import "SPRAccount.h"
#import "SPRCacheManager.h"
#import "SPRRCodeScanningViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SPRLoginViewController ()
@property (nonatomic, strong) UIView *frontBlockView;
@property (nonatomic, strong) UIView *backBlockView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UIView *usernameLineView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIView *passwordLineView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) UIButton *quickLoginButton;


@property (nonatomic, strong) UIView *scanQRCodeView;
@property (nonatomic, strong) UIImageView *scanQRCodeImageView;
@property (nonatomic, strong) UILabel *scanQRCodeLabel;
@end

@implementation SPRLoginViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

#pragma mark - Private

- (void)initSubViews {
    [self cornerLogo];
    [self backBlockView];
    [self frontBlockView];
    [self colorLineImageView];
    [self titleLabel];
    [self usernameLineView];
    [self usernameTextField];
    [self passwordLineView];
    [self passwordTextField];
    [self loginButton];
    [self quickLoginButton];
    [self dismissButton];
    [self scanQRCodeView];
}

- (UIImageView *)cornerLogo {
    UIImage *image = [UIImage imageNamed:@"sparrow_corner_LOGO"
                                inBundle:[SPRCommonData bundle]
           compatibleWithTraitCollection:nil];
    UIImageView *_cornerLogo = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_cornerLogo];
    [_cornerLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(@(271));
        make.height.equalTo(@(145));
    }];
    return _cornerLogo;
}

- (UIImageView *)colorLineImageView {
    UIImage *image = [UIImage imageNamed:@"sparrow_color_line"
                                inBundle:[SPRCommonData bundle]
           compatibleWithTraitCollection:nil];
    UIImageView *_colorLineView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_colorLineView];
    [_colorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.frontBlockView);
        make.bottom.equalTo(self.frontBlockView.mas_top).equalTo(@(-6));
        make.height.equalTo(@(6));
    }];
    return _colorLineView;
}

- (void)requestLogin {
    NSString *username = [self.usernameTextField.text
                          stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text
                          stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];

    __weak __typeof(self)weakSelf = self;
    [self showHUD];
    [SPRHTTPSessionManager POST:@"/frontend/account/login" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[username dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"username"];
        [formData appendPartWithFormData:[password dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"password"];
    } progress:nil success:^(NSURLSessionDataTask *task, SPRResponse *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf dismissHUD];
            [SPRToast showWithMessage:@"登录成功" from:strongSelf.view];
            SPRAccount *account = [[SPRAccount alloc] initWithDict:response.data];
            [SPRCacheManager cacheAccount:account];
            [strongSelf dismissVCCompletion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kSPRnotificationLoginSuccess object:nil];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SPRLog(@"%@", error);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf dismissHUD];
            [SPRToast showWithMessage:error.domain from:strongSelf.view];
        }
    }];
}

- (void)requestQuickLogin:(NSString *)url {
    __weak __typeof(self)weakSelf = self;
    [self showHUD];
    [SPRHTTPSessionManager GET:url
                isAbsolutePath:YES
                    parameters:nil
                       success:^(NSURLSessionDataTask *task, SPRResponse *response) {
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           if (strongSelf) {
                               [strongSelf dismissHUD];
                               [SPRToast showWithMessage:@"登录成功" from:strongSelf.view];
                               SPRAccount *account = [[SPRAccount alloc] initWithDict:response.data];
                               [SPRCacheManager cacheAccount:account];
                               [strongSelf dismissVCCompletion:^{
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kSPRnotificationLoginSuccess object:nil];
                               }];
                           }
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           if (strongSelf) {
                               SPRLog(@"%@", error);
                               [strongSelf dismissHUD];
                               [SPRToast showWithMessage:error.domain from:strongSelf.view];
                           }

                       }];
}

#pragma mark - Action

- (void)dismissButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissVCCompletion: (void (^ __nullable)(void))completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)loginButtonClicked {
    [self requestLogin];
}

- (void)quickLoginButtonClicked {
    SPRRCodeScanningViewController *vc = [[SPRRCodeScanningViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    vc.didScanedQRCodeCallBack = ^(NSString *content) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf requestQuickLogin:content];
        }
    };
    [self QRCodeScanVC:vc];
}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self presentViewController:scanVC animated:YES completion:nil];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self presentViewController:scanVC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

                }];

                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }

            default:
                break;
        }
        return;
    }

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Getter Setter

- (UIView *)backBlockView {
    if (_backBlockView == nil) {
        _backBlockView = [[UIView alloc] init];
        [self.view addSubview:_backBlockView];
        _backBlockView.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        _backBlockView.layer.shadowOpacity = 0.2f;
        _backBlockView.layer.shadowOffset = CGSizeMake(0,6);
        _backBlockView.layer.shadowRadius = 14;

        _backBlockView.layer.cornerRadius = 8;
        _backBlockView.backgroundColor = [UIColor whiteColor];
        [_backBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_centerY);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(220));
            make.height.equalTo(@(200));
        }];
    }
    return _backBlockView;
}

- (UIView *)frontBlockView {
    if (_frontBlockView == nil) {
        _frontBlockView = [[UIView alloc] init];
        [self.view addSubview:_frontBlockView];
        _frontBlockView.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        _frontBlockView.layer.shadowOpacity = 0.2f;
        _frontBlockView.layer.shadowOffset = CGSizeMake(0,6);
        _frontBlockView.layer.shadowRadius = 14;

        _frontBlockView.layer.cornerRadius = 8;
        _frontBlockView.backgroundColor = [UIColor whiteColor];
        [_frontBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.view);
            make.width.equalTo(@(300));
            make.height.equalTo(@(300));
        }];
    }

    return _frontBlockView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"SIGN UP";
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.frontBlockView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.frontBlockView).offset(20);
            make.left.equalTo(self.frontBlockView).offset(28);
        }];
    }
    return _titleLabel;
}

- (UIView *)usernameLineView {
    if (_usernameLineView == nil) {
        _usernameLineView = [[UIView alloc] init];
        _usernameLineView.backgroundColor = [UIColor colorWithHexString:@"DBDBDB"];
        [self.frontBlockView addSubview:_usernameLineView];
        [_usernameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.frontBlockView.mas_top).offset(110);
            make.left.equalTo(self.frontBlockView).offset(28);
            make.right.equalTo(self.frontBlockView).offset(-28);
            make.height.equalTo(@(1));
        }];
    }
    return _usernameLineView;
}

- (UITextField *)usernameTextField {
    if (_usernameTextField == nil) {
        _usernameTextField = [[UITextField alloc] init];
        _usernameTextField.placeholder = @"username";
        _usernameTextField.font = [UIFont systemFontOfSize:14];
        _usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
        [self.frontBlockView addSubview:_usernameTextField];
        [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.usernameLineView.mas_top);
            make.left.equalTo(self.usernameLineView).offset(6);
            make.right.equalTo(self.usernameLineView);
        }];
    }
    return _usernameTextField;
}

- (UIView *)passwordLineView {
    if (_passwordLineView == nil) {
        _passwordLineView = [[UIView alloc] init];
        _passwordLineView.backgroundColor = [UIColor colorWithHexString:@"DBDBDB"];
        [self.frontBlockView addSubview:_passwordLineView];
        [_passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.usernameLineView).offset(60);
            make.left.right.height.equalTo(self.usernameLineView);
            make.right.equalTo(self.frontBlockView).offset(-28);
        }];
    }
    return _passwordLineView;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"password";
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.secureTextEntry = YES;
        [self.frontBlockView addSubview:_passwordTextField];
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.passwordLineView.mas_top);
            make.left.equalTo(self.passwordLineView).offset(6);
            make.right.equalTo(self.passwordLineView);
        }];
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        UIImage *image = [UIImage imageNamed:@"sparrow_login_button"
                                    inBundle:[SPRCommonData bundle]
               compatibleWithTraitCollection:nil];
        _loginButton = [[UIButton alloc] init];
        _loginButton.backgroundColor = [UIColor clearColor];
        [_loginButton setImage:image forState:UIControlStateNormal];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 25;
        [_loginButton addTarget:self
                         action:@selector(loginButtonClicked)
               forControlEvents:UIControlEventTouchUpInside];

        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [UIColor whiteColor];
        shadowView.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        shadowView.layer.shadowOpacity = 0.2f;
        shadowView.layer.shadowOffset = CGSizeMake(0,6);
        shadowView.layer.shadowRadius = 14;
        shadowView.layer.cornerRadius = 25;

        [self.frontBlockView addSubview:shadowView];
        [self.frontBlockView addSubview:_loginButton];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.frontBlockView);
            make.width.height.equalTo(@(50));
            make.bottom.equalTo(self.frontBlockView).offset(-25);
        }];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_loginButton);
        }];
    }
    return _loginButton;
}

- (UIImageView *)scanQRCodeImageView {
    if (_scanQRCodeImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"sparrow_scan_qr_code"
                                    inBundle:[SPRCommonData bundle]
               compatibleWithTraitCollection:nil];
        _scanQRCodeImageView = [[UIImageView alloc] initWithImage:image];
        [self.scanQRCodeView addSubview:_scanQRCodeImageView];
        [_scanQRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.scanQRCodeView);
            make.width.height.equalTo(@(35));
        }];
    }
    return _scanQRCodeImageView;
}

- (UIButton *)quickLoginButton {
    if (_quickLoginButton == nil) {
        _quickLoginButton = [[UIButton alloc] init];
        [_quickLoginButton addTarget:self action:@selector(quickLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.scanQRCodeView addSubview:_quickLoginButton];
        [_quickLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scanQRCodeView);
        }];
    }
    return _quickLoginButton;
}

- (UIButton *)dismissButton {
    if (_dismissButton == nil) {
        _dismissButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"sparrow_login_dismiss_button"
                                    inBundle:[SPRCommonData bundle]
               compatibleWithTraitCollection:nil];
        [_dismissButton addTarget:self
                           action:@selector(dismissButtonClicked)
                 forControlEvents:UIControlEventTouchUpInside];
        [_dismissButton setImage:image forState:UIControlStateNormal];
        [self.view addSubview:_dismissButton];
        [_dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view).offset(-10);
            make.width.equalTo(@(116));
            make.height.equalTo(@(48));
        }];
    }
    return _dismissButton;
}

- (UIView *)scanQRCodeView {
    if (_scanQRCodeView == nil) {
        _scanQRCodeView = [[UIView alloc] init];
        [self.backBlockView addSubview:_scanQRCodeView];
        [self scanQRCodeImageView];
        [self scanQRCodeLabel];
        [_scanQRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backBlockView);
            make.bottom.equalTo(self.backBlockView).offset(-6);
            make.width.equalTo(@(110));
            make.height.equalTo(@(35));
        }];
    }
    return _scanQRCodeView;
}

- (UILabel *)scanQRCodeLabel {
    if (_scanQRCodeLabel == nil) {
        _scanQRCodeLabel = [[UILabel alloc] init];
        _scanQRCodeLabel.text = @"扫码登录";
        _scanQRCodeLabel.font = [UIFont boldSystemFontOfSize:17];
        _scanQRCodeLabel.textColor = [UIColor colorWithHexString:@"9B9B9B"];

        [self.scanQRCodeView addSubview:_scanQRCodeLabel];
        [_scanQRCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.scanQRCodeView);
        }];
    }
    return _scanQRCodeLabel;
}

@end
