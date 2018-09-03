//
//  SPRToast.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/16.
//

#import "SPRToast.h"
#import "SPRProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation SPRToast

+ (void)showWithMessage:(NSString *)message from:(UIView *)view {
    SPRProgressHUD *toast = [SPRProgressHUD showHUDAddedTo:view animated:YES];
    [toast setMode:SPRProgressHUDModeText];
    toast.label.text = message;
    [toast showAnimated:YES];
    __weak __typeof(SPRProgressHUD *)weak_toast = toast;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [weak_toast hideAnimated:YES];
                   });


}

@end
