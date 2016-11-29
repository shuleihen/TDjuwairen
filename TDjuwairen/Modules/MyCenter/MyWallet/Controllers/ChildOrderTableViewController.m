//
//  ChildOrderTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define redTextColor [HXColor hx_colorWithHexRGBAString:@"#E83C3D"]

#define yelloTextColor [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"]

#import "ChildOrderTableViewController.h"
#import "OrderModel.h"
#import "OrderDetailTableViewCell.h"
#import "NoOrderTableViewCell.h"

#import "AFNetworking.h"
#import "NetworkDefine.h"
#import "MJRefresh.h"
#import "HexColors.h"
#import "Masonry.h"

#import "LoginState.h"
#import "UIdaynightModel.h"

@interface ChildOrderTableViewController ()<OrderDetailCellDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) NSMutableArray *orderArr;

@property (nonatomic,assign) int tag;

@property (nonatomic,assign) int page;

@end

@implementation ChildOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.orderArr = [NSMutableArray array];
    self.page = 1;
    
    self.tableView.backgroundColor = self.daynightModel.navigationColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 250;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self addRefreshView];     //设置刷新
}

- (void)addRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestWithOrderListAndTag:self.tag];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestWithOrderListAndTag:self.tag];
}

- (void)requestWithOrderListAndTag:(int)tag
{
    self.tag = tag;
    NSDictionary *para = @{@"user_id":US.userId,
                           @"type":[NSString stringWithFormat:@"%d",tag-1],
                           @"page":[NSString stringWithFormat:@"%d",self.page]};
    NSString *url = [NSString stringWithFormat:@"%@User/getUserOrder",API_HOST];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        
        if (dataArr.count > 0 ) {
            NSMutableArray *list = nil;
            if (self.page == 1) {
                list = [NSMutableArray arrayWithCapacity:[dataArr count]];
            }
            else
            {
                list = [NSMutableArray arrayWithArray:self.orderArr];
            }
            for (NSDictionary *dic in dataArr) {
                OrderModel *model = [OrderModel getInstanceFromDic:dic];
                [list addObject:model];
            }
            self.orderArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.orderArr.count > 0) {
        return self.orderArr.count;
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.orderArr.count > 0) {
        OrderModel *model = self.orderArr[indexPath.row];
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        if (cell == nil) {
            cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
        }
        cell.delegate = self;
        [cell setupUIWithString:model.order_amount andIndexPath:indexPath];
        cell.IDLab.text = @"订单ID: ";
        cell.orderID.text = model.order_sn;
        cell.orderTitle.text = model.order_sn;
        cell.timeLab.text = @"下单时间：";
        cell.orderTime.text = model.order_ptime;
        cell.orderStatus.text = model.order_paystatus;
        if ([model.order_paystatus isEqualToString:@"交易成功"]) {
            cell.orderStatus.textColor = [HXColor hx_colorWithHexRGBAString:@"#1B69B1"];
        }
        else
        {
            cell.orderStatus.textColor = redTextColor;
        }
        cell.moneyImg.image = [UIImage imageNamed:@"icon_price"];
        cell.orderMoney.textColor = redTextColor;
        cell.cleanBtn.tag = indexPath.row;
        [cell.cleanBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        return cell;
    }
    else
    {
        NoOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noOrderCell"];
        if (cell == nil) {
            cell = [[NoOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noOrderCell"];
        }
        cell.imgView.image = [UIImage imageNamed:@"icon_zanwu"];
        cell.titLab.text = @"暂时没有订单~";
        CGFloat imgX = (kScreenHeight-108)/6;
        [cell.titLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell).with.offset(-(kScreenHeight-64-imgX-90-25-40));
        }];
        return cell;
    }
}

#pragma mark - 点击删除订单
- (void)clickDeleteCell:(UIButton *)sender
{
    OrderModel *model = self.orderArr[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    NSString *url = [NSString stringWithFormat:@"%@User/delUserOrder",API_HOST];
    NSDictionary *para = @{@"orderID":model.order_id};
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if (data[@"status"]) {
            [self.orderArr removeObject:model];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
@end
