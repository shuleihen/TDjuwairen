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
#import "CommentsModel.h"
#import "CommentsCell.h"
#import "TimeHotComView.h"
#import "BackCommentView.h"
#import "LoginState.h"
#import "LoginViewController.h"

#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "NSString+Ext.h"
#import "MBProgressHUD.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@import WebKit;
@interface DescContentViewController ()<UITableViewDelegate,UITableViewDataSource,NaviMoreViewDelegate,SelectFontViewDelegate,TimeHotComViewDelegate,BackCommentViewDelegate,WKUIDelegate,WKNavigationDelegate,UITextFieldDelegate>
{
    BOOL naviShow;
    BOOL fontShow;
    NSString *fontsize;
    CGSize titlesize;
    CGSize commentsize;
    CGSize floorviewsize;
    BOOL firstClickComment;
}
@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NaviMoreView *nmview;
@property (nonatomic,strong) SelectFontView *sfview;
@property (nonatomic,strong) TimeHotComView *thview;
/* 评论条 */
@property (nonatomic,strong) BackCommentView *backcommentview;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *FirstcommentArr;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic,strong) NSArray *sizeArr;

@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,strong) UIButton *selTimeHotBtn;

@property (nonatomic,strong) MBProgressHUD *hudload;

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
    firstClickComment = YES;
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.loginState = [LoginState addInstance];
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
    self.thview.timeBtn.selected = YES;
    
    [self setupWithNavigation];
    
    [self setupWithTableView];

    [self setupWithCommentView];
    [self requestWithData];
    [self requestWithCommentDataWithTimeHot];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)viewTapped:(UIButton *)sender{
    [self.view endEditing:YES];
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
    
    self.hudload = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hudload.labelText = @"加载中...";
    
    NSString *urlPath = @"http://192.168.1.109/tuanda_web/Appapi/View/view_show1_2/id/55";
//    NSString *urlPath = [NSString stringWithFormat:@"%@View/view_show1_2/id/%@",kAPI_bendi,self.view_id];
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            self.dataDic = data;
            
            NSString *urlpath = [NSString stringWithFormat:@"http://192.168.1.109%@",self.dataDic[@"view_content_url"]];

            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlpath]]];
            
            [self.tableview reloadData];
        }
        else
        {
            NSLog(@"%@",error);
            self.hudload.labelText = @"加载失败";
            [self.hudload hide:YES afterDelay:0.1];
        }
    }];
}

- (void)requestWithCommentDataWithTimeHot{
    NSString *urlPath ;
    if (self.thview.timeBtn.selected == YES) {
        urlPath = [NSString stringWithFormat:@"%@/View/GetViewComment1_2",kAPI_bendi];
    }
    else
    {
        urlPath = [NSString stringWithFormat:@"%@/View/GetViewComment1_2",kAPI_bendi];
    }
    NSDictionary *dic = @{@"type":@"view",
                          @"id":@"42", 
                          @"loadedLength":@"0"};
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:urlPath parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *arr = data;
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                CommentsModel *fModel = [CommentsModel getInstanceWithDictionary:dic];
                [self.FirstcommentArr addObject:fModel];
            }
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight-64-50) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    
    [self.view addSubview:self.tableview];
}

