//
//  PlayIndividualStockContentViewController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualStockContentViewController.h"
#import "PlayIndividualContentCell.h"
#import "STPopupController.h"
#import "PlayIndividualStockViewController.h"
#import "PlayGuessViewController.h"
#import "UIViewController+STPopup.h"
#import "PlayEnjoyPeopleViewController.h"
#import "GuessAddPourViewController.h"
#import "PlayListModel.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "PlayGuessIndividua.h"
#import "CommentsViewController.h"
#import "NSObject+ChangeState.h"
#import "StockManager.h"
#import "MJRefresh.h"
#import "NotificationDef.h"

@interface PlayIndividualStockContentViewController ()<UITableViewDelegate,UITableViewDataSource,GuessAddPourDelegate,PlayGuessViewControllerDelegate,StockManagerDelegate>


@property (copy, nonatomic) NSString *listTag;

//PlayListModel
@property (nonatomic, strong) PlayGuessIndividua *guessModel;
@property (nonatomic, strong) NSDictionary *stockInfo;
@property (assign, nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, strong) StockManager *stockManager;

@end


static NSString *KPlayIndividualContentCell = @"PlayIndividualContentCell";

@implementation PlayIndividualStockContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpValue];
    [self setUpUICommon];
    
    [self onRefresh];
}

- (void)setUpValue {
    _listArr = [NSArray new];
    
    // 开启股票刷新
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.interval = 10;
    self.stockManager.delegate = self;
}

- (void)setUpUICommon {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PlayIndividualContentCell class] forCellReuseIdentifier:KPlayIndividualContentCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


- (void)setStockInfo:(NSDictionary *)stockInfo
{
    _stockInfo = stockInfo;
    [self.tableView reloadData];
}

#pragma mark - loadData
- (void)onRefresh
{
    _currentIndex = 1;
    [self guessSourceListData];
}

- (void)loadMore
{
    [self guessSourceListData];
}

#pragma mark - loadData
/// 竞猜列表
- (void)guessSourceListData
{
    /**
     名称	类型	说明	是否必填	示例	默认值
     season	int	1表示上午场，2表示下午场	是
     tag	int	0表示按时间倒序，1表示按参与人数倒序	是
     page	int	当前页码，从1开始	是
     */
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *parmark = @{
                              @"season":@(self.listSeason),
                              @"tag": @(self.listType),
                              @"page":@(self.currentIndex)
                              };
    [ma GET:API_GetGuessIndividualList parameters:parmark completion:^(id data, NSError *error) {
        NSMutableArray *arrM = nil;
        if (self.currentIndex == 1) {
            arrM = [NSMutableArray array];
        }else {
            arrM = [NSMutableArray arrayWithArray:self.listArr];
            
        }
        if (!error) {
            __block NSMutableArray *stockIds = [NSMutableArray new];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PlayListModel *model = [[PlayListModel alloc] initWithDictionary:obj];
                [arrM addObject:model];
                [stockIds addObject:model.stock];
            }];
            
            self.listArr = [arrM mutableCopy];
            [self.stockManager addStocks:stockIds];
            [self.tableView reloadData];
            _currentIndex++;
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)reloadWithStocks:(NSDictionary *)stocks
{
    self.stockInfo = stocks;
}


- (void)addWithGuessId:(NSString *)stockId pri:(float)pri season:(NSInteger)season
{
    NetworkManager *ma = [[NetworkManager alloc] init];
    __weak PlayIndividualStockContentViewController *wself = self;
    NSDictionary *parmark = @{
                              @"season":@(season),
                              @"stock":SafeValue(stockId),
                              @"points":@(pri),
                              };
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    
    [ma POST:API_AddGuessIndividual parameters:parmark completion:^(id data, NSError *error) {
        [view stopAnimating];
        
        void (^errorBlock)(NSString *) = ^(NSString *title){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = title;
            [hud hide:YES afterDelay:0.5];
        };
        
        if (!error && data) {
            BOOL status = [data[@"status"] boolValue];
            if (status) {
                errorBlock(@"投注成功，等待开奖");
                
                [wself reloadCellWithStockId:stockId];
            } else {
                errorBlock(error.localizedDescription?:@"竞猜失败");
            }
        } else {
            errorBlock(error.localizedDescription?:@"竞猜失败");
        }
    }];
}


- (void)reloadCellWithStockId:(NSString *)stockId {
    
    [self.listArr enumerateObjectsUsingBlock:^(PlayListModel *obj, NSUInteger idx, BOOL *stop){
        if ([obj.stock isEqualToString:stockId]) {
            
            obj.has_join = YES;
            obj.guess_item_num += 1;
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            *stop = YES;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddJoinGuessNotification object:nil];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayListModel *model = _listArr[indexPath.row];
    StockInfo *sInfo = [self.stockInfo objectForKey:model.stock];
    PlayIndividualContentCell *cell = [PlayIndividualContentCell loadCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupStock:sInfo];
    cell.model = model;
    AddLineAtBottom(cell);
    
    cell.guessBlock = ^(UIButton *btn){
        PlayGuessViewController *vc = [[PlayGuessViewController alloc] init];
        vc.season = [model.guess_season integerValue];
        vc.stockInfo = sInfo;
        vc.delegate = self;
        vc.view.frame = CGRectMake(0, 0, kScreenWidth, 275);
        vc.inputView.userInteractionEnabled = NO;
        vc.inputView.text = model.com_code;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, 275);
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    };
    
    cell.enjoyBlock = ^(){
        PlayEnjoyPeopleViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayEnjoyPeopleViewController"];
        
        vc.guessID = [NSString stringWithFormat:@"%@",model.guess_id];
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.containerView.layer.cornerRadius = 4;
        popupController.navigationBarHidden = YES;
        popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth-80, 220);
        popupController.style = STPopupTransitionStyleSlideVertical;
        [popupController presentInViewController:self];
        
    };
    
    cell.moneyBlock = ^(){
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141.0f;
}


#pragma mark - GuessAddPourDelegate
- (void)addWithGuessId:(NSString *)guessId pri:(float)pri keyNum:(NSInteger)keyNum {
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSString *point = [NSString stringWithFormat:@"%.2f",pri];
    
    NSDictionary *dict = @{@"guess_id": guessId, @"keynum": @(keyNum), @"points": point};
    if (US.isLogIn) {
        dict = @{@"user_id": US.userId, @"guess_id": guessId, @"keynum": @(keyNum), @"points": point};
    }
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    
    __weak PlayIndividualStockContentViewController *wself = self;
    [ma POST:API_GuessAddJoin parameters:dict completion:^(id data, NSError *error){
        
        [view stopAnimating];
        
        void (^errorBlock)(NSString *) = ^(NSString *title){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"竞猜失败";
            [hud hide:YES afterDelay:0.5];
        };
        
        if (!error && data) {
            BOOL status = [data[@"status"] boolValue];
            if (status) {
                
            } else {
                errorBlock(@"竞猜失败");
            }
        } else {
            errorBlock(@"竞猜失败");
        }
        
        
    }];
    
}

- (void)commentPressed:(UIButton *)sender{
    if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转评论管理页面
    {
        CommentsViewController *comments = [[CommentsViewController alloc] init];
        comments.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:comments animated:YES];
    }
}

- (void)dealloc {
    
    
    [self.stockManager stopThread];
}

@end
