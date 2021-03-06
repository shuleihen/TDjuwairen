//
//  AddIndividualViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AddIndividualViewController.h"
#import "PAStepper.h"
#import "HexColors.h"
#import "UIImage+Create.h"
#import "STPopup.h"
#import "NetworkManager.h"
#import "StockManager.h"
#import "NSString+Util.h"
#import "YXCheckBox.h"
#import "PlayStockHnadler.h"

@interface AddIndividualViewController ()<UITextFieldDelegate, StockManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *label_CountDown;
@property (weak, nonatomic) IBOutlet UILabel *label_NowTime;
@property (nonatomic, weak) IBOutlet UITextField *stockCodeTextField;
@property (weak, nonatomic) IBOutlet PAStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (weak, nonatomic) IBOutlet YXCheckBox *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) StockManager *stockManager;
@property (nonatomic, strong) StockInfo *stockInfo;
//@property (nonatomic, copy) NSString *guess_date;

@end

@implementation AddIndividualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self initValue];
    // Do any additional setup after loading the view from its nib.
    
    self.stockManager = [[StockManager alloc] init];
    self.stockManager.delegate = self;
    self.stockManager.isOpenTimer = NO;
}


- (void)setupDefaultStock:(StockInfo *)stockInfo withStockCode:(NSString *)stockCode {
    
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)", stockInfo.name,stockCode];
    self.stockCode = stockCode;
    self.stockCodeTextField.hidden = YES;
    
    self.stockInfo = stockInfo;
    [self checkDoneEnable];
}

- (void)setStockInfo:(StockInfo *)stockInfo {
    _stockInfo = stockInfo;
    
    self.stepper.maximumValue = stockInfo.yestodEndPriValue*1.1;
    self.stepper.minimumValue = stockInfo.yestodEndPriValue*0.9;
    self.stepper.value = stockInfo.nowPriValue;
    self.stepper.stepValue = 0.01;
    
    self.minPriceLabel.text = [NSString stringWithFormat:@"%.02lf",self.stepper.minimumValue];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"%.02lf",self.stepper.maximumValue];
}

- (void)initValue {
    __weak AddIndividualViewController *wself = self;

    NSTimeInterval nowDate = [[NSDate new] timeIntervalSince1970];
    NSInteger  regiTime = self.endtime - nowDate;
    
    wself.label_NowTime.text = [PlayStockHnadler stringWithSeason:self.season];
    
    [wself startWithTime:regiTime block:^(NSString *day) {
        wself.label_CountDown.text = day;
    }];
    
    [self.stockCodeTextField addTarget:self action:@selector(stockCodeFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.stockCodeTextField.delegate = self;
    
    self.priceLabel.text = @"";
    self.minPriceLabel.text = @"--";
    self.maxPriceLabel.text = @"--";
    self.stepper.value = 0;
    
    if (!self.isJoin) {
        // 发起竞猜没有分享
        self.forwardBtn.hidden = YES;
        self.forwardBtn.checked = NO;
        
        self.contentSizeInPopup = CGSizeMake(kScreenWidth, 250);
    } else {
        self.forwardBtn.checked = YES;
        
        self.contentSizeInPopup = CGSizeMake(kScreenWidth, 275);
    }
    
    [self checkDoneEnable];
}

- (void)initViews {
    if (self.isJoin) {
        self.inputView.hidden = YES;
        self.stockNameLabel.hidden = NO;
    } else {
        self.inputView.hidden = NO;
        self.stockNameLabel.hidden = YES;
        
        [self.stockCodeTextField setValue:[UIColor hx_colorWithHexRGBAString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        self.stockCodeTextField.layer.cornerRadius = 4;
        self.stockCodeTextField.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#ec9c1d"].CGColor;
        self.stockCodeTextField.layer.borderWidth = 1;
    }
    

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
    
    [self.stepper.incrementButton setBackgroundImage:increase forState:UIControlStateNormal];
    [self.stepper.incrementButton setBackgroundImage:heightlight forState:UIControlStateHighlighted];

    self.stepper.decrementButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.stepper.decrementButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"] forState:UIControlStateNormal];
    [self.stepper.decrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.stepper.incrementButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.stepper.incrementButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#ec9c1d"] forState:UIControlStateNormal];
    [self.stepper.incrementButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.stepper addTarget:self action:@selector(stepperDidChanged:) forControlEvents:UIControlEventValueChanged];
}



- (void)stockCodeFieldDidChanged:(UITextField *)tf
{
    if (tf.text.length == 6) {
        NSString *queryStockId = [tf.text queryStockCode];
        [self.stockManager queryStockId:queryStockId];
    } else {
        self.stepper.minimumValue = 0;
        self.stepper.maximumValue = 0;
        self.stepper.value = 0;
    }
    
    [self checkDoneEnable];
}

- (void)stepperDidChanged:(id)sender {

    if (self.stockInfo) {
        CGFloat y = self.stockInfo.yestodEndPriValue;
        CGFloat value = self.stepper.value;
        
        if (value == 0.0) {
            // 输入的价格为空
            self.priceLabel.text = @"";
        } else {
            CGFloat pv = value - y;
            if (pv > 0) {
                CGFloat bv = (pv/y)*100;
                NSString *str = [NSString stringWithFormat:@"%+.2f %.2f%%",pv,bv];
                self.priceLabel.text = str;
                self.priceLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#ff0000"];
            } else if (pv < 0){
                CGFloat bv = (pv/y)*100;
                NSString *str = [NSString stringWithFormat:@"%+.2f %.2f%%",pv,bv];
                self.priceLabel.text = str;
                self.priceLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#14C76A"];
            } else {
                self.priceLabel.text = @"";
            }
        }
    }
    
    [self checkDoneEnable];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return !(text.length == 7);
}

#pragma mark - StockManagerDelegate
- (void)reloadWithStocks:(NSDictionary *)stocks {
    StockInfo *stock = stocks.allValues.firstObject;
    self.stockInfo = stock;
}

- (void)startWithTime:(NSInteger)timeLine block:(void(^)(NSString *))timeBlock {
    
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                timeBlock(@"00:00:00");
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger h=seconds/3600;
                NSInteger m=(seconds-h*3600)/60;
                NSInteger s=(seconds-h*3600)%60;
                timeBlock([NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h,(long)m,(long)s]);
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)checkDoneEnable {
    NSString *stockCode = @"";
    if (self.isJoin) {
        stockCode = self.stockCode;
    } else {
        stockCode = self.stockCodeTextField.text;
    }
    BOOL validStockCode = [stockCode isValidateStockCode];
    BOOL validPirce = !(self.stepper.value == 0.0f);
    
    self.doneBtn.enabled = validPirce && validStockCode;
}

#pragma mark - action
- (IBAction)cancelPressed:(id)sender {
    [self.popupController dismiss];
}


- (IBAction)determineClick:(id)sender {
    NSString *stockCode = @"";
    if (self.isJoin) {
        stockCode = self.stockCode;
    } else {
        stockCode = self.stockCodeTextField.text;
    }
    
    [self.popupController dismissWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(addGuessWithStockCode:pri:season:isJoin:isForward:)]) {
            [self.delegate addGuessWithStockCode:stockCode pri:self.stepper.value season:self.season isJoin:self.isJoin isForward:self.forwardBtn.checked];
        }
    }];
}


@end
