//
//  ApiListHeaderView.h
//  AFNetworking
//
//  Created by 周凌宇 on 2018/5/22.
//

#import <UIKit/UIKit.h>
#import "SPRApi.h"

@interface ApiListHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^didClickedButtonCallback)(SPRApiStatus status);

@end
