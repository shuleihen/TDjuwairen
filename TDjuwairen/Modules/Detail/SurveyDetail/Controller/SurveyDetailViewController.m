
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
#import "SurveyDetailAskViewController.h"
#import "SurveyDetailStockCommentViewController.h"
#import "StockCommentModel.h"
#import "StockManager.h"
#import "UIImage+Color.h"
#import "StockUnlockViewController.h"
#import "SurveyMoreViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SurveyBottomToolView.h"
#import "AskPublishViewController.h"
#import "AnsPublishViewController.h"
#import "NotificationDef.h"
#import "MBProgressHUD.h"
#import "STPopup.h"
#import "UIdaynightModel.h"
#import "SpotViewController.h"
#import "DialogueViewController.h"
#import "GradeListViewController.h"
#import "ApplySurveyViewController.h"
#import "Masonry.h"

#define kHeaderViewHeight 135
#define kSegmentHeight 45

@interface SurveyDetailViewController ()<SurveyDetailSegmentDelegate, SurveyDetailContenDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource, StockManagerDelegate, SurveyMoreDelegate, StockHeaderDelegate>

@property (weak, nonatomic) IBOutlet StockHeaderView *stockHeaderView;
@property (nonatomic, strong) SurveyDetailSegmentView *segment;
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) SurveyBottomToolView *bottomToolView;

@property (nonatomic, strong) NSMutableArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, weak) UIViewController *pageWillToController;
@property (nonatomic, strong) StockManager *stockManager;

@property (nonatomic, copy) NSString *stockName;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, assign) NSInteger keyNumber;
@end

@implementation SurveyDetailViewController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.stockManager stopThread];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 添加查询股票
    [self.stockManager addStocks:@[self.stockId]];
    
    // 查询
    [self querySurveySimpleDetail];
    
    /*
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    */
    
    // 监听 发布牛熊说、回答或提问通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContentData:) name:kSurveyDetailContentChanged object:nil];
    
    // 解锁通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockStock:) name:kSurveyDetailUnlock object:nil];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    // 表头
    self.stockHeaderView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    self.stockHeaderView.delegate = self;
    
    // 自定义悬浮segment
    self.segment.frame = CGRectMake(0, kHeaderViewHeight, kScreenWidth, kSegmentHeight);
    [self.tableView addSubview:self.segment];
    
    // 表尾
    self.tableView.tableFooterView = self.pageViewController.view;
    
    //添加监听，动态观察tableview的contentOffset的改变
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 导航条背景根据涨跌修改
    if (self.stockInfo) {
        [self setupStockInfo:self.stockInfo];
    }
    
    [self.stockManager start];
    
    [self showBottomTool];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.stockManager stop];
    
    [self hideBottomTool];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y > kHeaderViewHeight) {
            
            CGRect newFrame = CGRectMake(0, offset.y, self.view.frame.size.width, kSegmentHeight);
            self.segment.frame = newFrame;

        } else {
            CGRect newFrame = CGRectMake(0, kHeaderViewHeight, self.view.frame.size.width, kSegmentHeight);
            self.segment.frame = newFrame;
        }
    }
}

#pragma mark - Action
- (void)querySurveySimpleDetail {
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
    
    __weak SurveyDetailViewController *wself = self;
    [ma POST:API_SurveyDetailHeader parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            BOOL isLock = [data[@"isLock"] boolValue];
            
            wself.segment.isLock = isLock;
            wself.title = data[@"company"];
            wself.keyNumber = [data[@"keyNum"] integerValue];
            wself.cover = data[@"cover"];
            
            if (isLock) {
                // (加锁)默认显示热点篇
                wself.segment.selectedIndex = 3;
            } else {
                // （解锁）默认显示热点篇
                wself.segment.selectedIndex = 0;
            }
            
        } else {
            // 查询失败
        }
    }];
}

