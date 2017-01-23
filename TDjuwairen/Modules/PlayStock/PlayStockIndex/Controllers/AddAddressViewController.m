//
//  AddAddressViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AddAddressViewController.h"
#import "YXLocationPicker.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "NSString+Util.h"
#import "LoginState.h"

@interface AddAddressViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.footerView.backgroundColor = TDViewBackgrouondColor;
    
    self.addressTextField.delegate = self;
    
    [self queryAddress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardPressed:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)hideKeyboardPressed:(id)sender {
    [self.view endEditing:YES];
}

- (void)queryAddress {    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = @{@"user_id" : US.userId,
                           @"game_item_id" : self.guessId};
    
    __weak AddAddressViewController *wself = self;
    [ma GET:API_GameQueryAddress parameters:dict completion:^(id data,NSError *error){
        [hud hide:YES];
        
        if (!error && data) {
            BOOL isSubmit = [data[@"is_submit"] boolValue];
            
            
            if (isSubmit) {
                NSString *address = data[@"award_address"];
                NSString *area = data[@"award_area"];
                NSString *name = data[@"award_reciv_name"];
                NSString *phone = data[@"award_phone"];
                
                wself.nameTextField.text = name;
                wself.nameTextField.enabled = NO;
                
                wself.phoneTextField.text = phone;
                wself.phoneTextField.enabled = NO;
                
                wself.addressTextField.text = area;
                wself.addressTextField.enabled = NO;
                
                wself.detailAddressTextField.text = address;
                wself.detailAddressTextField.enabled = NO;
                
                wself.footerView.hidden = YES;
            }
        } else {
            
        }
    }];
}

- (void)showAddressPicker {
    
    __weak AddAddressViewController *wself = self;
    YXLocationPicker *picker = [[YXLocationPicker alloc] init];
    [picker showWithCompleteBlock:^(NSString *province,NSString *city,NSString *strict){
        wself.addressTextField.text = [NSString stringWithFormat:@"%@%@%@",province,city,strict];
    }];
}

- (IBAction)deonPressed:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *detail = self.detailAddressTextField.text;
    NSString *award = @"iPhone7Plus";
    
    if (!name.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"姓名不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(![phone isValidateMobile]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = (phone.length==0)?@"手机号不能为空":@"手机号格式错误";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(!address) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请选择省市区";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(!detail.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请填写详细地址";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NSDictionary *dict = @{@"user_id" : US.userId,
                           @"recive_name" : name,
                           @"phone" : phone,
                           @"address" : detail,
                           @"area" : address,
                           @"award" : award,
                           @"game_item_id" : self.guessId};
    
    __weak AddAddressViewController *wself = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请仔细检查并确认您填写的信息无误~" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"再改改" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [wself sendAddressWithDict:dict];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendAddressWithDict:(NSDictionary *)dict {
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    
    __weak AddAddressViewController *wself = self;
    [ma POST:API_GameAddAddress parameters:dict completion:^(id data,NSError *error){
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.addressTextField) {
        [self.view endEditing:YES];
        [self showAddressPicker];
        return NO;
    }
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
    } else if (section == 1) {
        return 30.0f;
    }
    return 0.001f;
}


@end
