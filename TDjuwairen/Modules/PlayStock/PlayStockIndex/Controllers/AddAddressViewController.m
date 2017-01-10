//
//  AddAddressViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AddAddressViewController.h"
#import "YXLocationPicker.h"

@interface AddAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) NSString *address;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.footerView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.addressTextField.delegate = self;
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

- (void)showAddressPicker {
    
    __weak AddAddressViewController *wself = self;
    YXLocationPicker *picker = [[YXLocationPicker alloc] init];
    [picker showWithCompleteBlock:^(NSString *province,NSString *city,NSString *strict){
        wself.address = [NSString stringWithFormat:@"%@%@%@",province,city,strict];
        wself.addressTextField.text = wself.address;
    }];
}

- (IBAction)deonPressed:(id)sender {
    
}

@end
