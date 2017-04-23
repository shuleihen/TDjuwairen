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

@interface OpenAnAccountController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel1;

@property (weak, nonatomic) IBOutlet UILabel *showLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *triangleleft;
@property (weak, nonatomic) IBOutlet UIImageView *triangleRight;

@property (weak, nonatomic) IBOutlet UIView *openAnAccountView;
@property (weak, nonatomic) IBOutlet UIView *verifyView;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (nonatomic, assign) BOOL isChecking;




@end

@implementation OpenAnAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showLabel1.text = @"请点击【去开户】进入爱建证券APP进行开户\n开户成功后回到此页点击下一步";
    self.showLabel2.text = @"请耐心等待 ，\n工作人员核对后会把钥匙奖励直接放入您的钱包";
    self.isChecking = NO;
    
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
            self.isChecking = YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)contantSevers:(id)sender {
    PhoneNumViewController *vc = [[PhoneNumViewController alloc] init];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth, 49*3);
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
