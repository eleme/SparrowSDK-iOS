//
//  SPRApiCell.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/15.
//

#import "SPRApiCell.h"
#import "SPRCommonData.h"
#import "SPRApi.h"
#import <Masonry/Masonry.h>

@implementation SPRApiCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self methodLabel];
        [self lineView];
        [self nameLabel];
        [self urlLabel];
        [self mockSwitch];
    }
    return self;
}

#pragma mark - Action

- (void)mockSwitchChanged:(UISwitch *)sender  {
    self.apiSwitchChanged(self.model, sender.on);
}

#pragma mark - Getter Setter

- (void)setModel:(SPRApi *)model {
    _model = model;
    if ([[model.method uppercaseString] isEqualToString:@"GET"]) {
        self.methodLabel.backgroundColor = SPRThemeColor;
        self.methodLabel.text = @"GET";
    } else if ([[model.method uppercaseString] isEqualToString:@"POST"]) {
        self.methodLabel.backgroundColor = [UIColor colorWithHexString:@"4373D5"];
        self.methodLabel.text = @"POST";
    } else if ([[model.method uppercaseString] isEqualToString:@"PUT"]) {
        self.methodLabel.backgroundColor = [UIColor colorWithHexString:@"FADD6E"];
        self.methodLabel.text = @"PUT";
    } else if ([[model.method uppercaseString] isEqualToString:@"DELETE"]) {
        self.methodLabel.backgroundColor = [UIColor colorWithHexString:@"EB4C64"];
        self.methodLabel.text = @"DEL";
    } else if ([[model.method uppercaseString] isEqualToString:@"PATCH"]) {
        self.methodLabel.backgroundColor = [UIColor colorWithHexString:@"6EB9DA"];
        self.methodLabel.text = @"PAT";
    } else {
        self.methodLabel.backgroundColor = [UIColor colorWithHexString:@"6EB9DA"];
        self.methodLabel.text = @"UNK";
    }
    self.nameLabel.text = model.name;
    self.urlLabel.text = [NSString stringWithFormat:@"/%@", model.path];
    self.mockSwitch.on = !model.isStoped;
}

- (UILabel *)methodLabel {
    if (_methodLabel == nil) {
        _methodLabel = [[UILabel alloc] init];
        _methodLabel.textColor = [UIColor whiteColor];
        _methodLabel.backgroundColor = SPRThemeColor;
        _methodLabel.layer.cornerRadius = 5;
        _methodLabel.layer.masksToBounds = YES;
        _methodLabel.font = [UIFont systemFontOfSize:14];
        _methodLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_methodLabel];
        [_methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(25);
            make.width.equalTo(@(40));
            make.height.equalTo(@(25));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _methodLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EEECEC"];
        [self.contentView addSubview:_lineView];

        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@(1));
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _lineView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"4B4B4B"];
        _nameLabel.font = [UIFont systemFontOfSize:12];

        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.methodLabel.mas_right).offset(10);
            make.top.equalTo(self.contentView).offset(6);
        }];
    }
    return _nameLabel;
}

- (UILabel *)urlLabel {
    if (_urlLabel == nil) {
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.textColor = [UIColor colorWithHexString:@"959595"];
        _urlLabel.font = [UIFont systemFontOfSize:12];
        _urlLabel.numberOfLines= 0;

        [self.contentView addSubview:_urlLabel];
        [_urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.mockSwitch.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
    }
    return _urlLabel;
}

- (UISwitch *)mockSwitch {
    if (_mockSwitch == nil) {
        _mockSwitch = [[UISwitch alloc] init];
        _mockSwitch.onTintColor = SPRThemeColor;

        [_mockSwitch addTarget:self action:@selector(mockSwitchChanged:)
              forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_mockSwitch];
        [_mockSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);

            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@(47));
        }];
    }
    return _mockSwitch;
}

@end
