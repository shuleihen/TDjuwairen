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
#import "FeedbackViewController.h"
#import "SharpTags.h"
#import "SearchViewController.h"

#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "NSString+Ext.h"
#import "MBProgressHUD.h"
#import "UIStoryboard+MainStoryboard.h"
#import "HexColors.h"
#import "YXFont.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@import WebKit;
@interface DescContentViewController ()<UITableViewDelegate,UITableViewDataSource,NaviMoreViewDelegate,SelectFontViewDelegate,TimeHotComViewDelegate,BackCommentViewDelegate,FloorInFloorViewDelegate,SharpTagsDelegate,WKUIDelegate,WKNavigationDelegate,UITextFieldDelegate>
{
    BOOL naviShow;
    BOOL fontShow;
    NSString *fontsize;
    CGSize titlesize;
    CGSize commentsize;
    CGSize floorviewsize;
    BOOL firstClickComment;
}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NaviMoreView *nmview;
@property (nonatomic,strong) SelectFontView *sfview;
@property (nonatomic,strong) TimeHotComView *thview;
/* 评论条 */
@property (nonatomic,strong) BackCommentView *backcommentview;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *FirstcommentArr;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) LoginState *loginState;

@property (nonatomic,strong) NSArray *sizeArr;

@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,strong) UIButton *selTimeHotBtn;

@property (nonatomic,strong) MBProgressHUD *hudload;

@property (nonatomic,strong) NSString *encryptedStr;

@property (nonatomic,strong) SharpTags *tagList;
@property (nonatomic,strong) NSMutableArray *sharpTagsArray;

@property (nonatomic,strong) NSString *pid;

@end

