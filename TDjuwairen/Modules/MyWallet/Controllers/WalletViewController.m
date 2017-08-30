//
//  WalletViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "WalletViewController.h"
#import "UIImage+Create.h"
#import "TDRechargeViewController.h"
#import "MJRefresh.h"
#import "UIViewController+Loading.h"
#import "WalletRecordModel.h"
#import "WalletTableViewCell.h"
#import "NetworkManager.h"
#import "NotificationDef.h"

@interface WalletViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *keyNumberLabel;
@end

@implementation WalletViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 76.0f;
        
        UINib *nib = [UINib nibWithNibName:@"WalletTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"WalletTableViewCellID"];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    return _tableView;
}


- (void)refreshAction {
    self.page = 1;
    [self.sections removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreAction {
    [self getSurveyWithPage:self.page];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak WalletViewController *wself = self;
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    hud.hidesWhenStopped = YES;
    
    if (pageA == 1) {
        [self.navigationController.view addSubview:hud];
        [hud startAnimating];
    }
    
    NSDictionary *dict = @{@"page" : @(pageA)};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_UserGetKeyRecordList parameters:dict completion:^(id data, NSError *error){

        if (pageA == 1) {
            [hud stopAnimating];
            self.tableView.tableHeaderView.hidden = NO;
        }
        
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                
                for (NSDictionary *d in dataArray) {
                    WalletRecordModel *model = [[WalletRecordModel alloc] initWithDictionary:d];
                    [list addObject:model];
                }
                
                [wself reloadWithRecordList:list];
                
                wself.page++;
            }
        }
        
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView reloadData];
    }];
}

- (void)reloadWithRecordList:(NSArray *)list {

    for (WalletRecordModel *model in list) {
        NSMutableArray *section = self.sections.lastObject;
        WalletRecordModel *last = section.lastObject;
        
        if (last == nil ||
            [last.moth isEqualToString:model.moth] == NO) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
            [array addObject:model];
            [self.sections addObject:array];
            [self.sectionTitles addObject:model.moth];
        } else {
            [section addObject:model];
        }
    }
}


- (void)requestWithKeysNum{
    __weak WalletViewController *wself = self;
    
    NSDictionary *para = @{@"user_id":US.userId};
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSInteger keyNumber = [data[@"keyNum"] integerValue];
            wself.keyNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)keyNumber];
        }
        else
        {
            wself.keyNumberLabel.text = @"0";
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";
    
    [self.view addSubview:self.tableView];
    [self setupTableHeaderView];
    
    self.sections = [NSMutableArray arrayWithCapacity:10];
    self.sectionTitles = [NSMutableArray arrayWithCapacity:10];
    self.tableView.tableHeaderView.hidden = YES;
    
    [self requestWithKeysNum];
    [self refreshAction];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeNotifi:) name:kRechargeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRechargeNotification object:nil];
}

- (void)setupTableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 161)];
    
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(27, 20, kScreenWidth-54, 149)];
    content.layer.cornerRadius = 10.0f;
    content.clipsToBounds = YES;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#2865D1"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#1BAFE7"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = content.bounds;
    [content.layer addSublayer:gradientLayer];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 80, 18)];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:14.0f];
    lable.text = @"我的余额";
    [content addSubview:lable];
    
    UIImageView *key = [[UIImageView alloc] initWithFrame:CGRectMake(15, 97, 28, 30)];
    [content addSubview:key];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 75, 100, 56)];
    keyLabel.textColor = [UIColor whiteColor];
    keyLabel.font = [UIFont boldSystemFontOfSize:40];
    [content addSubview:keyLabel];
    self.keyNumberLabel = keyLabel;
    
    UIImage *image = [UIImage imageWithSize:CGSizeMake(80, 27) backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#C4FFD9"] borderColor:[UIColor hx_colorWithHexRGBAString:@"#C4FFD9"] cornerRadius:13.5];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth-54-80-20, 34, 80, 27);
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#18853F"] forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setTitle:@"充值" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rechargePressed:) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:btn];
    
    [view addSubview:content];
    self.tableView.tableHeaderView = view;
}

- (void)rechargeNotifi:(NSNotification *)notifi {
    [self requestWithKeysNum];
    [self refreshAction];
}

- (void)rechargePressed:(id)sender {
    TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.sections[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletTableViewCellID"];
    
    NSArray *array = self.sections[indexPath.section];
    WalletRecordModel *model = array[indexPath.row];
    
    cell.titleLabel.text = model.title;
    cell.timeLabel.text = model.time;
    cell.keyLabel.text = [NSString stringWithFormat:@"%+ld",(long)model.key];
    
    if (model.key > 0) {
        cell.keyLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#18853F"];
    } else {
        cell.keyLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 80, 16)];
    lable.textColor = TDLightGrayColor;
    lable.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
    lable.text = self.sectionTitles[section];
    [view addSubview:lable];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
