//
//  PlayIndividualStockViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualStockViewController.h"
#import "UIViewController+Login.h"
#import "LoginState.h"
#import "MyWalletViewController.h"
#import "MyGuessViewController.h"
#import "TDWebViewController.h"
#import "PushMessageViewController.h"
#import "HMSegmentedControl.h"
#import "PlayIndividualStockContentViewController.h"
#import "NetworkManager.h"
#import "PlayGuessIndividua.h"
#import "PlayListModel.h"
#import "PlayGuessViewController.h"
#import "STPopupController.h"
#import "UIViewController+STPopup.h"
#import "MJRefresh.h"
#import "StockManager.h"
#import "MBProgressHUD.h"

@interface PlayIndividualStockViewController ()<UIScrollViewDelegate,PlayGuessViewControllerDelegate,StockManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *keyNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) NSArray *contentControllers;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) PlayGuessIndividua *guessModel;
@property (nonatomic, strong) PlayListModel *guessListModel;
@property (nonatomic, strong) NSMutableArray *listModelArr;
@property (nonatomic, strong) UISegmentedControl *timeControl;
@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutH;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (nonatomic, strong) StockManager *stockManager;



@end

@implementation PlayIndividualStockViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.stockManager stopThread];
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] init];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                                        NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#FD9E0A"]};
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor hx_colorWithHexRGBAString:@"#FD9E0A"];
        _segmentControl.sectionTitles = @[@"最新",@"最热"];
        self.segmentControl.frame = CGRectMake(0, 6, 100, 36);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (UISegmentedControl *)timeControl
{
    if (!_timeControl) {
        _timeControl = [[UISegmentedControl alloc] initWithItems:@[@"上午场",@"下午场"]];
        _timeControl.frame = CGRectMake(kScreenWidth-12-110, 7, 110, 28);
        _timeControl.tintColor = [UIColor hx_colorWithHexRGBAString:@"#191a1f"];
        _timeControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor hx_colorWithHexRGBAString:@"#101114"], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_timeControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_timeControl setTitleTextAttributes:dic2 forState:UIControlStateSelected];
        
        _timeControl.selectedSegmentIndex = 0;
        [_timeControl addTarget:self action:@selector(switchingView) forControlEvents:UIControlEventValueChanged];
        _timeIndex = 1;
        
        _timeControl.layer.borderWidth = 2;
        _timeControl.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"].CGColor;
        
    }
    return _timeControl;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        PlayIndividualStockContentViewController *one = [[PlayIndividualStockContentViewController alloc] init];
        one.view.frame = CGRectMake(0, 0, kScreenWidth, 0);
        one.superVC = self;
        
        PlayIndividualStockContentViewController *two = [[PlayIndividualStockContentViewController alloc] init];
        two.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 0);
        two.superVC = self;
        _contentControllers = @[one,two];
    }
    
    return _contentControllers;
}

- (UIScrollView *)pageScrollView {
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _pageScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.backgroundColor = [UIColor clearColor];
        _pageScrollView.bounces = NO;
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.userInteractionEnabled = YES;
        for (PlayIndividualStockContentViewController *vc in self.contentControllers) {
            vc.view.userInteractionEnabled = YES;
            [_pageScrollView addSubview:vc.view];
        }
        
        _pageScrollView.delegate = self;
        
    }
    return _pageScrollView;
}


- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    _currentIndex =1;
    
    [self.pageScrollView setContentOffset:CGPointMake(kScreenWidth*pageIndex, 0) animated:YES];
    
    [self guessSourceListWith:pageIndex season:_timeIndex pageNum:_currentIndex];
}

- (void)configTableViewHeightWithHeight:(CGFloat)height {

    self.pageScrollView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 1;
    _timeIndex = 1;
    self.pageIndex = 0;
    [self initViews];
    [self initValue];
    
    [self.tableView.mj_header beginRefreshing];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChanged:) name:kGuessCommentChanged object:nil];
    
}

- (void)initValue
{
    // 开启股票刷新
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.interval = 10;
    self.stockManager.delegate = self;
    [self loadFistViewMessage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshKeyNum) name:@"refreshGuessHome" object:nil];
}

- (void)refreshKeyNum
{
    [_keyNum setTitle:[NSString stringWithFormat:@"%d",(int)([_guessModel.user_keynum integerValue]-1)] forState:UIControlStateNormal];
}

- (void)initViews
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)onRefresh
{
    _currentIndex = 1;
    [self guessSourceListWith:self.pageIndex season:_timeIndex pageNum:_currentIndex];
}

- (void)loadMore
{
    _currentIndex++;
    [self guessSourceListWith:self.pageIndex season:_timeIndex pageNum:_currentIndex];
}
- (void)switchingView
{
    _timeIndex = _timeControl.selectedSegmentIndex+1;
    _currentIndex = 1;
    switch (_timeControl.selectedSegmentIndex) {
        case 0: {
            [self guessSourceListWith:self.pageIndex season:_timeIndex pageNum:_currentIndex];
        }
            break;
        case 1: {
            [self guessSourceListWith:self.pageIndex season:_timeIndex pageNum:_currentIndex];
        }
            break;
    }
}


