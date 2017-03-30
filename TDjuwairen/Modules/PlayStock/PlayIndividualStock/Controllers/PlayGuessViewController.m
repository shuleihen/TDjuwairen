//
//  PlayGuessViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayGuessViewController.h"
#import "PAStepper.h"
#import "HexColors.h"
#import "UIImage+Create.h"
#import "STPopup.h"


@interface PlayGuessViewController ()
{
    __weak IBOutlet UILabel *label_CountDown;
    __weak IBOutlet UITextField *inputView;
    
    
    __weak IBOutlet UILabel *label_moneyUse;
}
@property (weak, nonatomic) IBOutlet PAStepper *stepper;
@property (nonatomic, assign) float nowPri;

@end

@implementation PlayGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initValue];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)determineClick:(id)sender {

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addWithGuessId:pri:season:)]) {
        [self.delegate addWithGuessId:inputView.text pri:self.stepper.value season:self.season];
    }
    
    [self.popupController dismiss];
}

- (void)initValue
{
    
}

- (void)initViews
{
    [inputView setValue:[UIColor hx_colorWithHexRGBAString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
    inputView.layer.cornerRadius = 4;
    inputView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#ec9c1d"].CGColor;
    inputView.layer.borderWidth = 1;
    self.stepper.maximumValue = self.nowPri + 100;
    self.stepper.minimumValue = self.nowPri - 100;
    self.stepper.value = self.nowPri;
    
    self.stepper.stepValue = 0.01;
    self.stepper.textColor = [UIColor hx_colorWithHexRGBAString:@"#ec9c1d"];
    
    UIImage *bg = [UIImage imageWithSize:CGSizeMake(200, 30)
                          backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#0A0B0D"]
                             borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                            cornerRadius:4.0f];
    
    UIImage *decrease = [UIImage imageWithSize:CGSizeMake(30, 30)
                                backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#0A0B0D"]
                                   borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                  cornerRadius:4.0f];
    
    UIImage *increase = [UIImage imageWithSize:CGSizeMake(30, 30)
                                backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#0A0B0D"]
                                   borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                  cornerRadius:4.0f];
    UIImage *heightlight = [UIImage imageWithSize:CGSizeMake(30, 30)
                                   backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                      borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                     cornerRadius:4.0f];
    
    [self.stepper setBackgroundImage:bg forState:UIControlStateNormal];
    [self.stepper setBackgroundImage:bg forState:UIControlStateHighlighted];
    
    [self.stepper.decrementButton setBackgroundImage:decrease forState:UIControlStateNormal];
    [self.stepper.decrementButton setBackgroundImage:heightlight forState:UIControlStateHighlighted];
//    self.stepper.decrementButton.frame = CGRectMake(0, 0, 44, 44);
    [self.stepper.incrementButton setBackgroundImage:increase forState:UIControlStateNormal];
    [self.stepper.incrementButton setBackgroundImage:heightlight forState:UIControlStateHighlighted];
//    self.stepper.incrementButton.frame = CGRectMake(0, 0, 44, 44);
    
    [self.stepper.decrementButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"] forState:UIControlStateNormal];
    [self.stepper.decrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.stepper.incrementButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"] forState:UIControlStateNormal];
    [self.stepper.incrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
