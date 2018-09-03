//
//  SPRCacheManager.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SPRApi;
@class SPRProject;
@class SPRAccount;
@interface SPRCacheManager : NSObject

@property (nonatomic, strong) NSArray<SPRApi *> *apis;
@property (nonatomic, strong) NSSet<SPRProject *> *projects;
@property (nonatomic, strong) SPRAccount *account;
@property (nonatomic, assign) CGPoint floatingBallCoordinate;

+ (instancetype)sharedInstance;

+ (void)cacheApis:(NSArray<SPRApi *> *)apis;
+ (NSArray<SPRApi *> *)getApisFromCache;
+ (void)clearApisFromCache;

+ (void)cacheProjects:(NSSet<SPRProject *> *)projects;
+ (NSSet<SPRProject *> *)getProjectsFromCache;
+ (void)clearProjectsFromCache;

+ (void)cacheAccount:(SPRAccount *)account;
+ (SPRAccount *)getAccountFromCache;
+ (void)clearAccountFromCache;

+ (void)cacheFloatingBallCoordinate:(CGPoint)coordinate;
+ (CGPoint)getFloatingBallCoordinate;
+ (void)clearFloatingBallCoordinate;

+ (void)clearAllCache;

@end
