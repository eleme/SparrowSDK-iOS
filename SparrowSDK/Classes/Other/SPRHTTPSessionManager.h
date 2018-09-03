//
//  SPRHTTPSessionManager.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/9.
//

#import <AFNetworking/AFNetworking.h>
#import "SPRResponse.h"

@interface SPRHTTPSessionManager : AFHTTPSessionManager

+ (SPRHTTPSessionManager * _Nullable)defaultManager;
+ (void)updateBaseURL;

+ (void)GET:(NSString * _Nullable)URLString
 parameters:(id _Nullable)parameters
    success:(void (^ _Nullable)(NSURLSessionDataTask *task, SPRResponse *response))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)GET:(NSString * _Nullable)URLString
isAbsolutePath:(BOOL)isAbsolutePath
 parameters:(id _Nullable)parameters
    success:(void (^ _Nullable)(NSURLSessionDataTask *task, SPRResponse *response))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, SPRResponse *response))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError * error))failure;

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
     success:(void (^)(NSURLSessionDataTask *task, SPRResponse *response))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
