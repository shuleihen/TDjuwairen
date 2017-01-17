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
#import "LoginState.h"
#import "LoginViewController.h"
#import "NetworkDefine.h"
#import "MBProgressHUD.h"
#import "NSString+Emoji.h"
#import "NetworkManager.h"

@interface GradeAddViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *gradeItems;
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
    /*
    NSArray *itemTitle = @[@"德",@"智",@"财",@"势",@"创",@"观",@"透",@"行"];
    NSArray *itemDetail = @[@"管理层的信托责任",@"管理层运营能力",@"公司财务健康状况",@"估价走势",@"公司创新能力",@"公司外表形象",@"公司透明度",@"所处行业的潜力"];
    NSArray *itemValue = @[@"60",@"75",@"86",@"89",@"73",@"50",@"70",@"40"];
    
    */
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-55)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, 500);
    scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardPressed:)];
    [scrollView addGestureRecognizer:tap];
    
    UIView *gradeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 315)];
    gradeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:gradeView];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:8];
    
    CGFloat offy = 0;
    for (int i=0; i<[self.gradeDetail.itemGrades count]; i++) {
        GradeItem *item = self.gradeDetail.itemGrades[i];
        NSString *title = item.title;
        NSString *detail = item.desc;
        CGFloat value = 0;
        
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
        [array addObject:starRatingView];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, offy, kScreenWidth-215, 20)];
        detailLabel.font = [UIFont systemFontOfSize:12.0f];
        detailLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        detailLabel.text = detail;
        [gradeView addSubview:detailLabel];
    }
    
    self.gradeItems = array;
    gradeView.frame = CGRectMake(0, 0, kScreenWidth, offy+20+18);
    
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

- (void)hideKeyboardPressed:(id)sender {
    [self.view endEditing:YES];
}

- (void)submitPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    
    NSString *comment = [self.textView.text stringByReplacingEmojiUnicodeWithCheatCodes];
    
    if (!comment.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"评价不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    } else if(comment.length >= 200) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"评价不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.gradeItems count]];
    for (int i=0; i<[self.gradeItems count] && i<[self.gradeDetail.itemGrades count] ; i++) {
        GradeItem *item = self.gradeDetail.itemGrades[i];
        HCSStarRatingView *rateView = self.gradeItems[i];
        NSInteger grade = rateView.value *20;
        NSDictionary *dict = @{@"tag": item.order,@"grade": @(grade)};
        [array addObject:dict];
    }
   
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!jsonString.length) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"评价不能为空";
        [hud hide:YES afterDelay:0.4];
        return;
    }
    
    NSDictionary *dict = @{@"user_id" : US.userId,
                           @"code" : self.stockId,
                           @"grades" : jsonString,
                           @"review_text" : comment};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    
    __weak GradeAddViewController *wself = self;
    [ma POST:API_SurveyCompanyGradeAdd parameters:dict completion:^(id data,NSError *error){
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
@end
