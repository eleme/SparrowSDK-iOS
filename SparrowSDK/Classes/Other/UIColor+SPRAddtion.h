//
//  UIColor+SPRAddtion.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/15.
//

#import <UIKit/UIKit.h>

@interface UIColor (SPRAddtion)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
