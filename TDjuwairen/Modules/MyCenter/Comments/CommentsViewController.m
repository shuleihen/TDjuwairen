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
#import "MJRefresh.h"
#import "UIdaynightModel.h"
#import "CommentManagerModel.h"


@interface CommentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *CommentsArray;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,assign) int page;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self setupWithTableView];

    self.page=1;
    self.CommentsArray = [NSMutableArray array];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.view.backgroundColor = self.daynightmodel.navigationColor;
    [self requestComments];
    [self addRefreshView];           //设置刷新
    
    // Do any additional setup after loading the view.
}

- (void)addRefreshView {
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];

}

- (void)refreshAction {

    self.page = 1;
    [self requestComments];

}

- (void)loadMoreAction {

    self.page++;
    //继续请求
    [self requestComments];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [self.tableview registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"NoCommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoCommentsCell"];
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.view addSubview:self.tableview];
}

-(void)requestComments
{
    __weak CommentsViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*paras = @{@"userid":US.userId,
                         @"module_id":@"2",
                         @"page":[NSString stringWithFormat:@"%d",self.page]};
    
    [manager POST:API_GetUserComment parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.CommentsArray];
                }
                
                for (NSDictionary *d in dataArray) {
                    CommentManagerModel *model = [CommentManagerModel getInstanceWithDictionary:d];
                    [list addObject:model];
                }
                wself.CommentsArray = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
            }
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
            [wself.tableview reloadData];

        } else {
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
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
    if (self.CommentsArray.count > 0) {
        return self.CommentsArray.count;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.CommentsArray.count > 0) {
        CommentManagerModel *model = self.CommentsArray[indexPath.row];
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
        [cell setCellWithDic:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
        NoCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCommentsCell"];
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.label.textColor = self.daynightmodel.textColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.CommentsArray.count > 0) {
        return 136;
    }
    else{
        return kScreenHeight-64;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.CommentsArray.count > 0) {
        CommentManagerModel *model = self.CommentsArray[indexPath.row];
        SharpDetailsViewController *sharp = [[SharpDetailsViewController alloc] init];
        sharp.sharp_id = model.sharpcomment_sharpid;
        [self.navigationController pushViewController:sharp animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