@implementation DescContentViewController
- (NaviMoreView *)nmview{
    if (!_nmview) {
        //        _nmview = [[NaviMoreView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight/16*5)];
        NSString *str = @"yes";

        _nmview = [[NaviMoreView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight/16*5) withString:str];
        
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
    self.sharpTagsArray = [NSMutableArray array];
    self.sizeArr = @[@"120%",@"110%",@"100%",@"90%"];
    naviShow = NO;
    fontShow = NO;
    fontsize = @"100%";
    firstClickComment = YES;
    self.pid = @"0";
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    
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
    self.nmview.alpha = 0.0;
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
    
    self.backcommentview.backgroundColor = self.daynightmodel.backColor;
    self.backcommentview.commentview.backgroundColor = self.daynightmodel.inputColor;
    self.backcommentview.commentview.textColor = self.daynightmodel.textColor;
    self.backcommentview.commentview.layer.borderColor = self.daynightmodel.lineColor.CGColor;
    
    [self.nmview.tableview reloadData];
    [self.tableview reloadData];
}

- (void)requestWithData{
    
    self.hudload = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hudload.labelText = @"加载中...";
    
    NSString *urlPath ;
    if (US.isLogIn) {
        urlPath= [NSString stringWithFormat:@"%@index.php/View/view_show1_2/id/%@/userid/%@",API_HOST,self.view_id,US.userId];
    }
    else
    {
        urlPath = [NSString stringWithFormat:@"%@index.php/View/view_show1_2/id/%@",API_HOST,self.view_id];
    }
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            self.dataDic = data;
            
            self.sharpTagsArray = self.dataDic[@"tags"];
            NSString *urlpath = [NSString stringWithFormat:@"http://appapi.juwairen.net%@",self.dataDic[@"view_content_url"]];

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
        urlPath = [NSString stringWithFormat:@"%@index.php/View/GetViewComment1_2",API_HOST];
    }
    else
    {
        urlPath = [NSString stringWithFormat:@"%@index.php/View/GetViewComment1_2",API_HOST];
    }
    NSDictionary *dic = @{@"type":@"view",
                          @"id":self.view_id,
                          @"loadedLength":@"0"};
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:urlPath parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            [self.FirstcommentArr removeAllObjects];
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
    self.backcommentview.backgroundColor = self.daynightmodel.backColor;
    self.backcommentview.commentview.backgroundColor = self.daynightmodel.inputColor;
    self.backcommentview.commentview.textColor = self.daynightmodel.textColor;
    self.backcommentview.commentview.layer.borderColor = self.daynightmodel.lineColor.CGColor;
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
        return 3;
    }
    else
    {
        if (self.FirstcommentArr.count > 0) {
            return self.FirstcommentArr.count;
        }
        else
        {
            return 1;
        }
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
            UIFont *font = [UIFont systemFontOfSize:20];
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
            
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titleCell;
        }
        else if(indexPath.row == 1)
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
        else
        {
            /* 这里是文章标签 */
            NSString *identifier = @"tagscell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor clearColor];
            [self.tagList removeFromSuperview];
            self.tagList = [[SharpTags alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 1)];
            self.tagList.delegate = self;
            self.tagList.signalTagColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
            self.tagList.BGColor = [UIColor clearColor];
            
            /* 判断sharpTagsArray是否为空 */
            if ((NSNull *)self.sharpTagsArray != [NSNull null]) {
                NSArray *arr = [NSArray array];
                if (self.sharpTagsArray.count > 4) {
                    arr = [self.sharpTagsArray subarrayWithRange:NSMakeRange(0, 4)];
                }else
                {
                    arr = self.sharpTagsArray;
                }
                [self.tagList setTagWithTagArray:arr];
            }
            [cell addSubview:self.tagList];
            
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = self.daynightmodel.navigationColor;
            return cell;
        }
    }
    else
    {
        if (self.FirstcommentArr.count == 0) {
            NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"当前文章还没有评论";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.textColor = self.daynightmodel.textColor;
            cell.backgroundColor = self.daynightmodel.navigationColor;
            return cell;
        }
        else
        {
            NSString *identifier = @"commentCell";
            CommentsModel *model = self.FirstcommentArr[indexPath.row];
            CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                NSLog(@"%@",model.secondArr);
                cell = [[CommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andArr:model.secondArr];
            }
            cell.delegate = self;
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
            NSLog(@"%@",model.comment_goodnum);
            [cell.goodnumBtn setTitle:model.comment_goodnum forState:UIControlStateNormal];
            cell.goodnumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.goodnumBtn.tag = [model.viewcomment_id integerValue];
            
            [cell.goodnumBtn setTitleColor:self.daynightmodel.titleColor forState:UIControlStateNormal];
            cell.nickNameLab.textColor = self.daynightmodel.titleColor;
            cell.numfloor.textColor = self.daynightmodel.titleColor;
            cell.commentLab.textColor = self.daynightmodel.textColor;
            cell.line.backgroundColor = self.daynightmodel.titleColor;
            cell.backgroundColor = self.daynightmodel.navigationColor;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
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
        [self.thview.just setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
        return self.thview;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 10+50+10+titlesize.height+10;
        }
        else if(indexPath.row == 1)
        {
            return self.webview.frame.size.height;
        }
        else
        {
            return 10 + self.tagList.frame.size.height + 10;
        }
    }
    else
    {
        if (self.FirstcommentArr.count == 0) {
            return kScreenHeight-64-44;
        }
        else
        {
            if (indexPath.row == self.FirstcommentArr.count-1) {
                if (kScreenHeight-(10+15+10+floorviewsize.height+15+commentsize.height+15)*(self.FirstcommentArr.count-1) > 10+15+10+floorviewsize.height+15+commentsize.height+15) {
                    return kScreenHeight-(10+15+10+floorviewsize.height+15+commentsize.height+15)*(self.FirstcommentArr.count-1);
                }
            }
            return 10+15+10+floorviewsize.height+15+commentsize.height+15;
        }
        
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
    [self.backcommentview.commentview becomeFirstResponder];
    
    CommentsModel *fModel = self.FirstcommentArr[indexPath.row];
    self.backcommentview.commentview.placeholder = [NSString stringWithFormat:@"回复 %@:",fModel.user_nickName];
    self.pid = fModel.viewcomment_id;
}

#pragma mark - 标签代理方法
- (void)ClickTags:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.searchTags = sender.titleLabel.text;
    searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - FloorInFloorViewDelegate
- (void)good:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    NSString *comment_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    self.loginState = [LoginState sharedInstance];
    //点赞
    NSDictionary *dic = @{@"userid":self.loginState.userId,
                          @"comment_id":comment_id};
    NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [ma POST:API_AddGoodComment1_2 parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"成功");
                sender.selected = YES;
                [sender setImage:[UIImage imageNamed:@"btn_dianzan_pre"] forState:UIControlStateNormal];
                NSString *str = [NSString stringWithFormat:@"%d",[sender.titleLabel.text intValue] + 1];
                [sender setTitle:str forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
    
    
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
- (void)didSelectedWithIndexPath:(UITableViewCell *)cell
{
    if ([cell.textLabel.text isEqualToString:@"复制链接"]) {
        NSLog(@"%@",cell.textLabel.text);
    }
    else if ([cell.textLabel.text isEqualToString:@"收藏"]){
        cell.imageView.image = [UIImage imageNamed:@"btn_col_pre"];
        cell.textLabel.text = @"取消收藏";
        [self addCollection];
    }
    else if ([cell.textLabel.text isEqualToString:@"取消收藏"]){
        cell.imageView.image = [UIImage imageNamed:@"btn_col"];
        cell.textLabel.text = @"收藏";
        [self clearCollection];
    }
    else if ([cell.textLabel.text isEqualToString:@"字体大小"]){
        
        self.nmview.alpha = 0.0;
        self.sfview.alpha = 1.0;
        self.sfview.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-64);
        
    }
    else if ([cell.textLabel.text isEqualToString:@"日间模式"]){
        //读取用户设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefault objectForKey:@"daynight"];
        if ([daynight isEqualToString:@"yes"]) {
            [self.daynightmodel night];
            daynight = @"no";
            [userdefault setValue:daynight forKey:@"daynight"];
            [userdefault synchronize];
            
            [UINavigationBar appearance].barTintColor = self.daynightmodel.navigationColor;   // 设置导航条背景颜色
            [UINavigationBar appearance].translucent = NO;
            [UINavigationBar appearance].tintColor = self.daynightmodel.navigationColor;    // 设置左右按钮，文字和图片颜色
            // 设置导航条标题字体和颜色
            NSDictionary *dict = @{NSForegroundColorAttributeName:self.daynightmodel.titleColor, NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
            [[UINavigationBar appearance] setTitleTextAttributes:dict];
            
            // 设置导航条左右按钮字体和颜色
            NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
            [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
            
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
        self.nmview.alpha = 0.0;
        naviShow = NO;
        
    }
    else if([cell.textLabel.text isEqualToString:@"夜间模式"])
    {
        //读取用户设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefault objectForKey:@"daynight"];
        [self.daynightmodel day];
        daynight = @"yes";
        [userdefault setValue:daynight forKey:@"daynight"];
        [userdefault synchronize];
        
        [UINavigationBar appearance].barTintColor = self.daynightmodel.navigationColor;   // 设置导航条背景颜色
        [UINavigationBar appearance].translucent = NO;
        [UINavigationBar appearance].tintColor = self.daynightmodel.navigationColor;    // 设置左右按钮，文字和图片颜色
        // 设置导航条标题字体和颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName:self.daynightmodel.titleColor, NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
        
        // 设置导航条左右按钮字体和颜色
        NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
        
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
        //举报
        self.nmview.alpha = 0.0;
        naviShow = NO;
        FeedbackViewController *feedback =  [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FeedbackView"];
        [self.navigationController pushViewController:feedback animated:YES];
        
    }
}

#pragma mark - 点击收藏取消收藏
- (void)addCollection{
    if (US.isLogIn) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"添加收藏";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dic = @{@"userid":US.userId,
                              @"module_id":@3,
                              @"item_id":self.view_id};
        
        [manager POST:API_AddCollection parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                hud.labelText = @"收藏成功";
                [hud hide:YES afterDelay:0.2];

            } else {
                hud.labelText = @"收藏失败";
                [hud hide:YES afterDelay:0.2];
            }
        }];
    }
}

- (void)clearCollection{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"取消收藏";
    
    NSMutableArray *IDArr = [NSMutableArray array];
    [IDArr addObject:self.view_id];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"authenticationStr":US.userId,
                           @"encryptedStr":self.encryptedStr,
                           @"delete_ids":IDArr,
                           @"module_id":@"3",
                           @"userid":US.userId};
    
    [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"取消成功";
            [hud hide:YES afterDelay:0.2];
        } else {
            hud.labelText = @"取消失败";
            [hud hide:YES afterDelay:0.2];
        }
    }];
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
    
    if (self.thview.louzhu.selected == YES) {
        self.thview.louzhu.selected = NO;
    }
    else
    {
        self.thview.louzhu.selected = YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //发送评论
    [textField resignFirstResponder];
    [self sendCommentWithText:textField.text];
    return YES;
}

