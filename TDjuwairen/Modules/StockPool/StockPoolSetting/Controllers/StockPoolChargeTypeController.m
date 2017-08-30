//
//  StockPoolChargeTypeController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolChargeTypeController.h"
#import "Masonry.h"
#import "UILabel+TDLabel.h"
#import "UIView+Border.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "StockPoolPriceModel.h"

@interface StockPoolChargeTypeController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *saveBtn;
/// 钥匙数量textField
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UILabel *numDayLabel;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation StockPoolChargeTypeController

- (UITextField *)keyTextField {
    
    if (!_keyTextField) {
        _keyTextField = [[UITextField alloc] init];
        _keyTextField.placeholder = @"请输入钥匙数";
        _keyTextField.text = @"1";
        _keyTextField.textAlignment = NSTextAlignmentRight;
        _keyTextField.font = [UIFont systemFontOfSize:17.0];
        _keyTextField.delegate = self;
        _keyTextField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    return _keyTextField;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray arrayWithObjects:@"1",@"3", @"5",@"7",@"30",@"90",nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self congifNavigationBar];
    [self congfigCommonUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBorard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self hiddenKeyBorard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/** 设置导航条 */
- (void)congifNavigationBar {
    self.title = @"收费方式";
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_saveBtn setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
    //    [_saveBtn setTitleColor:TDDetailTextColor forState:UIControlStateDisabled];
    //    _saveBtn.enabled = NO;
    [_saveBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveBtn];
    
}


/** 设置UI */
- (void)congfigCommonUI {
    UIImageView *keyImageV  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_key_o"]];
    [self.view addSubview:keyImageV];
    [keyImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.keyTextField];
    [self.keyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keyImageV.mas_bottom).mas_offset(29);
        make.left.equalTo(self.view).mas_offset(12);
        make.right.equalTo(self.view.mas_centerX);
        
    }];
    
    _numDayLabel = [[UILabel alloc] initWithTitle:@"/3天" textColor:TDThemeColor fontSize:17.0 textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_numDayLabel];
    [_numDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keyTextField.mas_right).mas_offset(6);
        make.centerY.equalTo(self.keyTextField.mas_centerY);
        
    }];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = TDLineColor;
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(120);
        make.height.mas_equalTo(1);
    }];
    
    
    CGFloat btnW = (kScreenWidth-15*4)/3;
    CGFloat btnH = 60;
    CGFloat marginX = 15;
    CGFloat marginY = 20;
    CGFloat vHeigth = 120;
    for (int i=0; i<self.dataArr.count; i++) {
        NSString *titleStr = self.dataArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%@天",titleStr] forState:UIControlStateNormal];
        [btn setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn cutCircular:3];
        [btn addBorder:1 borderColor:TDThemeColor];
        btn.tag = i;
        btn.frame = CGRectMake(marginX+(btnW+marginX)*(i%3), 140+(btnH+marginY)*(i/3), btnW, btnH);
        [btn addTarget:self action:@selector(changeChargeTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if ([titleStr isEqualToString:@"3"]) {
            btn.selected = YES;
            btn.backgroundColor = TDThemeColor;
            self.selectedBtn = btn;
        }
        vHeigth = CGRectGetMaxY(btn.frame);
    }
    
    
    
    /// 例：1把钥匙/3天，他人支付1把钥匙即可查阅我的所有股票池记录，有效期：3天
    UILabel *descLabel = [[UILabel alloc] initWithTitle:@"例：1把钥匙/3天，他人支付1把钥匙即可查阅我的所有股票池记录，有效期：3天" textColor:TDDetailTextColor fontSize:13.0 textAlignment:NSTextAlignmentLeft];
    descLabel.numberOfLines = 0;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-15);
        make.top.equalTo(self.view).mas_offset(vHeigth+15);
        
    }];
    
    
    
    
}

- (void)changeChargeType {
    /**
     key_num	int	订阅钥匙数	是
     day	int	订阅天数	是
     is_free	int	1表示免费，0表示收费
     */
    __weak typeof (self)weakSelf = self;
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"key_num":self.keyTextField.text,
                           @"day":self.dataArr[self.selectedBtn.tag],
                           @"is_free":@"0"};
    
    [manager POST:API_StockPoolSetPrice parameters:dict completion:^(id data, NSError *error) {
        
        if (!error) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}

#pragma - action
- (void)saveBtnClick {
    
    if ([self.keyTextField.text integerValue] <= 0 || self.keyTextField.text.length <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (self.keyTextField.text.length <= 0) {
            
            hud.label.text = @"请输入钥匙数！";
        }else {
            hud.label.text = @"请输入正确的钥匙数！";
            self.keyTextField.text = @"";
            
        }
        
        [hud hideAnimated:YES afterDelay:0.8];
        return;
    }
    
    if ([[self.priceModel.key_num stringValue] isEqualToString:self.keyTextField.text] && [[self.priceModel.day stringValue] isEqualToString:self.dataArr[self.selectedBtn.tag]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"收费方式发生改变，新的收费方式将在8月5日生效！是否保存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertVC addAction:cancelAction];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeChargeType];
            
        }];
        [alertVC addAction:doneAction];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    
    
    
    
    
    
    
    
}

- (void)changeChargeTypeClick:(UIButton *)sender {
    if (sender.tag == self.selectedBtn.tag) {
        return;
    }
    
    self.selectedBtn.backgroundColor = [UIColor whiteColor];
    self.selectedBtn.selected = NO;
    
    sender.selected = YES;
    sender.backgroundColor = TDThemeColor;
    self.selectedBtn = sender;
    self.numDayLabel.text = [NSString stringWithFormat:@"/%@",sender.currentTitle];
    
    
}

#pragma - 手势
- (void)hiddenKeyBorard {
    [self.keyTextField resignFirstResponder];
    
}

@end
