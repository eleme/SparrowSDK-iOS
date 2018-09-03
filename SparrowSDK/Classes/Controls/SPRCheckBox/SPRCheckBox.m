//
//  SPRCheckBox.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/12.
//

#import "SPRCheckBox.h"
#import "SPRCommonData.h"

@implementation SPRCheckBox

- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 7.5;
        self.layer.borderColor = SPRThemeColor.CGColor;
        self.layer.borderWidth = 1;
        [self setCheckedStyle];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    if (checked) {
        [self setCheckedStyle];
    } else {
        [self setUnCheckedStyle];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setCheckedStyle {
    self.backgroundColor = SPRThemeColor;
}

- (void)setUnCheckedStyle {
    self.backgroundColor = [UIColor whiteColor];
}

@end
