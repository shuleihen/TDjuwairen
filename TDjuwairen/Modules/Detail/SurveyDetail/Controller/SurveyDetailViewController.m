
//  SurveyDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailViewController.h"
#import "StockHeaderView.h"
#import "SurveyDetailSegmentView.h"
#import "SurveyDetailWebViewController.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "HexColors.h"
#import "CocoaLumberjack.h"
#import "SurveyDetailCommentViewController.h"
#import "SurveyDetailStockCommentViewController.h"
#import "StockCommentModel.h"
#import "StockManager.h"
#import "UIImage+Color.h"
#import "StockUnlockViewController.h"

@interface SurveyDetailViewController ()<SurveyDetailSegmentDelegate, SurveyDetailContenDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource, StockManagerDelegate>

@property (weak, nonatomic) IBOutlet StockHeaderView *stockHeaderView;
@property (nonatomic, strong) SurveyDetailSegmentView *segment;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, weak) UIViewController *pageWillToController;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, copy) NSString *stockName;
@end

@implementation SurveyDetailViewController

- (void)dealloc {
    [self.stockManager stopThread];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 默认显示热点篇
    self.segment.selectedIndex = 3;
    
    // 添加查询股票
    [self.stockManager addStocks:@[self.stockId]];
    
    // 查询解锁
    [self queryUnlock];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.stockInfo) {
        [self setupStockInfo:self.stockInfo];
    }
    
    [self.stockManager start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.stockManager stop];
}

- (void)queryUnlock {
    // 查询解锁
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSString *code = [self.stockId substringFromIndex:2];
    NSDictionary *para ;
    if (US.isLogIn) {
        para = @{@"code": code,
                 @"user_id": US.userId};
    }
    else
    {
        para = @{@"code": code};
    }
    
    [ma POST:API_QueryDetailUnlock parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            BOOL isLock = [data[@"isLock"] boolValue];
            self.segment.isLock = isLock;
        } else {
            // 查询失败
        }
    }];
}

- (void)unlockStock {
    StockUnlockViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"StockUnlockViewController"];
    vc.stockCode = [self.stockId substringFromIndex:2];
    vc.stockName = self.stockName;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.hidesBottomBarWhenPushed = YES;
    [nav setNavigationBarHidden:YES animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        nav.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    StockInfo *stock = [stocks objectForKey:self.stockId];
    self.stockInfo = stock;
    
    [self setupStockInfo:stock];
}

- (void)setupStockInfo:(StockInfo *)stock {
    [self.stockHeaderView setupStockInfo:stock];
    
    // 修改导航条背景色
    float yestodEndPri = [[NSDecimalNumber decimalNumberWithString:stock.yestodEndPri] floatValue];
    float nowPri = [[NSDecimalNumber decimalNumberWithString:stock.nowPri] floatValue];
    float value = nowPri - yestodEndPri;
    
    UIColor *color = nil;
    if (value >= 0.0) {
        color = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
    } else {
        color = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
    }
    
    [self setupNavigationBarWithColor:color];
    
    self.title = [NSString stringWithFormat:@"%@(%@)",stock.name,stock.gid];
    self.stockName = stock.name;
}

- (void)setupNavigationBarWithColor:(UIColor *)color {
    UIImage *bgImage = [UIImage imageWithSize:CGSizeMake(kScreenWidth, 64) withColor:color];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    UIImage *shadowImage = [UIImage imageWithSize:CGSizeMake(kScreenWidth, 1) withColor:color];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self currentContentViewController] contentHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCellID"];
        [cell.contentView addSubview:self.pageViewController.view];
    }
    
    return cell;
}


