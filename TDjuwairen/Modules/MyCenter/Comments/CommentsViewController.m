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
#import "LoginState.h"
#import "SharpDetailsViewController.h"
#import "NSString+TimeInfo.h"
#import "NetworkManager.h"
#import "UIScrollView+FCXRefresh.h"
#import "MJRefresh.h"


@interface CommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*CommentsArray;
    int page;
    BOOL haveComments;

}

@property (nonatomic,strong) UITableView *tableview;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self setupWithTableView];

    page=1;
    CommentsArray=[NSMutableArray array];
    [self requestComments];
    [self addRefreshView];           //设置刷新
    
    // Do any additional setup after loading the view.
}

- (void)addRefreshView {
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];

}

- (void)refreshAction {

    page = 1;
    [self requestComments];

}

- (void)loadMoreAction {

    page++;
    //继续请求
    [self requestComments];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)setNavigation
{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    self.title = @"评论管理";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}

-(void)requestComments
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"userid":US.userId,
                         @"module_id":@"2",
                         @"page":[NSString stringWithFormat:@"%d",page]};
    
    [manager POST:API_GetUserComment parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            if (page == 1) {
                [CommentsArray removeAllObjects];
            }
            
            haveComments=YES;
            NSArray*array = data;
            for (NSDictionary*dic in array) {
                [CommentsArray addObject:dic];
            }
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
            [self.tableview reloadData];

        } else {
            if (error.code == 400) {
                haveComments = NO;
            }
            [self.tableview reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    SharpDetailsViewController *sharp = [[SharpDetailsViewController alloc] init];
    sharp.sharp_id=dic[@"sharpcomment_sharpid"];
    //[self presentViewController:sharp animated:YES completion:nil];
    [self.navigationController pushViewController:sharp animated:YES];
}

@end
