//
//  SurDetailViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/7.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurDetailViewController.h"
#import "SurDataView.h"
#import "SurDetailSelBtnView.h"

#import "UIdaynightModel.h"

@interface SurDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UIScrollView *scrollview;

@property (nonatomic,strong) SurDataView *dataView;

@property (nonatomic,strong) SurDetailSelBtnView *selBtnView;

@end

@implementation SurDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    
    [self setupWithNavigation];
    [self setupWithScrollView];
    [self setupWithDateView];
    [self setupWithSelectBtn];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = self.company_name;
}

- (void)setupWithScrollView{
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.scrollview.delegate = self;
    
    self.scrollview.backgroundColor = self.daynightModel.navigationColor;
    self.scrollview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*5);
    [self.view addSubview:self.scrollview];
}

- (void)setupWithDateView{
    self.dataView = [[SurDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140) WithStockID:@"sz000001"];
    self.dataView.backgroundColor = self.daynightModel.navigationColor;
    self.dataView.yestodEndPri.textColor = self.daynightModel.titleColor;
    self.dataView.todayStartPri.textColor = self.daynightModel.titleColor;
    self.dataView.todayMax.textColor = self.daynightModel.titleColor;
    self.dataView.todayMin.textColor = self.daynightModel.titleColor;
    self.dataView.traNumber.textColor = self.daynightModel.titleColor;
    self.dataView.traAmount.textColor = self.daynightModel.titleColor;
    [self.scrollview addSubview:self.dataView];
}

- (void)setupWithSelectBtn{
    self.selBtnView = [[SurDetailSelBtnView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, 60)];
    [self.scrollview addSubview:self.selBtnView];
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
