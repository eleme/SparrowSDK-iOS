//
//  SPRResponse.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/5/2.
//

#import "SPRResponse.h"

NSString *const kSPRResponseCode = @"code";
NSString *const kSPRResponseData = @"data";
NSString *const kSPRResponseMessage = @"message";

@interface SPRResponse ()
@end
@implementation SPRResponse

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kSPRResponseCode] isKindOfClass:[NSNull class]]){
        self.code = [dictionary[kSPRResponseCode] integerValue];
    }

    if(![dictionary[kSPRResponseData] isKindOfClass:[NSNull class]]){
        self.data = dictionary[kSPRResponseData];
    }

    if(![dictionary[kSPRResponseMessage] isKindOfClass:[NSNull class]]){
        self.message = dictionary[kSPRResponseMessage];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kSPRResponseCode] = @(self.code);
    if(self.data != nil){
        dictionary[kSPRResponseData] = [self.data toDictionary];
    }
    if(self.message != nil){
        dictionary[kSPRResponseMessage] = self.message;
    }
    return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.code) forKey:kSPRResponseCode];    if(self.data != nil){
        [aCoder encodeObject:self.data forKey:kSPRResponseData];
    }
    if(self.message != nil){
        [aCoder encodeObject:self.message forKey:kSPRResponseMessage];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.code = [[aDecoder decodeObjectForKey:kSPRResponseCode] integerValue];
    self.data = [aDecoder decodeObjectForKey:kSPRResponseData];
    self.message = [aDecoder decodeObjectForKey:kSPRResponseMessage];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    SPRResponse *copy = [SPRResponse new];

    copy.code = self.code;
    copy.data = [self.data copy];
    copy.message = [self.message copy];

    return copy;
}
@end
