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
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.titleArr = @[@"给我们评分",@"反馈意见"];
    haveUpdate = NO;
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self judgeAPPVersion];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"关于我们";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.tableview setSeparatorColor:self.daynightmodel.lineColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/4*3)];
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenWidth/4*3/4)];
    imgview.center = view.center;
    imgview.image = [UIImage imageNamed:@"logo.png"];
    [view addSubview:imgview];
    self.tableview.tableHeaderView = view;
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    
//    if (haveUpdate == YES) {
//        if (indexPath.row == 0) {
//            NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
//            UIImage *image = [UIImage imageNamed:@"reddot"];
//            textAttach.image = image;
//            NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:cell.textLabel.attributedText];
//            [string insertAttributedString:strA atIndex:cell.textLabel.text.length];
//            cell.textLabel.attributedText = string;
//        }
//    }
    cell.textLabel.textColor = self.daynightmodel.textColor;
    cell.backgroundColor = self.daynightmodel.navigationColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        if (haveUpdate == YES) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到当前有新版本了，点击确认更新" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //跳转到商店
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
//            }]];
//            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [alert dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }
//    else
        if (indexPath.row == 0){
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1125295972"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else
    {
        FeedbackViewController *feedback = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FeedbackView"];
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
