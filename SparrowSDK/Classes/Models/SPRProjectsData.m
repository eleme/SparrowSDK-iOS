//
//  SPRProjectsData.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/9.
//

#import "SPRProjectsData.h"
#import "SPRProject.h"

@implementation SPRProjectsData

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        return nil;
    }
    if (self = [super init]) {
        _currentPage = [dict[@"current_page"] intValue];
        _total = [dict[@"total"] intValue];
        _limit = [dict[@"limit"] intValue];
        NSArray<NSDictionary *> *array = dict[@"projects"];
        _projects = [self projectsWithDictArray:array];
    }
    return self;
}

- (NSMutableArray<SPRProject *> *)projectsWithDictArray:(NSArray<NSDictionary *> *)array {
    NSMutableArray<SPRProject *> *projects = [NSMutableArray array];
    for (NSDictionary *projectDict in array) {
        SPRProject *project = [[SPRProject alloc] initWithDict:projectDict];
        if (project != nil) {
            [projects addObject:project];
        }
    }
    return projects;
}

@end
