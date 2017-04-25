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

@interface OpenAnAccountController ()<YXSecurityCodeButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showLabel1;

@property (weak, nonatomic) IBOutlet UILabel *showLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *triangleleft;
@property (weak, nonatomic) IBOutlet UIImageView *triangleRight;

@property (weak, nonatomic) IBOutlet UIView *openAnAccountView;
@property (weak, nonatomic) IBOutlet UIView *verifyView;
@property (weak, nonatomic) IBOutlet UIView *checkView;
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
    __weak typeof(self)weakSelf = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_ShowFirmAccountInfo parameters:@{@"plat_id":_model.plat_id} completion:^(id data, NSError *error) {
        if (!error) {
//          self.isChecking = NO;
        }

    }];

    self.isChecking = [_model.account_status boolValue];
    self.openAnAccountView.hidden = self.isChecking;
    
    
    if (self.isChecking == YES) {
        self.checkView.hidden = NO;
        self.verifyView.hidden = YES;
        self.triangleleft.hidden = YES;
        self.triangleRight.hidden = NO;
    }else {
        self.checkView.hidden = YES;
        self.verifyView.hidden = YES;
        self.triangleleft.hidden = NO;
        self.triangleRight.hidden = YES;
        
    }
}

- (void)setModel:(FirmPlatListModel *)model
{
    _model = model;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)stepButtonClick:(UIButton *)sender {
    
    switch (sender.tag - 1000) {
        case 0:
            // 开户中的的下一步按钮
            self.openAnAccountView.hidden = YES;
            
            
            if (self.isChecking == YES) {
                self.checkView.hidden = NO;
                self.verifyView.hidden = YES;
            }else {
                self.checkView.hidden = YES;
                self.verifyView.hidden = NO;
                
            }
            self.triangleleft.hidden = YES;
            self.triangleRight.hidden = NO;
            
            break;
        case 1:
            // 验证页面中的的上一步按钮
            self.openAnAccountView.hidden = NO;
            self.checkView.hidden = YES;
            self.verifyView.hidden = YES;
            self.triangleleft.hidden = NO;
            self.triangleRight.hidden = YES;
            break;
        case 2:
            // 审核页面中的上一步按钮
            self.openAnAccountView.hidden = NO;
            self.checkView.hidden = YES;
            self.verifyView.hidden = YES;
            self.triangleleft.hidden = NO;
            self.triangleRight.hidden = YES;
            break;
        case 3:
            // 更改手机号
            
            self.openAnAccountView.hidden = YES;
            self.checkView.hidden = YES;
            self.verifyView.hidden = NO;
            break;
            
        case 4:
            // 确定
            [self doneClick];
            break;
            
        default:
            break;
    }
}

- (void)doneClick
{
    [self.view endEditing:YES];
    
    NSString *phone = self.input_phoneNum.text;
    NSString *code = self.input_phoneCode.text;
    NSString *msg_unique_id = self.sendCodeButton.msg_unique_id;
    
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
                          @"msg_code": code,
                          @"plat_id":_model.plat_id
                          };
    /**
     
     名称	类型	说明	是否必填	示例	默认值
     msg_unique_id	string	手机发送验证码返回的标识	是
     user_phone	string	验证的手机号	是
     plat_id	int	平台ID	是
    */
    [manager POST:API_FirmAccount_AddFirmAccount parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            self.isChecking = YES;
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
//    NSString *phone = [_input_phoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
