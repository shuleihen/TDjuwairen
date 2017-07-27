//
//  PSIndividualListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PSIndividualListViewController.h"
#import "UIViewController+Login.h"
#import "LoginState.h"
#import "MyWalletViewController.h"
#import "MyGuessViewController.h"
#import "TDWebViewController.h"
#import "HMSegmentedControl.h"
#import "NetworkManager.h"
#import "PSIndividualGuessModel.h"
#import "PSIndividualListModel.h"
#import "AddIndividualViewController.h"
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
#import "SurveyDetailWebViewController.h"
#import "SurveyDetailContentViewController.h"
#import "BVUnderlineButton.h"
#import "Masonry.h"
#import "ViewpointDetailViewController.h"
#import "NSString+Util.h"
#import "CBAutoScrollLabel.h"
#import "PlayStockDetailViewController.h"
#import "PlayStockHnadler.h"
#import "PSIndividualArticleModel.h"


@interface PSIndividualListViewController ()<UIScrollViewDelegate,PlayGuessViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, StockManagerDelegate, PlayIndividualContentCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIButton *keyNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *seasonDateLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *messageLabel;

@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, assign) NSInteger seasonIndex;

@property (nonatomic, strong) PSIndividualGuessModel *guessModel;

@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *stockDict;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PSIndividualListViewController

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
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


- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] init];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                                        NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#F5A91B"]};
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor hx_colorWithHexRGBAString:@"#F5A91B"];
        _segmentControl.sectionTitles = @[@"全部",@"我参与的"];
        self.segmentControl.frame = CGRectMake(0, 0, 135, 33);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#F5A91B"];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.frame = CGRectMake(140, 10, kScreenWidth-152, 13);
    }
    return _timeLabel;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        UIImage *image = [UIImage imageNamed:@"icon_guessList_empty.png"];
        
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, image.size.height+40)];
        _emptyView.backgroundColor = [UIColor clearColor];
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

    [self setupNav];
    
    self.tagIndex = 0;
    self.pageIndex = 1;
    self.seasonDateLabel.text = @"";
    
    [self setupTableView];
    
    [self loadGuessUserInfo];
    [self reloadGuessListData];
    
    [self addNotifi];
    
    __weak PSIndividualListViewController *wself = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:wself selector:@selector(timerFire:) userInfo:nil repeats:YES];
}

- (void)setupNav {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(myGuessPressed:)];
    [item1 setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(rulePressed:)];
    [item2 setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

- (void)setupTableView {
    
    self.tableView.rowHeight = 141;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#1D2027"];
    
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

#pragma mark - Notifi

- (void)commentChangedNotifi:(NSNotification *)notifi {
    [self loadGuessUserInfo];
}

#pragma mark - Action

- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
    [self.navigationController pushViewController:myWallet animated:YES];
    
}

- (void)myGuessPressed:(id)sender {
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
    
    if ([self.guessModel.user_keynum integerValue] <= 0) {
        __weak PSIndividualListViewController *wself = self;
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [wself walletPressed:nil];
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"筹码不足哦，是否充值？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self checkIndividualGuessEndTimeWithBlock:^(NSInteger season, NSInteger endTime){
        AddIndividualViewController *vc = [[AddIndividualViewController alloc] init];
        vc.season = season;
        vc.endtime = endTime;
        vc.isJoin = NO;
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }];
}

- (void)rulePressed:(id)sender {
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

- (void)timerFire:(id)timer {
    
    if (self.guessModel) {

        NSString *nextDay = [PlayStockHnadler stringWithNextDay:self.guessModel.next_day];
        NSString *season = [PlayStockHnadler stringWithSeason:self.guessModel.guess_season];
        NSString *remaining = [NSString intervalNowDateWithDateInterval:self.guessModel.guess_endTime];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@%@ %@",nextDay,season,remaining];
    }
}

#pragma mark - Query data

- (void)loadGuessUserInfo {
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    __weak PSIndividualListViewController *wself = self;
    [ma GET:API_GetGuessIndividual parameters:nil completion:^(id data, NSError *error) {
        if (!error) {
            PSIndividualGuessModel *model = [[PSIndividualGuessModel alloc] initWithDictionary:data];
            [wself reloadViewWithIndividaulModel:model];
        }
    }];
}


- (void)reloadViewWithIndividaulModel:(PSIndividualGuessModel *)model {
    self.guessModel = model;
    
    [self.keyNumBtn setTitle:[NSString stringWithFormat:@"%@",self.guessModel.user_keynum] forState:UIControlStateNormal];
    
    [self.bottomButton setTitle:[NSString stringWithFormat:@"评论(%@)",self.guessModel.guess_comment_count] forState:UIControlStateNormal];
    
    NSString *mesage = [model.guess_message componentsJoinedByString:@"   "];
    
    NSData *data=[mesage dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *optoins=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:data
                                                                         options:optoins
                                                              documentAttributes:nil
                                                                           error:nil];
    
    self.messageLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#101114"];
    self.messageLabel.attributedText = attributeString;
    self.messageLabel.font = [UIFont systemFontOfSize:12.0f];
    self.messageLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"3F3F3F"];
    
    self.seasonDateLabel.text = model.guess_date;
    
    [self timerFire:self.timer];
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
    
    __weak PSIndividualListViewController *wself = self;
    
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
                PSIndividualListModel *model = [[PSIndividualListModel alloc] initWithDictionary:obj];
                [arrM addObject:model];
                [stockIds addObject:model.stockId];
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
    [self.items enumerateObjectsUsingBlock:^(PSIndividualListModel *obj, NSUInteger idx, BOOL *stop){
        if ([obj.stockCode isEqualToString:stockCode]) {
            guessId = obj.guessId;
            *stop = YES;
        }
    }];
    
    if (!guessId.length) {
        return;
    }
    
    __weak PSIndividualListViewController *wself = self;
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *parmark = @{@"guess_id": guessId};
    
    [ma GET:API_GetGuessInfo parameters:parmark completion:^(id data, NSError *error) {
        if (!error) {
            PSIndividualListModel *model = [[PSIndividualListModel alloc] initWithDictionary:data];
            [wself reloadCellWithGuessInfo:model];
        }
    }];
}

