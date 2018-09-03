//
//  SPRCommonData.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import "UIColor+SPRAddtion.h"

#define SPRThemeColor ([UIColor colorWithHexString:@"04D1B2"])

#ifdef DEBUG
#define SPRLog(fmt, ...) NSLog(@"--------"); \
NSLog((@"SparrowSDK: %s [Line %d] "), __PRETTY_FUNCTION__, __LINE__); \
NSLog(fmt,  ##__VA_ARGS__); \
NSLog(@"--------");
#else
# define SPRLog(...);
#endif

extern NSString * const kSPRnotificationLoginSuccess;
extern NSString * const kSPRnotificationMotionEvent;
extern NSString * const kSPRnotificationNeedRefreshData;

@interface SPRCommonData : NSObject

@property (nonatomic, assign) BOOL shouldSyncWithShake;

+ (SPRCommonData *)defaultData;

+ (NSBundle *)bundle;
+ (NSString *)sparrowHost;
+ (void)setSparrowHost:(NSString *)hostStr;

@end
