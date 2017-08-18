//
//  StockPoolDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolDetailViewController.h"
#import "SPDetailTableViewCell.h"
#import "SPDetailPositionsTableViewCell.h"
#import "StockPoolDetailModel.h"
#import "NetworkManager.h"
#import "TDSegmentedControl.h"
#import "StockManager.h"
#import "UILabel+StockCode.h"
#import "NSString+Util.h"
#import "StockPoolAddAndEditViewController.h"
#import "TDNavigationController.h"

@interface StockPoolDetailViewController ()
<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) StockPoolDetailModel *detailModel;
@property (nonatomic, assign) CGFloat descCellHeight;
@property (nonatomic, assign) CGFloat commentCellHeight;
@property (nonatomic, strong) TDSegmentedControl *segment;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@end

@implementation StockPoolDetailViewController

- (void)dealloc
{
    [self.stockManager stopThread];
}

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"SPDetailTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"SPDetailTableViewCellID"];
        
        UINib *nib2 = [UINib nibWithNibName:@"SPDetailPositionsTableViewCell" bundle:nil];
        [_tableView registerNib:nib2 forCellReuseIdentifier:@"SPDetailPositionsTableViewCellID"];
    }
    
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    [self queryDetailInfo];
}


- (void)setupNavigation {
    
    self.title = @"股票池详情";
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"sp_edit.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 sizeToFit];
    UIBarButtonItem *master = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"sp_share.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 sizeToFit];
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 15;
    self.navigationItem.rightBarButtonItems = @[message,spacer,master];

    [self.navigationItem.rightBarButtonItems.firstObject setEnabled:NO];
    [self.navigationItem.rightBarButtonItems.lastObject setEnabled:NO];
}

- (void)editPressed:(id)sender {
    StockPoolAddAndEditViewController *vc = [[StockPoolAddAndEditViewController alloc] init];
    vc.recordId = self.detailModel.recordId;
    
    TDNavigationController *editNav = [[TDNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:editNav animated:YES completion:nil];
}

- (void)sharePressed:(id)sender {
    
}

- (void)queryDetailInfo {
    if (self.recordId.length == 0) {
        return;
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_StockPoolGetDetailInfo parameters:@{@"record_id":self.recordId} completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error && data && [data isKindOfClass:[NSDictionary class]]) {
            StockPoolDetailModel *model = [[StockPoolDetailModel alloc] initWithDictionary:data];
            [self reloadViewWithDetailModel:model];
        } else {
            [self reloadViewWithDetailModel:nil];
        }
    }];
}

- (void)reloadViewWithDetailModel:(StockPoolDetailModel *)model {
    self.detailModel = model;
    
    if (!model) {
        return;
    }
    
    [self.navigationItem.rightBarButtonItems.firstObject setEnabled:YES];
    [self.navigationItem.rightBarButtonItems.lastObject setEnabled:YES];
    
    CGSize size = [self.detailModel.desc boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
    self.descCellHeight = size.height + 30;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:model.positions.count];
    for (SPEditRecordModel *record in model.positions) {
        [array addObject:[record.stockCode queryStockCode]];
    }
    [self.stockManager addStocks:array];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 44-TDPixel, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
    [view addSubview:sep];
    
    self.segment = [[TDSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) witItems:@[@"持仓明细",@"持仓理由",@"评论区"]];
    [view addSubview:self.segment];
    
    [self.segment setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"333333"]}];
    [self.segment setSelectedAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"3371E2"]}];
    [self.view addSubview:view];
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    
}


#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    [self.tableView reloadData];
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailModel?4:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.detailModel.positions.count;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SPDetailPositionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailPositionsTableViewCellID"];
        cell.dateLabel.text = self.detailModel.date;
        cell.ratioLabel.text = [NSString stringWithFormat:@"仓位 %@%%",self.detailModel.ratio];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%ld%% 资金",(long)(100- [self.detailModel.ratio integerValue])];
        cell.progressView.progress = [self.detailModel.ratio integerValue]/100.0f;
        
        return cell;
    } else if (indexPath.section == 1) {
        SPDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailTableViewCellID"];
        SPEditRecordModel *model = self.detailModel.positions[indexPath.row];
        cell.recordModel = model;
        
        StockInfo *stock = [self.stockDict objectForKey:[model.stockCode queryStockCode]];
        [cell.stockPriceLabel setupForStockPoolDetailStockInfo:stock];
        
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailTextTableViewCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPDetailTextTableViewCellID"];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = TDTitleTextColor;
            cell.textLabel.text = self.detailModel.desc;
        }
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailTextTableViewCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPDetailTextTableViewCellID"];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 34.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 116.0f;
    } else if (indexPath.section == 1) {
        return 68.0f;
    } else if (indexPath.section == 2) {
        return self.descCellHeight;
    } else if (indexPath.section == 3){
        return self.commentCellHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, 34)];
    view.layer.borderColor = TDSeparatorColor.CGColor;
    view.layer.borderWidth = TDPixel;

    if (section == 0) {
        
    } else if (section == 1) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, 140, 15)];
        label1.font = [UIFont systemFontOfSize:14.0f];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label1.text = @"股票信息";
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(177, 10, 40, 15)];
        label2.font = [UIFont systemFontOfSize:14.0f];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label2.text = @"仓位";
        [view addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth+2-70, 10, 40, 15)];
        label3.font = [UIFont systemFontOfSize:14.0f];
        label3.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label3.text = @"操作";
        [view addSubview:label3];
        
        view.backgroundColor = [UIColor whiteColor];
    } else if (section == 2) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 70, 15)];
        label1.font = [UIFont systemFontOfSize:14.0f];
        label1.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        label1.text = @"持仓理由";
        [view addSubview:label1];
        
        view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
    } else if (section == 3){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 70, 15)];
        label1.font = [UIFont systemFontOfSize:14.0f];
        label1.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        label1.text = @"评论区";
        [view addSubview:label1];
        
        view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end