//
//  OpenAnAccountController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/4/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "OpenAnAccountController.h"
#import "PhoneNumViewController.h"
#import "STPopupController.h"
#import "UIViewController+STPopup.h"
#import "NetworkManager.h"
#import "YXSecurityCodeButton.h"
#import "MBProgressHUD.h"
#import "NSString+Util.h"
#import "TDWebViewController.h"

@interface OpenAnAccountController ()<YXSecurityCodeButtonDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel1;

@property (weak, nonatomic) IBOutlet UILabel *showLabel2;

@property (weak, nonatomic) IBOutlet UIView *openAnAccountView;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UIView *verifyView;
@property (nonatomic, assign) BOOL isChecking;

@property (weak, nonatomic) IBOutlet UITextField *input_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *input_phoneCode;
@property (nonatomic, copy) NSString *msg_unique_id;
@property (weak, nonatomic) IBOutlet YXSecurityCodeButton *sendCodeButton;

@end

@implementation OpenAnAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showLabel1.text = @"请点击【去开户】进入爱建证券APP进行开户\n开户成功后回到此页点击下一步";
    self.showLabel2.text = @"请耐心等待 ，\n工作人员核对后会把钥匙奖励直接放入您的钱包";
    _sendCodeButton.delegate = self;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.contentScrollView addGestureRecognizer:tap];
    
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth*3, 0);
    
    self.openAnAccountView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.contentScrollView addSubview:self.openAnAccountView];
    self.checkView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64);
    [self.contentScrollView addSubview:self.checkView];
    self.verifyView.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-64);
    [self.contentScrollView addSubview:self.verifyView];
    
    __weak typeof(self)weakSelf = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_ShowFirmAccountInfo parameters:@{@"plat_id":_model.plat_id} completion:^(id data, NSError *error) {
        if (!error) {
//          self.isChecking = NO;
        }
    }];
    
    self.isChecking = [_model.account_status boolValue];
   
    if (self.isChecking == YES) {
        [self.contentScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
       
    }else {
    
        [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
  
}

- (void)setModel:(FirmPlatListModel *)model
{
    _model = model;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 按钮点击事件
- (IBAction)stepButtonClick:(UIButton *)sender {
    
    switch (sender.tag - 1000) {
        case 0:
            // 开户中的的下一步按钮
            
            if (self.isChecking == YES) {
                
               
                [self.contentScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
            }else {
                
                [self.contentScrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:NO];
            }
            break;
        case 1:
            // 验证页面中的的上一步按钮
           
            [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            break;
        case 2:
            // 审核页面中的上一步按钮
            [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            break;
        case 3:
            // 更改手机号
           
            [self.contentScrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:NO];
            break;
            
        case 4:
            // 确定
            [self doneClick];
            break;
        case 5:
            // 去开户
        {
            NSURL *url = [NSURL URLWithString:self.model.plat_url];
            TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)doneClick
{
    [self.view endEditing:YES];

    NSString *code = self.input_phoneCode.text;
    NSString *msg_unique_id = self.sendCodeButton.msg_unique_id;
    NSString *phone = self.input_phoneNum.text;
    if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!msg_unique_id.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先获取证码";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if (!code.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先填写验证码";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"msg_unique_id": msg_unique_id,
                          @"msg_code": code};

    [manager POST:API_LoginCheckPhoneCode parameters:dic completion:^(id data, NSError *error){
        if (data) {
            BOOL is_expire = [data[@"is_expire"] boolValue];
            BOOL is_verify = [data[@"is_verify"] boolValue];
            
            if (is_verify) {
                [self requestChangePhone];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = is_expire?@"验证码过期，请重新获取":@"验证码错误，请重新输入";
                [hud hide:YES afterDelay:0.4];
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"验证码错误，请重新输入";
            [hud hide:YES afterDelay:0.4];
        }
    }];


}

- (void)requestChangePhone{
    NSString *phone = self.input_phoneNum.text;
    NSString *msg_unique_id = self.sendCodeButton.msg_unique_id;
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"msg_unique_id":msg_unique_id,
                           @"user_phone": phone,
                           @"plat_id":_model.plat_id
                           };
    [manager POST:API_FirmAccount_AddFirmAccount parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            self.isChecking = YES;
            if (self.isChecking == YES) {
                
                
                [self.contentScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
            }else {
                
                [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = error.userInfo[@"NSLocalizedDescription"];
            [hud hide:YES afterDelay:0.8];
        }
    }];
}




#pragma mark -YXSecurityCodeButtonDelegate
- (BOOL)canRequest {
    if (_input_phoneNum.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号";
        [hud hide:YES afterDelay:0.8];
        return NO;
    }
    return YES;
}

- (NSString *)codeWithPhone {
    NSString *phone = _input_phoneNum.text;
    return phone;
}

- (PhoneCodeType)codeType {
    return kPhoneOpenAccount;
}


- (IBAction)contantSevers:(id)sender {
    PhoneNumViewController *vc = [[PhoneNumViewController alloc] init];
    vc.sourceArr = _model.plat_phone;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, [vc getSelfHight]);
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (void)hiddenKeyBoard {
[self.view endEditing:YES];

}


@end
