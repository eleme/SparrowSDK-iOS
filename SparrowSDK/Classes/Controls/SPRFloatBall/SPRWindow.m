//
//  SPRFloatBallViewController.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRWindow.h"

@interface SPRWindow ()

@end

@implementation SPRWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    if (view == self.rootViewController.view) {
        return nil;
    }
    return view;
}

@end
