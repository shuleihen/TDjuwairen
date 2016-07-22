//
//  CommentsViewController.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsTableViewCell.h"
#import "NoCommentsTableViewCell.h"
#import "AFNetworking.h"
#import "LoginState.h"
#import "SharpDetailsViewController.h"
#import "NSString+TimeInfo.h"

//刷新
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"


@interface CommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*CommentsArray;
    int page;
    BOOL haveComments;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)LoginState*loginState;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.loginState=[LoginState addInstance];
    self.tableview.contentInset=UIEdgeInsetsMake(-35, 0, 0, 0);
    page=1;
    CommentsArray=[NSMutableArray array];
    [self requestComments];
    [self addRefreshView];           //设置刷新
    
    // Do any additional setup after loading the view.
}

- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [self.tableview addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    footerView = [self.tableview addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
    
    //自动刷新
    //    footerView.autoLoadMore = self.autoLoadMore;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        self.tableview.contentInset=UIEdgeInsetsMake(-35, 0, 0, 0);
    });
}

- (void)refreshAction {
    __weak UITableView *weakTableView = self.tableview;
    __weak FCXRefreshHeaderView *weakHeaderView = headerView;
    //数据表页数为1
    page = 1;
    [self requestComments];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakHeaderView endRefresh];
        [weakTableView reloadData];
    });
}

- (void)loadMoreAction {
    __weak UITableView *weakTableView = self.tableview;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
    page++;
    //继续请求
    [self requestComments];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakFooterView endRefresh];
        [weakTableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [self setNavigation];
}

-(void)setNavigation
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"评论管理";
    self.navigationItem.titleView=label;
}

-(void)requestComments
{
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/User/getUserComnment"];
    NSDictionary*paras=@{@"userid":self.loginState.userId,
                         @"module_id":@"2",
                         @"page":[NSString stringWithFormat:@"%d",page]};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (page==1) {
            [CommentsArray removeAllObjects];
            NSString*code=[responseObject objectForKey:@"code"];
            if ([code isEqualToString:@"400"]) {
                haveComments=NO;
            }
        }
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            haveComments=YES;
            NSArray*array=responseObject[@"data"];
            for (NSDictionary*dic in array) {
                [CommentsArray addObject:dic];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak FCXRefreshFooterView *weakFooterView = footerView;
                [weakFooterView endRefresh];
                [self.tableview reloadData];//主线程刷新tableview
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (haveComments) {
        return CommentsArray.count;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveComments) {
    NSDictionary*dic=CommentsArray[indexPath.row];
    [tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    CommentsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
    [cell setCellWithDic:dic];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    }
    else
    {
        [tableView registerNib:[UINib nibWithNibName:@"NoCommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoCommentsCell"];
        NoCommentsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"NoCommentsCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (haveComments) {
        return 136;
    }
    else{
        return 518;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=CommentsArray[indexPath.row];
    SharpDetailsViewController *sharp = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    sharp.sharp_id=dic[@"sharpcomment_sharpid"];
    //[self presentViewController:sharp animated:YES completion:nil];
    [self.navigationController pushViewController:sharp animated:YES];
}

@end