#pragma mark - 获取首页信息
- (void)loadFistViewMessage{

    NetworkManager *ma = [[NetworkManager alloc] init];
    
    __weak PlayIndividualStockViewController *wself = self;
    [ma GET:API_GetGuessIndividual parameters:nil completion:^(id data, NSError *error) {
        if (!error) {
            wself.guessModel = [[PlayGuessIndividua alloc] initWithDictionary:data];
            [wself.keyNum setTitle:[NSString stringWithFormat:@"%@",wself.guessModel.user_keynum] forState:UIControlStateNormal];
            wself.timeLabel.text = SafeValue(wself.guessModel.guess_date);
            [wself.bottomButton setTitle:[NSString stringWithFormat:@"评论(%@)",wself.guessModel.guess_comment_count] forState:UIControlStateNormal];
            
        }
    }];
}


#pragma mark - 竞猜列表
- (void)guessSourceListWith:(NSInteger)tag season:(NSInteger)season pageNum:(NSInteger)page
{
    /**
     名称	类型	说明	是否必填	示例	默认值
     season	int	1表示上午场，2表示下午场	是
     tag	int	0表示按时间倒序，1表示按参与人数倒序	是
     page	int	当前页码，从1开始	是
     */
    NetworkManager *ma = [[NetworkManager alloc] init];
    __weak PlayIndividualStockViewController *wself = self;
    NSDictionary *parmark = @{
                              @"season":@(season),
                              @"tag":@(tag),
                              @"page":@(page),
                              };
    if (page==1) {
        _listModelArr = [NSMutableArray new];
    }
    [ma GET:API_GetGuessIndividualList parameters:parmark completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *arr = data;
           __block NSMutableArray *stockIds = [NSMutableArray new];
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              PlayListModel *model = [[PlayListModel alloc] initWithDictionary:obj];
                [wself.listModelArr addObject:model];
                [stockIds addObject:model.stock];
            }];
            
            PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
            vc.listArr = wself.listModelArr.mutableCopy;
            vc.guessModel = _guessModel;
            [wself configTableViewHeightWithHeight:vc.view.frame.size.height];
            
            [wself.stockManager addStocks:stockIds];
            

        }
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    }];
}


- (void)reloadWithStocks:(NSDictionary *)stocks
{
    PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
    vc.stockInfo = stocks;
}

#pragma mark - Action
- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
    } else {
        MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
        [self.navigationController pushViewController:myWallet animated:YES];
    }
}

/// 我的竞猜
- (IBAction)myGuessPressed:(id)sender {
    
    if (!US.isLogIn) {
        [self pushLoginViewController];
    } else {
        MyGuessViewController *vc = [[MyGuessViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.guessListType = MyGuessIndividualListType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (IBAction)startGuessPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    PlayGuessViewController *vc = [[PlayGuessViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, kScreenWidth, 275);
    vc.guess_date = _guessModel.guess_date;
    vc.season = _timeIndex;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, 275);
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (IBAction)rulePressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/index.php/Game/guessRule?guess_name=individual&device=ios"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)commentPressed:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentPressed:(HMSegmentedControl *)sender {
    self.pageIndex = sender.selectedSegmentIndex;
}


- (void)commentChanged:(id)sender {
    [self loadFistViewMessage];
}

#pragma mark - PlayGuessViewControllerDelegate

- (void)addWithGuessId:(NSString *)stockId pri:(float)pri season:(NSInteger)season
{
    NetworkManager *ma = [[NetworkManager alloc] init];
    __weak PlayIndividualStockViewController *wself = self;
    NSDictionary *parmark1 = @{
                               @"stock":SafeValue(stockId),
                               @"points":@(pri),
                               };
    
    [ma POST:API_CheckStockAndPointsValid parameters:parmark1 completion:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *parmark = @{
                                      @"season":@(season),
                                      @"stock":SafeValue(stockId),
                                      @"points":@(pri),
                                      };
            
            [ma POST:API_AddGuessIndividual parameters:parmark completion:^(id data, NSError *error) {
                
            }];
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"不支持该股票的竞猜";
            [hud hide:YES afterDelay:0.5];
        }
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:self.pageScrollView];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hv = [[UIView alloc] init];
    hv.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"];
    
    [hv addSubview:self.segmentControl];
    [hv addSubview:self.timeControl];
    return hv;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.pageScrollView.frame.size.height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 42;
}


#pragma mark - UISCroolView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.pageScrollView) {
        return;
    }
    
    if(!decelerate)
    {   //OK,真正停止了，do something}
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.pageScrollView) {
        return;
    }
    
    int currentPage = self.pageScrollView.contentOffset.x/kScreenWidth;
    
    if (currentPage == self.pageIndex) {
        return;
    }else {
        self.pageIndex = currentPage;
    }
}

@end
