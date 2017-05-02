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
#import "NetworkManager.h"
#import "PlayGuessIndividua.h"
#import "PlayListModel.h"
#import "PlayGuessViewController.h"
#import "STPopupController.h"
#import "UIViewController+STPopup.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "PlayStockCommentViewController.h"
#import "Masonry.h"
#import "PlayIndividualContentCell.h"
#import "StockManager.h"
#import "MJRefresh.h"
#import "PlayEnjoyPeopleViewController.h"
#import "AliveDetailViewController.h"
#import "StockDetailViewController.h"
#import "DetailPageViewController.h"
#import "SurveyDetailWebViewController.h"
#import "SurveyDetailContentViewController.h"

@interface PlayIndividualStockViewController ()<UIScrollViewDelegate,PlayGuessViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, PlayIndividualContentCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *keyNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, assign) NSInteger seasonIndex;

@property (nonatomic, strong) PlayGuessIndividua *guessModel;

@property (nonatomic, strong) NSMutableArray *listModelArr;

@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UISegmentedControl *seasonSegmentControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation PlayIndividualStockViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.interval = 10;
        _stockManager.delegate = self;
    }
    return _stockManager;
}

// 开启股票刷新

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
        self.segmentControl.frame = CGRectMake(0, 0, 100, 41);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (UISegmentedControl *)seasonSegmentControl
{
    if (!_seasonSegmentControl) {
        NSInteger seasion = [self seasonWithCurrentTime];
        NSArray *items;
        if (seasion == 1) {
            // 上午场
            items = @[@"上午场"];
        } else {
            items = @[@"上午场",@"下午场"];
        }
        
        _seasonSegmentControl = [[UISegmentedControl alloc] initWithItems:items];
        _seasonSegmentControl.frame = CGRectMake(kScreenWidth-12- 55*items.count, 6.5, 55*items.count, 28);
        _seasonSegmentControl.tintColor = [UIColor hx_colorWithHexRGBAString:@"#191a1f"];
        _seasonSegmentControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor hx_colorWithHexRGBAString:@"#101114"], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_seasonSegmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_seasonSegmentControl setTitleTextAttributes:dic2 forState:UIControlStateSelected];
        
        [_seasonSegmentControl addTarget:self action:@selector(switchingViewAction:) forControlEvents:UIControlEventValueChanged];
        
        _seasonSegmentControl.layer.borderWidth = 2;
        _seasonSegmentControl.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"].CGColor;
    }
    return _seasonSegmentControl;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        UIImage *image = [UIImage imageNamed:@"icon_guessList_empty.png"];
        
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, image.size.height+40)];
        _emptyView.center = CGPointMake(kScreenWidth/2, CGRectGetWidth(self.tableView.frame)/2+65);
        _emptyView.tag = 20000;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.center = CGPointMake(CGRectGetWidth(_emptyView.frame)/2, image.size.height/2);
        
        [_emptyView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image.size.height+10, kScreenWidth, 20)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"试试主动发起竞猜吧~";
        [_emptyView addSubview:label];
    }
    return _emptyView;
}
#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagIndex = 0;
    self.pageIndex = 1;
    self.seasonIndex = ([self seasonWithCurrentTime]==1)?1:2;
    self.seasonSegmentControl.selectedSegmentIndex = self.seasonIndex-1;
    
    [self setupTableView];
    
    [self loadGuessUserInfo];
    [self reloadGuessListData];
    
    [self addNotifi];
}

- (void)setupTableView {
    
    self.tableView.rowHeight = 141;
    self.tableView.tableFooterView = [UIView new];
    
    UINib *nib = [UINib nibWithNibName:@"PlayIndividualContentCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PlayIndividualContentCellID"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)showEmptyView:(BOOL)empty {
    
    if (empty) {
        self.emptyView.hidden = NO;
        [self.tableView addSubview:self.emptyView];
    } else {
        self.emptyView.hidden = YES;
        [self.emptyView removeFromSuperview];
    }
}

- (void)addNotifi {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChangedNotifi:) name:kGuessCommentChanged object:nil];
}

#pragma mark - 按钮点击事件
- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
    [self.navigationController pushViewController:myWallet animated:YES];
    
}

