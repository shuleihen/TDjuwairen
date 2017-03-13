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

@interface AliveDetailViewController ()<AliveListTableCellDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (assign, nonatomic) NSInteger selectedPage;
@property (weak, nonatomic) AliveContentHeaderView *headerV;
@property (strong, nonatomic) AliveListModel *aliveInfoModel;



@end

@implementation AliveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        _pageScrollView.contentSize = CGSizeMake(kScreenWidth*3, 210);
        _pageScrollView.pagingEnabled = YES;
//        _pageScrollView.showsHorizontalScrollIndicator = NO;
//        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.backgroundColor = [UIColor lightGrayColor];
        _pageScrollView.delegate = self;
        
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

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [self.headerV configShowUI:selectedPage];
    
    
}

#pragma mark ---loadData
/// 加载动态详情页内容
- (void)loadDynamicDetailData {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"alive_id":self.alive_ID,@"alive_type" :@"1"};
    
    [manager GET:API_AliveGetAliveInfo parameters:dict completion:^(id data, NSError *error){
        
       
        
        if (!error) {
          
            NSLog(@"---------%@",data);
            
            
            self.aliveInfoModel = [[AliveListModel alloc] initWithDictionary:data];
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            
            
        } else {
            
        }
        
    }];

    
}




#pragma mark -------------- UITableViewDataSource ---------------------
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
    
        return 210;
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

    return 10;
}

#pragma mark ----------------------------------------------------------



#pragma mark ----- UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(!decelerate)
    {   //OK,真正停止了，do something}
        [self scrollViewDidEndDecelerating:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPage = scrollView.contentOffset.x/kScreenWidth;
    
    if (currentPage == self.selectedPage) {
        return;
    }else {
        
        self.selectedPage = currentPage;
        
    }
    
    
}

@end
