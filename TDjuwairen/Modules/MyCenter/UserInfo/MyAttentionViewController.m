//
//  MyAttentionViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "UserInfoViewController.h"
#import "MyAttentionTableViewCell.h"
#import "NothingTableViewCell.h"

#import "LoginState.h"
#import "UIdaynightModel.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "MJRefresh.h"

@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSMutableArray *attArr;

@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.attArr = [NSMutableArray array];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    
    [self requestWithAttentionList];
    
    [self addRefreshView];           //设置刷新
    // Do any additional setup after loading the view.
}

#pragma mark - 添加刷新
- (void)addRefreshView{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestWithAttentionList];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestWithAttentionList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupWithNavigation{
    self.title = @"我的关注";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = self.daynightmodel.navigationColor;
    
}

#pragma mark - 请求关注列表
- (void)requestWithAttentionList{
    __weak MyAttentionViewController *wself = self;
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_bendi];
    NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/getMyAttendUserInfo"];
    NSDictionary *dic = @{
                          @"user_id":US.userId,
                          @"page":[NSString stringWithFormat:@"%d",self.page],
                          };
    [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *dataArray = data;
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:wself.attArr];
                }
                
                for (NSDictionary *d in dataArray) {
                    [list addObject:d];
                }
                wself.attArr = [NSMutableArray arrayWithArray:list];
            }
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
            [wself.tableview reloadData];
        }
        else
        {
            NSLog(@"%@",error);
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.attArr.count > 0) {
        return self.attArr.count;
    }
    else
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.attArr.count > 0) {
        NSString *identifier = @"cell";
        NSDictionary *userInfoDic = self.attArr[indexPath.row];
        MyAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyAttentionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:userInfoDic[@"user_facesmall"]]];
        cell.nicknameLab.text = userInfoDic[@"user_nickname"];
        
        cell.backgroundColor = self.daynightmodel.navigationColor;
        cell.nicknameLab.textColor = self.daynightmodel.textColor;
        cell.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
        return cell;
    }
    else
    {
        NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.label.text = @"你当前没有关注用户哦~";
        cell.label.textColor = self.daynightmodel.textColor;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.attArr.count > 0) {
        return 60;
    }
    else
    {
        return kScreenHeight-64;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *userInfoDic = self.attArr[indexPath.row];
    UserInfoViewController *userinfoView = [[UserInfoViewController alloc]init];
    userinfoView.user_id = userInfoDic[@"user_id"];
    userinfoView.facesmall = userInfoDic[@"user_facesmall"];
    userinfoView.nickname = userInfoDic[@"user_nickname"];
    [self.navigationController pushViewController:userinfoView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
