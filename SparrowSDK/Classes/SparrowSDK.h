//
//  SparrowSDK.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/22.
//

#import <Foundation/Foundation.h>
#import "SPROptions.h"

@interface SparrowSDK : NSObject

/**
 * 通过 options 启动 Sparrow
 */
+ (void)startWithOption:(SPROptions *)options;
/**
 * 停止 Sparrow（停止网络监控，取消悬浮层）
 */
+ (void)stop;
/**
 * 显示 Sparrow 控制中心
 */
+ (void)showControlPage;
/**
 * 收回 Sparrow 控制中心
 */
+ (void)dismissControlPage;

@end
