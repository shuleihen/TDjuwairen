//
//  SurveyDetailStockCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailStockCommentViewController.h"
#import "NetworkManager.h"
#import "StockCommentModel.h"
#import "LoginState.h"
#import "NiuxiongTableViewCell.h"
#import "NiuxiongSectionHeaderView.h"
#import "LoginViewController.h"

@interface SurveyDetailStockCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *niuArray;
@property (nonatomic, strong) NSArray *xiongArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NiuxiongSectionHeaderView *sectionHeader;
@property (nonatomic, assign) BOOL isNiu;
@end

@implementation SurveyDetailStockCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.isNiu = YES;

    [self reloadData];
}

- (void)reloadData {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"code": self.stockId};
    if (US.isLogIn) {
        para = @{@"code": self.stockId,
                 @"user_id" : US.userId};
    }
    
    [ma GET:API_SurveyDetailComment parameters:para completion:^(id data, NSError *error){
        if (!error && data && [data isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithData:data];
        } else {
            // 查询失败
            [self reloadTableViewWithData:nil];
        }
    }];
}

- (void)reloadTableViewWithData:(NSArray *)list {
    NSMutableArray *niu = [NSMutableArray arrayWithCapacity:[list count]/2];
    NSMutableArray *xiong = [NSMutableArray arrayWithCapacity:[list count]/2];
    for (NSDictionary *dict in list) {
        StockCommentModel *model = [StockCommentModel getInstanceWithDictionary:dict];
        if (model.type == 1) {
            [niu addObject:model];
        } else if (model.type == 2) {
            [xiong addObject:model];
        }
    }
    
    self.niuArray = niu;
    self.xiongArray = xiong;
    self.isNiu = YES;
    
    [self reloadTableView];
}

- (void)reloadTableView {
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat height = [self calculateTabelViewHeight];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
            if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
                [self.delegate contentDetailController:self withHeight:height];
            }
        });
    });
}

- (CGFloat)calculateTabelViewHeight {
    CGFloat height = 0.f;
    for (StockCommentModel *comment in self.comments) {
        height += [NiuxiongTableViewCell heightWithContent:comment.content];
    }
    
    return height + 50;
}

- (CGFloat)contentHeight {
    return CGRectGetHeight(self.tableView.bounds);
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.sectionHeader.isNiu = self.isNiu;
    [self.sectionHeader setupXiong:[self.xiongArray count] niu:[self.niuArray count]];
    
    return self.sectionHeader;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockCommentModel *comment = self.comments[indexPath.row];
    
    return [NiuxiongTableViewCell heightWithContent:comment.content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockCommentModel *comment = self.comments[indexPath.row];
    NiuxiongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NiuxiongCellID"];
    [cell setupComment:comment];
    
    __weak SurveyDetailStockCommentViewController *wself = self;
    cell.favourBlcok = ^(UIButton *btn){
        if (US.isLogIn == YES) {
            if (btn.selected == NO) {
                NSDictionary *dic = @{@"user_id":    US.userId,
                                      @"comment_id": comment.commentId};
                
                NetworkManager *ma = [[NetworkManager alloc] init];
                [ma POST:API_SurveyAddFavour parameters:dic completion:^(id data, NSError *error) {
                    if (!error) {
                        comment.isLiked = YES;
                        comment.goodNums += 1;
                        [wself.tableView beginUpdates];
                        [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [wself.tableView endUpdates];
                    } else {
                        
                    }
                }];
            }
        } else {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
            [wself.rootController.navigationController pushViewController:login animated:YES];
        }
    };
    return cell;
}

- (void)setIsNiu:(BOOL)isNiu {
    _isNiu = isNiu;
    if (isNiu) {
        self.comments = self.niuArray;
    } else {
        self.comments = self.xiongArray;
    }
}


- (NiuxiongSectionHeaderView *)sectionHeader {
    if (!_sectionHeader) {
        __weak SurveyDetailStockCommentViewController *wself = self;
        
        _sectionHeader = [[NiuxiongSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _sectionHeader.backgroundColor = [UIColor whiteColor];
        _sectionHeader.buttonBlock = ^(NSInteger tag) {
            if (tag == 1) {
                wself.isNiu = YES;
            } else {
                wself.isNiu = NO;
            }

            [wself reloadTableView];
        };
    }
    return _sectionHeader;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        UINib *ask = [UINib nibWithNibName:@"NiuxiongTableViewCell" bundle:nil];
        [_tableView registerNib:ask forCellReuseIdentifier:@"NiuxiongCellID"];
    }
    
    return _tableView;
}
@end
