//
//  SPRRequestFilter.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/13.
//

#import "SPRRequestFilter.h"
#import "SPRCacheManager.h"
#import "SPRApi.h"
#import "SPRCommonData.h"

@implementation SPRRequestFilter

+ (NSURLRequest *)filterRequest:(NSURLRequest *)request {
    if ([request.URL.absoluteString hasPrefix:[SPRCommonData sparrowHost]]) {
        return request;
    }
    NSMutableURLRequest *mutableRequest = request.mutableCopy;

    NSArray<SPRApi *> *apis = [SPRCacheManager sharedInstance].apis;
    for (SPRApi *api in apis) {
        NSString *apiPath = [NSString stringWithFormat:@"/%@", api.path];
        if ([request.URL.path isEqualToString:apiPath] && !api.isStoped) {
            mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mock/%ld/%@",
                                                       [SPRCommonData sparrowHost], api.project_id, api.path]];
            break;
        }
    }
    return [mutableRequest copy];;
}

@end
