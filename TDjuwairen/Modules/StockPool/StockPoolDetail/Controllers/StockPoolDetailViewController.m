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
#import "ShareHandler.h"
#import "MBProgressHUD+Custom.h"
#import "StockPoolCommentViewController.h"
#import "TDCommentPublishViewController.h"
#import "TDStockPoolCommentTableViewDelegate.h"
#import "NSDate+Util.h"

@interface StockPoolDetailViewController ()
<UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, TDCommentPublishDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) StockPoolDetailModel *detailModel;
@property (nonatomic, assign) CGFloat descCellHeight;
@property (nonatomic, assign) CGFloat commentCellHeight;
@property (nonatomic, strong) TDSegmentedControl *segment;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) StockPoolCommentViewController *commentVC;
@property (nonatomic, strong) TDStockPoolCommentTableViewDelegate *commentTableViewDelegate;

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44-64) style:UITableViewStyleGrouped];
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

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setShortWeekdaySymbols:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
    }
    return _formatter;
}

- (StockPoolCommentViewController *)commentVC {
    if (!_commentVC) {
        _commentVC = [[StockPoolCommentViewController alloc] init];
        _commentVC.commentType = kCommentStockPool;
        _commentVC.masterId = self.detailModel.masterId;
    }
    return _commentVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"股票池详情";
    [self setupUI];
    [self queryDetailInfo];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stockPoolRecordChangedNotifi:) name:kStockPoolRecordChangedSuccessed object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStockPoolRecordChangedSuccessed object:nil];
}

- (void)setupUI {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 44-TDPixel, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
    [view addSubview:sep];
    
    self.segment = [[TDSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) witItems:@[@"持仓明细",@"持仓理由",@"评论区"]];
    [self.segment addTarget:self action:@selector(segmentedPressed:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.segment];
    
    [self.segment setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"333333"]}];
    [self.segment setSelectedAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"3371E2"]}];
    [self.view addSubview:view];
    
    [self.view addSubview:self.tableView];
}

- (void)setupNavigation {
    
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
    
    // 只有当天的记录显示编辑按钮
    if ([NSDate isCurrentDayWithDate:self.detailModel.date]) {
         self.navigationItem.rightBarButtonItems = @[message,spacer,master];
    } else {
         self.navigationItem.rightBarButtonItems = @[message];
    }
}

- (void)editPressed:(id)sender {
    if (self.detailModel.isNewRecord == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"股票池最新记录才能编辑，如果您想编辑此记录，您需要删除最新记录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    StockPoolAddAndEditViewController *vc = [[StockPoolAddAndEditViewController alloc] init];
    vc.recordId = self.detailModel.recordId;
    
    TDNavigationController *editNav = [[TDNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:editNav animated:YES completion:nil];
}

- (void)sharePressed:(id)sender {
    
    __weak typeof(self)weakSelf = self;
    [self.formatter setDateFormat:@"MM月dd日"];
    NSString *title = [NSString stringWithFormat:@"%@的股票池记录(%@)",US.userName, [self.formatter stringFromDate:self.detailModel.date]];
    NSString *detail = self.detailModel.desc;
    
    [ShareHandler shareWithTitle:title
                          detail:detail
                           image:nil
                             url:self.detailModel.shareUrl
                   selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 直播分享
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dict = @{@"item_id":SafeValue(weakSelf.detailModel.recordId),
                                   @"item_type": @(1)};
            
            [manager POST:API_StockPoolShare parameters:dict completion:^(NSDictionary *data, NSError *error) {
                if (!error) {
                    [MBProgressHUD showHUDAddedTo:weakSelf.view message:@"分享功能"];
                } else {
                    [MBProgressHUD showHUDAddedTo:weakSelf.view message:@"分享失败"];
                }
            }];
        }
    }  shareState:nil];
}

- (void)startCommentPressed:(id)sender {
    TDCommentPublishViewController *vc = [[TDCommentPublishViewController alloc] init];
    vc.publishType = kCommentPublishStockPool;
    vc.delegate = self;
    vc.masterId = self.detailModel.masterId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentedPressed:(TDSegmentedControl *)segmented {
    if (!self.detailModel) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:segmented.selectedIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    
    [self setupNavigation];
    
    CGSize size = [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
    self.descCellHeight = size.height + 30;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:model.positions.count];
    for (SPEditRecordModel *record in model.positions) {
        [array addObject:[record.stockCode queryStockCode]];
    }
    [self.stockManager addStocks:array];
    
    [self.tableView reloadData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorColor = TDSeparatorColor;
    tableView.separatorInset = UIEdgeInsetsZero;
    self.commentTableViewDelegate = [[TDStockPoolCommentTableViewDelegate alloc] initWithTableView:tableView controller:self];
    self.tableView.tableFooterView = tableView;
    self.commentTableViewDelegate.masterId = model.masterId;
    self.commentTableViewDelegate.contentTableView = self.tableView;
    [self.commentTableViewDelegate refreshData];
}


#pragma mark - Notifi
- (void)stockPoolRecordChangedNotifi:(NSNotification *)notifi {
    NSInteger type = [notifi.object integerValue];
    if (type == 2) {
        [self queryDetailInfo];
    } else if (type == 3) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - TDCommentPublishDelegate
- (void)commentPublishSuccessed {
    [self.commentTableViewDelegate refreshData];
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
        [self.formatter setDateFormat:@"yyyy-MM-dd EEE HH:mm"];
        
        cell.dateLabel.text = [self.formatter stringFromDate:self.detailModel.date];
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
        }
        
        cell.textLabel.text = self.detailModel.desc;
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDetailCommentTableViewCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPDetailCommentTableViewCellID"];
            UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, kScreenWidth-24, 35)];
            view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F8F8F8"];
            view.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#DFDFDF"].CGColor;
            view.layer.borderWidth = 1;
            [view addTarget:self action:@selector(startCommentPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 35)];
            lable.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
            lable.text = @"发表评论…";
            lable.font = [UIFont systemFontOfSize:14.0f];
            [view addSubview:lable];
            [cell.contentView addSubview:view];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
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
        return 55;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
