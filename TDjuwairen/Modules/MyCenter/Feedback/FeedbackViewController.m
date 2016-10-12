//
//  FeedbackViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ResponsListTableViewCell.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "UIdaynightModel.h"
#import "LoginState.h"

@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) LoginState *loginState;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int cellheight;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.cellheight = 80;
    
    self.loginState = [LoginState sharedInstance];
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    [self setupWithNavigation];
    [self setupWithTableView];
    [self setupWithFeedbackView];
    
    [self requestFeedbackAuthentication];
    
    [self registerForKeyboardNotifications];
    
//    收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.tableview addGestureRecognizer:tap];
    
    //监听contentTextField内容的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(content) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"意见反馈";
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-46) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}

- (void)setupWithFeedbackView{
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-46, kScreenWidth, 46)];
    self.contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 8, kScreenWidth-24-60, 30)];
    self.contentTextField.delegate = self;
    self.contentTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.SendBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-8-60, 8, 60, 30)];
    [self.SendBtn addTarget:self action:@selector(clickSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:self.contentTextField];
    [self.backView addSubview:self.SendBtn];
    [self.view addSubview:self.backView];
    
}

- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

//当键盘出现时计算键盘的高度大小，用于输入框显示
- (void)keyboardWasShown:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    //kbSize为键盘尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    
    [self beginMoveUpAnimation:kbSize.height];
    
}

//当键盘隐藏时
- (void)keyboardWillBeHidden{
    self.backView.transform = CGAffineTransformIdentity;
}

- (void)beginMoveUpAnimation:(CGFloat )height{
    self.backView.transform = CGAffineTransformMakeTranslation(0, -height);
}



//根据contentTextField内容的改变设置button的状态
-(void)content
{
    if ([self.contentTextField.text isEqualToString:@""]) {
        self.SendBtn.layer.cornerRadius=3;
        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"send-notext"] forState:UIControlStateNormal];
    }
    else {
        self.SendBtn.layer.cornerRadius=3;
        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"send-text"] forState:UIControlStateNormal];
    }

}
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigation];
    [self requestInfo];
    
    self.tableview.backgroundColor = self.daynightmodel.navigationColor;
    self.backView.backgroundColor = self.daynightmodel.backColor;
    self.contentTextField.backgroundColor = self.daynightmodel.inputColor;
    self.contentTextField.textColor = self.daynightmodel.textColor;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)setNavigation
{
    self.title = @"意见反馈";
    
    self.SendBtn.layer.cornerRadius = 3;
    [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"send-notext"] forState:UIControlStateNormal];
}



- (IBAction)SendBtn:(UIButton *)sender {
    if ([self.contentTextField.text isEqualToString:@""]) {
        
    }
    else
    {
        [self requestFeedback];
    }
}

- (void)clickSend:(UIButton *)sender{
    if ([self.contentTextField.text isEqualToString:@""]) {
        
    }
    else
    {
        [self.contentTextField resignFirstResponder];
        [self requestFeedback];
    }
}

//身份验证
-(void)requestFeedbackAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary*dic = data;
            self.str = dic[@"str"];
        } else {
            
        }
    }];
}

//发送反馈意见
-(void)requestFeedback
{
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary*para = @{@"authenticationStr":US.userId,
                         @"encryptedStr":self.str,
                         @"userid":US.userId,
                         @"feedbackContent":self.contentTextField.text};
    
    [manager POST:API_AddUserFeedback parameters:para completion:^(id data, NSError *error){
        if (!error) {
            self.contentTextField.text = @"";
            [self requestInfo];
        } else {
            
        }
    }];
}

-(void)requestInfo
{
    self.dataArray = [[NSMutableArray alloc]init];
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *paras = @{@"user_id":US.userId};
    
    [manager POST:API_GetUserFeedbackList parameters:paras completion:^(id data, NSError *error){
        if (!error) {
            NSArray *array = data;
            [self.dataArray addObjectsFromArray:array];
            [self.tableview reloadData];
        } else {
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSString *identifier = @"cell";
        ResponsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ResponsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andArr:dic];
        }
        cell.contentLab.text = dic[@"feedback_content"];
        self.cellheight = cell.viewheight;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        return nil;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellheight;
}

@end
