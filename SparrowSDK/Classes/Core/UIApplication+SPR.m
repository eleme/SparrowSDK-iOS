//
//  UIApplication+SPR.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/4/11.
//

#import "UIApplication+SPR.h"
#import <objc/runtime.h>
#import "SPRCommonData.h"

void Swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation UIApplication (SPR)

+ (void)initialize {
    Swizzle([UIApplication class], @selector(sendEvent:), @selector(sprSendEvent:));
}

- (void)sprSendEvent:(UIEvent*)event {
    BOOL shouldSyncWithShake = [[SPRCommonData defaultData] shouldSyncWithShake];
    if (shouldSyncWithShake == YES) {
        if (event.type == UIEventTypeMotion) {
            int result = [event valueForKey:@"_shakeState"] != nil ? [[event valueForKey:@"_shakeState"] intValue]: 0;
            if (result == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSPRnotificationMotionEvent object:nil];
            }
        }
    }
    [self sprSendEvent:event];
}

@end
