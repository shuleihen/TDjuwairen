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
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "PlayStockCommentViewController.h"
#import "Masonry.h"

@interface PlayIndividualStockViewController ()<UIScrollViewDelegate,PlayGuessViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *keyNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic, strong) NSArray *contentControllers;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) PlayGuessIndividua *guessModel;
@property (nonatomic, strong) PlayListModel *guessListModel;
@property (nonatomic, strong) NSMutableArray *listModelArr;
@property (nonatomic, strong) UISegmentedControl *seasonSegmentControl;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation PlayIndividualStockViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter
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
        _seasonSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"上午场",@"下午场"]];
        _seasonSegmentControl.frame = CGRectMake(kScreenWidth-12-110, 6.5, 110, 28);
        _seasonSegmentControl.tintColor = [UIColor hx_colorWithHexRGBAString:@"#191a1f"];
        _seasonSegmentControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor hx_colorWithHexRGBAString:@"#101114"], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_seasonSegmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_seasonSegmentControl setTitleTextAttributes:dic2 forState:UIControlStateSelected];
        
        [_seasonSegmentControl addTarget:self action:@selector(switchingViewAction:) forControlEvents:UIControlEventValueChanged];
        
        _seasonSegmentControl.layer.borderWidth = 2;
        _seasonSegmentControl.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"].CGColor;
        
        NSInteger seasion = [self seasonWithCurrentTime];
        if (seasion == 2) {
            _seasonSegmentControl.selectedSegmentIndex = 1;
        } else {
            _seasonSegmentControl.selectedSegmentIndex = 0;
        }
        
    }
    return _seasonSegmentControl;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        NSInteger season = [self seasonWithCurrentTime];
        
        PlayIndividualStockContentViewController *one = [[PlayIndividualStockContentViewController alloc] initWithStyle:UITableViewStylePlain];
        one.listType = PlayIndividualContentNewType;
        one.listSeason = (season>0)?season:1;;
        [self addChildViewController:one];
        
        PlayIndividualStockContentViewController *two = [[PlayIndividualStockContentViewController alloc] initWithStyle:UITableViewStylePlain];
        two.listType = PlayIndividualContentHostType;
        two.listSeason = (season>0)?season:1;;
        [self addChildViewController:two];
        
        _contentControllers = @[one,two];
    }
    
    return _contentControllers;
}


#pragma mark - Setter
- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;

    PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
    self.seasonSegmentControl.selectedSegmentIndex = vc.listSeason-1;
    
    [self.pageScrollView setContentOffset:CGPointMake(kScreenWidth*pageIndex, 0) animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self initValue];
}

- (void)initValue
{
    self.pageIndex = 0;
    
    [self loadGuessUserInfo];
    
    _listModelArr = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChanged:) name:kGuessCommentChanged object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAddJoinGuess) name:kAddJoinGuessNotification object:nil];
}

- (void)initViews
{
    [self.headerView addSubview:self.segmentControl];
    [self.headerView addSubview:self.seasonSegmentControl];
    

    for (int i = 0; i<self.contentControllers.count; i++) {
        PlayIndividualStockContentViewController *vc = self.contentControllers[i];
        
        [self.pageScrollView addSubview:vc.tableView];
        [vc.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pageScrollView).with.offset(0);
            make.left.equalTo(self.pageScrollView).with.offset(i*kScreenWidth);
            make.width.mas_equalTo(kScreenWidth);
            make.height.equalTo(self.pageScrollView);
        }];
    }
    
    self.pageScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
}

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

#pragma mark - 按钮点击事件
/// 我的钱包
- (IBAction)walletPressed:(id)sender {
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    MyWalletViewController *myWallet = [[MyWalletViewController alloc] init];
    [self.navigationController pushViewController:myWallet animated:YES];
    
}

/// 我的竞猜列表
- (IBAction)myGuessPressed:(id)sender {
    
    if (!US.isLogIn) {
        [self pushLoginViewController];
        return;
    }
    
    MyGuessViewController *vc = [[MyGuessViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.guessListType = MyGuessIndividualListType;
    [self.navigationController pushViewController:vc animated:YES];
    
}


/// 发起竞猜
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
                vc.delegate = self;
                vc.view.frame = CGRectMake(0, 0, kScreenWidth, 275);
                
                STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
                popupController.navigationBarHidden = YES;
                popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, 275);
                popupController.style = STPopupStyleBottomSheet;
                [popupController presentInViewController:self];
                
            }
        }
    }];
}

/// 规则
- (IBAction)rulePressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/index.php/Game/guessRule?guess_name=individual&device=ios"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 评论
- (IBAction)commentPressed:(id)sender {
    PlayStockCommentViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
    vc.playStockType = kPlayStockIndividual;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 最新／最热
- (void)segmentPressed:(HMSegmentedControl *)sender {
    self.pageIndex = sender.selectedSegmentIndex;
}

/// 上午场／下午场
- (void)switchingViewAction:(HMSegmentedControl *)segControl
{
    PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
    vc.listSeason = segControl.selectedSegmentIndex+1;
    [vc onRefresh];
}


#pragma mark - PlayGuessViewControllerDelegate
- (void)addWithGuessId:(NSString *)stockId pri:(float)pri season:(NSInteger)season
{
    NSDictionary *parmark1 = @{@"stock":SafeValue(stockId),
                               @"points":@(pri),
                               };
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    
    void (^errorBlock)(NSString *) = ^(NSString *title){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = title;
        [hud hide:YES afterDelay:0.8];
    };
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_CheckStockAndPointsValid parameters:parmark1 completion:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *parmark = @{@"season":@(season),
                                      @"stock":SafeValue(stockId),
                                      @"points":@(pri),
                                      };
            
            [ma POST:API_AddGuessIndividual parameters:parmark completion:^(id data, NSError *error) {
                [view stopAnimating];
                
                if (error) {
                    errorBlock(error.localizedDescription?:@"竞猜失败");
                } else {
                    errorBlock(@"投注成功，等待开奖");
                    
                    [self refreshCurrentPageController];
                }
            }];
        } else {
            [view stopAnimating];
            errorBlock(error.localizedDescription?:@"竞猜失败");
        }
    }];
    
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


- (void)refreshCurrentPageController {
    if (self.pageIndex >= 0 && self.pageIndex < self.contentControllers.count) {
        PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
        [vc onRefresh];
    }
}

/// 钥匙数量改变
- (void)refreshAddJoinGuess {
    [self loadGuessUserInfo];
}

/// 评论数改变
- (void)commentChanged:(id)sender {
    [self loadGuessUserInfo];
}

- (NSInteger)seasonWithCurrentTime {
    // 10:30 之前为上午场，11：30--14：00为下午场
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:now];
    dateComponents.hour = 10;
    dateComponents.minute = 30;
    dateComponents.second =0;
    dateComponents.nanosecond =0;
    NSDate *date1 = [calendar dateFromComponents:dateComponents];
    
    dateComponents.hour = 11;
    dateComponents.minute = 30;
    NSDate *date2 = [calendar dateFromComponents:dateComponents];
    
    dateComponents.hour = 14;
    dateComponents.minute = 00;
    NSDate *date3 = [calendar dateFromComponents:dateComponents];
    
    if ([[now earlierDate:date1] isEqualToDate:now]) {
        return 1;
    } else if ([[now laterDate:date2] isEqualToDate:now] &&
               [[now earlierDate:date3] isEqualToDate:now]){
        return 2;
    } else {
        return 0;
    }
}
@end
