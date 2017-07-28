//
//  AwardViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AwardViewController.h"
#import "AwardImfomationTableViewCell.h"
#import "AwardAdressTableViewCell.h"
#import "LoginStateManager.h"
#import "NetworkManager.h"

@interface AwardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *titArr;

@end

@implementation AwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    
    if ([self.model.prize_level isEqualToString:@"1"]) {
        self.titArr = @[@"充值金额:",@"充值号码"];
        [self setupWithUPdate];
    }
    else
    {
        self.titArr = @[@"收货人:",@"电话:",@"邮编:",@"我的地址:"];
    }
    
    // Do any additional setup after loading the view.
}

- (void) setupWithNavigation{
    if ([self.model.prize_level isEqualToString:@"1"]) {
        self.title = @"手机充值";
    }
    else
    {
        self.title = @"领奖地址";
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickSave:)];
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[AwardImfomationTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[AwardAdressTableViewCell class] forCellReuseIdentifier:@"adress"];
    
    self.tableview.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableview];
}

- (void)setupWithUPdate{
    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 220, kScreenWidth-30, 50)];
    updateBtn.layer.cornerRadius = 5;
    [updateBtn setTitle:@"提交" forState:UIControlStateNormal];
    [updateBtn setBackgroundColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0]];
    [updateBtn addTarget:self action:@selector(clickUpdate:) forControlEvents:UIControlEventTouchUpInside];
    updateBtn.tag = [self.model.prize_level integerValue];;
    [self.view addSubview:updateBtn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.model.prize_level isEqualToString:@"1"]) {
        return 2;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.model.prize_level isEqualToString:@"1"]) {
        AwardImfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            NSRange range = [self.model.prize_name rangeOfString:@"元"];//匹配得到的下标
            NSRange r = NSMakeRange(0, range.location+range.length);
            NSString *string = [self.model.prize_name substringWithRange:r];//截取范围类的字符串
            cell.field.text = string;
            cell.field.userInteractionEnabled = NO;
        }
        
        cell.titLab.text = self.titArr[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titLab.textColor = TDTitleTextColor;
        cell.line.layer.borderColor = TDSeparatorColor.CGColor;
        return cell;
    }
    else
    {
        if (indexPath.row < 3) {
            AwardImfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.titLab.text = self.titArr[indexPath.row];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titLab.textColor = TDTitleTextColor;
            cell.line.layer.borderColor = TDSeparatorColor.CGColor;
            return cell;
        }
        else {
            AwardAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adress" forIndexPath:indexPath];
            cell.titLab.text = self.titArr[indexPath.row];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titLab.textColor = TDTitleTextColor;
            cell.line.layer.borderColor = TDSeparatorColor.CGColor;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        return 50;
    }
    else
    {
        return 200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (void)clickSave:(UIButton *)sender{
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    AwardImfomationTableViewCell *peoplecell = [self.tableview cellForRowAtIndexPath:indexPath0];
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    AwardImfomationTableViewCell *phonecell = [self.tableview cellForRowAtIndexPath:indexPath1];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
    AwardImfomationTableViewCell *zipcell = [self.tableview cellForRowAtIndexPath:indexPath2];
    
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
    AwardAdressTableViewCell *adresscell = [self.tableview cellForRowAtIndexPath:indexPath3];
    
    NSString *people = peoplecell.field.text;
    NSString *phone = phonecell.field.text;
    NSString *zip = zipcell.field.text;
    NSString *adress = adresscell.textView.text;
    
    NSString *url = @"User/keyExchange";
    NSDictionary *para = @{@"user_id":US.userId,
                          @"username":people,
                          @"address":adress,
                          @"phone":phone,
                          @"zipcode":zip,
                          @"level":self.model.prize_level};
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"%@",data);
            if ([data[@"status"] boolValue]) {
                //成功
                if (self.block) {
                    self.block([data[@"status"] boolValue],self.model);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
}

- (void)clickUpdate:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    AwardImfomationTableViewCell *phonecell = [self.tableview cellForRowAtIndexPath:indexPath];
    NSString *url = @"User/keyExchange";
    NSDictionary *para = @{@"user_id":US.userId,
                           @"phone":phonecell.field.text,
                           @"level":self.model.prize_level};
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"%@",data);
            if ([data[@"status"] boolValue]) {
                //成功
                if (self.block) {
                    self.block([data[@"status"] boolValue],self.model);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSLog(@"错误");
            }
        }
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
