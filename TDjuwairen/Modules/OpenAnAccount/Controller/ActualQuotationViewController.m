//
//  ActualQuotationViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ActualQuotationViewController.h"
#import "MJRefresh.h"
#import "ActualQuotationCell.h"
#import "OpenAnAccountController.h"
#import "PhoneNumViewController.h"
#import "STPopupController.h"
#import "UIViewController+STPopup.h"
#import "NetworkManager.h"
#import "FirmPlatListModel.h"
@interface ActualQuotationViewController ()<UITableViewDelegate,UITableViewDataSource,ActualQuotationCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation ActualQuotationViewController


- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实盘开户";
    
    [self initViews];
    [self initValue];
    
}


- (void)initValue
{
    self.currentPage = 1;
    _listArr = [NSMutableArray new];
    [self refreshActions];
    
}

- (void)initViews
{
   [self.view addSubview:self.tableView];
}

#pragma mark - loadData
- (void)refreshActions {
    self.currentPage = 1;
    [self getFirmAccountListWithPage:_currentPage];
}

- (void)loadMoreActions {
    
    [self getFirmAccountListWithPage:_currentPage];
}


- (void)getFirmAccountListWithPage:(NSInteger)pageNum
{
    if (pageNum == 1) {
        [_listArr removeAllObjects];
    }
    __weak typeof(self)weakSelf = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_FirmAccount_firmPlatList parameters:@{@"page":@(pageNum)} completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *arr = data; 
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FirmPlatListModel *model = [[FirmPlatListModel alloc] initWithDictionary:obj];
                [weakSelf.listArr addObject:model];
            }];
            [weakSelf.tableView reloadData];
            _currentPage++;
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _listArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActualQuotationCell *cell = [ActualQuotationCell loadActualQuotationCellWithTableView:tableView];
    cell.delegate = self;
    cell.firmModel = _listArr[indexPath.row];
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FirmPlatListModel *model = _listArr[indexPath.row];
    OpenAnAccountController *vc = [[OpenAnAccountController alloc] init];
    vc.model = model;
    vc.title = model.plat_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_account"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark - ActualQuotationCellDelegate 
- (void)openAnAccountButtonClickDone:(FirmPlatListModel *)model {

    // 开户
    OpenAnAccountController *vc = [[OpenAnAccountController alloc] init];
    vc.model = model;
    vc.title = model.plat_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)callnNumButtonClickDone:(FirmPlatListModel *)model
{
    PhoneNumViewController *vc = [[PhoneNumViewController alloc] init];
    vc.sourceArr = model.plat_phone;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, [vc getSelfHight]);
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

@end
