//
//  CommentViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/14.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentViewController.h"
#import "BearBullTableViewCell.h"

#import "UIdaynightModel.h"
#import "LoginState.h"

#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"
#import "Masonry.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    CGSize contentSize;
}
@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UITextView *comView;

@property (nonatomic,strong) UILabel *placeholder;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.view.backgroundColor = self.daynightModel.navigationColor;
    
    [self setupWithNavigation];
    [self setupWithTableView];
}

- (void)setupWithNavigation{
    UIButton *pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    if ([self.type isEqualToString:@"bull"]) {
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bull"]];
            [pushBtn setImage:[UIImage imageNamed:@"fabu_bull"] forState:UIControlStateNormal];
        }
    else if([self.type isEqualToString:@"bear"])
        {
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bear"]];
            [pushBtn setImage:[UIImage imageNamed:@"fabu_bear"] forState:UIControlStateNormal];
        }
   else if ([self.type isEqualToString:@"ask"]) {
            self.title = @"提问";
            [pushBtn setImage:[UIImage imageNamed:@"fabu_ask"] forState:UIControlStateNormal];
        }
    else if ([self.type isEqualToString:@"ans"])
        {
            self.title = @"回答";
            [pushBtn setImage:[UIImage imageNamed:@"fabu_ask"] forState:UIControlStateNormal];
        }
    [pushBtn addTarget:self action:@selector(clickPush:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:pushBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupWithTableView{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight = kScreenHeight-64;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerClass:[BearBullTableViewCell class] forCellReuseIdentifier:@"bearbullCell"];
    [self.view addSubview:self.tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.type isEqualToString:@"ans"]) {
        return 1;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.type isEqualToString:@"ans"]) {
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self setupWithTextView];
        [cell.contentView addSubview:self.comView];
        
        [self.comView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(0);
            make.left.equalTo(cell.contentView).with.offset(0);
            make.bottom.equalTo(cell.contentView).with.offset(-0);
            make.right.equalTo(cell.contentView).with.offset(-0);
            make.height.mas_equalTo(kScreenHeight-64);
        }];
        return cell;
    }
    else
    {
        
        if (indexPath.row == 0) {
            NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"问题:";
            return cell;
        }
        else if (indexPath.row == 1){
            BearBullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bearbullCell" forIndexPath:indexPath];
            [cell.faceMinImg sd_setImageWithURL:[NSURL URLWithString:self.model.userinfo_facemin]];
            cell.nickNameLab.text = [NSString stringWithFormat:@"%@  %@",self.model.user_nickname,self.model.surveyask_addtime];
            
            NSString *content = self.model.surveyask_content;
            contentSize = CGSizeMake(kScreenWidth-15-30-10, 1000.0);
            contentSize = [content calculateSize:contentSize font:[UIFont systemFontOfSize:16]];
            cell.commentLab.text = content;
            [cell.commentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentSize.height);
            }];
            return cell;
        }
        else if (indexPath.row == 2){
            NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"进行回答:";
            return cell;
        }
        else
        {
            NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [self setupWithTextView];
            [cell.contentView addSubview:self.comView];
            [self.comView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(0);
                make.left.equalTo(cell.contentView).with.offset(0);
                make.bottom.equalTo(cell.contentView).with.offset(0);
                make.right.equalTo(cell.contentView).with.offset(0);
                make.height.mas_equalTo(kScreenHeight-64-88-10-30-5-contentSize.height-15);
            }];
            return cell;
        }
    }
}

- (void)setupWithTextView{
    self.comView = [[UITextView alloc] init];
    self.comView.font = [UIFont systemFontOfSize:16];
    self.comView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.comView.delegate = self;
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth, 30)];
    self.placeholder.font = [UIFont systemFontOfSize:15];
    self.placeholder.textColor = self.daynightModel.titleColor;
    if ([self.type isEqualToString:@"bull"]) {
        self.placeholder.text = @"在这里输入牛评";
    }
    else if ([self.type isEqualToString:@"bear"]){
        self.placeholder.text = @"在这里输入熊评";
    }
    else if ([self.type isEqualToString:@"ask"]){
        self.placeholder.text = @"在这里输入问题";
    }
    else
    {
        self.placeholder.text = @"输入回答...";
    }
    [self.comView addSubview:self.placeholder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.comView.text.length > 0) {
        self.placeholder.alpha = 0.0;
    }
    else
    {
        self.placeholder.alpha = 1.0;
    }
}

#pragma mark - 点击发布
- (void)clickPush:(UIButton *)sender{
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para ;
    NSString *url ;
    NSString *code = [self.company_code substringFromIndex:2];
    if ([self.type isEqualToString:@"bull"]) {
        url = [NSString stringWithFormat:@"%@Survey/addComment",API_HOST];
        para = @{@"type":@"1",
                 @"content":self.comView.text,
                 @"code":code,
                 @"user_id":US.userId};
    }
    else if ([self.type isEqualToString:@"bear"]){
        url = [NSString stringWithFormat:@"%@Survey/addComment",API_HOST];
        para = @{@"type":@"2",
                 @"content":self.comView.text,
                 @"code":code,
                 @"user_id":US.userId};
    }
    else if ([self.type isEqualToString:@"ask"]){
        url = [NSString stringWithFormat:@"%@Survey/addQuestion",API_HOST];
        para = @{@"code":code,
                 @"question":self.comView.text,
                 @"user_id":US.userId};
    }
    else if ([self.type isEqualToString:@"ans"]){
        url = [NSString stringWithFormat:@"%@Survey/answerQuestion",API_HOST];
        para = @{@"ask_id":self.model.surveyask_id,
                 @"content":self.comView.text,
                 @"user_id":US.userId};
    }
    
    [manager POST:url parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"%@",data);
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
