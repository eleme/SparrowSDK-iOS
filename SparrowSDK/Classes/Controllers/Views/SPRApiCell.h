//
//  SPRApiCell.h
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/15.
//

#import <UIKit/UIKit.h>

@class SPRApi;

@interface SPRApiCell : UITableViewCell
@property (nonatomic, strong, nonnull) UILabel *methodLabel;
@property (nonatomic, strong, nonnull) UILabel *nameLabel;
@property (nonatomic, strong, nonnull) UILabel *urlLabel;
@property (nonatomic, strong, nonnull) UISwitch *mockSwitch;
@property (nonatomic, strong, nonnull) UIView *lineView;

@property (nonatomic, strong, nonnull) SPRApi *model;

@property (nonatomic, copy, nullable) void (^apiSwitchChanged)(SPRApi *_Nonnull model , BOOL isOn);
@end
