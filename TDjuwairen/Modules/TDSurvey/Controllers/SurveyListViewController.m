//
//  SurveyListViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListViewController.h"
#import "SurveyListNavView.h"
#import "SurveyListTableViewCell.h"
#import "SurveyListLeftTableViewCell.h"
#import "PersonalCenterViewController.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "SDCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "NetworkManager.h"
#import "AFNetworking.h"
#import "NSString+Ext.h"
#import "Masonry.h"

@interface SurveyListViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    CGFloat _scalef;  //实时横向位移
}

@property (nonatomic,strong) NSMutableArray *scrollImageArray;  //轮播图片数据
@property (nonatomic,strong) NSMutableArray *scrollTitleArray;  //轮播标题数据
@property (nonatomic,strong) NSMutableArray *scrollIDArray;   //轮播链接数据

@property (nonatomic,assign) CGFloat speedf;

@property (nonatomic,strong) SurveyListNavView *naviView;

@property (nonatomic,strong) PersonalCenterViewController *personal;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@property (nonatomic,strong) NSArray *textArr;
@end

@implementation SurveyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.speedf = 0.5;
    
    self.textArr = [NSArray arrayWithObjects:@"sz000001",@"sz000002",@"sz000003",@"sz000004",@"sz000005",@"sz000006",@"sz000007",@"sz000008",@"sz000009",@"sz000010",@"sz000011",@"sz000012",@"sz000013",@"sz000014",@"sz000015",@"sz000016",@"sz000017",@"sz000018",@"sz000019",@"sz000020",@"sz000001",@"sz000002",@"sz000003",@"sz000004",@"sz000005",@"sz000006",@"sz000007",@"sz000008",@"sz000009",@"sz000010",@"sz000011",@"sz000012",@"sz000013",@"sz000014",@"sz000015",@"sz000016",@"sz000017",@"sz000018",@"sz000019",@"sz000020",@"sz000001",@"sz000002",@"sz000003",@"sz000004",@"sz000005",@"sz000006",@"sz000007",@"sz000008",@"sz000009",@"sz000010",@"sz000011",@"sz000012",@"sz000013",@"sz000014",@"sz000015",@"sz000016",@"sz000017",@"sz000018",@"sz000019",@"sz000020", nil];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [self.daynightmodel day];
    }
    else
    {
        [self.daynightmodel night];
    }
    
    [self setupWithNavigation];
    [self setupWithTableView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.naviView.backgroundColor = self.daynightmodel.navigationColor;
    [self.naviView.searchBtn setBackgroundColor:self.daynightmodel.inputColor];
    self.naviView.searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;  //线色
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    
    [self.naviView.headImgBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadUnLogin"]];
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.naviView = [[SurveyListNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.naviView.headImgBtn addTarget:self action:@selector(clickHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.naviView];
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-48) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 180;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerClass:[SurveyListTableViewCell class] forCellReuseIdentifier:@"listRightCell"];
    [self.tableview registerClass:[SurveyListLeftTableViewCell class] forCellReuseIdentifier:@"listLeftCell"];
    [self.view addSubview:self.tableview];
    
    //设置tableheadview无限轮播
    [self setupWithTableHeaderView];
}

#pragma mark - 设置tableHeaderView无限轮播
- (void)setupWithTableHeaderView{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/5*2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//page样式
    cycleScrollView.titlesGroup = self.scrollTitleArray;
    cycleScrollView.imageURLStringsGroup = self.scrollImageArray;
    self.tableview.tableHeaderView = cycleScrollView;
    
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_GetBanner parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            self.scrollImageArray = [NSMutableArray array];
            self.scrollTitleArray = [NSMutableArray array];
            self.scrollIDArray = [NSMutableArray array];
            NSArray *dataArr = data;
            for (NSDictionary *d in dataArr) {
                [self.scrollImageArray addObject:d[@"ad_imgurl"]];
                [self.scrollTitleArray addObject:d[@"ad_title"]];
                [self.scrollIDArray addObject:d[@"ad_link"]];
            }
            
            [self.tableview reloadData];//页面刷新
            cycleScrollView.titlesGroup = self.scrollTitleArray;//设置轮播图片的标题
            cycleScrollView.imageURLStringsGroup = self.scrollImageArray;//设置轮播图片
        } else {
            
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 != 1) {
        SurveyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listRightCell" forIndexPath:indexPath];
        NSString *git = self.textArr[indexPath.row];
        NSString *http = [NSString stringWithFormat:@"http://web.juhe.cn:8080/finance/stock/hs?gid=%@&type=&key=84fbc17aeef934baa37526dd3f57b841",git];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager GET:http parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSArray *result = dic[@"result"];
            if (result.count > 0) {
                NSDictionary *diction = result[0];
                NSDictionary *data = diction[@"data"];
                cell.stockName.text = [NSString stringWithFormat:@"%@(%@)",data[@"name"],data[@"gid"]];
                
                NSString *date1 = [NSString stringWithFormat:@"%.2f",[data[@"yestodEndPri"] floatValue]];
                CGSize d1Size = [date1 calculateSize:CGSizeMake(100, 100) font:[UIFont boldSystemFontOfSize:24]];
                cell.stockDate1.text = date1;
                
                NSString *date2= [NSString stringWithFormat:@"%@%@",data[@"increPer"],@"%"];
                CGSize d2Size = [date2 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.stockDate2.text = date2;
                
                NSString *date3 = [NSString stringWithFormat:@"%.2f",[data[@"nowPri"] floatValue]];
                CGSize d3Size = [date3 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.stockDate3.text = date3;
                
                [cell.stockDate1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(d1Size.width);
                }];
                
                [cell.stockDate2 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.stockDate1).with.offset(8+d1Size.width);
                    make.width.mas_equalTo(d2Size.width);
                }];
                
                [cell.stockDate3 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.stockDate2).with.offset(8+d2Size.width);
                    make.width.mas_equalTo(d3Size.width);
                }];
            }
            else
            {
                cell.stockName.text = @"错误";
                cell.stockDate1.text = @"0.00";
                cell.stockDate2.text = @"0.00%";
                cell.stockDate3.text = @"0.00";
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.bgView.backgroundColor = self.daynightmodel.navigationColor;
        return cell;
    }
    else
    {
        SurveyListLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listLeftCell" forIndexPath:indexPath];
        NSString *git = self.textArr[indexPath.row];
        NSString *http = [NSString stringWithFormat:@"http://web.juhe.cn:8080/finance/stock/hs?gid=%@&type=&key=84fbc17aeef934baa37526dd3f57b841",git];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager GET:http parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSArray *result = dic[@"result"];
            if (result.count > 0) {
                NSDictionary *diction = result[0];
                NSDictionary *data = diction[@"data"];
                cell.stockName.text = [NSString stringWithFormat:@"%@(%@)",data[@"name"],data[@"gid"]];
                
                NSString *date1 = [NSString stringWithFormat:@"%.2f",[data[@"yestodEndPri"] floatValue]];
                CGSize d1Size = [date1 calculateSize:CGSizeMake(100, 100) font:[UIFont boldSystemFontOfSize:24]];
                cell.stockDate1.text = date1;
                
                NSString *date2= [NSString stringWithFormat:@"%@%@",data[@"increPer"],@"%"];
                CGSize d2Size = [date2 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.stockDate2.text = date2;
                
                NSString *date3 = [NSString stringWithFormat:@"%.2f",[data[@"nowPri"] floatValue]];
                CGSize d3Size = [date3 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.stockDate3.text = date3;
                
                [cell.stockDate1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(d1Size.width);
                }];
                
                [cell.stockDate2 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.stockDate1).with.offset(8+d1Size.width);
                    make.width.mas_equalTo(d2Size.width);
                }];
                
                [cell.stockDate3 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.stockDate2).with.offset(8+d2Size.width);
                    make.width.mas_equalTo(d3Size.width);
                }];
            }
            else
            {
                cell.stockName.text = @"错误";
                cell.stockDate1.text = @"0.00";
                cell.stockDate2.text = @"0.00%";
                cell.stockDate3.text = @"0.00";
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.bgView.backgroundColor = self.daynightmodel.navigationColor;
        return cell;
    }
}

#pragma mark - 点击头像
- (void)clickHeadImg:(UIButton *)sender{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //方式
    transition.subtype = kCATransitionFromLeft; //方向
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    PersonalCenterViewController *personal = [[PersonalCenterViewController alloc] init];
    personal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personal animated:YES];
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
