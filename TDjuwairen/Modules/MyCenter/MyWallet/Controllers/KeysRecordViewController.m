//
//  KeysRecordViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define redTextColor [HXColor hx_colorWithHexRGBAString:@"#E83C3D"]

#define yelloTextColor [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"]

#import "KeysRecordViewController.h"
#import "RecordModel.h"
#import "OrderDetailTableViewCell.h"
#import "NoOrderTableViewCell.h"

#import "LoginState.h"
#import "UIdaynightModel.h"

#import "AFNetworking.h"
#import "NetworkDefine.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "HexColors.h"
#import "NSString+Ext.h"

@interface KeysRecordViewController ()<UITableViewDataSource,UITableViewDelegate,OrderDetailCellDelegate>
@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *keyRecordArr;

@property (nonatomic,assign) int page;

@end

@implementation KeysRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.keyRecordArr = [NSMutableArray array];
    self.page = 1;
    
    [self setupWithNavigation];
    [self setupWithTableView];
    
    [self requestWithKeyRecord];
    
    [self addRefreshView];     //设置刷新
    // Do any additional setup after loading the view.
}

- (void)addRefreshView{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestWithKeyRecord];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestWithKeyRecord];
}


- (void)setupWithNavigation{
    self.title = @"钥匙使用记录";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = self.daynightModel.navigationColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 250;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.keyRecordArr.count > 0) {
        return self.keyRecordArr.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.keyRecordArr.count > 0) {
        RecordModel *model = self.keyRecordArr[indexPath.row];
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        if (cell == nil) {
            cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
        }
        cell.delegate = self;
        
        [cell setupUIWithString:model.record_keynum andIndexPath:indexPath];
        cell.IDLab.text = @"解锁股票";
        cell.orderTitle.text = model.record_item;
        cell.timeLab.text = @"解锁时间：";
        cell.orderTime.text = model.record_time;
        cell.moneyImg.image = [UIImage imageNamed:@"key_yellow"];
        cell.orderMoney.textColor = yelloTextColor;
        cell.cleanBtn.tag = indexPath.row;
        [cell.cleanBtn setTitle:@"删除记录" forState:UIControlStateNormal];
        
        return cell;
    }
    else
    {
        NoOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noOrderCell"];
        if (cell == nil) {
            cell = [[NoOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noOrderCell"];
        }
        cell.imgView.image = [UIImage imageNamed:@"icon_key"];
        cell.titLab.text = @"暂时使用记录~";
        
        CGFloat imgX = (kScreenHeight-108)/6;
        [cell.titLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell).with.offset(-(kScreenHeight-64-imgX-90-25-40));
        }];
        return cell;
    }
}

- (void)requestWithKeyRecord{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    NSString *url = [NSString stringWithFormat:@"%@User/getUserKeyRecord",API_HOST];
    NSDictionary *para = @{@"user_id":US.userId,
                           @"page":[NSString stringWithFormat:@"%d",self.page]};
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *dataArr = responseObject[@"data"];
        
        if (dataArr.count > 0 ) {
            NSMutableArray *list = nil;
            if (self.page == 1) {
                list = [NSMutableArray arrayWithCapacity:[dataArr count]];
            }
            else
            {
                list = [NSMutableArray arrayWithArray:self.keyRecordArr];
            }
            for (NSDictionary *dic in dataArr) {
                RecordModel *model = [RecordModel getInstanceWithDic:dic];
                [list addObject:model];
            }
            self.keyRecordArr = [NSMutableArray arrayWithArray:[list sortedArrayUsingSelector:@selector(compare:)]];
        }
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}

#pragma mark - 点击删除钥匙使用记录
- (void)clickDeleteCell:(UIButton *)sender
{
    RecordModel *model = self.keyRecordArr[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    NSString *url = [NSString stringWithFormat:@"%@User/delKeyRecord",API_HOST];
    NSDictionary *para = @{@"recordID":model.record_id};
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if (data[@"status"]) {
            [self.keyRecordArr removeObject:model];
            [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
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
