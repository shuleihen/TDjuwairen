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
#import "STPopupController.h"
#import "TDRechargeViewController.h"

#import "SearchCompanyListTableView.h"
#import "SearchCompanyListModel.h"


@interface ApplySurveyViewController ()<MBProgressHUDDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *stockNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *HoldingNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *attentionTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) UIView *toolView;
@property (weak, nonatomic) IBOutlet YXCheckBox *checkBox;
@property (strong, nonatomic) SearchCompanyListTableView *companyListTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *stockNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyNameCell;

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
    
    self.checkBox.checked = YES;
    
    self.stockNumberTextField.text = self.stockCode;
    self.companyTextField.text = self.stockName;
    
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCompanyTableView)];
//    [self.view addGestureRecognizer:tap];
    
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    
    [self.stockNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.companyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.companyListTableView = [[SearchCompanyListTableView alloc] initWithSearchCompanyListTableViewWithFrame:CGRectMake(85, 44, kScreenWidth-97, 0)];
    self.companyListTableView.vcType = @"特约调研";
    self.companyListTableView.userInteractionEnabled = YES;
    __weak typeof(self)weakSelf = self;
    self.companyListTableView.backBlock = ^(NSString *code,NSString *name){
        
        weakSelf.stockNumberTextField.text = code;
        weakSelf.companyTextField.text = name;
        
    };
    [self.view addSubview:self.companyListTableView];
    
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

#pragma mark - loadCompanyList
- (void)loadCompanyListData:(NSString *)textStr andTextField:(UITableViewCell *)cell {
    
    
    CGRect rect = [self.tableView convertRect:cell.frame toView:self.view];
    NSDictionary *dict = @{@"keyword":textStr};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_ViewSearchCompnay parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *dataArray = data;
            NSMutableArray *resultModelArrM = [NSMutableArray array];
            for (NSDictionary *d in dataArray) {
                SearchCompanyListModel *model = [[SearchCompanyListModel alloc] initWithDictionary:d];
                [resultModelArrM addObject:model];
            }
            
            [self.companyListTableView configResultDataArr:[resultModelArrM mutableCopy] andRectY:CGRectGetMaxY(rect) andBottomH:55];
            
        }else{
            [self.companyListTableView configResultDataArr:[NSArray array] andRectY:CGRectGetMaxY(rect) andBottomH:55];
        }
    }];
}





- (void)recharge {
    TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.stockNumberTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hiddenCompanyTableView];
}


- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField != self.stockNumberTextField && textField != self.companyTextField) {
        return;
    }
    
    self.stockCode = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField == self.stockNumberTextField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            return;
        }
    }
    
    if (textField.text.length > 0) {
        
        if (textField == self.stockNumberTextField) {
            [self loadCompanyListData:textField.text andTextField:self.stockNumberCell];
        }if (textField == self.companyTextField) {
            [self loadCompanyListData:textField.text andTextField:self.companyNameCell];
        }
        
    }else {
        
        CGRect rect = [self.tableView convertRect:textField.frame toView:self.view];
        [self.companyListTableView configResultDataArr:[NSMutableArray array] andRectY:CGRectGetMaxY(rect) andBottomH:55];
    }
}

#pragma mark - UITextViewDelegate 
- (void)textViewDidBeginEditing:(UITextView *)textView {

    [self hiddenCompanyTableView];
}


#pragma makr - 隐藏hiddenCompanyTableView
- (void)hiddenCompanyTableView {
    if (self.companyListTableView.hidden == NO) {
        self.companyListTableView.hidden = YES;
    }
}


@end
