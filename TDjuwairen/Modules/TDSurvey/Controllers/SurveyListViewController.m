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
#import "SurDetailViewController.h"

#import "StockListModel.h"
#import "UIdaynightModel.h"
#import "LoginState.h"

#import "SDCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "NetworkManager.h"
#import "AFNetworking.h"
#import "NSString+Ext.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

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

@property (nonatomic,strong) NSMutableArray *stockListArr;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSTimer *refTimer;
@end

@implementation SurveyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.speedf = 0.5;
    self.page = 1;
    self.textArr = [NSArray arrayWithObjects:@"sz000001",@"sz000002",@"sz000003",@"sz000004",@"sz000005",@"sz000006",@"sz000007",@"sz000008",@"sz000009",@"sz000010",@"sz000011",@"sz000012",@"sz000013",@"sz000014",@"sz000015",@"sz000016",@"sz000017",@"sz000018",@"sz000019",@"sz000020",@"sz000001",@"sz000002",@"sz000003",@"sz000004",@"sz000005",@"sz000006",@"sz000007",@"sz000008",@"sz000009",@"sz000010",@"sz000011",@"sz000012",@"sz000013",@"sz000014",@"sz000015",@"sz000016",@"sz000017",@"sz000018",@"sz000019",@"sz000020",@"sz000001",@"sz000002",@"sz000003",@"sz000004",@"sz000005",@"sz000006",@"sz000007",@"sz000008",@"sz000009",@"sz000010",@"sz000011",@"sz000012",@"sz000013",@"sz000014",@"sz000015",@"sz000016",@"sz000017",@"sz000018",@"sz000019",@"sz000020", nil];
    
    self.stockListArr = [NSMutableArray array];
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

    [self requestWithList];
    
    [self setupWithTimer];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.naviView.backgroundColor = self.daynightmodel.navigationColor;
    [self.naviView.searchBtn setBackgroundColor:self.daynightmodel.inputColor];
    self.naviView.searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;  //线色
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
    
    [self.naviView.headImgBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadUnLogin"]];
    
    [self.tableview reloadData];
    
    [self.refTimer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.refTimer setFireDate:[NSDate distantFuture]];
}

