//
//  SPRManagerViewController.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRBaseViewController.h"

typedef void (^DidFetchedDataCallBack)(void);
@interface SPRProjectListViewController : SPRBaseViewController

@property (nonatomic, copy, nullable) DidFetchedDataCallBack didFetchedDataCallBack;

@end
