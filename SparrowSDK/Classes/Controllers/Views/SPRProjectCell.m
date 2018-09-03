//
//  SPRProjectCell.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRProjectCell.h"
#import <Masonry/Masonry.h>
#import "SPRProject.h"
#import "SPRCommonData.h"
#import "SPRCheckBox.h"

@implementation SPRProjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self checkBox];
        [self blockView];
    }
    return self;
}

- (void)setModel:(SPRProject *)model {
    _model = model;
    self.titleLabel.text = model.name;
    self.descriptionLabel.text = model.note;
    self.checkBox.checked = model.isSelected;
}

- (void)setIsSelecting:(BOOL)isSelecting {
    if (isSelecting) {
        [self.checkBox mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.width.height.equalTo(@(20));
            make.centerY.equalTo(self.contentView);
        }];
    } else {
        [self.checkBox mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_left);
            make.width.height.equalTo(@(25));
            make.centerY.equalTo(self.contentView);
        }];
    }
}

- (UIView *)blockView {
    if (_blockView == nil) {
        _blockView = [[UIView alloc] init];
        _blockView.backgroundColor = [UIColor whiteColor];
        _blockView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
        _blockView.layer.borderWidth = 1;
        _blockView.layer.cornerRadius = 8;

        _blockView.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        _blockView.layer.shadowOpacity = 0.2f;
        _blockView.layer.shadowOffset = CGSizeMake(0,6);
        _blockView.layer.shadowRadius = 12;

        [_blockView addSubview:[self titleLabel]];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_blockView).offset(8);
            make.left.equalTo(_blockView).offset(15);
        }];

        [_blockView addSubview:[self descriptionLabel]];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.titleLabel);
        }];

        [self.contentView addSubview:_blockView];
        [_blockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.checkBox.mas_right).offset(10);
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    return _blockView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithRed:54/256.0 green:54/256.0 blue:54/256.0 alpha:1];
        _titleLabel.text = @"标题";
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.textColor = [UIColor lightGrayColor];
        _descriptionLabel.text = @"描述";
    }
    return _descriptionLabel;
}

- (SPRCheckBox *)checkBox {
    if (_checkBox == nil) {
        _checkBox = [[SPRCheckBox alloc] init];
        _checkBox.cornerRadius = 10;
        [self.contentView addSubview:_checkBox];
        [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_left);
            make.width.height.equalTo(@(20));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _checkBox;
}

@end
