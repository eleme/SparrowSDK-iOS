//
//  SPRURLSessionConfiguration.m
//  SparrowSDK
//
//  Created by summertian4 on 03/07/2018.
//  Copyright (c) 2018 summertian4. All rights reserved.
//

#import "SPRURLSessionConfiguration.h"
#import <objc/runtime.h>
#import "SPRURLProtocol.h"

@implementation SPRURLSessionConfiguration

+ (SPRURLSessionConfiguration *)defaultConfiguration {
    static SPRURLSessionConfiguration *staticConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfiguration=[[SPRURLSessionConfiguration alloc] init];
    });
    return staticConfiguration;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSwizzle=NO;
    }
    return self;
}

- (void)load {
    self.isSwizzle=YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)unload {
    self.isSwizzle=NO;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    return @[[SPRURLProtocol class]];
    //如果还有其他的监控protocol，也可以在这里加进去
}

@end