- (IBAction)myGuessPressed:(id)sender {
    
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    MyGuessViewController *vc = [[MyGuessViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.guessListType = MyGuessIndividualListType;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)startGuessPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    NSInteger season = [self seasonWithCurrentTime];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_GetGuessIndividualEndtime parameters:@{@"season":@(season)} completion:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *dict = data;
            
            if (dict[@"guess_status"]) {
                // [dict[@"guess_status"] boolValue] == NO
                [self.view makeToast:@"已封盘" duration:0.8 position:CSToastPositionCenter];
            }else {
                
                PlayGuessViewController *vc = [[PlayGuessViewController alloc] init];
                vc.season = season;
                vc.isJoin = NO;
                vc.delegate = self;
                
                STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
                popupController.navigationBarHidden = YES;
                popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, 275);
                popupController.style = STPopupStyleBottomSheet;
                [popupController presentInViewController:self];
                
            }
        }
    }];
}

- (IBAction)rulePressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/index.php/Game/guessRule?guess_name=individual&device=ios"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)commentPressed:(id)sender {
    PlayStockCommentViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    vc.playStockType = kPlayStockIndividual;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentPressed:(HMSegmentedControl *)sender {
    self.pageIndex = 1;
    self.tagIndex = sender.selectedSegmentIndex;
    
    [self reloadGuessListData];
}

- (void)switchingViewAction:(HMSegmentedControl *)segControl {
    self.pageIndex = 1;
    self.seasonIndex = segControl.selectedSegmentIndex+1;
    
    [self reloadGuessListData];
}

#pragma mark - Notifi

- (void)commentChangedNotifi:(NSNotification *)notifi {
    [self loadGuessUserInfo];
}


#pragma mark - PlayGuessViewControllerDelegate
- (void)addGuessWithStockCode:(NSString *)stockCode pri:(float)pri season:(NSInteger)season isJoin:(BOOL)isJoin
{
    NSDictionary *parmark1 = @{@"stock":SafeValue(stockCode),
                               @"points":@(pri)};
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    view.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.navigationController.view addSubview:view];
    [view startAnimating];
    
    __weak PlayIndividualStockViewController *wself = self;
    
    void (^errorBlock)(NSString *) = ^(NSString *title){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = title;
        [hud hide:YES afterDelay:0.8];
    };
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_CheckStockAndPointsValid parameters:parmark1 completion:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *parmark = @{@"season":@(season),
                                      @"stock":SafeValue(stockCode),
                                      @"points":@(pri),
                                      };
            
            [ma POST:API_AddGuessIndividual parameters:parmark completion:^(id data, NSError *error) {
                [view stopAnimating];
                
                if (error) {
                    errorBlock(error.localizedDescription?:@"竞猜失败");
                } else {
                    errorBlock(@"投注成功，等待开奖");
                    
                    // 刷新钥匙数量
                    [wself loadGuessUserInfo];
                    
                    if (isJoin) {
                        [wself reloadCellWithStockCode:stockCode];
                    } else {
                        wself.pageIndex = 1;
                        [wself reloadGuessListData];
                    }
                }
            }];
        } else {
            [view stopAnimating];
            errorBlock(error.localizedDescription?:@"竞猜失败");
        }
    }];
    
}

#pragma mark - Query data

- (void)loadGuessUserInfo {
    
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

- (void)refreshData {
    self.pageIndex = 1;
    
    [self reloadGuessListData];
}

- (void)loadMoreData {
    [self reloadGuessListData];
}

- (void)reloadGuessListData
{
    /**
     名称	类型	说明	是否必填	示例	默认值
     season	int	1表示上午场，2表示下午场	是
     tag	int	0表示按时间倒序，1表示按参与人数倒序	是
     page	int	当前页码，从1开始	是
     */
    
    __weak PlayIndividualStockViewController *wself = self;
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.navigationController.view addSubview:hud];
    
    hud.hidesWhenStopped = YES;
    [hud startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *parmark = @{
                              @"season":@(self.seasonIndex),
                              @"tag": @(self.tagIndex),
                              @"page":@(self.pageIndex)
                              };
    [ma GET:API_GetGuessIndividualList parameters:parmark completion:^(id data, NSError *error) {
        
        [hud stopAnimating];
        
        if (wself.tableView.mj_header.isRefreshing) {
            [wself.tableView.mj_header endRefreshing];
        }
        
        if (!error) {
            NSMutableArray *arrM = nil;
            if (wself.pageIndex == 1) {
                arrM = [NSMutableArray array];
            }else {
                arrM = [NSMutableArray arrayWithArray:self.items];
            }
            
            __block NSMutableArray *stockIds = [NSMutableArray new];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PlayListModel *model = [[PlayListModel alloc] initWithDictionary:obj];
                [arrM addObject:model];
                [stockIds addObject:model.stock];
            }];
            
            wself.items = arrM;
            [wself.stockManager addStocks:stockIds];
            [wself.tableView reloadData];
            
            wself.pageIndex++;
            
            if ([data count] != 20) {
                [wself.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [wself.tableView.mj_footer endRefreshing];
            }
        } else {
            [wself.tableView.mj_footer endRefreshing];
        }

        [wself showEmptyView:(wself.items.count == 0)];
    }];
}

