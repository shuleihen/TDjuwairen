//
//  SurDetailViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurDetailViewController.h"
#import "NMView.h"
#import "SelectFontView.h"
#import "SurDataView.h"
#import "SurDetailSelBtnView.h"
#import "ChildDetailTableViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"
#import "UnlockView.h"
#import "RechargeView.h"
#import "SelWXOrAlipayView.h"
#import "FeedbackViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "NetworkManager.h"
#import "UIStoryboard+MainStoryboard.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface SurDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NMViewDelegate,SelectFontViewDelegate,SurDetailSelBtnViewDelegate,ChildDetailDelegate,unlockViewDelegate,RechargeViewDelegate,SelWXOrAlipayViewDelegate>
{
    CGSize contentSize;
}
@property (nonatomic,assign) int tag;

@property (nonatomic,strong) NMView *nmview;

@property (nonatomic,strong) SelectFontView *sfview;
@property (nonatomic,strong) NSArray *sizeArr;
@property (nonatomic,copy) NSString *fontsize;

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) SurDataView *dataView;

@property (nonatomic,strong) SurDetailSelBtnView *selBtnView;

@property (nonatomic,strong) NSMutableArray *tableviewsArr;

@property (nonatomic,strong) UIScrollView *contentScrollview;

@property (nonatomic,strong) UIButton *comBtn;

@property (nonatomic,strong) UIImageView *comImg;

@property (nonatomic,strong) UnlockView *unlockView;          //解锁页面

@property (nonatomic,strong) RechargeView *rechargeView;      //充值页面

@property (nonatomic,strong) SelWXOrAlipayView *payView;      //选择支付页面

@property (nonatomic,strong) NSString *keysNum;

@end

@implementation SurDetailViewController

- (NMView *)nmview{
    if (!_nmview) {
        _nmview = [[NMView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-176, kScreenWidth, 176)];
        _nmview.delegate = self;
        [self.view addSubview:_nmview];
    }
    return _nmview;
}

- (SelectFontView *)sfview{
    if (!_sfview) {
        _sfview = [[SelectFontView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3*2, 300)];
        _sfview.center = self.view.center;
        _sfview.delegate = self;
        [self.view addSubview:_sfview];
    }
    return _sfview;
}

