//
//  SPRProjectDetailViewController.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRProjectDetailViewController.h"
#import <Masonry/Masonry.h>

@interface SPRProjectDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *blockView;

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SPRProjectDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self blockView];
    [self titleLabel];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Getter Setter

- (UIView *)blockView {
    if (_blockView == nil) {
        _blockView = [[UIView alloc] init];
        _blockView.backgroundColor = [UIColor whiteColor];
        _blockView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
        _blockView.layer.borderWidth = 1;
        _blockView.layer.cornerRadius = 5;
        _blockView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _blockView.layer.shadowOpacity = 0.95f;
        _blockView.layer.shadowOffset = CGSizeMake(1,1);

        [self.view addSubview:_blockView];
        [_blockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-5);
        }];
    }
    return _blockView;
}

- (UITableView *)mainTable {
    if (_mainTable == nil) {
        _mainTable = [[UITableView alloc] init];
        _mainTable.backgroundColor = self.view.backgroundColor;
        _mainTable.rowHeight = 100;
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
    }
    return _mainTable;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        [self.view addSubview:_titleLabel];
        _titleLabel.text = @"标题";
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(5);
            make.left.equalTo(self.view).offset(8);
        }];
    }
    return _titleLabel;
}

@end
