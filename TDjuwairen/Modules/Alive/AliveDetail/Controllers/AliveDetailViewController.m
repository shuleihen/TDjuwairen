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
#import "AlivePingLunViewController.h"
#import "AliveListBottomTableViewCell.h"
#import "AliveCommentViewController.h"
#import "AliveRoomViewController.h"

@interface AliveDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AliveListBottomTableCellDelegate, AliveListTableCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (assign, nonatomic) NSInteger selectedPage;
@property (weak, nonatomic) AliveContentHeaderView *sectionHeaderView;
@property (strong, nonatomic) AliveListModel *aliveInfoModel;
@property (strong, nonatomic) AliveMasterListViewController *dianZanVC;
@property (strong, nonatomic) AliveMasterListViewController *shareVC;
@property (strong, nonatomic) AlivePingLunViewController *pinglunVC;
@property (strong, nonatomic) AliveListBottomTableViewCell *toolView;
@end

@implementation AliveDetailViewController

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
        
        UINib *nib = [UINib nibWithNibName:@"AliveListTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"AliveListTableViewCellID"];
        
    }
    
    return _tableView;
}

- (AliveListBottomTableViewCell *)toolView {
    if (!_toolView) {
        _toolView = [[[NSBundle mainBundle] loadNibNamed:@"AliveListBottomTableViewCell" owner:self options:nil] firstObject];
        _toolView.backgroundColor = [UIColor whiteColor];
        _toolView.frame = CGRectMake(0, kScreenHeight-64-44, kScreenWidth, 44);
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UIScrollView *)pageScrollView {
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _pageScrollView.contentSize = CGSizeMake(kScreenWidth*3, 0);
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.backgroundColor = [UIColor clearColor];
        [_pageScrollView addSubview:self.pinglunVC.view];
        [_pageScrollView addSubview:self.dianZanVC.view];
        [_pageScrollView addSubview:self.shareVC.view];
        _pageScrollView.delegate = self;

    }
    return _pageScrollView;
}

- (AliveContentHeaderView *)sectionHeaderView {
    
    if (!_sectionHeaderView) {
        _sectionHeaderView = [AliveContentHeaderView loadAliveContentHeaderView];
        _sectionHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 45);
        
        __weak typeof(self)weakSelf = self;
        _sectionHeaderView.selectedBlock = ^(UIButton *btn){
            [weakSelf.pageScrollView setContentOffset:CGPointMake(kScreenWidth*(btn.tag-100), 0) animated:YES];
            weakSelf.selectedPage = btn.tag-100;
        };
    }
    return _sectionHeaderView;
}

- (AlivePingLunViewController *)pinglunVC
{
    if (!_pinglunVC) {
        _pinglunVC = [[AlivePingLunViewController alloc] init];
        
        _pinglunVC.detail_id = self.alive_ID;
        _pinglunVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.pinglunVC.tableView.frame.size.height-44);
        _pinglunVC.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        _pinglunVC.dataBlock = ^(NSInteger dataCount){
            
            UIButton *btn = (UIButton *)[weakSelf.sectionHeaderView viewWithTag:100];
            [btn setTitle:[NSString stringWithFormat:@"评论 %ld",dataCount] forState:UIControlStateNormal];
            
            weakSelf.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.pinglunVC.tableView.contentSize.height);
            weakSelf.pinglunVC.tableView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.pinglunVC.tableView.contentSize.height);
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.sectionHeaderView configShowUI:weakSelf.selectedPage];
        };
    };
    
    
    return _pinglunVC;
}

- (AliveMasterListViewController *)dianZanVC {
    
    if (!_dianZanVC) {
        _dianZanVC = [[AliveMasterListViewController alloc] initWithDianZanVC:self aliveId:self.alive_ID aliveType:self.alive_type viewControllerType:AliveDianZanList];
        _dianZanVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.pageScrollView.frame.size.height);
        
        _dianZanVC.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        _dianZanVC.dataBlock = ^(NSInteger dataCount){
            
            UIButton *btn = (UIButton *)[weakSelf.sectionHeaderView viewWithTag:101];
            [btn setTitle:[NSString stringWithFormat:@"点赞 %ld",dataCount] forState:UIControlStateNormal];

            weakSelf.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.dianZanVC.tableView.contentSize.height);
            weakSelf.dianZanVC.tableView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.dianZanVC.tableView.contentSize.height);
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.toolView.likeBtn setTitle:[NSString stringWithFormat:@"%ld", dataCount] forState:UIControlStateNormal];
            
            [weakSelf.sectionHeaderView configShowUI:weakSelf.selectedPage];
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
            UIButton *btn = (UIButton *)[weakSelf.sectionHeaderView viewWithTag:102];
            [btn setTitle:[NSString stringWithFormat:@"分享 %ld",dataCount] forState:UIControlStateNormal];
                        weakSelf.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.shareVC.tableView.contentSize.height);
                        weakSelf.shareVC.tableView.frame = CGRectMake(0,0,kScreenWidth, weakSelf.shareVC.tableView.contentSize.height);
                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.sectionHeaderView configShowUI:weakSelf.selectedPage];
        };
    }
    return _shareVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"直播正文";
    
    [self setUpUICommon];
    [self setSelectedPage:0];
}


