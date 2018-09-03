//
//  SPRRCodeScanningViewController.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/20.
//

#import "SPRBaseViewController.h"

typedef void (^DidScanedQRCodeCallBack)(NSString *content);

@interface SPRRCodeScanningViewController : SPRBaseViewController

@property (nonatomic, copy, nullable) DidScanedQRCodeCallBack didScanedQRCodeCallBack;

@end
