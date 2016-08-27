//
//  MyAttentionViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "UserInfoViewController.h"
#import "MyAttentionTableViewCell.h"


#import "LoginState.h"
#import "UIdaynightModel.h"
#import "UIImageView+WebCache.h"

@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) UITableView *tableview;

@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupWithNavigation{
    self.title = @"我的关注";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    MyAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyAttentionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:US.headImage]];
    cell.nicknameLab.text = US.nickName;
    
    cell.backgroundColor = self.daynightmodel.navigationColor;
    cell.nicknameLab.textColor = self.daynightmodel.textColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:userinfo animated:YES];
    
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