#pragma mark - 发送评论
- (void)sendCommentWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发表评论";
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *para = @{@"comment_content":text,
                          @"user_id":US.userId,
                          @"view_id":self.view_id,
                          @"comment_pid":self.pid};
    
    [manager POST:API_AddViewCommont parameters:para completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"评论成功";
            [hud hide:YES afterDelay:0.1f];
            
            self.pid = @"0";//成功后清零
            
            [self requestWithCommentDataWithTimeHot];
            self.backcommentview.commentview.text = @"";
            self.backcommentview.commentview.placeholder = @"自古评论出人才，快来发表评论吧";
            //滑动到评论
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.tableview reloadData];
        } else {
            hud.labelText = @"评论失败";
            [hud hide:YES afterDelay:0.1f];
        }
    }];
}

#pragma mark - backcomment.delegate
- (void)clickComments:(UIButton *)sender{
    if (self.tableview.contentOffset.y > self.webview.frame.size.height-400) {
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        //回到顶部
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    else
    {
        //滑动到评论
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"nav_zt.png"] forState:UIControlStateNormal];
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

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.backcommentview.commentview resignFirstResponder];
    if (self.tableview.contentOffset.y > self.webview.frame.size.height-400) {
        
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"nav_zt.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
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
    if (!US.isLogIn) {
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
    if (US.isLogIn) {
        //进行身份验证
        [self requestAuthentication];
    }
    [self registerForKeyboardNotifications];
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
}
//身份验证
-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.encryptedStr = dic[@"str"];
        } else {
            
        }
    }];
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
    self.backcommentview.commentview.placeholder = @"自古评论出人才，快来发表评论吧";
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
