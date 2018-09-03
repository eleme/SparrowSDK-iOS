//
//  SPRSettingViewController.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/20.
//

#import "SPRSettingViewController.h"
#import "SPRHTTPSessionManager.h"
#import "SPRCacheManager.h"
#import "SPRManager.h"

@interface SPRSettingViewController ()
#pragma mark - Host Setting
@property (nonatomic, strong) UILabel *hostTitleLabel;
@property (nonatomic, strong) UITextField *hostTextField;
@property (nonatomic, strong) UIButton *hostConfirmButton;
@property (nonatomic, strong) UIView *hostContentView;
#pragma mark - SyncWithShake
@property (nonatomic, strong) UIView *syncWithShakeContentView;
@property (nonatomic, strong) UISwitch *syncWithShakeSwitch;
#pragma mark - Logout Button
@property (nonatomic, strong) UIButton *logoutButton;
@end

@implementation SPRSettingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initSubviews];
}

#pragma mark - Private

- (void)initSubviews {
    [self hostTitleLabel];
    [self hostContentView];
    [self hostTextField];
    [self hostConfirmButton];
    [self logoutButton];
    [self syncWithShakeContentView];
}

- (void)hostConfirmButtonClicked {
    NSString *hostStr = [self.hostTextField.text
                         stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
    if ([hostStr hasSuffix:@"/"]) {
        hostStr = [hostStr substringToIndex: hostStr.length - 1];
    }
    [SPRCommonData setSparrowHost:hostStr];
    [SPRToast showWithMessage:@"设置 host 成功" from:self.view];
}

- (void)requestLogout {
    __weak __typeof(self)weakSelf = self;
    [self showHUD];
    [SPRHTTPSessionManager POST:@"/frontend/account/logout"
                     parameters:nil
                        success:^(NSURLSessionDataTask *task, SPRResponse *response) {
                            __strong __typeof(weakSelf)strongSelf = weakSelf;
                            if (strongSelf) {
                                [strongSelf dismissHUD];
                                [SPRToast showWithMessage:@"登出成功" from:strongSelf.view];
                                [SPRCacheManager clearAccountFromCache];
                                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            SPRLog(@"%@", error);
                            __strong __typeof(weakSelf)strongSelf = weakSelf;
                            if (strongSelf) {
                                [strongSelf dismissHUD];
                                [SPRToast showWithMessage:error.domain from:strongSelf.view];
                            }
                        }];
}

#pragma mark - Action

- (void)logoutButtonClicked {
    [self requestLogout];
}

- (void)syncWithShakeSwitchChanged:(UISwitch *)sender {
    [[SPRCommonData defaultData] setShouldSyncWithShake:sender.isOn];
}

#pragma mark - Getter Setter

- (UILabel *)hostTitleLabel {
    if (_hostTitleLabel == nil) {
        _hostTitleLabel = [[UILabel alloc] init];
        _hostTitleLabel.text = @"Sparrow Host 设置";
        _hostTitleLabel.font = [UIFont systemFontOfSize:17];
        _hostTitleLabel.textColor = [UIColor colorWithHexString:@"545454"];

        [self.view addSubview:_hostTitleLabel];
        [_hostTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide).offset(15);
            make.left.equalTo(self.view).offset(15);
        }];
    }
    return _hostTitleLabel;
}

- (UIView *)hostContentView {
    if (_hostContentView == nil) {
        _hostContentView = [[UIView alloc] init];
        [self.view addSubview:_hostContentView];
        [_hostContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.hostTitleLabel.mas_bottom).offset(8);
            make.right.equalTo(self.view).offset(-15);
            make.height.equalTo(@(50));
        }];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"EEECEC"];
        [_hostContentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_hostContentView);
            make.height.equalTo(@(1));
        }];
    }
    return _hostContentView;
}

