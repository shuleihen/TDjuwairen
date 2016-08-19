//
//  FeedbackViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackTableViewCell.h"
#import "ResponsListTableViewCell.h"
#import "LoginState.h"
#import "NetworkManager.h"
#import "UIdaynightModel.h"

@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int cellheight;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.contentTextField.delegate=self;
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    
    [self registerForKeyboardNotifications];
    
    [self setupWithNavigation];
//    收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //监听contentTextField内容的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(content) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"意见反馈";
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
        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－未输入文字时"] forState:UIControlStateNormal];
    }
    else {
        self.SendBtn.layer.cornerRadius=3;
        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－输入文字后"] forState:UIControlStateNormal];
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:self.daynightmodel.titleColor}];
    self.SendBtn.layer.cornerRadius = 3;
    [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－未输入文字时"] forState:UIControlStateNormal];
}



- (IBAction)SendBtn:(UIButton *)sender {
    if ([self.contentTextField.text isEqualToString:@""]) {
        
    }
    else
    {
        [self requestFeedbackAuthentication];
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
            self.str=dic[@"str"];
            [self requestFeedback];
        } else {
            
        }
    }];
}

//发送反馈意见
-(void)requestFeedback
{
    NetworkManager *manager = [[NetworkManager alloc] init];
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
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
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
    NSDictionary*dic = self.dataArray[indexPath.row];
//    [tableView registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedbackCell"];
//    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCell"];
//    [cell cellforDic:dic];
//    [cell setContentText:dic[@"feedback_content"]];
    NSString *identifier = @"cell";
    ResponsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ResponsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andArr:dic];
    }
    self.cellheight = cell.viewheight;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellheight;
}

@end
