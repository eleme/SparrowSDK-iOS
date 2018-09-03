//
//  SPRAccount.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/4/9.
//

#import "SPRAccount.h"

@implementation SPRAccount

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _accountId = [dict[@"id"] longValue];
        _username = dict[@"username"];
        _email = dict[@"email"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.accountId) forKey:@"accountId"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.email forKey:@"email"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.accountId = [[coder decodeObjectForKey:@"accountId"] longValue];
    self.username = [coder decodeObjectForKey:@"username"];
    self.email = [coder decodeObjectForKey:@"email"];
    return self;
}

@end