- (void)setupWithNavigation{
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

- (void)requestWithList{
    //这里也可以用这个接口。但是得到的是JS类型的数据，解析半天没弄出来 - - ！
//    NSString *listStr = [self.textArr componentsJoinedByString:@","];
//    NSString *s = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@",listStr];
    NSString *str = @"http://192.168.1.103/Survey/lists/1";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        if (self.page > 1) {
            for (NSDictionary *d in dataArr) {
                StockListModel *model = [StockListModel getInstanceWithDictionary:d];
                [self.stockListArr addObject:model];
            }
        }
        else
        {
            [self.stockListArr removeAllObjects];
            for (NSDictionary *d in dataArr) {
                StockListModel *model = [StockListModel getInstanceWithDictionary:d];
                [self.stockListArr addObject:model];
            }
        }
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupWithTimer{
    self.refTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)refresh{
    NSLog(@"1");
    [self.tableview reloadData];
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
    return self.stockListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockListModel *model = self.stockListArr[indexPath.row];
    if (indexPath.row %2 != 1) {
        SurveyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listRightCell" forIndexPath:indexPath];
        NSString *http = [NSString stringWithFormat:@"http://web.juhe.cn:8080/finance/stock/hs?gid=%@&type=&key=84fbc17aeef934baa37526dd3f57b841",model.company_code];
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
                if ([data[@"increPer"] floatValue] > 0) {
                    cell.nowPri.textColor = [UIColor redColor];
                    cell.increPer.textColor = [UIColor redColor];
                    cell.increase.textColor = [UIColor redColor];
                }
                else
                {
                    cell.nowPri.textColor = [UIColor greenColor];
                    cell.increPer.textColor = [UIColor greenColor];
                    cell.increase.textColor = [UIColor greenColor];
                }
                
                NSString *date1 = [NSString stringWithFormat:@"%.2f",[data[@"nowPri"] floatValue]];
                CGSize d1Size = [date1 calculateSize:CGSizeMake(100, 100) font:[UIFont boldSystemFontOfSize:24]];
                cell.nowPri.text = date1;
                
                NSString *date2= [NSString stringWithFormat:@"%@%@",data[@"increPer"],@"%"];
                CGSize d2Size = [date2 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.increPer.text = date2;
                
                NSString *date3 = [NSString stringWithFormat:@"%.2f",[data[@"increase"] floatValue]];
                CGSize d3Size = [date3 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.increase.text = date3;
                
                [cell.stockImg sd_setImageWithURL:[NSURL URLWithString:model.survey_cover]];
                
                [cell.nowPri mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(d1Size.width);
                }];
                
                [cell.increPer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.nowPri).with.offset(8+d1Size.width);
                    make.width.mas_equalTo(d2Size.width);
                }];
                
                [cell.increase mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.increPer).with.offset(8+d2Size.width);
                    make.width.mas_equalTo(d3Size.width);
                }];
                [task cancel];
            }
            else
            {
                cell.stockName.text = model.company_name;
                cell.nowPri.text = @"0.00";
                cell.increPer.text = @"0.00%";
                cell.increase.text = @"0.00";
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        cell.stockName.text = [NSString stringWithFormat:@"%@",model.company_name];
        
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.bgView.backgroundColor = self.daynightmodel.navigationColor;
        cell.stockName.textColor = self.daynightmodel.textColor;
        cell.stockSurvey.textColor = self.daynightmodel.textColor;
        [manager.operationQueue cancelAllOperations];
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
                if ([data[@"increPer"] floatValue] > 0) {
                    cell.nowPri.textColor = [UIColor redColor];
                    cell.increPer.textColor = [UIColor redColor];
                    cell.increase.textColor = [UIColor redColor];
                }
                else
                {
                    cell.nowPri.textColor = [UIColor greenColor];
                    cell.increPer.textColor = [UIColor greenColor];
                    cell.increase.textColor = [UIColor greenColor];
                }
                
                NSString *date1 = [NSString stringWithFormat:@"%.2f",[data[@"nowPri"] floatValue]];
                CGSize d1Size = [date1 calculateSize:CGSizeMake(100, 100) font:[UIFont boldSystemFontOfSize:24]];
                cell.nowPri.text = date1;
                
                NSString *date2= [NSString stringWithFormat:@"%@%@",data[@"increPer"],@"%"];
                CGSize d2Size = [date2 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.increPer.text = date2;
                
                NSString *date3 = [NSString stringWithFormat:@"%.2f",[data[@"increase"] floatValue]];
                CGSize d3Size = [date3 calculateSize:CGSizeMake(100, 100) font:[UIFont systemFontOfSize:13]];
                cell.increase.text = date3;
                
                [cell.stockImg sd_setImageWithURL:[NSURL URLWithString:model.survey_cover]];
                
                [cell.nowPri mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(d1Size.width);
                }];
                
                [cell.increPer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.nowPri).with.offset(8+d1Size.width);
                    make.width.mas_equalTo(d2Size.width);
                }];
                
                [cell.increase mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.increPer).with.offset(8+d2Size.width);
                    make.width.mas_equalTo(d3Size.width);
                }];
                [task cancel];
            }
            else
            {
                cell.stockName.text = model.company_name;
                cell.nowPri.text = @"0.00";
                cell.increPer.text = @"0.00%";
                cell.increase.text = @"0.00";
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        cell.stockName.text = [NSString stringWithFormat:@"%@",model.company_name];
        
        cell.backgroundColor = self.daynightmodel.backColor;
        cell.bgView.backgroundColor = self.daynightmodel.navigationColor;
        cell.stockName.textColor = self.daynightmodel.textColor;
        cell.stockSurvey.textColor = self.daynightmodel.textColor;
        
        [manager.operationQueue cancelAllOperations];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    StockListModel *model = self.stockListArr[indexPath.row];
    SurDetailViewController *surDetail = [[SurDetailViewController alloc] init];
    surDetail.company_image = model.survey_cover;
    surDetail.company_code = model.company_code;
    surDetail.company_name = model.company_name;
    surDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:surDetail animated:YES];
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

#pragma mark - 定时器操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.refTimer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refTimer setFireDate:[NSDate distantPast]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.refTimer setFireDate:[NSDate distantPast]];;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
