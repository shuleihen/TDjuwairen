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
#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "DescContentViewController.h"
#import "PublishViewViewController.h"

@interface ChildTableViewController ()
{
    CGSize titlesize;

}
@property (nonatomic,assign) int page;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,assign) int typeID;

@end

@implementation ChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArr = [NSMutableArray array];
    self.page = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.loginState = [LoginState sharedInstance];
    
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
    [self requestShowList:self.typeID];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestShowList:self.typeID];
}

- (void)requestShowList:(int)typeID
{
    self.typeID = typeID;
    NSDictionary *para ;
    if (typeID == 0) {
        para = @{@"user_id":US.userId,
                 @"type":@"publish1",
                 @"page":[NSString stringWithFormat:@"%d",self.page]
                 };
    }
    else if (typeID == 1){
        para = @{@"user_id":US.userId,
                 @"type":@"verifystatus0",
                 @"page":[NSString stringWithFormat:@"%d",self.page]
                 };
    }
    else
    {
        para = @{@"user_id":US.userId,
                 @"type":@"publish0",
                 @"page":[NSString stringWithFormat:@"%d",self.page]
                 };
    }
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager POST:API_GetUserViewList1_2 parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSArray *array = data;
            if (array.count > 0 ) {
                NSMutableArray *list = nil;
                if (self.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[array count]];
                }
                else
                {
                    list = [NSMutableArray arrayWithArray:self.listArr];
                }
                for (NSDictionary *d in data) {
                    ViewPointListModel *model = [ViewPointListModel getInstanceWithDictionary:d];
                    [list addObject:model];
                }
                self.listArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
            }
        
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.hud hide:YES afterDelay:0.1];
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.hud.labelText = @"加载失败";
            [self.hud hide:YES afterDelay:0.1];
            [self.tableView reloadData];
        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArr.count > 0) {
        return self.listArr.count;
    }
    else
    {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArr.count == 0) {
        NSString *identifier = @"ce";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"您当前还没有发布观点或草稿";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        cell.textLabel.textColor = self.daynightmodel.titleColor;
        cell.backgroundColor = self.daynightmodel.navigationColor;
        
        return cell;
    }
    else
    {
        NSString *identifier = @"cell";
        ViewPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ViewPointTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ViewPointListModel *model = self.listArr[indexPath.row];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:self.loginState.headImage]];
        NSString *isoriginal;
        if ([model.view_isoriginal isEqualToString:@"0"]) {
            isoriginal = @"转载";
        }else
        {
            isoriginal = @"原创";
        }
        cell.nicknameLabel.text = [NSString stringWithFormat:@"%@  %@  %@",self.loginState.nickName,model.view_wtime,isoriginal];
        
        
        UIFont *font = [UIFont systemFontOfSize:16];
        cell.titleLabel.font = font;
        cell.titleLabel.numberOfLines = 0;
        titlesize = CGSizeMake(kScreenWidth-30, 500.0);
        titlesize = [model.view_title calculateSize:titlesize font:font];
        cell.titleLabel.text = model.view_title;
        [cell.titleLabel setFrame:CGRectMake(15, 15+25+10, kScreenWidth-30, titlesize.height)];
        [cell.lineLabel setFrame:CGRectMake(0, 15+25+10+titlesize.height+14, kScreenWidth, 1)];
        
        cell.nicknameLabel.textColor = self.daynightmodel.titleColor;
        cell.titleLabel.textColor = self.daynightmodel.textColor;
        cell.backgroundColor = self.daynightmodel.navigationColor;
        cell.lineLabel.layer.borderColor = self.daynightmodel.lineColor.CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        if (self.listArr.count > 0) {
            ViewPointListModel *model = self.listArr[indexPath.row];
            if (self.typeID == 0 || self.typeID == 1) {
                DescContentViewController *dc = [[DescContentViewController alloc] init];
                dc.view_id = model.view_id;
                dc.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
                [self.navigationController pushViewController:dc animated:YES];
            }
            else
            {
                PublishViewViewController *publish = [[PublishViewViewController alloc]init];
                publish.titleStr = model.view_title;
                publish.contentStr = model.view_content;
                [self.navigationController pushViewController:publish animated:YES];
            }
        }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15+25+10+titlesize.height+15;
}



@end
