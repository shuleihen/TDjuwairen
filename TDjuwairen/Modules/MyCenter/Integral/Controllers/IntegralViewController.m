//
//  IntegralViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "IntegralViewController.h"
#import "UIImage+Create.h"
#import "TDRechargeViewController.h"
#import "MJRefresh.h"
#import "UIViewController+Loading.h"
#import "IntegralRecordModel.h"
#import "WalletTableViewCell.h"
#import "NetworkManager.h"
#import "IntegralRecordSectionModel.h"
#import "TDWebViewHandler.h"

@interface IntegralViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *keyNumberLabel;
@property (nonatomic, strong) NSDictionary *integralDict;
@end

@implementation IntegralViewController

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
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreAction {
    [self getSurveyWithPage:self.page];
}

- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak IntegralViewController *wself = self;
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    hud.hidesWhenStopped = YES;
    
    if (pageA == 1) {
        [self.navigationController.view addSubview:hud];
        [hud startAnimating];
    }
    
    NSDictionary *dict = @{@"page" : @(pageA)};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_UserGetIntegralList parameters:dict completion:^(id data, NSError *error){
                
        if (pageA == 1) {
            [hud stopAnimating];
            self.tableView.tableHeaderView.hidden = NO;
        }
        
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                
                for (NSDictionary *d in dataArray) {
                    IntegralRecordModel *model = [[IntegralRecordModel alloc] initWithDictionary:d];
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
    
    for (IntegralRecordModel *model in list) {
        IntegralRecordSectionModel *section = self.sections.lastObject;
        IntegralRecordModel *last = section.list.lastObject;
        
        if (last == nil ||
            [last.moth isEqualToString:model.moth] == NO) {
            section = [[IntegralRecordSectionModel alloc] init];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
            [array addObject:model];
            section.list = array;
            section.title = model.moth;
            [self.sections addObject:section];
            
        } else {
            [section.list addObject:model];
        }
        
        if (model.integral > 0) {
            section.allIn += model.integral;
        } else {
            section.allOut -= model.integral;
        }
    }
}



- (void)requestWithKeysNum{
    __weak IntegralViewController *wself = self;
    
    NSDictionary *para = @{@"user_id":US.userId};
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    [ma POST:API_UserGetIntegral parameters:para completion:^(id data, NSError *error){
        if (!error) {
            wself.integralDict = data;
        }
        
        wself.navigationItem.rightBarButtonItem.enabled = YES;
        [wself setupTableHeaderView];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的积分";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"积分说明" style:UIBarButtonItemStylePlain target:self action:@selector(rulePressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.view addSubview:self.tableView];
    [self setupTableHeaderView];
    
    self.sections = [NSMutableArray arrayWithCapacity:10];
    self.sectionTitles = [NSMutableArray arrayWithCapacity:10];
    self.tableView.tableHeaderView.hidden = YES;
    
    [self requestWithKeysNum];
    [self refreshAction];
}

- (void)setupTableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 221)];
    
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(27, 20, kScreenWidth-54, 149)];
    content.layer.cornerRadius = 10.0f;
    content.clipsToBounds = YES;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#2865D1"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"#1BAFE7"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = content.bounds;
    [content.layer addSublayer:gradientLayer];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(25, 19, content.bounds.size.width-50, 18)];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14.0f];
    lable.text = @"当前积分";
    [content addSubview:lable];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, content.bounds.size.width-24, 56)];
    keyLabel.textColor = [UIColor whiteColor];
    keyLabel.textAlignment = NSTextAlignmentCenter;
    keyLabel.font = [UIFont boldSystemFontOfSize:44];
    [content addSubview:keyLabel];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(33, 110, 100, 16)];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:14.0f];
    [content addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(content.bounds.size.width-133, 110, 100, 16)];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = [UIFont systemFontOfSize:14.0f];
    [content addSubview:label2];
    
    if (self.integralDict) {
        keyLabel.text = self.integralDict[@"user_points"];
        
        NSString *all = [NSString stringWithFormat:@"总获取 %@",self.integralDict[@"user_in_points"]];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:all];
        [attr1 setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]} range:NSMakeRange(4, all.length-4)];
        label1.attributedText = attr1;
        
        
        NSString *used = [NSString stringWithFormat:@"总使用 %@",self.integralDict[@"user_out_points"]];
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:used];
        [attr2 setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]} range:NSMakeRange(4, used.length-4)];
        label2.attributedText = attr2;
    }
    
    [view addSubview:content];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 161, kScreenWidth, 60)];
    buttonView.backgroundColor = [UIColor whiteColor];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 15, TDPixel, 30)];
    sep.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#dedede"];
    [buttonView addSubview:sep];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, kScreenWidth/2-TDPixel, 60);
    [button1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#3370E2"] forState:UIControlStateNormal];
    [button1 setTitle:@"赚积分" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    [button1 addTarget:self action:@selector(getIntegralPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kScreenWidth/2+TDPixel, 0, kScreenWidth/2-TDPixel, 60);
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"花积分(敬请期待)"];
    [attri setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                           NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                   range:NSMakeRange(0, 3)];
    [attri setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                           NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                   range:NSMakeRange(3, 6)];
    [button2 setAttributedTitle:attri forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    [buttonView addSubview:button2];
    [view addSubview:buttonView];
    
    self.tableView.tableHeaderView = view;
}

- (void)getIntegralPressed:(id)sender {
    
}

- (void)rulePressed:(id)sender {
    if (self.integralDict) {
        [TDWebViewHandler openURL:self.integralDict[@"points_desc_url"] inNav:self.navigationController];
    }
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    IntegralRecordSectionModel *model = self.sections[section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletTableViewCellID"];
    
    IntegralRecordSectionModel *section = self.sections[indexPath.section];
    IntegralRecordModel *model = section.list[indexPath.row];
    
    cell.titleLabel.text = model.title;
    cell.timeLabel.text = model.time;
    cell.keyLabel.text = [NSString stringWithFormat:@"%+ld",(long)model.integral];
    
    if (model.integral > 0) {
        cell.keyLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF6C00"];
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
    
    IntegralRecordSectionModel *model = self.sections[section];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 80, 16)];
    lable.textColor = TDLightGrayColor;
    lable.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
    lable.text = model.title;
    [view addSubview:lable];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-240-12, 10, 240, 16)];
    lable2.textColor = TDLightGrayColor;
    lable2.textAlignment = NSTextAlignmentRight;
    lable2.font = [UIFont systemFontOfSize:14.0f];
    lable2.text = [NSString stringWithFormat:@"获取:%ld  使用:%ld",model.allIn,model.allOut];
    [view addSubview:lable2];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
