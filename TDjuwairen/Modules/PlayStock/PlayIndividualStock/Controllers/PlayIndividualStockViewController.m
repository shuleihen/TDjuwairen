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
@property (nonatomic, strong) UISegmentedControl *timeControl;
@property (nonatomic, assign) NSInteger timeIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutH;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (assign, nonatomic) BOOL isFirstLoad;



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

- (UISegmentedControl *)timeControl
{
    if (!_timeControl) {
        _timeControl = [[UISegmentedControl alloc] initWithItems:@[@"上午场",@"下午场"]];
        _timeControl.frame = CGRectMake(kScreenWidth-12-110, 6.5, 110, 28);
        _timeControl.tintColor = [UIColor hx_colorWithHexRGBAString:@"#191a1f"];
        _timeControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor hx_colorWithHexRGBAString:@"#101114"], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_timeControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        [_timeControl setTitleTextAttributes:dic2 forState:UIControlStateSelected];
        
        _timeControl.selectedSegmentIndex = 0;
        [_timeControl addTarget:self action:@selector(switchingViewAction:) forControlEvents:UIControlEventValueChanged];
        _timeIndex = 1;
        
        _timeControl.layer.borderWidth = 2;
        _timeControl.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#272a31"].CGColor;
        
    }
    return _timeControl;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.pageScrollView.frame));
        PlayIndividualStockContentViewController *one = [[PlayIndividualStockContentViewController alloc] initWithPlayIndividualStockContentViewControllerWithFrame:rect andListType:PlayIndividualContentNewType];
        one.superVC = self;
        
        PlayIndividualStockContentViewController *two = [[PlayIndividualStockContentViewController alloc] initWithPlayIndividualStockContentViewControllerWithFrame:rect andListType:PlayIndividualContentHostType];
        two.superVC = self;
        _contentControllers = @[one,two];
    }
    
    return _contentControllers;
}


#pragma mark - Setter
- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    self.segmentControl.selectedSegmentIndex = pageIndex;
    PlayIndividualStockContentViewController *vc = self.contentControllers[pageIndex];
    
    if (pageIndex == 1) {
        if (self.isFirstLoad == YES) {
            vc.listSeason = self.timeControl.selectedSegmentIndex+1;
            self.isFirstLoad = NO;
            return;
        }
    }
    
    if (vc.listSeason != self.timeIndex) {
        vc.listSeason = self.timeIndex;
    }
    [self.pageScrollView setContentOffset:CGPointMake(kScreenWidth*pageIndex, 0) animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initViews];
    
    
}

- (void)initValue
{
    self.timeIndex = 1;
    self.pageIndex = 0;
    self.isFirstLoad = YES;
    [self loadFistViewMessage];
    _listModelArr = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChanged:) name:kGuessCommentChanged object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshKeyNum) name:@"refreshGuessHome" object:nil];
    
}

- (void)initViews
{
    [self.headerView addSubview:self.segmentControl];
    [self.headerView addSubview:self.timeControl];
    self.pageScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
    for (int i = 0; i<self.contentControllers.count; i++) {
        PlayIndividualStockContentViewController *vc = self.contentControllers[i];
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, CGRectGetHeight(self.pageScrollView.frame))];
        [vi addSubview:vc.view];
        [self.pageScrollView addSubview:vi];
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
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_GetGuessIndividualEndtime parameters:@{@"season":@(self.timeIndex)} completion:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *dict = data;
            
            if (dict[@"guess_status"]) {
                [self.view makeToast:@"已封盘" duration:0.8 position:CSToastPositionCenter];
            }else {
                
                PlayGuessViewController *vc = [[PlayGuessViewController alloc] init];
                vc.view.frame = CGRectMake(0, 0, kScreenWidth, 275);
                vc.guess_date = _guessModel.guess_date;
                vc.season = self.timeIndex;
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
    self.timeIndex = segControl.selectedSegmentIndex+1;
    PlayIndividualStockContentViewController *vc = self.contentControllers[self.pageIndex];
    vc.listSeason = segControl.selectedSegmentIndex+1;
    
}


#pragma mark - PlayGuessViewControllerDelegate
- (void)addWithGuessId:(NSString *)stockId pri:(float)pri season:(NSInteger)season
{
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    //    __weak PlayIndividualStockViewController *wself = self;
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
                if (error) {
                    [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:0.8 position:CSToastPositionCenter];
                }
                
            }];
        }else
        {
            
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:0.8 position:CSToastPositionCenter];
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

#pragma mark - 通知action
/// 钥匙数量改变
- (void)refreshKeyNum
{
    [_keyNum setTitle:[NSString stringWithFormat:@"%d",(int)([_guessModel.user_keynum integerValue]-1)] forState:UIControlStateNormal];
}

/// 评论数改变
- (void)commentChanged:(id)sender {
    [self loadFistViewMessage];
}
@end
