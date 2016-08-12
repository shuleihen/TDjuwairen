//
//  ChildTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ChildTableViewController.h"
#import "LoginState.h"
#import "UIdaynightModel.h"
#import "ViewPointTableViewCell.h"
#import "ViewPointListModel.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface ChildTableViewController ()
{
    CGSize titlesize;
    int ID;
}
@property (nonatomic,assign) int page;

@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation ChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArr = [NSMutableArray array];
    self.page = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loginState = [LoginState addInstance];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"加载中...";
    
    [self addRefreshView];     //设置刷新
}

- (void)addRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestShowList:ID];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestShowList:ID];
}

- (void)requestShowList:(int)typeID
{
    __weak ChildTableViewController *wself = self;
    NSString *url = [NSString stringWithFormat:@"%@View/getUserViewList1_2",kAPI_bendi];
    NSDictionary *para ;
    if (typeID == 0) {
        para = @{@"user_id":self.loginState.userId,
                 @"type":@"publish1",
                 @"page":[NSString stringWithFormat:@"%d",self.page]
                 };
    }
    else
    {
        para = @{@"user_id":self.loginState.userId,
                 @"type":@"publish0",
                 @"page":[NSString stringWithFormat:@"%d",self.page]
                 };
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *data = responseObject[@"data"];
            if (data.count > 0 ) {
                NSMutableArray *list = nil;
                if (wself.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[data count]];
                }
                else
                {
                    list = [NSMutableArray arrayWithArray:self.listArr];
                }
                for (NSDictionary *d in data) {
                    ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                    [list addObject:model];
                }
                wself.listArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.hud hide:YES afterDelay:0.1];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.hud.labelText = @"加载失败";
        [self.hud hide:YES afterDelay:0.1];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ViewPointListModel *model = self.listArr[indexPath.row];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.user_facemin]];
    NSString *isoriginal;
    if ([model.view_isoriginal isEqualToString:@"0"]) {
        isoriginal = @"转载";
    }else
    {
        isoriginal = @"原创";
    }
    cell.nicknameLabel.text = [NSString stringWithFormat:@"%@  %@  %@",model.user_nickname,model.view_wtime,isoriginal];
    
    
    UIFont *font = [UIFont systemFontOfSize:16];
    cell.titleLabel.font = font;
    cell.titleLabel.numberOfLines = 0;
    titlesize = CGSizeMake(kScreenWidth-30, 500.0);
    titlesize = [model.view_title calculateSize:titlesize font:font];
    cell.titleLabel.text = model.view_title;
    [cell.titleLabel setFrame:CGRectMake(15, 15+25+10, kScreenWidth-30, titlesize.height)];
    
    cell.nicknameLabel.textColor = self.daynightmodel.titleColor;
    cell.titleLabel.textColor = self.daynightmodel.textColor;
    cell.backgroundColor = self.daynightmodel.navigationColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15+25+10+titlesize.height+15;
}



@end
