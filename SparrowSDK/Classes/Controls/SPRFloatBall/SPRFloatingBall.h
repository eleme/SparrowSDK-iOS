//
//  SPRFloatingBall.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import <UIKit/UIKit.h>

@interface SPRFloatingBall : UIView

@property (nonatomic, copy) void (^ballClickedCallback)(void);

- (instancetype)initWithCallBack:(void (^)(void))callback;

@end