- (UITextField *)hostTextField {
    if (_hostTextField == nil) {
        _hostTextField = [[UITextField alloc] init];
        _hostTextField.text = [SPRCommonData sparrowHost];
        _hostTextField.font = [UIFont systemFontOfSize:17];
        _hostTextField.textColor = [UIColor colorWithHexString:@"4B4B4B"];
        [self.hostContentView addSubview:_hostTextField];
        [_hostTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hostContentView).offset(8);
            make.bottom.equalTo(self.hostContentView).offset(-6);
            make.right.equalTo(self.hostConfirmButton.mas_left).offset(8);
        }];
    }
    return _hostTextField;
}

- (UIButton *)hostConfirmButton {
    if (_hostConfirmButton == nil) {
        _hostConfirmButton = [[UIButton alloc] init];
        _hostConfirmButton.backgroundColor = SPRThemeColor;
        _hostConfirmButton.layer.cornerRadius = 5;
        _hostConfirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_hostConfirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_hostConfirmButton addTarget:self action:@selector(hostConfirmButtonClicked)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.hostContentView addSubview:_hostConfirmButton];
        [_hostConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.hostContentView).offset(-8);
            make.bottom.equalTo(self.hostContentView).offset(-6);
            make.width.equalTo(@(45));
            make.height.equalTo(@(30));
        }];
    }
    return _hostConfirmButton;
}

- (UIButton *)logoutButton {
    if (_logoutButton == nil) {
        _logoutButton = [[UIButton alloc] init];
        _logoutButton.backgroundColor = SPRThemeColor;
        [_logoutButton setTitle:@"登出" forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _logoutButton.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        _logoutButton.layer.shadowOpacity = 0.2f;
        _logoutButton.layer.shadowOffset = CGSizeMake(0,6);
        _logoutButton.layer.shadowRadius = 14;
        _logoutButton.layer.cornerRadius = 8;
        [_logoutButton addTarget:self
                          action:@selector(logoutButtonClicked)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_logoutButton];
        [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.syncWithShakeContentView.mas_bottom).offset(30);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.height.equalTo(@(45));
        }];
    }
    return _logoutButton;
}

- (UIView *)syncWithShakeContentView {
    if (_syncWithShakeContentView == nil) {
        _syncWithShakeContentView = [[UIView alloc] init];
        [self.view addSubview:_syncWithShakeContentView];
        [_syncWithShakeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.hostContentView);
            make.top.equalTo(self.hostContentView.mas_bottom);
        }];

        UILabel *label = [[UILabel alloc] init];
        label.text = @"摇一摇同步";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor colorWithHexString:@"4B4B4B"];
        label.textAlignment = NSTextAlignmentLeft;
        [_syncWithShakeContentView addSubview:label];
        __weak __typeof(UIView *)w_syncWithShakeContentView = _syncWithShakeContentView;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(w_syncWithShakeContentView).offset(8);
            make.bottom.equalTo(w_syncWithShakeContentView).offset(-6);
        }];

        [self syncWithShakeSwitch];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"EEECEC"];
        [_syncWithShakeContentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(w_syncWithShakeContentView);
            make.height.equalTo(@(1));
        }];
    }
    return _syncWithShakeContentView;
}

- (UISwitch *)syncWithShakeSwitch {
    if (_syncWithShakeSwitch == nil) {
        _syncWithShakeSwitch = [[UISwitch alloc] init];
        _syncWithShakeSwitch.onTintColor = SPRThemeColor;
        _syncWithShakeSwitch.on = [[SPRCommonData defaultData] shouldSyncWithShake];
        [_syncWithShakeSwitch addTarget:self
                                 action:@selector(syncWithShakeSwitchChanged:)
                       forControlEvents:UIControlEventValueChanged];
        [self.syncWithShakeContentView addSubview:_syncWithShakeSwitch];
        [_syncWithShakeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.syncWithShakeContentView).offset(-8);
            make.bottom.equalTo(self.syncWithShakeContentView).offset(-6);
        }];
    }
    return _syncWithShakeSwitch;
}

@end
