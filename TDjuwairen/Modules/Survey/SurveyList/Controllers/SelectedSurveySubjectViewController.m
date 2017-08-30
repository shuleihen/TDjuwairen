//
//  SelectedSurveySubjectViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SelectedSurveySubjectViewController.h"
#import "SurveySubjectModel.h"
#import "HexColors.h"
#import "UIImage+Create.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"

@interface SelectedSurveySubjectViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *totalArray;
@end

@implementation SelectedSurveySubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.title = @"关注选择";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self querySurveySubject];
}

- (void)querySurveySubject {
    __weak SelectedSurveySubjectViewController *wself = self;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    activity.hidesWhenStopped = YES;
    [self.view addSubview:activity];
    
    [activity startAnimating];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveySubject parameters:nil completion:^(id data, NSError *error) {
        [activity stopAnimating];
        wself.navigationItem.rightBarButtonItem.enabled = YES;
        
        if (!error && data) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                SurveySubjectModel *model = [[SurveySubjectModel alloc] initWithDict:dict];
                [array addObject:model];
            }
            
            wself.totalArray = array;
        } else {
            
        }
        
        [wself setupSubjectView];
    }];
}

- (void)setupSubjectView {
    
    CGFloat w = (kScreenWidth- 24-30)/4;
    CGFloat h = 31.0f;
    int i=0,j=0;
    CGFloat offy = 22;
    
    for (SurveySubjectModel *sub in self.totalArray) {
        
        UIButton *button = [self buttonWithSubject:sub];
        button.enabled = sub.isCanCancel;
        if (button.enabled) {
            button.selected = sub.isAtten;
        }
        
        button.frame = CGRectMake(12+i*(10+w), offy, w, h);
        button.tag = j;
        [self.view addSubview:button];
        
        if (button.enabled) {
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        j++;
        
        offy = 22 +(31+22)*(j/4);
        i = j%4;
    }
}
/*
- (BOOL)isEnabledWithSubjectId:(NSString *)subjectId {
    NSArray *array = @[@"154",@"155",@"156"];
    return ![array containsObject:subjectId];
}

- (BOOL)isSelectedWithSubjectId:(NSString *)subjectId {
    __block BOOL selected = NO;
    
    [self.selectedArray enumerateObjectsUsingBlock:^(SurveySubjectModel *sub, NSUInteger idx, BOOL *stop){
        if ([sub.subjectId isEqualToString:subjectId]) {
            selected = YES;
            *stop = YES;
        }
    }];
    
    return selected;
}
*/

- (UIButton *)buttonWithSubject:(SurveySubjectModel *)subject {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitle:subject.subjectTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    CGFloat w = (kScreenWidth- 24-30)/4;
    CGFloat h = 31.0f;
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(w, h)
                              backgroudColor:[UIColor whiteColor]
                                 borderColor:[UIColor hx_colorWithHexRGBAString:@"#cccccc"]
                                cornerRadius:3.0];
    UIImage *selected = [UIImage imageWithSize:CGSizeMake(w, h)
                              backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#518bf6"]
                                 borderColor:[UIColor hx_colorWithHexRGBAString:@"#518bf6"]
                                cornerRadius:3.0];
    UIImage *disabled = [UIImage imageWithSize:CGSizeMake(w, h)
                                backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#cccccc"]
                                   borderColor:[UIColor hx_colorWithHexRGBAString:@"#cccccc"]
                                  cornerRadius:3.0];
    
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:selected forState:UIControlStateHighlighted];
    [button setBackgroundImage:selected forState:UIControlStateSelected];
    [button setBackgroundImage:disabled forState:UIControlStateDisabled];
    
    button.bounds = CGRectMake(0, 0, w, h);
    
    return button;
}

- (void)buttonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    SurveySubjectModel *subject = self.totalArray[btn.tag];
    subject.isAtten = btn.selected;
}

- (void)donePressed:(id)sender {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *subjects = [NSMutableArray arrayWithCapacity:10];
    
    for (SurveySubjectModel *sub in self.totalArray) {
        if (sub.isAtten) {
            [array addObject:sub.subjectId];
            [subjects addObject:sub];
        }
    }
    
    NSString *subIds = [NSString stringWithFormat:@"[%@]",[array componentsJoinedByString:@","]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"提交中";
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_SurveyAddSubject parameters:@{@"sub_ids": subIds} completion:^(id data, NSError *error) {
        
        if (!error && data) {
            hud.delegate = self;
            hud.label.text = @"提交成功";
            [hud hideAnimated:YES afterDelay:0.6];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSubjectChangedNotification object:subjects];
            
        } else {
            hud.label.text = @"添加关注失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