- (void)reloadCellWithStockCode:(NSString *)stockCode {
    
    // 刷新钥匙
    [self loadGuessUserInfo];
    
    __block NSString *guessId;
    [self.items enumerateObjectsUsingBlock:^(PlayListModel *obj, NSUInteger idx, BOOL *stop){
        if ([obj.com_code isEqualToString:stockCode]) {
            guessId = obj.guess_id;
            *stop = YES;
        }
    }];
    
    if (!guessId.length) {
        return;
    }
    
    __weak PlayIndividualStockViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *parmark = @{@"guess_id": guessId};
    
    [ma GET:API_GetGuessInfo parameters:parmark completion:^(id data, NSError *error) {
        if (!error) {
            PlayListModel *model = [[PlayListModel alloc] initWithDictionary:data];
            [wself reloadCellWithGuessInfo:model];
        }
    }];
}

- (void)reloadCellWithGuessInfo:(PlayListModel *)guess {
    
    __block NSInteger index;
    
    [self.items enumerateObjectsUsingBlock:^(PlayListModel *obj, NSUInteger idx, BOOL *stop){
        if ([obj.guess_id isEqualToString:guess.guess_id]) {
            
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index >= 0 && index<self.items.count) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
        [array replaceObjectAtIndex:index withObject:guess];
        self.items = array;
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    
    [self.tableView reloadData];
}


#pragma mark - PlayIndividualContentCellDelegate

- (void)playIndividualCell:(PlayIndividualContentCell *)cell guessPressed:(id)sender {
    PlayListModel *model = cell.model;
    StockInfo *sInfo = [self.stockDict objectForKey:model.stock];
    
    PlayGuessViewController *vc = [[PlayGuessViewController alloc] init];
    vc.season = [model.guess_season integerValue];
    vc.isJoin = YES;
    vc.delegate = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
    
    [vc setupDefaultStock:sInfo withStockCode:model.com_code];
}

- (void)playIndividualCell:(PlayIndividualContentCell *)cell enjoyListPressed:(id)sender {
    PlayListModel *model = cell.model;
    
    PlayEnjoyPeopleViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayEnjoyPeopleViewController"];
    
    vc.guessID = [NSString stringWithFormat:@"%@",model.guess_id];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.navigationBarHidden = YES;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth-80, 220);
    popupController.style = STPopupTransitionStyleSlideVertical;
    [popupController presentInViewController:self];
}

- (void)playIndividualCell:(PlayIndividualContentCell *)cell surveyPressed:(id)sender {
    PlayListModel *model = cell.model;
    
    NSString *article_id = model.artile_info[@"article_id"];
    NSInteger article_type = [model.artile_info[@"article_type"] integerValue];
    
    if (article_type == 1) {
        // 调研
        StockDetailViewController *vc = [[StockDetailViewController alloc] init];
        vc.stockCode = article_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (article_type == 2){
        // 热点
        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
        vc.contentId = article_id;
        vc.stockCode = model.com_code;
        vc.stockName = model.guess_company;
        vc.tag = 3;
        vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:article_id withTag:@"3"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (article_type == 3) {
        // 观点
        DetailPageViewController *detail = [[DetailPageViewController alloc]init];
        detail.pageMode = @"view";
        detail.view_id = article_id;
        [self.navigationController pushViewController:detail animated:YES];
    }else if (article_type == 4) {
        // 直播
        AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
        vc.alive_ID = model.artile_info[@"article_id"];
        vc.alive_type = @"2";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{

    }
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayListModel *model = self.items[indexPath.row];
    StockInfo *sInfo = [self.stockDict objectForKey:model.stock];
    
    PlayIndividualContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayIndividualContentCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setupStock:sInfo];
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    return 41.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 41)];
    header.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"];
    
    [header addSubview:self.segmentControl];
    [header addSubview:self.seasonSegmentControl];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)seasonWithCurrentTime {
    
    // 10:30 之前为上午场，11：30--14：00为下午场
    
    // 11：30之前显示上午场，之后显示，上午场和下午场

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:now];
    dateComponents.hour = 11;
    dateComponents.minute = 30;
    dateComponents.second =0;
    dateComponents.nanosecond =0;
    
    NSDate *date1 = [calendar dateFromComponents:dateComponents];
    
    if ([[now earlierDate:date1] isEqualToDate:now]) {
        return 1;
    } else {
        return 2;
    }
}
@end
