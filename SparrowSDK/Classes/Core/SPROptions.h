//
//  SPROptions.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/22.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    // 使用悬浮球
    SPROptionsSytleFloatingBall,
    // 自定义启动
    SPROptionsSytleCustom,
} SPROptionsSytle;

@interface SPROptions : NSObject

/**
 * Sparrow 服务器的地址
 * 如果使用本机运行 Sparrow 服务，可以使用本机地址，如 http://localhost:8080
 */
@property (nonatomic, copy) NSString *hostURL;
/**
 * Sparrow 展现形式
 */
@property(nonatomic, assign) SPROptionsSytle sytle;
@end