- (void)createUnLockView{
    self.unlockView = [[UnlockView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) andCompany_name:self.company_name];
    self.unlockView.delegate = self;
    if (US.isLogIn) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSString *url = [NSString stringWithFormat:@"%@Survey/getUserKeyNum",kAPI_songsong];
        NSDictionary *para = @{@"user_id":US.userId};
        [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *data = responseObject[@"data"];
            NSString *keyNum = data[@"keyNum"];
            self.unlockView.balanceLab.text = [NSString stringWithFormat:@"账户余额 %@",keyNum];
            [self.unlockView.unlockBtn setTitle:@"解锁" forState:UIControlStateNormal];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    else
    {
        self.unlockView.balanceLab.text = [NSString stringWithFormat:@"账户余额 0"];
        [self.unlockView.unlockBtn setTitle:@"充值" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.unlockView];
}

- (void)createChargeView{
    self.rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.rechargeView.delegate = self;
    [self.view addSubview:self.rechargeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    contentSize.height = kScreenHeight-64-60;
    self.tag = 0;
    self.sizeArr = @[@"140%",@"120%",@"100%",@"80%"];
    self.fontsize = @"100%";
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self setupWithDateView];
    [self addChildViewController];
    
    [self setupWithCommentBtn];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
//    ChildDetailTableViewController *childView = self.tableviewsArr[self.tag];
//    [childView requestWithSelBtn:self.tag WithSurveyID:self.company_code];
    //监听日夜间模式
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [self.daynightModel day];
    }
    else
    {
        [self.daynightModel night];
    }
    [userdefault addObserver:self forKeyPath:@"daynight" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.unlockView) {
        [self.unlockView removeFromSuperview];
        [self createUnLockView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //移除观察者模式
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault removeObserver:self forKeyPath:@"daynight"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听daynightModel
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"daynight"]) {
        self.view.backgroundColor = self.daynightModel.navigationColor;
        self.contentScrollview.backgroundColor = self.daynightModel.backColor;
        [self.navigationController.navigationBar setBackgroundColor:self.daynightModel.navigationColor];
        [self.navigationController.navigationBar setBarTintColor:self.daynightModel.navigationColor];
        
        //tableheadView
        self.dataView.backgroundColor = self.daynightModel.navigationColor;
        self.dataView.yestodEndPri.textColor = self.daynightModel.titleColor;
        self.dataView.todayStartPri.textColor = self.daynightModel.titleColor;
        self.dataView.todayMax.textColor = self.daynightModel.titleColor;
        self.dataView.todayMin.textColor = self.daynightModel.titleColor;
        self.dataView.traNumber.textColor = self.daynightModel.titleColor;
        self.dataView.traAmount.textColor = self.daynightModel.titleColor;

        [self.tableview reloadData];
    }
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = self.company_name;
    
    [self.navigationController.navigationBar setBackgroundColor:self.daynightModel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightModel.navigationColor];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more@3x.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(naviMore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight = kScreenHeight-64-60;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.backgroundColor = self.daynightModel.navigationColor;
    self.tableview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*5);
    [self.view addSubview:self.tableview];
}

- (void)setupWithDateView{
    self.dataView = [[SurDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140) WithStockID:self.company_code];
    
    self.tableview.tableHeaderView = self.dataView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.selBtnView = [[SurDetailSelBtnView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, 60) WithStockCode:self.company_code];
    
    UIButton *btn = self.selBtnView.btnsArr[self.tag];
    self.selBtnView.selBtn.selected = NO;
    btn.selected = YES;
    self.selBtnView.selBtn = btn;
    
    self.selBtnView.delegate = self;
    self.selBtnView.backgroundColor = self.daynightModel.navigationColor;
    return self.selBtnView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (!self.contentScrollview) {
        self.contentScrollview = [[UIScrollView alloc]init];
        self.contentScrollview.delegate = self;
        self.contentScrollview.showsHorizontalScrollIndicator = NO;
        self.contentScrollview.showsVerticalScrollIndicator = NO;
        self.contentScrollview.pagingEnabled = YES;
        self.contentScrollview.backgroundColor = self.daynightModel.navigationColor;
        [cell.contentView addSubview:self.contentScrollview];
        
        [self.contentScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(0);
            make.left.equalTo(cell.contentView).with.offset(0);
            make.bottom.equalTo(cell.contentView).with.offset(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenHeight-140-60);
        }];
        
        self.contentScrollview.contentSize = CGSizeMake(kScreenWidth*6, 0);
        if (self.selBtnView.isLocked) {
            self.selBtnView.selBtn = self.selBtnView.btnsArr[0];
            self.tag = 0;
        }
        else
        {
            self.selBtnView.selBtn = self.selBtnView.btnsArr[3];
            self.tag = 3;
        }
        [self selectWithDetail:self.selBtnView.selBtn];
    }
    cell.backgroundColor = self.daynightModel.backColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight-64-60;
}

- (void)addChildViewController{
    self.tableviewsArr = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        ChildDetailTableViewController *childView = [[ChildDetailTableViewController alloc] init];
        childView.delegate = self;
        childView.tableView.bounces = NO;
        [self.tableviewsArr addObject:childView];
        [self addChildViewController:childView];
    }
}

