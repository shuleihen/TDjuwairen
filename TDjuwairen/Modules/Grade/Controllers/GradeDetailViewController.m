//
//  GradeDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeDetailViewController.h"
#import "HexColors.h"
#import "GradeHeaderView.h"
#import "GradeDetailCell.h"
#import "GradeCommentModel.h"
#import "GradeAddViewController.h"
#import "GradeDetailModel.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "NotificationDef.h"
#import "GradeReplyToolView.h"
#import "MBProgressHUD.h"

@interface GradeDetailViewController ()<UITableViewDelegate, UITableViewDataSource,GradeReplyToolViewDelegate>
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GradeHeaderView *headerView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) GradeDetailModel *gradeDetail;
@property (nonatomic, strong) GradeReplyToolView *replyToolView;

@end

@implementation GradeDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolView];
    
    self.title = @"评级列表";
    
    [self reloadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:kAddStockGradeSuccessed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setupToolView {
    UIView *v = [self.toolView viewWithTag:10];
    v.backgroundColor = [self colorWithGrade:self.gradeDetail.totalGrade];
}

- (void)reloadView {
    [self queryGradeTetail];
    [self queryCompanyReview];
}

- (void)queryGradeTetail {
    __weak GradeDetailViewController *wself = self;
    NSDictionary *dict = @{@"code" : self.stockCode};
    if (US.isLogIn) {
        dict = @{@"code" : self.stockCode, @"user_id": US.userId};
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyCompanyGrade parameters:dict completion:^(id data, NSError *error){
        
        if (!error && data) {
            wself.gradeDetail = [[GradeDetailModel alloc] initWithDict:data];
        }
        
        [wself.headerView setupGradeModel:wself.gradeDetail];
        [wself setupToolView];
    }];
}

- (void)queryCompanyReview {
    __weak GradeDetailViewController *wself = self;
    NSDictionary *dict = @{@"code" : self.stockCode};
    if (US.isLogIn) {
        dict = @{@"code" : self.stockCode, @"user_id": US.userId};
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyCompanyReview parameters:dict completion:^(id data, NSError *error){
        
        if (!error && data) {
            NSArray *list = data[@"review_list"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[list count]];
            
            for (NSDictionary *dict in list) {
                GradeCommentModel *item = [[GradeCommentModel alloc] initWithDict:dict];
                [array addObject:item];
            }
            
            wself.items = array;
            [wself.tableView reloadData];
        }
    }];
}

- (void)gradePressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    GradeAddViewController *vc = [[GradeAddViewController alloc] init];
    vc.stockName = self.stockName;
    vc.stockCode = self.stockCode;
    vc.gradeDetail = self.gradeDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)replyWithIndexPath:(NSIndexPath *)indexPath {
    GradeCommentModel *model = self.items[indexPath.row];
    
    if (!self.replyToolView.superview) {
        [self.view addSubview:self.replyToolView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeybord)];
        [self.view addGestureRecognizer:tap];
    }
    
    self.replyToolView.reviewId = model.reviewId;
    [self.replyToolView.textView becomeFirstResponder];
}


- (void)hideKeybord {
    self.replyToolView.reviewId = nil;
    [self.replyToolView.textView resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

    
    CGRect rect = self.replyToolView.frame;
    self.replyToolView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-keyboardBounds.size.height- rect.size.height, kScreenWidth, rect.size.height);
}

-(void)keyboardWillHide:(NSNotification *)note{
    [self.replyToolView removeFromSuperview];
    [self.view removeGestureRecognizer:self.view.gestureRecognizers.firstObject];
}

- (void)sendReplyWithContent:(NSString *)content withReviewId:(NSString *)reviewId {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    if (!content.length || !reviewId.length) {
        return;
    }
    
    [self.replyToolView removeFromSuperview];
    [self.replyToolView.textView resignFirstResponder];
    
    __weak GradeDetailViewController *wself = self;
    NSDictionary *dict = dict = @{@"content" : content, @"review_id": reviewId};
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.view addSubview:hud];
    [hud startAnimating];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_SurveyCompanyReplyReview parameters:dict completion:^(id data, NSError *error){
        [hud stopAnimating];
        
        if (!error) {
            
            [wself queryCompanyReview];
            
            // 回复成功以后，情况输入框内容
            wself.replyToolView.textView.text = @"";
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.labelText = @"回复失败";
            [hud hide:YES afterDelay:0.8];
        }
        
    }];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 203;
    }
    
    GradeCommentModel *model = self.items[indexPath.row];
    return [GradeDetailCell heightWithCommentModel:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35.0f)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 40, 20)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    label.text = @"评价";
    [view addSubview:label];
    
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(62, 7, 160, 20)];
    labelB.font = [UIFont systemFontOfSize:14.0f];
    labelB.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
    labelB.text = [NSString stringWithFormat:@"已有%lu人评价",(unsigned long)[self.items count]];
    [view addSubview:labelB];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeHeaderCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GradeHeaderCellID"];
            [cell.contentView addSubview:self.headerView];
        }
        return cell;
    } else {
        GradeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeDetailCellID"];
        
        GradeCommentModel *model = self.items[indexPath.row];
        [cell setupCommentModel:model];
        
        __weak GradeDetailViewController *wself = self;
        cell.replyBlock = ^{
            [wself replyWithIndexPath:indexPath];
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-55) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        UINib *nib = [UINib nibWithNibName:@"GradeDetailCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"GradeDetailCellID"];
    }
    return _tableView;
}

- (GradeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[GradeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 204)];
        
        [_headerView setupScore:self.score];
    }
    return _headerView;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-55, kScreenWidth, 55)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"我要评分" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.frame = CGRectMake(12, 12, kScreenWidth-24, 34);
        btn.tag = 10;
        [btn addTarget:self action:@selector(gradePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        sep.backgroundColor = TDSeparatorColor;
        [_toolView addSubview:sep];
        
        _toolView.backgroundColor = [UIColor whiteColor];
        btn.backgroundColor = [self colorWithGrade:[self.score integerValue]];
    }
    return _toolView;
}

- (GradeReplyToolView *)replyToolView {
    if (!_replyToolView) {
        _replyToolView = [[GradeReplyToolView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, kScreenWidth, 44)];
        _replyToolView.delegate = self;
    }
    
    return _replyToolView;
}

- (UIColor *)colorWithGrade:(NSInteger)grade {
    
    UIColor *color;
    if (grade < 50) {
        color = [UIColor hx_colorWithHexRGBAString:@"#dc4e5a"];
    } else if (grade >= 50 &&
               grade < 80) {
        color = [UIColor hx_colorWithHexRGBAString:@"#e77b21"];
    } else {
        color = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
    }
    return color;
}
@end
