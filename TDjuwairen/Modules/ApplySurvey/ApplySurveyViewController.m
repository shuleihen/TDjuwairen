//
//  ApplySurveyViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ApplySurveyViewController.h"
#import "HexColors.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "NetworkDefine.h"
#import "MBProgressHUD.h"
#import "NSString+Emoji.h"
#import "NetworkManager.h"
#import "NSString+Util.h"
#import "YXCheckBox.h"
#import "TDWebViewController.h"
#import "RechargeViewController.h"
#import "STPopupController.h"

@interface ApplySurveyViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *stockNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *HoldingNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *attentionTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) UIView *toolView;
@property (weak, nonatomic) IBOutlet YXCheckBox *checkBox;

@end

@implementation ApplySurveyViewController

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"申请调研" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.frame = CGRectMake(12, 12, kScreenWidth-24, 35);
        btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
        [btn addTarget:self action:@selector(applySurveyPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    self.checkBox.checked = YES;
    
    self.stockNumberTextField.text = self.stockId;
    self.companyTextField.text = self.stockName;
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardPressed:)];
    [self.tableView addGestureRecognizer:tap];
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

- (IBAction)agreePressed:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://appapi.juwairen.net/Page/index/p/diaoyanfuwushuoming"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applySurveyPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    if (!self.checkBox.checked) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先同意《局外人调研服务说明》";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NSString *stockCode = self.stockNumberTextField.text;
    NSString *companyName = self.companyTextField.text;
//    NSString *count = self.HoldingNumberTextField.text;
//    NSString *attent = self.attentionTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *email = self.emailTextField.text;
    
    if (!stockCode.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"股票不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(!companyName.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"公司名称不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(![email isValidateEmail]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = (email.length==0)?@"邮箱不能为空":@"邮箱格式错误";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    __weak ApplySurveyViewController *wself = self;
    NSString *message = [NSString stringWithFormat:@"需支付调研费用500把钥匙"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [wself queyUserKey];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)queyUserKey {
    
    __weak ApplySurveyViewController *wself = self;
    
    NSDictionary *para = @{@"user_id":US.userId};
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSInteger keyNumber = [data[@"keyNum"] integerValue];
            [wself applySurveyWithKeyNumber:keyNumber];
        }
        else
        {
            [wself applySurveyWithKeyNumber:0];
        }
    }];
}

- (void)applySurveyWithKeyNumber:(NSInteger)keyNumber {
    __weak ApplySurveyViewController *wself = self;
    
    if (keyNumber < 500) {
        NSString *message = [NSString stringWithFormat:@"金钥匙不足，先去充值吧~\r\n当前余额：%ld把",(long)keyNumber];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"立即充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [wself recharge];
        }];
        [alert addAction:cancel];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self sendApplySurveyRequest];
    }
}

- (void)recharge {
    RechargeViewController *vc = [[UIStoryboard storyboardWithName:@"Recharge" bundle:nil] instantiateViewControllerWithIdentifier:@"RechargeViewController"];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:self];
}

- (void)sendApplySurveyRequest {
    NSString *stockCode = self.stockNumberTextField.text;
    NSString *companyName = self.companyTextField.text;
    NSString *count = self.HoldingNumberTextField.text;
    NSString *attent = self.attentionTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *email = self.emailTextField.text;
    
    
    NSDictionary *dict = @{@"user_id" : US.userId,
                           @"code" : stockCode,
                           @"com_name" : companyName,
                           @"stock_number" : count.length?count:@"",
                           @"focus" : attent.length?attent:@"",
                           @"get_way" : @(2),
                           @"phone" : phone,
                           @"email" : email};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    
    __weak ApplySurveyViewController *wself = self;
    
    [ma POST:API_SurveyAddSurvey parameters:dict completion:^(id data,NSError *error){
        if (!error && data && [data[@"status"] boolValue]) {
            hud.labelText = @"提交成功";
            hud.delegate = wself;
            [hud hide:YES afterDelay:0.4];
        } else {
            hud.labelText = error.localizedDescription?:@"提交失败";
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
    return (section==0)?0.001:10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
