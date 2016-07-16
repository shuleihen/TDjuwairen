//
//  FeedbackViewController.m
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackTableViewCell.h"
#import "LoginState.h"
#import "AFNetworking.h"


@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray*dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)LoginState*loginstate;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.contentTextField.delegate=self;
    
    self.loginstate=[LoginState addInstance];
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //监听contentTextField内容的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(content) name:UITextFieldTextDidChangeNotification object:nil];
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

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigation];
    [self requestInfo];
}

-(void)setNavigation
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    label.text=@"意见反馈";
    self.navigationItem.titleView=label;
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

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if ([self.contentTextField.text isEqualToString:@""]) {
//        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－未输入文字时"] forState:UIControlStateNormal];
//    }
//    else {
//        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－输入文字后"] forState:UIControlStateNormal];
//    }
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([self.contentTextField.text isEqualToString:@""]) {
//        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－未输入文字时"] forState:UIControlStateNormal];
//    }
//    else {
//        [self.SendBtn setBackgroundImage:[UIImage imageNamed:@"发送－输入文字后"] forState:UIControlStateNormal];
//    }
//}
//身份验证
-(void)requestFeedbackAuthentication
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/Public/getapivalidate/"];
    NSDictionary*para=@{@"validatestring":self.loginstate.userId};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary*dic=responseObject[@"data"];
            self.str=dic[@"str"];
            [self requestFeedback];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//发送反馈意见
-(void)requestFeedback
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/addUserFeedback/"];
    NSDictionary*paras=@{@"authenticationStr":self.loginstate.userId,
                         @"encryptedStr":self.str,
                         @"userid":self.loginstate.userId,
                         @"feedbackContent":self.contentTextField.text};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"发送成功");
            self.contentTextField.text=@"";
            [self requestInfo];
            
        }
        else
        {
            NSLog(@"发送失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)requestInfo
{
        dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/User/getUserFeedback/"];
    NSDictionary*paras=@{@"feedback_os":@"3",
                         @"userid":self.loginstate.userId};
    [manager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"获取信息成功");
            NSArray*array=responseObject[@"data"];
            [dataArray addObjectsFromArray:array];
            [self.tableview reloadData];
        }
        else
        {
            NSLog(@"获取信息失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=dataArray[indexPath.row];
    [tableView registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedbackCell"];
    FeedbackTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"FeedbackCell"];
    [cell cellforDic:dic];
    [cell setContentText:dic[@"feedback_content"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackTableViewCell*cell=[self tableView:_tableview cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
//    NSDictionary*dic=dataArray[indexPath.row];
//    NSString*content=dic[@"feedback_content"];
//    CGSize size = [content calculateSize:CGSizeMake(self.view.frame.size.width - 30, FLT_MAX) font:[UIFont systemFontOfSize:15]];
//    
//    CGFloat contentHeight=size.height+40;
//    
//    return contentHeight;
}

@end
