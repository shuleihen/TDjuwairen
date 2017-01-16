//
//  GradeAddViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeAddViewController.h"
#import "HCSStarRatingView.h"
#import "HexColors.h"
#import "UITextView+Placeholder.h"

@interface GradeAddViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textLimitLabel;
@end

@implementation GradeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.title = [NSString stringWithFormat:@"评价 %@",self.stockName];
    
    [self setupUI];
}

- (void)setupUI {
    NSArray *itemTitle = @[@"德",@"智",@"财",@"势",@"创",@"观",@"透",@"行"];
    NSArray *itemDetail = @[@"管理层的信托责任",@"管理层运营能力",@"公司财务健康状况",@"估价走势",@"公司创新能力",@"公司外表形象",@"公司透明度",@"所处行业的潜力"];
    NSArray *itemValue = @[@"60",@"75",@"86",@"89",@"73",@"50",@"70",@"40"];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 500)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, 500);
    scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    UIView *gradeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 315)];
    gradeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:gradeView];
    
    CGFloat offy = 0;
    for (int i=0; i<8; i++) {
        NSString *title = itemTitle[i];
        NSString *detail = itemDetail[i];
        CGFloat value = [itemValue[i] floatValue]/20;
        
        offy = 19 +(18+18)*i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, offy, 40, 20)];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        label.text = title;
        [gradeView addSubview:label];
        
        HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(62, offy, 132, 18)];
        starRatingView.maximumValue = 5;
        starRatingView.minimumValue = 0;
        starRatingView.value = value;
        starRatingView.tintColor = [UIColor hx_colorWithHexRGBAString:@"#FD7D2B"];
        starRatingView.allowsHalfStars = YES;
//        starRatingView.accurateHalfStars = YES;
        starRatingView.emptyStarImage = [[UIImage imageNamed:@"star.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        starRatingView.filledStarImage = [[UIImage imageNamed:@"star_in.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        [gradeView addSubview:starRatingView];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, offy, kScreenWidth-215, 20)];
        detailLabel.font = [UIFont systemFontOfSize:12.0f];
        detailLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        detailLabel.text = detail;
        [gradeView addSubview:detailLabel];
    }
    
    UIView *textPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 325, kScreenWidth, 180)];
    textPanel.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:textPanel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-40, 180-35)];
    _textView.placeholder = @"写点评价吧，股民也能给出评级～";
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:15.0f];
    [textPanel addSubview:_textView];
    
    _textLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-200, 180-50, 200, 20)];
    _textLimitLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLimitLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    [textPanel addSubview:_textLimitLabel];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-55, kScreenWidth, 55)];
    toolView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    btn.frame = CGRectMake(12, 12, kScreenWidth-24, 34);
    btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
    [btn addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:btn];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    sep.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [toolView addSubview:sep];
    
    [self.view addSubview:scrollView];
    [self.view addSubview:toolView];
}

- (void)didChangeValue:(id)sender {
    
}

- (void)submitPressed:(id)sender {
    
}
@end
