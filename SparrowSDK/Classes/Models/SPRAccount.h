//
//  SPRAccount.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/4/9.
//

#import <Foundation/Foundation.h>

@interface SPRAccount : NSObject <NSCoding>
@property (nonatomic, assign) long accountId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *email;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
