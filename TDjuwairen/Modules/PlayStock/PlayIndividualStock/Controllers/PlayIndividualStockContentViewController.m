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

@interface PlayIndividualStockContentViewController ()<UITableViewDelegate,UITableViewDataSource,GuessAddPourDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
static NSString *KPlayIndividualContentCell = @"PlayIndividualContentCell";

@implementation PlayIndividualStockContentViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[PlayIndividualContentCell class] forCellReuseIdentifier:KPlayIndividualContentCell];
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (CGFloat)viewHeight {

    return self.tableView.contentSize.height;
}

- (void)setListArr:(NSArray *)listArr{
    _listArr = listArr;
    [self.tableView reloadData];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, self.tableView.contentSize.height);
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
    PlayIndividualContentCell *cell = [PlayIndividualContentCell loadCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
#pragma mark - 参与竞猜
    cell.guessBlock = ^(UIButton *btn){
        
        GuessAddPourViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessAddPourViewController"];
        vc.userKeyNum = [_guessModel.user_keynum integerValue];
        vc.nowPri = 0;
        vc.guessId = [NSString stringWithFormat:@"%@",model.guess_id];
        vc.delegate = self;
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:_superVC];
    };
    
#pragma mark - 参与人数
    cell.enjoyBlock = ^(){
        PlayEnjoyPeopleViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayEnjoyPeopleViewController"];
        //        vc.userKeyNum = self.keyNum;
        //        vc.nowPri = stock.nowPriValue;
        //        vc.guessId = guess.guessId;
        //        vc.delegate = self;
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
        popupController.navigationBarHidden = YES;
        popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth-80, 220);
        popupController.style = STPopupTransitionStyleSlideVertical;
        [popupController presentInViewController:_superVC];
        
    };
#pragma mark - 奖励
    cell.moneyBlock = ^(){
        
    };
    
    return cell;
}



#pragma mark - GuessAddPourDelegate
- (void)addWithGuessId:(NSString *)guessId pri:(float)pri keyNum:(NSInteger)keyNum {
    /*
     __weak StockIndexViewController *wself = self;
     for (int i=0;i < [self.guessList count];i++) {
     StockGuessModel *guess = self.guessList[i];
     if ([guess.guessId isEqualToString:guessId]) {
     
     [wself addAnimationWithGuessId:guessId withPri:pri];
     [wself queryGuessStock];
     [wself playAudio];
     }
     
     }
     
     return;
     
     */
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#101115"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.guessModel.guess_comment_count > 0) {
        NSString *title = [NSString stringWithFormat:@"评价(%@)",self.guessModel.guess_comment_count];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
    } else {
        [btn setTitle:@"评价" forState:UIControlStateNormal];
        [btn setTitle:@"评价" forState:UIControlStateHighlighted];
    }
    
    [view addSubview:btn];
    return view;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
- (void)commentPressed:(UIButton *)sender{
    if (US.isLogIn==NO) {//检查是否登录，没有登录直接跳转登录界面
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.superVC.navigationController pushViewController:login animated:YES];
    }
    else//登录后 跳转评论管理页面
    {
        CommentsViewController *comments = [[CommentsViewController alloc] init];
        comments.hidesBottomBarWhenPushed = YES;
        [self.superVC.navigationController pushViewController:comments animated:YES];
    }
}

#pragma mark -



#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//[tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

#pragma mark -


@end