- (void)reloadCellWithGuessInfo:(PSIndividualListModel *)guess {
    
    __block NSInteger index;
    
    [self.items enumerateObjectsUsingBlock:^(PSIndividualListModel *obj, NSUInteger idx, BOOL *stop){
        if ([obj.guessId isEqualToString:guess.guessId]) {
            
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

#pragma mark - CheckGuessEndTime
- (void)checkIndividualGuessEndTimeWithBlock:(void (^)(NSInteger season, NSInteger endTime))block {
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.view addSubview:hud];
    
    hud.hidesWhenStopped = YES;
    [hud startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_GetGuessIndividualEndtime parameters:@{@"season":@(self.seasonIndex)} completion:^(id data, NSError *error) {
        
        [hud stopAnimating];
        
        if (!error) {
            NSDictionary *dict = data;
            
            if (dict[@"guess_status"]) {
                [self.view makeToast:@"已封盘" duration:0.8 position:CSToastPositionCenter];
            }else {
                NSInteger season = [dict[@"guess_season"] integerValue];
                NSInteger endTime = [dict[@"guess_endtime"] integerValue];
                block(season,endTime);
            }
        }
    }];
}

#pragma mark - PlayGuessViewControllerDelegate
- (void)addGuessWithStockCode:(NSString *)stockCode pri:(float)pri season:(NSInteger)season isJoin:(BOOL)isJoin isForward:(BOOL)isForward
{
    NSDictionary *parmark1 = @{@"stock":SafeValue(stockCode),
                               @"points":@(pri)};
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    view.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.navigationController.view addSubview:view];
    [view startAnimating];
    
    __weak PSIndividualListViewController *wself = self;
    
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
                                      @"is_forward":@(isForward),
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

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    self.stockDict = stocks;
    
    [self.tableView reloadData];
}


#pragma mark - PlayIndividualContentCellDelegate

- (void)playIndividualCell:(PlayIndividualContentCell *)cell guessPressed:(id)sender {
    if ([self.guessModel.user_keynum integerValue] <= 0) {
        __weak PSIndividualListViewController *wself = self;
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [wself walletPressed:nil];
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"筹码不足哦，是否充值？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self checkIndividualGuessEndTimeWithBlock:^(NSInteger season, NSInteger endTime){
        PSIndividualListModel *model = cell.model;
        StockInfo *sInfo = [self.stockDict objectForKey:model.stockId];
        
        AddIndividualViewController *vc = [[AddIndividualViewController alloc] init];
        vc.season = season;
        vc.endtime = endTime;
        vc.isJoin = YES;
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
        
        [vc setupDefaultStock:sInfo withStockCode:model.stockCode];
    }];
}

- (void)playIndividualCell:(PlayIndividualContentCell *)cell enjoyListPressed:(id)sender {
    PSIndividualListModel *model = cell.model;
    
    PlayEnjoyPeopleViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayEnjoyPeopleViewController"];
    
    vc.guessID = [NSString stringWithFormat:@"%@",model.guessId];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.navigationBarHidden = YES;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth-80, 220);
    popupController.style = STPopupTransitionStyleSlideVertical;
    [popupController presentInViewController:self];
}

- (void)playIndividualCell:(PlayIndividualContentCell *)cell articlePressedWithIndex:(NSInteger)index{
    PSIndividualListModel *model = cell.model;
    PSIndividualArticleModel *article = cell.model.artile_list[index];

    NSString *article_id = article.articleId;
    NSInteger article_type = article.articleType;
    NSString *article_url = article.articleUrl;
    
    if (article_type == 1) {
        // 调研
        StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
        vc.stockCode = model.stockCode;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (article_type == 2){
        // 热点
        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
        vc.contentId = article_id;
        vc.stockCode = model.stockCode;
        vc.stockName = model.stockName;
        vc.surveyType = kSurveyTypeHot;
        vc.url = article_url;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (article_type == 3) {
        // 观点
        ViewpointDetailViewController *vc = [[ViewpointDetailViewController alloc] initWithAliveId:article_id aliveType:kAliveViewpoint];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (article_type == 4) {
        // 直播
        AliveDetailViewController *vc = [[AliveDetailViewController alloc] init];
        vc.aliveID = article_id;
        vc.aliveType = kAlivePosts;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (article_type == 5) {
        // 公告
        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
        vc.contentId = article_id;
        vc.stockCode = model.stockCode;
        vc.stockName = model.stockName;
        vc.surveyType = kSurveyTypeAnnounce;
        vc.url = article_url;
        [self.navigationController pushViewController:vc animated:YES];
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
    
    PSIndividualListModel *model = self.items[indexPath.row];
    StockInfo *sInfo = [self.stockDict objectForKey:model.stockId];
    
    PlayIndividualContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayIndividualContentCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setupStock:sInfo];
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    header.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#141519"];
    
    [header addSubview:self.segmentControl];

    [header addSubview:self.timeLabel];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PSIndividualListModel *model = self.items[indexPath.row];
    
    PlayStockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockDetailViewController"];
    vc.guessId = model.guessId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
