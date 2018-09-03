//
//  SPRManagerViewController.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRProjectListViewController.h"
#import "SPRProjectCell.h"
#import "SPRProjectDetailViewController.h"
#import "SPRProject.h"
#import "SPRHTTPSessionManager.h"
#import "SPRProjectsData.h"
#import "SPRApi.h"
#import "SPRCacheManager.h"

@interface SPRProjectListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SPRProjectsData *projectsData;
@property (nonatomic, assign) BOOL isSelecting;

@property (nonatomic, strong) NSMutableSet *seletedProjects;
@end

@implementation SPRProjectListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选择项目";
    [self setRightBarWithTitle:@"选择" action:@selector(startSelect)];

    [self.view addSubview:[self tableView]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];

    [self fetchProjects];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kSPRnotificationLoginSuccess
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)startSelect {
    self.isSelecting = !self.isSelecting;
    NSString *text = @"";
    if (self.isSelecting) {
        text = @"完成";
    } else {
        text = @"选择";
        // 拉取 API
        if (self.seletedProjects.count > 0) {
            [self fetchApis];
        }
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:text
                                                                              style:UIBarButtonItemStyleDone target:self
                                                                             action:@selector(startSelect)];
    [self.tableView reloadData];
}

- (void)fetchProjects {
    __weak __typeof(self)weakSelf = self;

    [self showHUD];
    [SPRHTTPSessionManager GET:@"/frontend/project/list"
                    parameters:@{@"current_page": @(self.projectsData.currentPage + 1), @"limit": @(self.projectsData.limit)}
                       success:^(NSURLSessionDataTask *task, SPRResponse *response) {
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           if (strongSelf) {
                               [strongSelf dismissHUD];
                               SPRProjectsData *newPorjectsData = [[SPRProjectsData alloc] initWithDict:response.data];
                               if (newPorjectsData == nil || newPorjectsData.projects == nil) {
                                   strongSelf.projectsData.currentPage = 0;
                                   [strongSelf.tableView reloadData];
                                   return;
                               }
                               [strongSelf.projectsData.projects addObjectsFromArray:newPorjectsData.projects];

                               NSSet<SPRProject *> *seletedProjectsFromCache = [SPRCacheManager getProjectsFromCache];
                               for (SPRProject *seletedProject in seletedProjectsFromCache) {
                                   for (SPRProject *project in newPorjectsData.projects) {
                                       if (project.project_id == seletedProject.project_id) {
                                           project.isSelected = YES;
                                           [strongSelf.seletedProjects addObject:project];
                                       }
                                   }
                               }

                               strongSelf.projectsData.currentPage = newPorjectsData.currentPage;
                               [strongSelf.tableView reloadData];
                           }
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           SPRLog(@"%@", error);
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           if (strongSelf) {
                               [strongSelf dismissHUD];
                               [SPRToast showWithMessage:error.domain from:strongSelf.view];
                           }
                       }];
}

- (void)refreshProjects {
    [self fetchProjects];
}

- (void)fetchApis {
    __weak __typeof(self)weakSelf = self;

    NSMutableArray *projectIds = [NSMutableArray array];
    for (SPRProject *project in self.seletedProjects) {
        [projectIds addObject:@(project.project_id)];
    }
    [self showHUD];
    [SPRHTTPSessionManager GET:@"/frontend/api/fetch"
      parameters:@{@"project_id": projectIds}
         success:^(NSURLSessionDataTask *task, SPRResponse *response) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
             if (strongSelf) {
                 [strongSelf dismissHUD];
                 NSMutableArray *apis = [SPRApi apisWithDictArray:response.data];
                 if (apis.count != 0) {
                     [SPRCacheManager cacheProjects:[NSSet setWithSet:strongSelf.seletedProjects]];
                     [SPRCacheManager cacheApis:apis];
                 }
                 [strongSelf.navigationController popViewControllerAnimated:YES];
                 strongSelf.didFetchedDataCallBack();
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             SPRLog(@"%@", error);
             __strong __typeof(weakSelf)strongSelf = weakSelf;
             if (strongSelf) {
                 [strongSelf dismissHUD];
                 [SPRToast showWithMessage:@"拉取 API 失败" from:strongSelf.view];
             }
         }];
}

#pragma mark - Action

- (void)loginSuccess:(NSNotification *)notification {
    [self refreshProjects];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelecting == NO) {
        return;
    }
    SPRProject *project = self.projectsData.projects[indexPath.row];
    project.isSelected = !project.isSelected;
    if (project.isSelected) {
        [self.seletedProjects addObject:project];
    } else {
        [self.seletedProjects removeObject:project];
    }

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projectsData.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPRProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SPRProjectCell"];
    if (cell == nil) {
        cell = [[SPRProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPRProjectCell"];
        cell.backgroundColor = self.view.backgroundColor;
    }
    SPRProject *model = self.projectsData.projects[indexPath.row];
    cell.model = model;
    cell.isSelecting = self.isSelecting;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.backgroundColor = SPRThemeColor;
    [button setTitle:@"加载更多" forState:UIControlStateNormal];
    [button setTitle:@"已加载全部" forState:UIControlStateDisabled];
    [footer addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer);
        make.centerY.equalTo(footer);
        make.height.equalTo(@(30));
        make.width.equalTo(@(100));
    }];
    [button addTarget:self action:@selector(fetchProjects) forControlEvents:UIControlEventTouchUpInside];

    BOOL result = (self.projectsData.currentPage - 1) * self.projectsData.limit < self.projectsData.total;
    button.enabled = result;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 45;
}

#pragma mark - Getter Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SPRProjectsData *)projectsData {
    if (_projectsData == nil) {
        _projectsData = [[SPRProjectsData alloc] init];
        _projectsData.currentPage = 0;
        _projectsData.limit = 10;
        _projectsData.total = 10;
        _projectsData.projects = [NSMutableArray array];
    }
    return _projectsData;
}

- (NSMutableSet *)seletedProjects {
    if (_seletedProjects == nil) {
        _seletedProjects = [NSMutableSet set];
    }
    return _seletedProjects;
}
@end
