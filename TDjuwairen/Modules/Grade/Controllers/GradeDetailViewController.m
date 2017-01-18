//
//  GradeDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeDetailViewController.h"
#import "HexColors.h"
#import "GradeHeaderView.h"
#import "GradeDetailCell.h"
#import "GradeCommentModel.h"
#import "GradeAddViewController.h"
#import "GradeDetailModel.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "NotificationDef.h"

@interface GradeDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GradeHeaderView *headerView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) GradeDetailModel *gradeDetail;

@end

@implementation GradeDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolView];
    
    self.title = @"评级列表";
    
    [self reloadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:kAddStockGradeSuccessed object:nil];
}

- (void)reloadView {
    [self queryGradeTetail];
    [self queryCompanyReview];
}

- (void)queryGradeTetail {
    __weak GradeDetailViewController *wself = self;
    NSDictionary *dict = @{@"code" : self.stockId};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyCompanyGrade parameters:dict completion:^(id data, NSError *error){
        
        if (!error && data) {
            wself.gradeDetail = [[GradeDetailModel alloc] initWithDict:data];
        }
        
        [wself.headerView setupGradeModel:wself.gradeDetail];
        wself.toolView.hidden = wself.gradeDetail.canGrade;
    }];
}

- (void)queryCompanyReview {
    __weak GradeDetailViewController *wself = self;
    NSDictionary *dict = @{@"code" : self.stockId};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyCompanyReview parameters:dict completion:^(id data, NSError *error){
        
        if (!error && data) {
            NSArray *list = data[@"review_list"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[list count]];
            
            for (NSDictionary *dict in list) {
                GradeCommentModel *item = [[GradeCommentModel alloc] initWithDict:dict];
                [array addObject:item];
            }
            
            wself.items = array;
            [wself.tableView reloadData];
        }
    }];
}

- (void)gradePressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    GradeAddViewController *vc = [[GradeAddViewController alloc] init];
    vc.stockName = self.stockName;
    vc.stockId = self.stockId;
    vc.gradeDetail = self.gradeDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 203;
    }
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35.0f)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 40, 20)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    label.text = @"评价";
    [view addSubview:label];
    
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(62, 7, 160, 20)];
    labelB.font = [UIFont systemFontOfSize:14.0f];
    labelB.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    labelB.text = [NSString stringWithFormat:@"已有%lu人评价",(unsigned long)[self.items count]];
    [view addSubview:labelB];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeHeaderCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradeHeaderCellID"];
            [cell.contentView addSubview:self.headerView];
        }
        return cell;
    } else {
        GradeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeDetailCellID"];
        
        GradeCommentModel *model = self.items[indexPath.row];
        [cell setupCommentModel:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-55) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120.0f;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        UINib *nib = [UINib nibWithNibName:@"GradeDetailCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"GradeDetailCellID"];
    }
    return _tableView;
}

- (GradeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[GradeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 204)];
    }
    return _headerView;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-55, kScreenWidth, 55)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"我要评分" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.frame = CGRectMake(12, 12, kScreenWidth-24, 34);
        btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        [btn addTarget:self action:@selector(gradePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        sep.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
        [_toolView addSubview:sep];
        
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}

@end
