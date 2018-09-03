//
//  ApiListHeaderView.m
//  AFNetworking
//
//  Created by 周凌宇 on 2018/5/22.
//

#import "ApiListHeaderView.h"
#import "UIColor+SPRAddtion.h"
#import <Masonry/Masonry.h>

@interface ApiListHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ApiListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self titleLabel];
        [self button];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self titleLabel];
        [self button];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)button {
    if (self.didClickedButtonCallback) {
        SPRApiStatus status = button.isSelected ? SPRApiStatusMock : SPRApiStatusDisabled;
        self.didClickedButtonCallback(status);
    }
    button.selected = !button.isSelected;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithHexString:@"545454"];
        _titleLabel.text = @"API List";
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _titleLabel;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"打开全部" forState:UIControlStateSelected];
        [_button setTitle:@"关闭全部" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithHexString:@"545454"] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_button];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _button;
}

@end
