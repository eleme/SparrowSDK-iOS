//
//  SPRURLProtocol.h
//  SparrowSDK
//
//  Created by summertian4 on 03/07/2018.
//  Copyright (c) 2018 summertian4. All rights reserved.
//

#import "SPRURLProtocol.h"
#import "SPRURLSessionConfiguration.h"
#import "SPRRequestFilter.h"

static NSString *const SPRHTTP = @"SPRHTTP";

@interface SPRURLProtocol() <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLRequest *spr_request;
@property (nonatomic, strong) NSURLResponse *spr_response;
@property (nonatomic, strong) NSMutableData *spr_data;

@end

@implementation SPRURLProtocol

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)load {
    
}

+ (void)start {
    NSLog(@"┌────────────────────────────────────────────────────────────────────────────────────────┐"); // 1
    NSLog(@"│****************************************************************************************│"); // 2
    NSLog(@"│                                                                                        │"); // 3
    NSLog(@"│                                                                                        │"); // 4
    NSLog(@"│           _____                                        _____ __             __         │"); // 5
    NSLog(@"│          / ___/____  ____ _______________ _      __   / ___// /_____ ______/ /_        │"); // 6
    NSLog(@"│          \\__ \\/ __ \\/ __ `/ ___/ ___/ __ \\ | /| / /   \\__ \\/ __/ __ `/ ___/ __/        │"); // 7
    NSLog(@"│         ___/ / /_/ / /_/ / /  / /  / /_/ / |/ |/ /   ___/ / /_/ /_/ / /  / /_          │"); // 8
    NSLog(@"│        /____/ .___/\\__,_/_/  /_/   \\____/|__/|__/   /____/\\__/\\__,_/_/   \\__/          │"); // 9
    NSLog(@"│            /_/                                                                         │"); // 10
    NSLog(@"│                                                                                        │"); // 11
    NSLog(@"│                                                                                        │"); // 12
    NSLog(@"│****************************************************************************************│"); // 13
    NSLog(@"└────────────────────────────────────────────────────────────────────────────────────────┘"); // 14

    SPRURLSessionConfiguration *sessionConfiguration = [SPRURLSessionConfiguration defaultConfiguration];
    [NSURLProtocol registerClass:[SPRURLProtocol class]];
    if (![sessionConfiguration isSwizzle]) {
        [sessionConfiguration load];
    }
}

+ (void)end {
    NSLog(@"┌────────────────────────────────────────────────────────────────────────────────────────┐"); // 1
    NSLog(@"│****************************************************************************************│"); // 2
    NSLog(@"│                                                                                        │"); // 3
    NSLog(@"│                                                                                        │"); // 4
    NSLog(@"│             _____                                        _____ __                      │"); // 5
    NSLog(@"│            / ___/____  ____ _______________ _      __   / ___// /_____  ____           │"); // 6
    NSLog(@"│            \\__ \\/ __ \\/ __ `/ ___/ ___/ __ \\ | /| / /   \\__ \\/ __/ __ \\/ __ \\          │"); // 7
    NSLog(@"│           ___/ / /_/ / /_/ / /  / /  / /_/ / |/ |/ /   ___/ / /_/ /_/ / /_/ /          │"); // 8
    NSLog(@"│          /____/ .___/\\__,_/_/  /_/   \\____/|__/|__/   /____/\\__/\\____/ .___/           │"); // 9
    NSLog(@"│              /_/                                                    /_/                │"); // 10
    NSLog(@"│                                                                                        │"); // 11
    NSLog(@"│                                                                                        │"); // 12
    NSLog(@"│****************************************************************************************│"); // 13
    NSLog(@"└────────────────────────────────────────────────────────────────────────────────────────┘"); // 14

    SPRURLSessionConfiguration *sessionConfiguration = [SPRURLSessionConfiguration defaultConfiguration];
    [NSURLProtocol unregisterClass:[SPRURLProtocol class]];
    if ([sessionConfiguration isSwizzle]) {
        [sessionConfiguration unload];
    }
}


/**
 需要控制的请求

 @param request 此次请求
 @return 是否需要监控
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    // 拦截过的不再拦截
    if ([NSURLProtocol propertyForKey:SPRHTTP inRequest:request] ) {
        return NO;
    }
    return YES;
}

/**
 设置我们自己的自定义请求
 可以在这里统一加上头之类的
 
 @param request 应用的此次请求
 @return 我们自定义的请求
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:SPRHTTP
                     inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading {
    NSURLRequest *request = [[self class] canonicalRequestForRequest:self.request];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    self.spr_request = self.request;
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.client URLProtocol:self didFailWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
    return YES;
}

#pragma mark - NSURLConnectionDataDelegate

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    request = [SPRRequestFilter filterRequest:request];

    if (response != nil) {
        self.spr_response = response;
        [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.spr_response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.spr_data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
