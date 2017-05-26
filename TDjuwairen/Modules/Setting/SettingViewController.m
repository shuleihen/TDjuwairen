//
//  SettingViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SettingViewController.h"
#import "PushSwitchViewController.h"
#import "FeedbackViewController.h"
#import "LoginState.h"
#import "NotificationDef.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import "UIMacroDef.h"
#import "AccouontManagerViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *cachePathArr;
@property (nonatomic, strong) NSString *clearString;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgArr = @[@[@"icon_push.png",@"icon_push.png",@"icon_clear.png"],@[@"btn_fankui.png"]];
    self.titleArr = @[@[@"账号绑定",@"消息推送",@"清除缓存"],@[@"问题反馈"],@[@"退出"]];
    self.cachePathArr = [NSMutableArray array];
    
    [self setupWithNavigation];
    [self setupClearString];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.title = @"设置";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.backgroundColor = TDViewBackgrouondColor;
    [self.tableview setSeparatorColor:TDSeparatorColor];
    
    [self.view addSubview:self.tableview];
}

- (void)setupClearString {
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
    NSString *text = [NSString stringWithFormat:@"%.2fM",(size+size2+size3)/1024];
    if ([text floatValue ]<0.25) {
        self.clearString = @"0.00M";
    } else {
        self.clearString = text;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.titleArr[section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 1) {
        NSString *identifier = @"SettingsCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            cell.textLabel.textColor = TDTitleTextColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSArray *array = self.titleArr[indexPath.section];
        NSString *title = array[indexPath.row];
        
//        NSArray *images = self.imgArr[indexPath.section];
//        NSString *imageName = images[indexPath.row];
        
//        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = title;
        
        
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = self.clearString;
        } else {
            cell.detailTextLabel.text = @"";
        }
        
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
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AccouontManagerViewController *vc = [[UIStoryboard storyboardWithName:@"AccountManager" bundle:nil] instantiateViewControllerWithIdentifier:@"AccouontManagerViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            PushSwitchViewController *SwitchView = [[PushSwitchViewController alloc]init];
            [self.navigationController pushViewController:SwitchView animated:YES];
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
    } else if (indexPath.section == 1) {
        FeedbackViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
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
            [Defaults setValue:@"" forKey:@"unique_str"];
            [Defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangedNotification object:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