- (void)unlockStockPressed {
    
    StockUnlockViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"StockUnlockViewController"];
    vc.stockCode = [self.stockId substringFromIndex:2];
    vc.stockName = self.stockName;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:self];
}

- (void)niuxiongPublish {
    __weak SurveyDetailViewController *wself = self;
    UIAlertAction *niu = [UIAlertAction actionWithTitle:@"发布牛评" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        AskPublishViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"AskPublishViewController"];
        vc.comanyCode = [wself.stockId substringFromIndex:2];
        vc.type = kPublishNiu;
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *xiong = [UIAlertAction actionWithTitle:@"发布熊评" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        AskPublishViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"AskPublishViewController"];
        vc.comanyCode = [wself.stockId substringFromIndex:2];
        vc.type = kPublishXiong;
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:niu];
    [alert addAction:xiong];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)askPublish {
    AskPublishViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"AskPublishViewController"];
    vc.comanyCode = [self.stockId substringFromIndex:2];
    vc.type = kPublishAsk;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showBottomTool {
    if (self.segment.selectedIndex == 2 ||
        self.segment.selectedIndex == 5) {
        self.bottomToolView.center = CGPointMake(kScreenWidth/2, kScreenHeight+25);
        self.bottomToolView.tag = self.segment.selectedIndex;
        [self.navigationController.view addSubview:self.bottomToolView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomToolView.center = CGPointMake(kScreenWidth/2, kScreenHeight - 25);
            
        } completion:^(BOOL finish){

        }];
    }
}

- (void)hideBottomTool {
    if (self.bottomToolView.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomToolView.center = CGPointMake(kScreenWidth/2, kScreenHeight+25);
            
        } completion:^(BOOL finish){

            [self.bottomToolView removeFromSuperview];
        }];
    }
}

- (void)setupStockInfo:(StockInfo *)stock {
    [self.stockHeaderView setupStockInfo:stock];
    
    self.stockName = stock.name;
}


- (void)morePressed:(id)sender {
    SurveyMoreViewController  *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"SurveyMoreViewController"];
    vc.delegate = self;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.style = STPopupStyleBottomSheet; 
    [popupController presentInViewController:self];
}

- (void)reloadContentData:(NSNotification *)notifi {
    NSInteger tag = [notifi.userInfo[@"Tag"] integerValue];
    SurveyDetailContentViewController *vc = self.contentControllers[tag];
    [vc reloadData];
}

- (void)unlockStock:(NSNotification *)notifi {
    NSString *code = [self.stockId substringFromIndex:2];
    NSDictionary *para = @{@"user_id":  US.userId,
                           @"code":     code};
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    [self.navigationController.view addSubview:indicator];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_SurveyUnlock parameters:para completion:^(id data, NSError *error){
        [indicator stopAnimating];
        
        if (!error) {
            self.segment.isLock = NO;
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:0.4];
        }
            
    }];
}

- (void)reloadTableView {
    CGFloat contentHeight = [[self currentContentViewController] contentHeight];
    CGFloat minHeight = kScreenHeight - 200;
    CGFloat height = MAX(contentHeight, minHeight);
    
    self.pageViewController.view.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.tableView reloadData];
}

