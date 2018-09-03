//
//  SPRResponse.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/5/2.
//

#import <Foundation/Foundation.h>

@interface SPRResponse : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString * message;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
