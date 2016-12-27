//
//  GuessAddPourViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GuessAddPourViewController.h"
#import "HexColors.h"

@interface GuessAddPourViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation GuessAddPourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textField.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#ec9c1d"].CGColor;
    self.textField.layer.cornerRadius = 4.0f;
    self.textField.layer.borderWidth = 1.0f;
}


@end