- (void)setUpUICommon {

    self.view.backgroundColor = TDViewBackgrouondColor;
    
    
    [self.view addSubview:self.tableView];
    [self loadDynamicDetailData];
    
    
    _toolView = [[[NSBundle mainBundle] loadNibNamed:@"AliveListBottomTableViewCell" owner:nil options:nil] lastObject];
    _toolView.frame = CGRectMake(0, kScreenHeight-44-64, kScreenWidth, 44);
    _toolView.backgroundColor = [UIColor whiteColor];
    _toolView.delegate = self;
    [self.view addSubview:_toolView];
}

- (void)setSelectedPage:(NSInteger)selectedPage {
    
    _selectedPage = selectedPage;
    
#define KnotifierGoPingLun @"KnotifierGoPingLun"
    switch (selectedPage) {
        case 0:
        {
            self.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, self.pinglunVC.tableView.contentSize.height);
            self.pinglunVC.tableView.frame = CGRectMake(0,0,kScreenWidth, self.pinglunVC.tableView.contentSize.height);
            [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoPingLun object:nil];
            self.toolView.hidden = NO;
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
            
            
        }
            break;
        case 1:
        {
            self.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, self.dianZanVC.tableView.contentSize.height);
            self.dianZanVC.tableView.frame = CGRectMake(0,0,kScreenWidth, self.dianZanVC.tableView.contentSize.height);
            self.toolView.hidden = YES;
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
            
        }
            break;
        case 2:
        {
            self.pageScrollView.frame = CGRectMake(0,0,kScreenWidth, self.shareVC.tableView.contentSize.height);
            self.shareVC.tableView.frame = CGRectMake(0,0,kScreenWidth, self.shareVC.tableView.contentSize.height);
            self.toolView.hidden = YES;
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
            
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    
    [self.sectionHeaderView configShowUI:selectedPage];
}


- (void)loadDynamicDetailData {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":self.alive_ID,@"alive_type" :self.alive_type};
    
    [manager GET:API_AliveGetAliveInfo parameters:dict completion:^(id data, NSError *error){
        
        if (!error) {
            
            self.aliveInfoModel = [[AliveListModel alloc] initWithDictionary:data];
            [self.tableView reloadData];
            [_toolView setupAliveModel:_aliveInfoModel];
            
        } else {
            
        }
        
    }];
}


#pragma mark - UITableView
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
        
        UITableViewCell *contentCell =  [tableView dequeueReusableCellWithIdentifier:@"AliveContentTableViewCell"];
        if (contentCell == nil) {
            contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliveContentTableViewCell"];
        }
        
        [contentCell.contentView addSubview:self.pageScrollView];
        
        
        return contentCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    if (section == 0) {
        return nil;
    }else {
        return self.sectionHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [AliveListTableViewCell heightWithAliveModel:self.aliveInfoModel];
    }else {
        self.pageScrollView.frame = CGRectMake(0, 0, kScreenWidth, MAX(self.pageScrollView.frame.size.height, kScreenHeight-[AliveListTableViewCell heightWithAliveModel:self.aliveInfoModel]-45));
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
    
    if (currentPage == self.selectedPage) {
        return;
    }else {
        self.selectedPage = currentPage;
    }
}

#pragma mark - AliveListTableCellDelegate

- (void)aliveListTableCell:(AliveListTableViewCell *)cell avatarPressed:(id)sender {
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:self.aliveInfoModel.masterId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AliveListBottomTableCellDelegate

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell sharePressed:(id)sender;
{
    
}
- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell commentPressed:(id)sender;
{
    AliveCommentViewController *commVC = [AliveCommentViewController new];
    commVC.alive_ID = _alive_ID;
    commVC.alive_type = _alive_type;
    [self.navigationController pushViewController:commVC animated:YES];
}

- (void)aliveListBottomTableCell:(AliveListBottomTableViewCell *)cell likePressed:(id)sender;
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":self.alive_ID,@"alive_type" :self.alive_type};
    
    __weak typeof(self)wself = self;
    [manager POST:API_AliveAddLike parameters:dict completion:^(id data, NSError *error) {
#define KnotifierGoAddLike @"KnotifierGoAddLike"
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KnotifierGoAddLike object:nil];
            
        }
    }];
}


@end
