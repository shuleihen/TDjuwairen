//
//  PaySubscriptionViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PaySubscriptionViewController.h"
#import "HexColors.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "LoginStateManager.h"
#import "LoginViewController.h"

@interface PaySubscriptionViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong) UIView *toolView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *keyBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation PaySubscriptionViewController
- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitle:@"确认订阅" forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(12, 11, kScreenWidth-24, 34);
        btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        [btn addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        sep.backgroundColor = TDSeparatorColor;
        [_toolView addSubview:sep];
        
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardPressed:)];
    [self.tableView addGestureRecognizer:tap];
    
    self.subTitleLabel.text = [NSString stringWithFormat:@"周刊订阅(%@)",self.typeModel.subDesc];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)self.typeModel.keyNum];
    [self.keyBtn setTitle:key forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.toolView.frame = CGRectMake(0, kScreenHeight-55, kScreenWidth, 55);
    [self.navigationController.view addSubview:self.toolView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.toolView removeFromSuperview];
}

- (void)confirmPressed:(id)sender {
    
    if (!self.typeModel) {
        return;
    }
    
    NSString *name = self.nameTextField.text;
    NSString *email = self.emailTextField.text;
    
    if (!name.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"姓名不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!email.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"邮箱不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NSDictionary *dict = @{@"user_id" : US.userId,
                           @"type" : @(self.typeModel.subType),
                           @"way" : @(0),
                           @"real_name" : name,
                           @"email" : email};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"订阅中...";
    
    __weak PaySubscriptionViewController *wself = self;
    [ma POST:API_SubscriptionAdd parameters:dict completion:^(id data,NSError *error){
        if (!error && data && [data[@"status"] boolValue]) {
            hud.labelText = @"恭喜，订阅成功";
            hud.delegate = wself;
            [hud hide:YES afterDelay:0.4];
        } else {
            hud.labelText = error.localizedDescription?:@"订阅失败";
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboardPressed:(id)sender {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"产品信息";
    } else {
        label.text = @"订阅信息";
    }
        
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
