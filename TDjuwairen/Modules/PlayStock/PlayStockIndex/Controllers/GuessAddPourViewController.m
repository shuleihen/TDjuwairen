//
//  GuessAddPourViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GuessAddPourViewController.h"
#import "HexColors.h"
#import "BorderButton.h"
#import "PAStepper.h"
#import "UIImage+Create.h"
#import "STPopup.h"

@interface GuessAddPourViewController ()
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *tenButton;
@property (weak, nonatomic) IBOutlet PAStepper *stepper;
@property (weak, nonatomic) IBOutlet UIButton *guessButton;

@property (nonatomic, assign) NSInteger keyNum;
@end

@implementation GuessAddPourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.oneButton.enabled = NO;
    self.fiveButton.enabled = NO;
    self.tenButton.enabled = NO;
    self.guessButton.enabled = NO;
    
    if (self.userKeyNum >= 10) {
        self.tenButton.enabled = YES;
    }
    
    if (self.userKeyNum >= 5) {
        self.fiveButton.enabled = YES;
    }
    
    if (self.userKeyNum >= 1) {
        self.oneButton.enabled = YES;
        // 默认选择一把钥匙
        self.oneButton.selected = YES;
        self.guessButton.enabled = YES;
        self.keyNum = 1;
    }
    
    self.stepper.maximumValue = self.nowPri + 100;
    self.stepper.minimumValue = self.nowPri - 100;
    self.stepper.value = self.nowPri;
    
    self.stepper.stepValue = 0.01;
    self.stepper.textColor = [UIColor hx_colorWithHexRGBAString:@"#ec9c1d"];
    
    UIImage *bg = [UIImage imageWithSize:CGSizeMake(200, 44)
                          backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#1b1a1f"]
                             borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                            cornerRadius:4.0f];
    
    UIImage *decrease = [UIImage imageWithSize:CGSizeMake(44, 44)
                                backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#1b1a1f"]
                                   borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                  cornerRadius:4.0f];
    
    UIImage *increase = [UIImage imageWithSize:CGSizeMake(44, 44)
                                backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#1b1a1f"]
                                   borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                  cornerRadius:4.0f];
    UIImage *heightlight = [UIImage imageWithSize:CGSizeMake(44, 44)
                                   backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                      borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                     cornerRadius:4.0f];
    
    [self.stepper setBackgroundImage:bg forState:UIControlStateNormal];
    [self.stepper setBackgroundImage:bg forState:UIControlStateHighlighted];
    
    [self.stepper.decrementButton setBackgroundImage:decrease forState:UIControlStateNormal];
    [self.stepper.decrementButton setBackgroundImage:heightlight forState:UIControlStateHighlighted];
    [self.stepper.incrementButton setBackgroundImage:increase forState:UIControlStateNormal];
    [self.stepper.incrementButton setBackgroundImage:heightlight forState:UIControlStateHighlighted];
    
    [self.stepper.decrementButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"] forState:UIControlStateNormal];
    [self.stepper.decrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.stepper.incrementButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"] forState:UIControlStateNormal];
    [self.stepper.incrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(50, 50)
                              backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#1b1a1f"]
                                 borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                cornerRadius:4.0f];
    
    UIImage *selected = [UIImage imageWithSize:CGSizeMake(50, 50)
                              backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                 borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                cornerRadius:4.0f];
    
    UIImage *disable = [UIImage imageWithSize:CGSizeMake(50, 50)
                                backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#333333"]
                                   borderColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"]
                                  cornerRadius:4.0f];
    
    NSArray *array = @[self.oneButton,self.fiveButton,self.tenButton];
    for (UIButton *btn in array) {
        [btn setBackgroundImage:normal forState:UIControlStateNormal];
        [btn setBackgroundImage:selected forState:UIControlStateHighlighted];
        [btn setBackgroundImage:selected forState:UIControlStateSelected];
        [btn setBackgroundImage:disable forState:UIControlStateDisabled];
    }
}

- (IBAction)guessPressed:(id)sender {
    if (self.keyNum <= 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addWithGuessId:pri:keyNum:)]) {
        [self.delegate addWithGuessId:self.guessId pri:self.stepper.value keyNum:self.keyNum];
    }
    
    [self.popupController dismiss];
}

- (IBAction)keyBtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        self.oneButton.selected = YES;
        self.fiveButton.selected = NO;
        self.tenButton.selected = NO;
    } else if (btn.tag == 5) {
        self.oneButton.selected = NO;
        self.fiveButton.selected = YES;
        self.tenButton.selected = NO;
    } else if (btn.tag == 10) {
        self.oneButton.selected = NO;
        self.fiveButton.selected = NO;
        self.tenButton.selected = YES;
    }
    
    self.keyNum = btn.tag;
    self.guessButton.enabled = YES;
}

@end
