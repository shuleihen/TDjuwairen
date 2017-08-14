//
//  ViewpointDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ViewpointDetailViewController.h"
#import "ViewpointWebTableViewCell.h"
#import "ViewpointHeaderTableViewCell.h"
#import "NetworkManager.h"
#import "ViewModel.h"
#import "ACActionSheet.h"
#import "AliveRoomViewController.h"
#import "MBProgressHUD.h"
#import "FeedbackViewController.h"

@interface ViewpointDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) ViewModel *viewModel;
@property (nonatomic, assign) CGFloat headerCellHeight;
@property (nonatomic, assign) CGFloat webCellHeight;
@end

@implementation ViewpointDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播正文";
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UINib *nib1 = [UINib nibWithNibName:@"ViewpointHeaderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"ViewpointHeaderTableViewCellID"];
    
    UINib *nib2 = [UINib nibWithNibName:@"ViewpointWebTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"ViewpointWebTableViewCellID"];
    
    [self loadViewpointInfo];
}


- (void)loadViewpointInfo {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_ViewGetDetail parameters:@{@"id": self.aliveID} completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            ViewModel *model = [ViewModel shareWithDictionary:data];
            [self reloadViewWithViewModel:model];
        } else {
            
        }
    }];
}

- (void)reloadViewWithViewModel:(ViewModel *)model {
    self.viewModel = model;
    
    TDShareModel *shareModel = [[TDShareModel alloc] init];
    shareModel.title = model.view_title;
    shareModel.images = @[model.view_thumb];
    shareModel.url = model.view_share_url;
    self.shareModel = shareModel;
    
    CGSize size = [model.view_title boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil].size;
    self.headerCellHeight = 250+size.height+20;
    
    self.masterID = model.view_userid;
    
    [self loadTabelView];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self setupIsLike:model.view_isLike withAnimation:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        ViewpointWebTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *url = [NSString stringWithFormat:@"%@%@/id/%@",API_HOST,API_ViewGetDetailWebContent,self.viewModel.view_id];
        [cell loadWebWithURLString:url];
    });
    
}

- (AliveListModel *)shareAliveListModel {
    
    AliveListModel *model = [[AliveListModel alloc] init];
    model.aliveId = self.aliveID;
    model.aliveType = self.aliveType;
    model.aliveTitle = self.viewModel.view_title;
    model.masterId = self.viewModel.view_userid;
    model.masterNickName = self.viewModel.view_author;
    model.masterAvatar = self.viewModel.userinfo_facesmall;
    model.aliveImgs = self.viewModel.view_thumb.length?@[self.viewModel.view_thumb]:@[];
    model.shareUrl = self.viewModel.view_share_url;

    return model;
}

- (void)collectionPressed {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    NSDictionary *dic,*showDict;

    if (self.viewModel.view_isCollected) {
        showDict = @{@"showMess1":@"取消收藏",@"showMess2":@"取消成功",@"showMess3":@"取消失败",@"apiStr":API_DelCollection,@"changeValue":@0};
        dic = @{@"module_id":@(3),
                @"delete_ids":self.viewModel.view_id};
    }else {
        showDict = @{@"showMess1":@"添加收藏",@"showMess2":@"收藏成功",@"showMess3":@"收藏失败",@"apiStr":API_AddCollection,@"changeValue":@1};
        dic = @{@"module_id":@(3),
                @"item_id":self.viewModel.view_id};
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showDict[@"showMess1"];
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager POST:showDict[@"apiStr"] parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText =showDict[@"showMess2"];
            [hud hide:YES afterDelay:0.2];
            self.viewModel.view_isCollected = [showDict[@"changeValue"] boolValue];
        } else {
            hud.labelText = showDict[@"showMess3"];
            [hud hide:YES afterDelay:0.2];
            self.viewModel.view_isCollected = [showDict[@"changeValue"] boolValue];
        }
    }];
}

- (void)feedbackPressed {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    FeedbackViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)morePressed:(id)sender {
    
    NSArray *array;
    if (self.viewModel.view_isCollected) {
        array = @[@"取消收藏",@"举报"];
    } else {
        array = @[@"收藏",@"举报"];
    }
    
    ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:array actionSheetBlock:^(NSInteger index){
        if (index == 0) {
            [self collectionPressed];
        } else if (index == 1) {
            [self feedbackPressed];
        }
    }];
    [sheet show];
}

- (void)avatarPressed:(id)sender {
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:self.viewModel.view_userid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)arrowPressed:(id)sender {
    
    NSDictionary *dic,*showDict;
    
    if (self.viewModel.view_isAtten) {
        showDict = @{@"showMess1":@"取消关注",@"showMess2":@"取消成功",@"showMess3":@"取消失败",@"apiStr":API_AliveDelAttention,@"changeValue":@0};

    }else {
        showDict = @{@"showMess1":@"添加关注",@"showMess2":@"关注成功",@"showMess3":@"关注失败",@"apiStr":API_AliveAddAttention,@"changeValue":@1};
    }
    dic = @{@"user_id": self.viewModel.view_userid};
    
    __weak typeof(self)weakSelf = self;
    
    ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:showDict[@"showMess1"] otherButtonTitles:nil actionSheetBlock:^(NSInteger index){
        if (index == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = showDict[@"showMess1"];
            NetworkManager *manager = [[NetworkManager alloc] init];
            
            [manager POST:showDict[@"apiStr"] parameters:dic completion:^(id data, NSError *error){
                if (!error) {
                    hud.labelText =showDict[@"showMess2"];
                    [hud hide:YES afterDelay:0.2];
                    weakSelf.viewModel.view_isAtten = [showDict[@"changeValue"] boolValue];
                } else {
                    hud.labelText = showDict[@"showMess3"];
                    [hud hide:YES afterDelay:0.2];
                    weakSelf.viewModel.view_isAtten = [showDict[@"changeValue"] boolValue];
                }
            }];
        }
    }];
    [sheet show];
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        ViewpointHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewpointHeaderTableViewCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.moreBtn addTarget:self action:@selector(arrowPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.avatarBtn addTarget:self action:@selector(avatarPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setupViewModel:self.viewModel];
        
        return cell;
    } else if (indexPath.section == 0 &&
               indexPath.row == 1) {
        ViewpointWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewpointWebTableViewCellID"];
        cell.webView.delegate = self;
        
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return self.headerCellHeight;
    } else if (indexPath.section == 0 &&
               indexPath.row == 1) {
        return MAX(kScreenHeight-56-self.headerCellHeight, self.webCellHeight);
    }
    
    return 0;
}

#pragma mark - UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Viewpoint web url = %@",webView.request.URL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ViewpointWebTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.indicator stopAnimating];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webCellHeight = height + 10;
    
    [self.tableView reloadData];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ViewpointWebTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.indicator stopAnimating];
}
@end
