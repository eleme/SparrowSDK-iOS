//
//  SPRCacheManager.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/12.
//

#import "SPRCacheManager.h"
#import "SPRApi.h"
#import "SPRCommonData.h"
#import "SPRAccount.h"

static char *QueueName = "com.zhoulingyu.sparrow.queue";
@interface SPRCacheManager () {
    dispatch_queue_t _queue;
}

@end

@implementation SPRCacheManager

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create(QueueName, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSArray *)apis {
    if (_apis == nil) {
        _apis = [SPRCacheManager getApisFromCache];
    }
    return _apis;
}

+ (instancetype)sharedInstance {
    static SPRCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SPRCacheManager alloc] init];
    });
    return instance;
}

+ (void)load {
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
                            firstObject]
                           stringByAppendingString:@"/com.zhoulingyu.sparrow"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheDir]) {
        [fileManager createDirectoryAtPath:cacheDir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}

+ (NSString *)cacheDir {
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
                            firstObject]
                           stringByAppendingString:@"/com.zhoulingyu.sparrow"];
    return cacheDir;
}

#pragma mark - Apis

+ (void)cacheApis:(NSArray<SPRApi *> *)apis {
    [[SPRCacheManager sharedInstance] cacheApis:apis];
}

- (void)cacheApis:(NSArray<SPRApi *> *)apis {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:apis];
            BOOL result = [data writeToFile:[SPRCacheManager apisPath] atomically:YES];

            if (result == NO) {
                SPRLog(@"Caching API failed");
                return;
            }
            strongSelf.apis = apis;
        }
    });

}

+ (NSArray<SPRApi *> *)getApisFromCache {
    __block NSArray<SPRApi *> *block_apis = [NSArray array];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[SPRCacheManager sharedInstance] getApisFromCache:^(NSArray<SPRApi *> *apis) {
        block_apis = apis;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return block_apis;
}

- (void)getApisFromCache:(void (^)(NSArray<SPRApi *> *apis))callback {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [[NSData alloc]initWithContentsOfFile:[SPRCacheManager apisPath]];
            NSArray<SPRApi *> *apis =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
            callback(apis);
        }
    });
}

+ (void)clearApisFromCache {
    [[self sharedInstance] clearApisFromCache];
}

- (void)clearApisFromCache {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSFileManager *fileMger = [NSFileManager defaultManager];
            NSString *path = [SPRCacheManager apisPath];

            BOOL exist = [fileMger fileExistsAtPath:path];
            if (exist) {
                NSError *err;
                [fileMger removeItemAtPath:path error:&err];
                if (err) {
                    SPRLog(@"Delete projects cache failed");
                } else {
                    strongSelf.apis = nil;
                }
            }
        }
    });
}

#pragma mark - Projects

+ (void)cacheProjects:(NSSet<SPRProject *> *)projects {
    [[SPRCacheManager sharedInstance] cacheProjects:projects];
}

- (void)cacheProjects:(NSSet<SPRProject *> *)projects {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:projects];
            BOOL result = [data writeToFile:[SPRCacheManager projectsPath] atomically:YES];

            if (result == NO) {
                SPRLog(@"Caching API failed");
                return;
            }
            strongSelf.projects = projects;
        }
    });
}

+ (NSSet<SPRProject *> *)getProjectsFromCache {
    __block NSSet<SPRProject *> *block_projects = [NSSet set];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[SPRCacheManager sharedInstance] getProjectsFromCache:^(NSSet<SPRProject *> *projects) {
        block_projects = projects;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return block_projects;
}

- (void)getProjectsFromCache:(void (^)(NSSet<SPRProject *> *projects))callback {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [[NSData alloc]initWithContentsOfFile:[SPRCacheManager projectsPath]];
            NSSet<SPRProject *> *projects =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
            callback(projects);
        }
    });
}

+ (void)clearProjectsFromCache {
    [[SPRCacheManager sharedInstance] clearProjectsFromCache];
}

- (void)clearProjectsFromCache {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSFileManager *fileMger = [NSFileManager defaultManager];
            NSString *path = [SPRCacheManager projectsPath];

            BOOL exist = [fileMger fileExistsAtPath:path];
            if (exist) {
                NSError *err;
                [fileMger removeItemAtPath:path error:&err];
                if (err) {
                    SPRLog(@"Delete Projects cache failed");
                } else {
                    strongSelf.projects = nil;
                }
            }
        }
    });
}

