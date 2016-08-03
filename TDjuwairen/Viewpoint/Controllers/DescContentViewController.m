//
//  DescContentViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "DescContentViewController.h"
#import "TitlesTableViewCell.h"
#import "NaviMoreView.h"
#import "SelectFontView.h"
#import "UIdaynightModel.h"

#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
@import WebKit;
@interface DescContentViewController ()<UITableViewDelegate,UITableViewDataSource,NaviMoreViewDelegate,SelectFontViewDelegate,WKUIDelegate,WKNavigationDelegate>
{
    BOOL naviShow;
    BOOL fontShow;
    NSString *fontsize;
}

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NaviMoreView *nmview;
@property (nonatomic,strong) SelectFontView *sfview;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *FirstcommentArr;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic,strong) NSArray *sizeArr;

@property (nonatomic,strong) WKWebView *webview;

@end

@implementation DescContentViewController
- (NaviMoreView *)nmview{
    if (!_nmview) {
        _nmview = [[NaviMoreView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight/16*5)];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.FirstcommentArr = [NSMutableArray array];
    self.sizeArr = @[@"120%",@"110%",@"100%",@"90%"];
    naviShow = NO;
    fontShow = NO;
    fontsize = @"100%";
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [self.daynightmodel day];
    }
    else
    {
        [self.daynightmodel night];
    }
    [userdefault addObserver:self forKeyPath:@"daynight" options:NSKeyValueObservingOptionNew context:nil];
    
    self.view.backgroundColor = self.daynightmodel.navigationColor;
    
    [self requestWithData];
    
    [self setupWithNavigation];
    
    [self setupWithTableView];

    // Do any additional setup after loading the view.
}
#pragma mark - 监听daynight
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@",keyPath);
    self.view.backgroundColor = self.daynightmodel.navigationColor;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
    
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    
    [self.nmview.tableview reloadData];
    [self.tableview reloadData];
}

- (void)requestWithData{
    NSString *urlPath = @"http://192.168.1.105/tuanda_web/Appapi/index.php/View/view_show1_2/id/44";
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            self.dataDic = data;
            
            NSString *urlpath = [NSString stringWithFormat:@"http://192.168.1.105%@",self.dataDic[@"view_content_url"]];

            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlpath]]];
            
            [self.tableview reloadData];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

- (void)setupWithNavigation{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more@3x.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(naviMore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight-64-44) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TitlesTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            if (titleCell == nil) {
                titleCell = [[TitlesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            }
            [titleCell.userheadImage sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"userinfo_facesmall"]]];
            
            NSString *str =self.dataDic[@"view_addtime"];
            NSTimeInterval time = [str doubleValue];
            NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *custime = [dateFormatter stringFromDate:detaildate];
            
            titleCell.usernickname.text = self.dataDic[@"view_author"];
            titleCell.addtime.text = custime;
            titleCell.titleLabel.text = self.dataDic[@"view_title"];
            
            titleCell.usernickname.textColor = self.daynightmodel.titleColor;
            titleCell.addtime.textColor = self.daynightmodel.titleColor;
            titleCell.titleLabel.textColor = self.daynightmodel.textColor;
            titleCell.backgroundColor = self.daynightmodel.navigationColor;
            return titleCell;
        }
        else
        {
            NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (!self.webview) {
                self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.webview.UIDelegate = self;
                self.webview.navigationDelegate = self;
                /* 禁止滚动 */
                self.webview.scrollView.scrollEnabled = NO;
                
                [cell.contentView addSubview:self.webview];
            }
            [self.webview setBackgroundColor:self.daynightmodel.navigationColor];
            [self.webview.scrollView setBackgroundColor:self.daynightmodel.navigationColor];
            
            cell.backgroundColor = self.daynightmodel.navigationColor;
            return cell;
        }
    }
    else
    {
        NSString *identifier = @"commentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"测试";
        cell.textLabel.textColor = self.daynightmodel.textColor;
        cell.backgroundColor = self.daynightmodel.navigationColor;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }
        else
        {
            return self.webview.frame.size.height;
        }
    }
    else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 20;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView.isLoading) {
        return;
    }
    //调整字号
    
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fontsize];
    [webView evaluateJavaScript:jsZiti completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
    }];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5B5B5B'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='white';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='white';\
        }";
        
        [self.webview evaluateJavaScript:textcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        [self.webview evaluateJavaScript:backcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
    }
    else
    {
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#CCCCCC'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='#222222';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='#222222';\
        }";
        
        [self.webview evaluateJavaScript:textcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        [self.webview evaluateJavaScript:backcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //获取页面高度，并重置webview的frame
            CGFloat documentHeight = [result doubleValue];
            CGRect frame = webView.frame;
            frame.size.height = documentHeight + 10/*显示不全*/;
            webView.frame = frame;
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                //停止加载样式
            });
        }];
    });
}

- (void)naviMore:(UIButton *)sender{
    //显示更多菜单
    if (naviShow == NO) {
        self.nmview.alpha = 1.0;
        naviShow = YES;
    }
    else
    {
        self.nmview.alpha = 0.0;
        naviShow = NO;
    }
    
}

#pragma mark - 浮窗的代理方法
- (void)didSelectedWithIndexPath:(NSInteger)indexpath
{
    if (indexpath == 0) {
        NSLog(@"%ld",(long)indexpath);
    }else if (indexpath == 1){
        NSLog(@"%ld",(long)indexpath);
    }else if (indexpath == 2){
        
        self.sfview.alpha = 1.0;
        
    }else if (indexpath == 3){
        //读取用户设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefault objectForKey:@"daynight"];
        if ([daynight isEqualToString:@"yes"]) {
            [self.daynightmodel night];
            daynight = @"no";
            [userdefault setValue:daynight forKey:@"daynight"];
            [userdefault synchronize];
            
            NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#CCCCCC'";
            
            NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='#222222';\
            var pNode=document.getElementsByTagName('p');\
            for(var i=0;i<pNode.length;i++){\
                pNode[i].style.backgroundColor='#222222';\
            }";
            
            [self.webview evaluateJavaScript:textcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //
            }];
            [self.webview evaluateJavaScript:backcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //
            }];
        }
        else
        {
            [self.daynightmodel day];
            daynight = @"yes";
            [userdefault setValue:daynight forKey:@"daynight"];
            [userdefault synchronize];
            NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5B5B5B'";
            
            NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='white';\
            var pNode=document.getElementsByTagName('p');\
            for(var i=0;i<pNode.length;i++){\
                pNode[i].style.backgroundColor='white';\
            }";
            
            [self.webview evaluateJavaScript:textcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //
            }];
            [self.webview evaluateJavaScript:backcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //
            }];
        }
        
        self.nmview.alpha = 0.0;
        naviShow = NO;
        
    }else
    {
        NSLog(@"%ld",(long)indexpath);
    }
}

#pragma mark - 更改字体的浮窗
- (void)clickSure:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
    naviShow = NO;
    
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fontsize];
    [self.webview evaluateJavaScript:jsZiti completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
    }];
    
    [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = self.webview.frame;
        frame.size.height = documentHeight + 10/*显示不全*/;
        self.webview.frame = frame;
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            //停止加载样式
        });
    }];

}

- (void)clickCancel:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
    naviShow = NO;
}

- (void)SelectFontWithIndexPath:(NSInteger)indexPath
{
    fontsize = self.sizeArr[indexPath];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //移除观察者模式
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault removeObserver:self forKeyPath:@"daynight"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
