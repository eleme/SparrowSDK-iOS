//
//  SPRProject.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/9.
//

#import "SPRProject.h"

@implementation SPRProject

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        return nil;
    }
    if (self = [super init]) {
        _name = dict[@"name"];
        _status = [dict[@"status"] intValue];
        _note = dict[@"note"];
        _project_id = [dict[@"project_id"] longValue];
        _updateTime = dict[@"updateTime"];
        _createTime = dict[@"createTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:@(self.status) forKey:@"status"];
    [coder encodeObject:self.note forKey:@"note"];
    [coder encodeObject:@(self.project_id) forKey:@"project_id"];
    [coder encodeObject:self.updateTime forKey:@"updateTime"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.name = [coder decodeObjectForKey:@"name"];
    self.status = [[coder decodeObjectForKey:@"status"] intValue];
    self.note = [coder decodeObjectForKey:@"note"];
    self.project_id = [[coder decodeObjectForKey:@"project_id"] longValue];
    self.updateTime = [coder decodeObjectForKey:@"updateTime"];
    self.createTime = [coder decodeObjectForKey:@"createTime"];
    return self;
}

@end