#pragma mark - Account

+ (void)cacheAccount:(SPRAccount *)account {
    [[SPRCacheManager sharedInstance] cacheAccount:account];
}

- (void)cacheAccount:(SPRAccount *)account {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
            BOOL result = [data writeToFile:[SPRCacheManager accountPath] atomically:YES];

            if (result == NO) {
                SPRLog(@"Caching Account failed");
                return;
            }
            strongSelf.account = account;
        }
    });
}

+ (SPRAccount *)getAccountFromCache {
    __block SPRAccount *block_account = [SPRAccount new];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[SPRCacheManager sharedInstance] getAccountFromCache:^(SPRAccount *account) {
        block_account = account;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return block_account;
}

- (void)getAccountFromCache:(void (^)(SPRAccount *account))callback {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [[NSData alloc]initWithContentsOfFile:[SPRCacheManager accountPath]];
            SPRAccount *account =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
            callback(account);
        }
    });
}

+ (void)clearAccountFromCache {
    [[SPRCacheManager sharedInstance] clearAccountFromCache];
}

- (void)clearAccountFromCache {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSFileManager *fileMger = [NSFileManager defaultManager];
            NSString *path = [SPRCacheManager accountPath];

            BOOL exist = [fileMger fileExistsAtPath:path];
            if (exist) {
                NSError *err;
                [fileMger removeItemAtPath:path error:&err];
                if (err) {
                    SPRLog(@"Delete Projects cache failed");
                } else {
                    strongSelf.projects = nil;
                }
            }
        }
    });
}

+ (void)clearAllCache {
    [self clearAccountFromCache];
    [self clearApisFromCache];
    [self clearProjectsFromCache];
    [self clearFloatingBallCoordinate];
}

#pragma mark - Coordinate

+ (void)cacheFloatingBallCoordinate:(CGPoint)offset {
    [[self sharedInstance] cacheFloatingBallCoordinate:offset];
}

- (void)cacheFloatingBallCoordinate:(CGPoint)offset {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSDictionary *dic = @{@"x": @(offset.x), @"y": @(offset.y)};
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
            BOOL result = [data writeToFile:[SPRCacheManager floatingBallCoordinate] atomically:YES];

            if (result == NO) {
                SPRLog(@"Caching floatingBall coordinate failed");
                return;
            }
            strongSelf.floatingBallCoordinate = offset;
        }
    });
}

+ (CGPoint)getFloatingBallCoordinate {
    __block CGPoint block_coordinate = CGPointZero;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[SPRCacheManager sharedInstance] getFloatingBallCoordinate:^(CGPoint coordinate) {
        block_coordinate = coordinate;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return block_coordinate;
}

- (void)getFloatingBallCoordinate:(void (^)(CGPoint coordinate))callback {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [[NSData alloc]initWithContentsOfFile:[SPRCacheManager floatingBallCoordinate]];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            CGFloat x = [dic[@"x"] floatValue];
            CGFloat y = [dic[@"y"] floatValue];
            callback(CGPointMake(x, y));
        }
    });
}

+ (void)clearFloatingBallCoordinate {
    [[self sharedInstance] clearFloatingBallCoordinate];
}

- (void)clearFloatingBallCoordinate {
    __weak __typeof(self)weakSelf = self;
    dispatch_sync(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            NSFileManager *fileMger = [NSFileManager defaultManager];
            NSString *path = [SPRCacheManager floatingBallCoordinate];

            BOOL exist = [fileMger fileExistsAtPath:path];
            if (exist) {
                NSError *err;
                [fileMger removeItemAtPath:path error:&err];
                if (err) {
                    SPRLog(@"Delete floating ball coordinate cache failed");
                } else {
                    strongSelf.floatingBallCoordinate = CGPointZero;
                }
            }
        }
    });
}


#pragma mark - Path

+ (NSString *)apisPath {
    return [[self cacheDir] stringByAppendingString:@"/apis"];
}

+ (NSString *)projectsPath {
    return [[self cacheDir] stringByAppendingString:@"/projects"];
}

+ (NSString *)accountPath {
    return [[self cacheDir] stringByAppendingString:@"/account"];
}

+ (NSString *)floatingBallCoordinate {
    return [[self cacheDir] stringByAppendingString:@"/floating_ball_coordinate"];
}

@end
