//
//  SPRBaseViewController.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/16.
//

#import <UIKit/UIKit.h>
#import "SPRToast.h"
#import <Masonry/Masonry.h>
#import "SPRCommonData.h"

@interface SPRBaseViewController : UIViewController

- (void)setRightBarWithTitle:(NSString *)title action:(SEL)action;
- (void)setRightBarWithImage:(UIImage *)image action:(SEL)action;
- (void)setLeftBarWithImage:(UIImage *)image action:(SEL)action;

- (void)showHUD;
- (void)dismissHUD;

@end
