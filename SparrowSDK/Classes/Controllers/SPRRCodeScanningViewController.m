//
//  SPRRCodeScanningVC.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/20.
//

#import "SPRRCodeScanningViewController.h"
#import "SGQRCode.h"
#import "SPRManager.h"
#import "SPROptions.h"

@interface SPRRCodeScanningViewController () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation SPRRCodeScanningViewController

#pragma mark - Life Circle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    SPRLog(@"WBQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self initSubviews];
    [self setupQRCodeScanning];
}

#pragma mark - Private

- (void)initSubviews {
    [self closeButton];
    [self.view addSubview:self.promptLabel];
}

- (void)closeButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate

- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}

- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
    } else {
    }
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    SPRLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    SPRLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *url = [obj stringValue];
        if ([url hasPrefix:[SPRManager sharedInstance].options.hostURL]) {
            [scanManager stopRunning];
            __weak __typeof(self)weakSelf = self;
            [self dismissViewControllerAnimated:YES completion:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf) {
                    if (strongSelf.didScanedQRCodeCallBack) {
                        strongSelf.didScanedQRCodeCallBack([obj stringValue]);
                    }
                }
            }];
        } else {
            [SPRToast showWithMessage:@"请扫描正确的二维码" from:self.view];
        }
    } else {
        SPRLog(@"暂未识别出扫描的二维码");
    }
}

#pragma mark - Getter Setter

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        _scanningView.cornerColor = [UIColor colorWithHexString:@"50E3C2"];
    }
    return _scanningView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"sparrow_close"
                                    inBundle:[SPRCommonData bundle]
               compatibleWithTraitCollection:nil];
        [_closeButton setImage:image forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(30));
            make.width.height.equalTo(@(35));
        }];
    }
    return _closeButton;
}

@end

