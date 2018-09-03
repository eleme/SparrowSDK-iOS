//
//  SPRApi.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/12.
//

#import "SPRApi.h"

@implementation SPRApi

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _api_id = [dict[@"api_id"] longValue];
        _path = dict[@"path"];
        _method = dict[@"method"];
        _name = dict[@"name"];
        _note = dict[@"note"];
        _project_id = [dict[@"project_id"] longValue];
        switch ([dict[@"status"] intValue]) {
            case 0:
                _status = SPRApiStatusDisabled;
                break;
            case 1:
                _status = SPRApiStatusMock;
                break;
            case 2:
                _status = SPRApiStatusUseOther;
                break;
            default:
                break;
        }
        _isStoped = [dict[@"isStoped"] boolValue];
    }
    return self;
}

+ (NSMutableArray *)apisWithDictArray:(NSArray *)dictArr {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dictArr) {
        SPRApi *api = [[SPRApi alloc] initWithDict:dic];
        [array addObject:api];
    }
    return array;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.api_id) forKey:@"api_id"];
    [coder encodeObject:self.path forKey:@"path"];
    [coder encodeObject:self.method forKey:@"method"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.note forKey:@"note"];
    [coder encodeObject:@(self.status) forKey:@"status"];
    [coder encodeObject:@(self.project_id) forKey:@"project_id"];
    [coder encodeObject:@(self.isStoped) forKey:@"isStoped"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.api_id = [[coder decodeObjectForKey:@"api_id"] longValue];
    self.path = [coder decodeObjectForKey:@"path"];
    self.method = [coder decodeObjectForKey:@"method"];
    self.name = [coder decodeObjectForKey:@"name"];
    self.note = [coder decodeObjectForKey:@"note"];
    self.status = [[coder decodeObjectForKey:@"status"] intValue];
    self.project_id = [[coder decodeObjectForKey:@"project_id"] longValue];
    self.isStoped = [[coder decodeObjectForKey:@"isStoped"] boolValue];
    return self;
}

@end