#pragma mark - SurDetailSelBtnView Delegate   点击选择
- (void)selectWithDetail:(UIButton *)sender
{
    self.selBtnView.selBtn.selected = NO;
    sender.selected = YES;
    self.selBtnView.selBtn = sender;
    
    if (self.selBtnView) {
        int i = (int)sender.tag;
        self.tag = i;
    }
    if (self.tag == 2 ) {
        self.comBtn.alpha = 1.0;
        self.comImg.image = [UIImage imageNamed:@"comment_blue"];
        [self.comBtn setTitle:@" 评论" forState:UIControlStateNormal];
    }
    else if (self.tag == 5){
        self.comBtn.alpha = 1.0;
        self.comImg.image = [UIImage imageNamed:@"tiwen"];
        [self.comBtn setTitle:@" 提问" forState:UIControlStateNormal];
    }
    else
    {
        self.comBtn.alpha = 0.0;
    }
    CGFloat x = self.tag * kScreenWidth;
    self.contentScrollview.contentOffset = CGPointMake(x, 0);
    ChildDetailTableViewController *childView = self.tableviewsArr[self.tag];
    [self setUpOneChildController:self.tag];
    [childView requestWithSelBtn:self.tag WithSurveyID:self.company_code];
    
    //显示解锁
    if (self.selBtnView.isLocked) {
        if (self.tag < 3) {
            [self createUnLockView];
        }
        else
        {
            [self.unlockView removeFromSuperview];
        }
    }
}

- (void)setUpOneChildController:(NSInteger)index {
    CGFloat x  = index * kScreenWidth;
    ChildDetailTableViewController *vc = self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.backgroundColor = self.daynightModel.navigationColor;
    [self.contentScrollview addSubview:vc.view];
    if (index == 2 || index == 5) {
        [vc.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentScrollview).with.offset(0);
            make.left.equalTo(self.contentScrollview).with.offset(x);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenHeight-64-60-50);
        }];
    }
    else
    {
        [vc.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentScrollview).with.offset(0);
            make.left.equalTo(self.contentScrollview).with.offset(x);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenHeight-64-60);
        }];
    }
}

#pragma mark - 设置隐藏评论按钮
- (void)setupWithCommentBtn{
    self.comBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50)];
    [self.comBtn setBackgroundColor:self.daynightModel.navigationColor];
    [self.comBtn setTitle:@" 评论" forState:UIControlStateNormal];
    [self.comBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.comBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15)];
    
    self.comImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.comBtn.titleLabel.frame.origin.x - 40, (50-15)/2, 20, 20)];
    self.comImg.image = [UIImage imageNamed:@"comment_blue"];
    [self.comBtn addSubview:self.comImg];
    self.comBtn.alpha = 0.0;
    [self.view addSubview:self.comBtn];
    
    [self.comBtn addTarget:self action:@selector(clickToAsk:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 滑动操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //这里不写方法不生效- -
    self.nmview.alpha = 0.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSString *rollway = [NSString stringWithFormat:@"%@",[scrollView class]];
    if ([rollway isEqualToString:@"UIScrollView"]) {
        NSInteger i = self.contentScrollview.contentOffset.x / kScreenWidth;
        self.tag = (int)i;
        if (i == 2 ) {
            self.comBtn.alpha = 1.0;
            self.comImg.image = [UIImage imageNamed:@"comment_blue"];
            [self.comBtn setTitle:@" 评论" forState:UIControlStateNormal];
        }
        else if (i == 5){
            self.comBtn.alpha = 1.0;
            self.comImg.image = [UIImage imageNamed:@"tiwen"];
            [self.comBtn setTitle:@" 提问" forState:UIControlStateNormal];
        }
        else
        {
            self.comBtn.alpha = 0.0;
        }
        UIButton *btn = self.selBtnView.btnsArr[i];
        self.selBtnView.selBtn.selected = NO;
        btn.selected = YES;
        self.selBtnView.selBtn = btn;
        
        ChildDetailTableViewController *childView = self.tableviewsArr[i];
        [self setUpOneChildController:i];
        [childView requestWithSelBtn:(int)i WithSurveyID:self.company_code];
        
        //显示解锁
        if (self.selBtnView.isLocked) {
            if (self.tag < 3) {
                [self createUnLockView];
            }
            else
            {
                [self.unlockView removeFromSuperview];
            }
        }
    }
}

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView
{
    ChildDetailTableViewController *childTableView = self.tableviewsArr[self.tag];
    if (scrollView.contentOffset.y < 140) {
        self.tableview.contentOffset = scrollView.contentOffset;
        
        if (self.tag == 2 || self.tag == 5) {
            [childTableView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kScreenHeight-64-60-50-(140-scrollView.contentOffset.y));
            }];
        }
    }
    else
    {
        self.tableview.contentOffset = CGPointMake(0, 140);
    }
    
    self.nmview.alpha = 0.0;
}

