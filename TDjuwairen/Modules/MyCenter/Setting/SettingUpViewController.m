//
//  SettingUpViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SettingUpViewController.h"
#import "UIdaynightModel.h"
#import "LoginState.h"
#import "PushMessageViewController.h"

#import "SDImageCache.h"
#import "MBProgressHUD.h"

@interface SettingUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *cachePathArr;

@end

@implementation SettingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.imgArr = @[@"pushMessageImg",@"clearImg"];
    self.titleArr = @[@"消息推送",@"清除缓存"];
    self.cachePathArr = [NSMutableArray array];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"设置";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    [self.tableview setSeparatorColor:self.daynightmodel.lineColor];
    
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.imageView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
        cell.textLabel.text = self.titleArr[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 1) {
            //取沙盒路径
            NSString *rootPath = NSHomeDirectory();
            NSString *tmpC = [NSString stringWithFormat:@"%@/tmp/MediaCache",rootPath];
            NSString *LibraryC = [NSString stringWithFormat:@"%@/Library/Caches",rootPath];
            NSString *DocumentC = [NSString stringWithFormat:@"%@/Documents",rootPath];
            [self.cachePathArr addObject:tmpC];
            [self.cachePathArr addObject:LibraryC];
            [self.cachePathArr addObject:DocumentC];
            //建立文件管理类
            NSFileManager *manager=[NSFileManager defaultManager];
            float size = [[manager attributesOfItemAtPath:tmpC error:nil] fileSize];
            float size2 = [[manager attributesOfItemAtPath:LibraryC error:nil] fileSize];
            float size3 = [[manager attributesOfItemAtPath:DocumentC error:nil] fileSize];
            NSLog(@"%.2f",size+size2+size3);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",(size+size2+size3)/1024];
            if ([cell.detailTextLabel.text floatValue ]<0.25) {
                cell.detailTextLabel.text = @"0.00M";
            }
        }
        cell.textLabel.textColor = self.daynightmodel.textColor;
        cell.backgroundColor = self.daynightmodel.navigationColor;
        
        return cell;
    }
    else
    {
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.textLabel.textColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
        cell.backgroundColor = self.daynightmodel.navigationColor;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //
            PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
            [self.navigationController pushViewController:messagePush animated:YES];
        }
        else
        {
            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"是否清除缓存？" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"正在清除...";
                for (NSString *path in self.cachePathArr) {
                    //建立文件管理类
                    NSFileManager *manager=[NSFileManager defaultManager];
                    NSString *name;
                    NSDirectoryEnumerator *directoryEnumerator= [manager enumeratorAtPath:path];
                    //遍历目录
                    while (name = [directoryEnumerator nextObject]) {
                        NSString *newPath = [NSString stringWithFormat:@"%@/%@",path,name];
                        //执行删除沙盒目录里的图片
                        [manager removeItemAtPath:newPath error:nil];
                    }
                    //清除缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                }
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = @"0.00M";
                hud.labelText = @"清除完成";
                [hud hide:YES afterDelay:1];
                [self.tableview reloadData];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    else
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            US.isLogIn=NO;
            US.userName=nil;
            US.headImage=nil;
            US.userId=nil;
            
            NSUserDefaults*Defaults=[NSUserDefaults standardUserDefaults];
            [Defaults setValue:@"" forKey:@"loginStyle"];
            [Defaults setValue:@"" forKey:@"account"];
            [Defaults setValue:@"" forKey:@"password"];
            [Defaults setValue:@"" forKey:@"openid"];
            [Defaults setValue:@"" forKey:@"unionid"];
            [Defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