#pragma mark - StockHeaderDelegate
- (void)gradePressed:(id)sender {
    GradeListViewController *vc = [[GradeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addStockPressed:(id)sender {
    
}

- (void)invitePressed:(id)sender {
    ApplySurveyViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplySurveyViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    StockInfo *stock = [stocks objectForKey:self.stockId];
    self.stockInfo = stock;
    
    [self setupStockInfo:stock];
}

#pragma mark - SurveyMoreDelegate
- (void)didSelectedWithRow:(NSInteger)row {
    if (row == 0) {
        // 夜间模式切换
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        UIdaynightModel *daynightmodel = [UIdaynightModel sharedInstance];
        
        // 夜间模式切换
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
            [self.dk_manager dawnComing];
            [daynightmodel day];
            [userdefault setObject:@"yes" forKey:@"daynight"];
        } else {
            [self.dk_manager nightFalling];
            [daynightmodel night];
            [userdefault setObject:@"no" forKey:@"daynight"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNightVersionChanged object:nil];
    } else if (row == 2) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSString *code = [self.stockId substringFromIndex:2];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:@[self.cover]
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/Survey/%@",code]]
                                          title:self.stockName
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
                               [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                               [self presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享失败" preferredStyle:UIAlertControllerStyleAlert];
                               [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                               [self presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    } else if (row == 3) {
        //跳转反馈
        if (US.isLogIn) {
            FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
    
}

#pragma mark - SurveyDetailSegmentDelegate
- (void)didSelectedSegment:(SurveyDetailSegmentView *)segmentView withIndex:(NSInteger)index {
    DDLogInfo(@"Survey detail content selected tag = %ld",(long)index);
    if (index > [self.contentControllers count]) {
        return;
    }
    
    SurveyDetailSegmentItem *item = segmentView.segments[index];
    if (item.locked) {
        [self unlockStockPressed];
    } else {
        
        __weak SurveyDetailViewController *wself = self;
        SurveyDetailContentViewController *vc = self.contentControllers[index];
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){

            [wself reloadTableView];
            
            if (wself.tableView.contentOffset.y > CGRectGetHeight(wself.stockHeaderView.bounds)) {
                wself.tableView.contentOffset = CGPointMake(0, wself.stockHeaderView.bounds.size.height);
            }
        }];
        
        if (index == 5 || index == 2) {
            [self showBottomTool];
        } else {
            [self hideBottomTool];
        }
    }
}

#pragma mark - SurveyDetailContenDelegate
- (void)contentDetailController:(UIViewController *)controller withHeight:(CGFloat)height {
    [self reloadTableView];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kSegmentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCellID"];
    }
    
    return cell;
}


#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger before = index - 1;
    
    //    DDLogInfo(@"after index = %d before=%d",index,before);
    
    if (before < 0) {
        return nil;
    } else {
        SurveyDetailSegmentItem *item = self.segment.segments[before];
        if (item.locked) {
            return nil;
        } else {
            return self.contentControllers[before];
        }
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger after = index + 1;
    
    //    DDLogError(@"after index = %d after=%d",index,after);
    
    if (after >= [self.contentControllers count]) {
        return nil;
    } else {
        SurveyDetailSegmentItem *item = self.segment.segments[after];
        if (item.locked) {
            return nil;
        } else {
            return self.contentControllers[after];
        }
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
    
    UIViewController *currentVc = [pageViewController.viewControllers firstObject];
    NSInteger index = [self.contentControllers indexOfObject:currentVc];
    
    if (index != self.segment.selectedIndex) {
        [self.segment changedSelectedIndex:index executeDelegate:NO];
        
        [self reloadTableView];
        
        if (self.tableView.contentOffset.y > CGRectGetHeight(self.stockHeaderView.bounds)) {
            self.tableView.contentOffset = CGPointMake(0, self.stockHeaderView.bounds.size.height);
        }
        
        if (index == 5 || index == 2) {
            [self showBottomTool];
        } else {
            [self hideBottomTool];
        }
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
- (SurveyBottomToolView *)bottomToolView {
    if (!_bottomToolView) {
        __weak SurveyDetailViewController *wself = self;
        _bottomToolView = [[SurveyBottomToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _bottomToolView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
        _bottomToolView.buttonBlock = ^(NSInteger tag) {
            if (US.isLogIn) {
                if (tag == 2) {
                    [wself niuxiongPublish];
                } else if (tag == 5) {
                    [wself askPublish];
                }
            } else {
                LoginViewController *login = [[LoginViewController alloc] init];
                [wself.navigationController pushViewController:login animated:YES];
            }
        };
    }
    return _bottomToolView;
}

- (StockManager *)stockManager {
    if (!_stockManager) {
        _stockManager = [[StockManager alloc] init];
        _stockManager.delegate = self;
    }
    
    return _stockManager;
}

- (SurveyDetailSegmentView *)segment {
    if (!_segment) {
        _segment = [[SurveyDetailSegmentView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSegmentHeight)];
        _segment.delegate = self;
        _segment.dk_backgroundColorPicker = DKColorPickerWithKey(STOCKSEGMENT);
        
        SurveyDetailSegmentItem *shidi = [[SurveyDetailSegmentItem alloc] initWithTitle:@"实地"
                                                                                  image:[UIImage imageNamed:@"ico_spot.png"]
                                                                selectedBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#69ae1d"]];
        SurveyDetailSegmentItem *duihua = [[SurveyDetailSegmentItem alloc] initWithTitle:@"对话"
                                                                                  image:[UIImage imageNamed:@"ico_dialogue.png"]
                                                                 selectedBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#5e7ef0"]];
        SurveyDetailSegmentItem *niuxiong = [[SurveyDetailSegmentItem alloc] initWithTitle:@"牛熊"
                                                                                   image:[UIImage imageNamed:@"ico_vs.png"]
                                                                   selectedBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#ff9600"]];
        SurveyDetailSegmentItem *redian = [[SurveyDetailSegmentItem alloc] initWithTitle:@"热点"
                                                                                   image:[UIImage imageNamed:@"ico_hot.png"]
                                                                 selectedBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#f65050"]];
        /*
        SurveyDetailSegmentItem *chanpin = [[SurveyDetailSegmentItem alloc] initWithTitle:@"产品篇"
                                                                                   image:[UIImage imageNamed:@"btn_chanpin_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_chanpin_select"]
                                                                     highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#43A6F3"]];
        SurveyDetailSegmentItem *wenda = [[SurveyDetailSegmentItem alloc] initWithTitle:@"问答篇"
                                                                                   image:[UIImage imageNamed:@"btn_wenda_nor"]
                                                                        highlightedImage:[UIImage imageNamed:@"btn_wenda_select"]
                                                                   highlightedTextColor:[UIColor hx_colorWithHexRGBAString:@"#26D79F"]];
         */
        _segment.segments = @[shidi,duihua,niuxiong,redian];
        
    }
    
    return _segment;
}

- (NSMutableArray *)contentControllers {
    if (!_contentControllers) {
        _contentControllers = [NSMutableArray arrayWithCapacity:4];
        
        __weak SurveyDetailViewController *wself = self;
        
        for (int i=0; i<4; i++) {
            if (i == 0) {
                SpotViewController *content = [[SpotViewController alloc] init];
                content.rootController = wself;
                content.stockId = self.stockId;
                content.tag = i;
                content.delegate = wself;
                [_contentControllers addObject:content];
            } else if (i == 1) {
                DialogueViewController *content = [[DialogueViewController alloc] init];
                content.rootController = wself;
                content.stockId = self.stockId;
                content.tag = i;
                content.delegate = wself;
                [_contentControllers addObject:content];
            } else if (i == 2) {
                SurveyDetailStockCommentViewController *niuxiongvc = [[SurveyDetailStockCommentViewController alloc] init];
                niuxiongvc.rootController = wself;
                niuxiongvc.stockId = self.stockId;
                niuxiongvc.tag = i;
                niuxiongvc.delegate = wself;
                [_contentControllers addObject:niuxiongvc];
            } else if (i == 5) {
                SurveyDetailAskViewController *askvc = [[SurveyDetailAskViewController alloc] init];
                askvc.rootController = wself;
                askvc.stockId = self.stockId;
                askvc.tag = i;
                askvc.delegate = wself;
                [_contentControllers addObject:askvc];
            } else {
                SurveyDetailWebViewController *content = [[SurveyDetailWebViewController alloc] init];
                content.rootController = wself;
                content.stockId = self.stockId;
                content.tag = i;
                content.delegate = wself;
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