#pragma mark - 点击出现更多选项
- (void)naviMore:(UIButton *)sender{
    if (self.nmview.alpha == 1.0) {
        self.nmview.alpha = 0.0;
    }
    else
    {
        self.nmview.alpha = 1.0;
    }
}

- (void)selectWithNMViewTableView:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //读取用户设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefault objectForKey:@"daynight"];
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"日间模式"]) {
            [self.daynightModel night];
            daynight = @"no";
            [userdefault setValue:daynight forKey:@"daynight"];
            [userdefault synchronize];
        }
        else //夜间
        {
            [self.daynightModel day];
            daynight = @"yes";
            [userdefault setValue:daynight forKey:@"daynight"];
            [userdefault synchronize];
        }
    }
    else if (indexPath.row == 1){
        self.nmview.alpha = 0.0;
        self.sfview.alpha = 1.0;
        self.sfview.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-64);
    }
    else if (indexPath.row == 2){
        [self clickShare];
    }
    else if (indexPath.row == 3){
        //跳转反馈
        if (US.isLogIn) {
            FeedbackViewController *feedback = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FeedbackView"];
            [self.navigationController pushViewController:feedback animated:YES];
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}

#pragma mark - 更改字体的浮窗
- (void)clickSure:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
    
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",self.fontsize];
    ChildDetailTableViewController *childView = self.tableviewsArr[self.tag];
    [childView.webview evaluateJavaScript:jsZiti completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
    }];
}

- (void)clickCancel:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
}

- (void)SelectFontWithIndexPath:(NSInteger)indexPath
{
    self.fontsize = self.sizeArr[indexPath];
}

#pragma mark - 点击隐藏解锁页面
- (void)closeUnlockView:(UIButton *)sender
{
    [self.unlockView removeFromSuperview];
    if (self.selBtnView.isLocked) {
        self.selBtnView.selBtn.selected = NO;
        self.selBtnView.selBtn = self.selBtnView.btnsArr[3];
        [self selectWithDetail:self.selBtnView.selBtn];
    }
}

- (void)closeRechargeView:(UIButton *)sender
{
    [self.rechargeView removeFromSuperview];
    if (self.selBtnView.isLocked) {
        self.selBtnView.selBtn.selected = NO;
        self.selBtnView.selBtn = self.selBtnView.btnsArr[3];
        [self selectWithDetail:self.selBtnView.selBtn];
    }
}

- (void)closeSelWXOrAlipayView:(UIButton *)sender
{
    [self.payView removeFromSuperview];
    if (self.selBtnView.isLocked) {
        self.selBtnView.selBtn.selected = NO;
        self.selBtnView.selBtn = self.selBtnView.btnsArr[3];
        [self selectWithDetail:self.selBtnView.selBtn];
    }
}