#pragma mark - SurveyDetailSegmentDelegate
- (void)didSelectedSegment:(SurveyDetailSegmentView *)segmentView withIndex:(NSInteger)index {
    DDLogInfo(@"Survey detail content selected tag = %ld",(long)index);
    if (index > [self.contentControllers count]) {
        return;
    }
    
    SurveyDetailSegmentItem *item = segmentView.segments[index];
    if (item.locked) {
        [self unlockStock];
    } else {
        SurveyDetailContentViewController *vc = self.contentControllers[index];
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
}

#pragma mark - SurveyDetailContenDelegate
- (void)contentDetailController:(UIViewController *)controller withHeight:(CGFloat)height {
    [self.tableView reloadData];
}


#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger before = (index - 1)%[self.contentControllers count];

    SurveyDetailSegmentItem *item = self.segment.segments[index];
    if (item.locked) {
        return nil;
    } else {
        return self.contentControllers[before];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger after = (index + 1)%[self.contentControllers count];

    SurveyDetailSegmentItem *item = self.segment.segments[index];
    if (item.locked) {
        return nil;
    } else {
        return self.contentControllers[after];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    UIViewController *vc = [pendingViewControllers firstObject];
    self.pageWillToController = vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    if (!finished) {
        return;
    }
    
    if (self.pageWillToController) {
        NSInteger index = [self.contentControllers indexOfObject:self.pageWillToController];
        [self.segment changedSelectedIndex:index executeDelegate:NO];
        [self.tableView reloadData];
    }
    
}

#pragma mark - Private
- (SurveyDetailContentViewController *)currentContentViewController {
    NSInteger index = self.segment.selectedIndex;
    if (index >= 0 && index < [self.contentControllers count]) {
        return self.contentControllers[index];
    } else {
        return nil;
    }
}

#pragma mark - Getter
- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (SurveyDetailSegmentView *)segment {
    if (!_segment) {
        _segment = [[SurveyDetailSegmentView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _segment.delegate = self;
        
        SurveyDetailSegmentItem *shidi = [[SurveyDetailSegmentItem alloc] initWithTitle:@"实地篇"
                                                                                  image:[UIImage imageNamed:@"btn_shidi_nor"]
                                                                       highlightedImage:[UIImage imageNamed:@"btn_shidi_select"]
                                                                   highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#FF9E05"]];
        SurveyDetailSegmentItem *duihua = [[SurveyDetailSegmentItem alloc] initWithTitle:@"对话录"
                                                                                  image:[UIImage imageNamed:@"btn_duihua_nor"]
                                                                       highlightedImage:[UIImage imageNamed:@"btn_duihua_select"]
                                                                    highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#EA4344"]];
        SurveyDetailSegmentItem *niuxiong = [[SurveyDetailSegmentItem alloc] initWithTitle:@"牛熊说"
                                                                                   image:[UIImage imageNamed:@"btn_niuxiong_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_niuxiong_select"]
                                                                      highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#00C9EE"]];
        SurveyDetailSegmentItem *redian = [[SurveyDetailSegmentItem alloc] initWithTitle:@"热点篇"
                                                                                   image:[UIImage imageNamed:@"btn_redian_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_redian_select"]
                                                                    highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#FF875B"]];
        SurveyDetailSegmentItem *chanpin = [[SurveyDetailSegmentItem alloc] initWithTitle:@"产品篇"
                                                                                   image:[UIImage imageNamed:@"btn_chanpin_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_chanpin_select"]
                                                                     highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#43A6F3"]];
        SurveyDetailSegmentItem *wenda = [[SurveyDetailSegmentItem alloc] initWithTitle:@"问答篇"
                                                                                   image:[UIImage imageNamed:@"btn_wenda_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_wenda_select"]
                                                                   highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#26D79F"]];
        _segment.segments = @[shidi,duihua,niuxiong,redian,chanpin,wenda];
        
    }
    
    return _segment;
}

- (NSMutableArray *)contentControllers {
    if (!_contentControllers) {
        _contentControllers = [NSMutableArray arrayWithCapacity:7];
        for (int i=0; i<6; i++) {
            if (i == 2) {
                SurveyDetailStockCommentViewController *niuxiongvc = [[SurveyDetailStockCommentViewController alloc] init];
                niuxiongvc.stockId = self.stockId;
                niuxiongvc.tag = i;
                niuxiongvc.delegate = self;
                [_contentControllers addObject:niuxiongvc];
            } else if (i == 5) {
                SurveyDetailCommentViewController *askvc = [[SurveyDetailCommentViewController alloc] init];
                askvc.stockId = self.stockId;
                askvc.tag = i;
                askvc.delegate = self;
                [_contentControllers addObject:askvc];
            } else {
                SurveyDetailWebViewController *content = [[SurveyDetailWebViewController alloc] init];
                content.stockId = self.stockId;
                content.tag = i;
                content.delegate = self;
                [_contentControllers addObject:content];
            }
        }
    }
    
    return _contentControllers;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;

    }
    return _pageViewController;
}
@end
