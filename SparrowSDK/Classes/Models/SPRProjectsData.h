//
//  SPRProjectsData.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/9.
//

#import <Foundation/Foundation.h>

@class SPRProject;
@interface SPRProjectsData : NSObject

@property (nonatomic, strong) NSMutableArray<SPRProject *> *projects;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int limit;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
