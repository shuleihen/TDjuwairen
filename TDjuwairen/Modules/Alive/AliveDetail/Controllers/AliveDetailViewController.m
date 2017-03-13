//
//  AliveDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveDetailViewController.h"
#import "AliveListTableViewCell.h"
#import "AliveContentHeaderView.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "AliveListModel.h"
#import "AliveMasterListViewController.h"
#import "PlayStockCommentViewController.h"

@interface AliveDetailViewController ()<AliveListTableCellDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (assign, nonatomic) NSInteger selectedPage;
@property (weak, nonatomic) AliveContentHeaderView *headerV;
@property (strong, nonatomic) AliveListModel *aliveInfoModel;
@property (strong, nonatomic) AliveMasterListViewController *dianZanVC;
@property (strong, nonatomic) AliveMasterListViewController *shareVC;
@property (strong, nonatomic) PlayStockCommentViewController *pinglunVC;









@end

@implementation AliveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"直播正文";
    [self setUpValue];
    [self setUpUICommon];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)setUpValue {
    
    
    
}

- (void)setUpUICommon {
    self.view.backgroundColor = TDViewBackgrouondColor;

    
    [self.view addSubview:self.tableView];
    [self loadDynamicDetailData];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"AliveListTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
    }
    
    return _tableView;
}

- (UIScrollView *)pageScrollView {
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _pageScrollView.contentSize = CGSizeMake(kScreenWidth*3, 0);
        _pageScrollView.pagingEnabled = YES;
//        _pageScrollView.showsHorizontalScrollIndicator = NO;
//        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.backgroundColor = [UIColor lightGrayColor];
        [_pageScrollView addSubview:[UIView new]];
        [_pageScrollView addSubview:_pinglunVC.view];
        [_pageScrollView addSubview:self.dianZanVC.view];
        [_pageScrollView addSubview:self.shareVC.view];
        _pageScrollView.delegate = self;
        
        
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayStockCommentViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    return _pageScrollView;
}

- (AliveContentHeaderView *)headerV {

    if (!_headerV) {
        _headerV = [AliveContentHeaderView loadAliveContentHeaderView];
        _headerV.frame = CGRectMake(0, 0, kScreenWidth, 45);
        __weak typeof(self)weakSelf = self;
        _headerV.selectedBlock = ^(UIButton *btn){
            [weakSelf.pageScrollView setContentOffset:CGPointMake(kScreenWidth*(btn.tag-100), 0) animated:YES];
            weakSelf.selectedPage = btn.tag-100;
            
        };
    }
    return _headerV;
}

- (void)setSelectedPage:(NSInteger)selectedPage {

    _selectedPage = selectedPage;


    switch (selectedPage) {
        case 0:
        {
            self.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, self.dianZanVC.tableView.contentSize.height);
            self.dianZanVC.tableView.frame = CGRectMake(0,0,kScreenWidth, self.dianZanVC.tableView.contentSize.height);

        }
            break;
        case 1:
        {
            self.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, self.dianZanVC.tableView.contentSize.height);
            self.dianZanVC.tableView.frame = CGRectMake(0,0,kScreenWidth, self.dianZanVC.tableView.contentSize.height);

        }
            break;
        case 2:
        {
            self.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, self.shareVC.tableView.contentSize.height);
            self.shareVC.tableView.frame = CGRectMake(0,0,kScreenWidth, self.shareVC.tableView.contentSize.height);

        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [self.headerV configShowUI:selectedPage];
    
    
    
}

- (PlayStockCommentViewController *)pinglunVC
{
    if (!_pinglunVC) {
        _pinglunVC = [[PlayStockCommentViewController alloc] init];
        _pinglunVC.view.frame = CGRectMake(0, 0, kScreenWidth, 200);
    }
    return _pinglunVC;
}
- (AliveMasterListViewController *)dianZanVC {

    if (!_dianZanVC) {
        _dianZanVC = [[AliveMasterListViewController alloc] initWithDianZanVC:self aliveId:self.alive_ID aliveType:self.alive_type viewControllerType:AliveDianZanList];
        _dianZanVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.pageScrollView.frame.size.height);

        _dianZanVC.tableView.scrollEnabled = NO;
         __weak typeof(self)weakSelf = self;
        _dianZanVC.dataBlock = ^(NSInteger dataCount){
            
        UIButton *btn = (UIButton *)[weakSelf.headerV viewWithTag:101];
            [btn setTitle:[NSString stringWithFormat:@"点赞 %ld",dataCount] forState:UIControlStateNormal];
            weakSelf.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.dianZanVC.tableView.contentSize.height);
            weakSelf.dianZanVC.tableView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.dianZanVC.tableView.contentSize.height);
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    return  _dianZanVC;
}


- (AliveMasterListViewController *)shareVC {

    if (!_shareVC) {
        _shareVC = [[AliveMasterListViewController alloc] initWithDianZanVC:self aliveId:self.alive_ID aliveType:self.alive_type viewControllerType:AliveShareList];
       
        _shareVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.pageScrollView.frame.size.height);
        _shareVC.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        _shareVC.dataBlock = ^(NSInteger dataCount){
            UIButton *btn = (UIButton *)[weakSelf.headerV viewWithTag:102];
            [btn setTitle:[NSString stringWithFormat:@"分享 %ld",dataCount] forState:UIControlStateNormal];
        };
    }
    return _shareVC;
}


#pragma mark ---loadData
/// 加载动态详情页内容
- (void)loadDynamicDetailData {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":self.alive_ID,@"alive_type" :self.alive_type};
    
    [manager GET:API_AliveGetAliveInfo parameters:dict completion:^(id data, NSError *error){
        
        if (!error) {
          
            self.aliveInfoModel = [[AliveListModel alloc] initWithDictionary:data];
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            
            
        } else {
            
        }
        
    }];

    
}




#pragma mark - dasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AliveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListTableViewCellID"];
        cell.delegate = self;
        if (self.aliveInfoModel != nil) {
            
            [cell setupAliveModel:self.aliveInfoModel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
    
        UITableViewCell *contentCell =  [tableView dequeueReusableCellWithIdentifier:@"contentTableViewCell"];
        if (contentCell == nil) {
            contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentTableViewCell"];
        }
        
        [contentCell.contentView addSubview:self.pageScrollView];
        
        
        return contentCell;
    }
}

#pragma mark ----------------------------------------------------------



#pragma mark -------------- UITableViewDelegate ---------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {

    
   
    if (section == 0) {
        return nil;
    }else {
        return self.headerV;
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [AliveListTableViewCell heightWithAliveModel:self.aliveInfoModel];
    }else {
    
        return self.pageScrollView.frame.size.height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return CGFLOAT_MIN;
    }else {
    
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    if (section == 0) {
        return 10;
    }else {
    
        return CGFLOAT_MIN;
    }
}

#pragma mark ----------------------------------------------------------



#pragma mark ----- UIScrollViewDelegate
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
    
    if (currentPage == self.selectedPage) {
        return;
    }else {
        
        self.selectedPage = currentPage;
        
    }
    
    
}

@end
