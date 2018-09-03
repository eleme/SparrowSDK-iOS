//
//  SPRHTTPSessionManager.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/9.
//

#import "SPRHTTPSessionManager.h"
#import "SPRCommonData.h"
#import "SPRManager.h"

@implementation SPRHTTPSessionManager

static SPRHTTPSessionManager *manager;

+ (SPRHTTPSessionManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SPRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[SPRCommonData sparrowHost]]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return manager;
}

+ (void)updateBaseURL {
    manager = [[SPRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[SPRCommonData sparrowHost]]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
}

+ (void)GET:(NSString * _Nullable)URLString
 parameters:(id _Nullable)parameters
    success:(void (^ _Nullable)(NSURLSessionDataTask *task, SPRResponse *response))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask *task, NSError *error))failure {
    [[SPRHTTPSessionManager defaultManager] GET:URLString
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             SPRResponse *response = [[SPRResponse alloc] initWithDictionary:responseObject];
             [SPRHTTPSessionManager handleSuccessBlock:success
                                               failure:failure
                                                  task:task responseObject:response];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failure(task, error);
         }];
}

+ (void)GET:(NSString * _Nullable)URLString
isAbsolutePath:(BOOL)isAbsolutePath
 parameters:(id _Nullable)parameters
    success:(void (^ _Nullable)(NSURLSessionDataTask *task, SPRResponse *response))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask *task, NSError *error))failure {
    if (isAbsolutePath) {
        SPRHTTPSessionManager *manager = [[SPRHTTPSessionManager alloc] init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:URLString
          parameters:parameters
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 SPRResponse *response = [[SPRResponse alloc] initWithDictionary:responseObject];
                 [SPRHTTPSessionManager handleSuccessBlock:success
                                                   failure:failure
                                                      task:task responseObject:response];
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(task, error);
             }];
    } else {
        [self GET:URLString parameters:parameters success:success failure:failure];
    }
}

+ (void)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, SPRResponse *response))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError * error))failure {
    [[SPRHTTPSessionManager defaultManager] POST:URLString
                                      parameters:parameters
                                        progress:nil
                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                             SPRResponse *response = [[SPRResponse alloc] initWithDictionary:responseObject];
                                             [SPRHTTPSessionManager handleSuccessBlock:success
                                                                               failure:failure
                                                                                  task:task responseObject:response];
                                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                             failure(task, error);
                                         }
     ];
}

+ (void)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, SPRResponse *response))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[SPRHTTPSessionManager defaultManager] POST:URLString
                                      parameters:parameters
                       constructingBodyWithBlock:block
                                        progress:uploadProgress
                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                             SPRResponse *response = [[SPRResponse alloc] initWithDictionary:responseObject];
                                             [SPRHTTPSessionManager handleSuccessBlock:success
                                                                               failure:failure
                                                                                  task:task responseObject:response];
                                         }
                                         failure:failure];
}

+ (void)handleSuccessBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                      task:(NSURLSessionDataTask *)task
            responseObject:(SPRResponse *)responseObject {
    if (responseObject.code == 200) {
        success(task, responseObject);
    } else if (responseObject.code == 901) {
        NSString *domain = @"请先登录";
        NSError *error = [[NSError alloc] initWithDomain:domain
                                                    code:responseObject.code
                                                userInfo:@{}];
        // 跳转登录
        [SPRManager showLoginPage];
        failure(task, error);
    } else {
        NSString *domain = responseObject.message;
        NSError *error = [[NSError alloc] initWithDomain:domain
                                                    code:(NSInteger)responseObject.code
                                                userInfo:@{}];
        failure(task, error);
    }
}

@end