#pragma mark - 充值或解锁
- (void)clickUnlockOrRecharge:(UIButton *)sender
{
    if (US.isLogIn) {
        if ([sender.titleLabel.text isEqualToString:@"充值"]) {     //进入选择充值页面
            [self.unlockView removeFromSuperview];
            [self createChargeView];
        }
        else
        {
            //解锁
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
            NSString *urlString = [NSString stringWithFormat:@"%@Survey/unlockCompany",kAPI_songsong];
            NSString *code = [self.company_code substringFromIndex:2];
            NSDictionary *para = @{@"user_id":US.userId,
                                   @"code":code};
            [manager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self.unlockView removeFromSuperview];
                [self.tableview reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
    else
    {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

//充值
- (void)clickRecharge:(UIButton *)sender
{
    if (sender.tag == 0) {
        self.keysNum = @"1";
    }
    else if (sender.tag == 1){
        self.keysNum = @"5";
    }
    else if (sender.tag == 2){
        self.keysNum = @"10";
    }
    else
    {
        self.keysNum = @"VIP";
    }
    //进入选择付款页面
    [self.rechargeView removeFromSuperview];
    self.payView = [[SelWXOrAlipayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.payView.delegate = self;
    [self.view addSubview:self.payView];
}

#pragma mark - 进入支付
- (void)didSelectWXOrZhifubao:(NSIndexPath *)indePath
{
    if (indePath.row == 0) { //支付宝支付
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 设置请求接口回来的时候支持什么类型的数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSDictionary *dic;
        if (![self.keysNum isEqualToString:@"VIP"]) {
            dic = @{@"type":@"1",
                    @"number":self.keysNum,
                    @"version":@"1.0",
                    @"user_id":US.userId};
        }
        else
        {
            dic = @{@"type":@"2",   //type = 2 表示充值VIP
                    @"number":@"1",
                    @"version":@"1.0",
                    @"user_id":US.userId};
        }
        
        NSString *url = [NSString stringWithFormat:@"%@Survey/alipayKey",kAPI_songsong];
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *orderString = dic[@"data"];
            NSString *appScheme = @"TDjuwairen";
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    else    //微信支付
    {
        NSString *urlString   = [NSString stringWithFormat:@"%@Survey/wxpayKey",kAPI_songsong];
        NSDictionary *dic;
        if (![self.keysNum isEqualToString:@"VIP"]) {
            dic = @{@"type":@"1",
                                   @"number":self.keysNum,
                                   @"user_id":US.userId,
                                   @"device":@"1"};
        }
        else
        {
            dic = @{@"type":@"2",
                                   @"number":@"1",
                                   @"user_id":US.userId,
                                   @"device":@"1"};
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *str = dic[@"data"];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *order = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&err];
            NSLog(@"%@",order);
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID = [order objectForKey:@"appid"];
            req.partnerId           = [order objectForKey:@"mch_id"];
            req.prepayId            = [order objectForKey:@"prepay_id"];
            req.nonceStr            = [order objectForKey:@"nonce_str"];
            req.timeStamp           = [[order objectForKey:@"timestamp"] intValue];
            req.package             = @"Sign=WXPay";
            req.sign                = [order objectForKey:@"sign"];
            [WXApi sendReq:req];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - 点击跳转提问界面
- (void)clickToAsk:(UIButton *)sender{
    
    ChildDetailTableViewController *childView = self.tableviewsArr[self.tag];
    
    CommentViewController *comView = [[CommentViewController alloc] init];
    comView.tag = self.tag;
    comView.company_code = self.company_code;
    if (childView.niuxiong == 1) {
        comView.type = @"bull";
    }
    else if (childView.niuxiong == 0)
    {
        comView.type = @"bear";
    }
    if(self.tag == 5)
    {
        comView.type = @"ask";
    }
    
    if (US.isLogIn) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"发布牛评" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //牛评
            [self.navigationController pushViewController:comView animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"发布熊评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //熊评
            [self.navigationController pushViewController:comView animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //熊评
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - 分享
- (void)clickShare{
    //1、创建分享参数
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *code = [self.company_code substringFromIndex:2];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:@[self.survey_cover]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/Survey/%@",code]]
                                      title:self.company_name
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