- (void)setupWithCommentView{
    self.backcommentview = [[BackCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50)];
    
    self.backcommentview.delegate = self;
    self.backcommentview.commentview.delegate = self;
    
    [self.view addSubview:self.backcommentview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return self.FirstcommentArr.count;
    }
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
            NSString *text = self.dataDic[@"view_title"];
            UIFont *font = [UIFont systemFontOfSize:16];
            titleCell.titleLabel.font = font;
            titleCell.titleLabel.numberOfLines = 0;
            titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
            titlesize = [text calculateSize:titlesize font:font];
            titleCell.titleLabel.text = text;
            titleCell.titleLabel.frame = CGRectMake(15, 10+50+10, kScreenWidth-30, titlesize.height);
            
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
        CommentsModel *model = self.FirstcommentArr[indexPath.row];
        CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andArr:model.secondArr];
        }
        floorviewsize = cell.floorView.frame.size;
        
        NSString *comment = model.viewcomment;
        UIFont *font = [UIFont systemFontOfSize:16];
        cell.commentLab.font = font;
        cell.commentLab.numberOfLines = 0;
        commentsize = CGSizeMake(kScreenWidth-70, 20000.0f);
        commentsize = [comment calculateSize:commentsize font:font];
        [cell.commentLab setFrame:CGRectMake(55, 10+15+10+cell.floorView.frame.size.height+15, kScreenWidth-70, commentsize.height)];
        
        NSString *s = [NSString stringWithFormat:@"http://static.juwairen.net/Pc/Uploads/Images/Face/%@",model.user_headImg];
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:s]];
        cell.nickNameLab.text = [NSString stringWithFormat:@"%@  %@",model.user_nickName,model.viewcommentTime];
        cell.numfloor.text = [NSString stringWithFormat:@"%lu楼",self.FirstcommentArr.count-indexPath.row];
        cell.commentLab.text = model.viewcomment;
        
        cell.nickNameLab.textColor = self.daynightmodel.titleColor;
        cell.numfloor.textColor = self.daynightmodel.titleColor;
        cell.commentLab.textColor = self.daynightmodel.textColor;
        cell.line.backgroundColor = self.daynightmodel.titleColor;
        cell.backgroundColor = self.daynightmodel.navigationColor;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else
    {
        if (!self.thview) {
            self.thview = [[TimeHotComView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            self.thview.delegate = self;
            self.thview.timeBtn.selected = YES;
            self.selTimeHotBtn = self.thview.timeBtn;
            
            [self.thview.timeBtn setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
            [self.thview.timeBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
            
            [self.thview.hotBtn setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
            [self.thview.hotBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
        }
        self.thview.backgroundColor = self.daynightmodel.navigationColor;
        self.thview.just.textColor = self.daynightmodel.textColor;
        return self.thview;
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

        return 10+15+10+floorviewsize.height+15+commentsize.height+15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    else
    {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
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
                self.hudload.labelText = @"加载完成";
                [self.hudload hide:YES afterDelay:0.1];
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

#pragma mark - timehot delegate with comment
- (void)justLouzhu:(UIButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
    }
    else
    {
        sender.selected = YES;
    }
}

- (void)selectTime:(UIButton *)sender
{
    self.selTimeHotBtn.selected = NO;
    if (sender.selected == YES) {
        sender.selected = NO;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
    else
    {
        sender.selected = YES;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
}

- (void)selectHot:(UIButton *)sender
{
    self.selTimeHotBtn.selected = NO;
    if (sender.selected == YES) {
        sender.selected = NO;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
    else
    {
        sender.selected = YES;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
}

#pragma mark - backcomment.delegate
- (void)clickComments:(UIButton *)sender{
    
    //滑动到评论
    
    if (firstClickComment) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
        firstClickComment = NO;
    }
    else
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)clickShare:(UIButton *)sender{
    //释放键盘第一响应
    [self.backcommentview.commentview resignFirstResponder];
    //1、创建分享参数
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:@[self.dataDic[@"userinfo_facesmall"]]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/View/%@",self.dataDic[@"view_id"]]]
                                      title:self.dataDic[@"view_title"]
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //判断当前是否为登录状态,不是则去登录
    if (!self.loginState.isLogIn) {
        [self.backcommentview removeFromSuperview];
        //登录
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.loginState.isLogIn) {
        //进行身份验证
//        [self requestAuthentication];
    }
    [self registerForKeyboardNotifications];
}

#pragma mark - 监听键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

//当键盘出现时计算键盘的高度大小，用于输入框显示
- (void)keyboardWasShown:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    //kbSize为键盘尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    [self beginMoveUpAnimation:kbSize.height];
    
}

//当键盘隐藏时
- (void)keyboardWillBeHidden{
        self.backcommentview.transform = CGAffineTransformIdentity;
}

- (void)beginMoveUpAnimation:(CGFloat )height{
        self.backcommentview.transform = CGAffineTransformMakeTranslation(0, -height);
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
@end
