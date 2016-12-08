//
//  AboutMineViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AboutMineViewController.h"
#import "UIdaynightModel.h"
#import "FeedbackViewController.h"
#import "UIStoryboard+MainStoryboard.h"

#import "AFNetworking.h"


@interface AboutMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL haveUpdate;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) NSString *trackViewUrl;

@end

@implementation AboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.titleArr = @[@"给我们评分",@"反馈意见"];
    haveUpdate = NO;
    
    [self setupWithTableView];
    [self judgeAPPVersion];
    // Do any additional setup after loading the view.
}

- (void)setupWithTableView {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.tableview setSeparatorColor:self.daynightmodel.lineColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:view.bounds];
    imgview.image = [UIImage imageNamed:@"icon_logo.png"];
    imgview.contentMode = UIViewContentModeCenter;
    [view addSubview:imgview];
    self.tableview.tableHeaderView = view;
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"AboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = self.daynightmodel.textColor;
    cell.backgroundColor = self.daynightmodel.navigationColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1125295972"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else {
        FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedback animated:YES];
    }
}

#pragma mark - detection
- (void)judgeAPPVersion{
    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1125295972";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSDictionary *data = (NSDictionary *)responseObject;
        NSArray *infoContent = [data objectForKey:@"results"];
        //商店版本
        NSString *newversion = [[infoContent objectAtIndex:0] objectForKey:@"version"];
        
        //当前版本
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        self.trackViewUrl = [[infoContent objectAtIndex:0] objectForKey:@"trackViewUrl"];
        if (![newversion isEqualToString:currentVersion]) {
            //判断当前设备版本
            float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
            if (iOSVersion < 8.0f) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的系统版本过低，为了更好的用户体验请升级" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert addButtonWithTitle:@"确定"];
                [alert show];
            }
            else
            {
                haveUpdate = YES;
                [self.tableview reloadData];
            }
        }
        else
        {
            haveUpdate = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){}];
}

@end
