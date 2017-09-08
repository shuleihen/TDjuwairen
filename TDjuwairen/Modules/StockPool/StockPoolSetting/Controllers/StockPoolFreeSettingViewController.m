//
//  StockPoolFreeSettingViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolFreeSettingViewController.h"
#import "UIImage+Create.h"
#import "MBProgressHUD.h"
#import "NSString+Util.h"
#import "NetworkManager.h"

@interface StockPoolFreeSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation StockPoolFreeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收费方式";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    
    
    if (self.priceModel.isFree) {
        self.switchBtn.on = YES;
        self.keyTextField.enabled = NO;
        self.keyTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        self.monthLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
    } else {
        self.switchBtn.on = NO;
        self.keyTextField.enabled = YES;
        self.keyTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#3370E2"];
        self.monthLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3370E2"];
        self.keyTextField.text = [NSString stringWithFormat:@"%@", self.priceModel.key_num];
    }
}

- (IBAction)switchChanged:(id)sender {
    if (self.switchBtn.on) {
        self.switchBtn.on = YES;
        self.keyTextField.enabled = NO;
        self.keyTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
        self.monthLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#cccccc"];
    } else {
        self.switchBtn.on = NO;
        self.keyTextField.enabled = YES;
        self.keyTextField.textColor = [UIColor hx_colorWithHexRGBAString:@"#3370E2"];
        self.monthLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#3370E2"];
        self.keyTextField.text = [NSString stringWithFormat:@"%@", self.priceModel.key_num];
    }
}

- (IBAction)donePressed:(id)sender {
    [self.view endEditing:YES];
    
    NSString *keyString = self.keyTextField.text;
    if (keyString.length == 0 ||
        [keyString integerValue] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入钥匙数";
        [hud hideAnimated:YES afterDelay:0.8];
        return;
    }

    BOOL on = self.switchBtn.on;
    NSInteger key = [keyString integerValue];
    if (self.priceModel.isFree == on &&
        [self.priceModel.key_num integerValue] == key) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    __weak typeof (self)weakSelf = self;
    NSDictionary *dict = @{@"key_num": keyString,
                           @"is_free": @(on)};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_StockPoolSetPrice parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            hud.label.text = @"修改成功";
            hud.completionBlock =  ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [hud hideAnimated:YES afterDelay:0.8];
        } else {
            hud.label.text = @"修改失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
    }];
}

@end
