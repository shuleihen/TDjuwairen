//
//  ChildDetailTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ChildDetailTableViewController.h"
#import "BearBullTableViewCell.h"
#import "AskQuestionTableViewCell.h"
#import "BearBullSelBtnView.h"
#import "AskModel.h"
#import "AnsModel.h"
#import "CommentViewController.h"
#import "LoginViewController.h"

#import "LoginState.h"
#import "UIdaynightModel.h"

#import "NSString+Ext.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "HexColors.h"

@import WebKit;
@interface ChildDetailTableViewController ()<WKNavigationDelegate,WKUIDelegate,BearBullSelBtnViewDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightModel;

@property (nonatomic,assign) int tag;

@property (nonatomic,strong) UIScrollView *contentScrollview;

@property (nonatomic,strong) NSMutableArray *bullsArr;

@property (nonatomic,strong) NSMutableArray *bearsArr;

@property (nonatomic,strong) NSMutableArray *askArr;

@end

@implementation ChildDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightModel = [UIdaynightModel sharedInstance];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[BearBullTableViewCell class] forCellReuseIdentifier:@"BearBullCell"];
    [self.tableView registerClass:[AskQuestionTableViewCell class] forCellReuseIdentifier:@"askCell"];
    self.tableView.estimatedRowHeight = 10000;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)requestWithSelBtn:(int)tag WithSurveyID:(NSString *)surveyID
{
    self.tag = tag;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    NSString *url = @"http://192.168.1.103/Survey/survey_show_tag";
    NSString *code = [surveyID substringFromIndex:2];
    NSDictionary *para;
    if (US.isLogIn) {
        para = @{@"code":code,
                 @"tag":[NSString stringWithFormat:@"%d",tag],
                 @"userid":US.userId};
    }
    else
    {
        para = @{@"code":code,
                 @"tag":[NSString stringWithFormat:@"%d",tag]};
    }
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (self.tag == 0 || self.tag == 1) {
            NSArray *data = responseObject[@"data"];
            NSDictionary *dic = data[1];
            NSString *content = dic[@"content"];
            
            [self.webview loadHTMLString:content baseURL:nil];
            [self.tableView reloadData];
        }
        else if(self.tag == 2)
        {
            self.bullsArr = [NSMutableArray array];
            self.bearsArr = [NSMutableArray array];
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *dic in dataArr) {
                if ([dic[@"surveycomment_type"] isEqualToString:@"1"]) {
                    [self.bullsArr addObject:dic];
                }
                else
                {
                    [self.bearsArr addObject:dic];
                }
            }
            self.niuxiong = 1;
            [self.tableView reloadData];
        }
        else if (self.tag == 3)
        {
            NSArray *dataArr = responseObject[@"data"];
            NSString *html1 = dataArr[1];
            [self.webview loadHTMLString:html1 baseURL:nil];
            [self.tableView reloadData];
        }
        else if (self.tag == 4)
        {
            NSString *html = responseObject[@"data"];
            [self.webview loadHTMLString:html baseURL:nil];
            [self.tableView reloadData];
        }
        else
        {
            self.askArr = [NSMutableArray array];
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *dic in dataArr) {
                AskModel *model = [AskModel getInstanceWithDictionary:dic];
                
                [self.askArr addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.tag == 5) {
        if (self.askArr.count > 0) {
            return self.askArr.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tag == 0 || self.tag == 1 || self.tag == 3 || self.tag == 4) {
        return 1;
    }
    else if(self.tag == 2)
    {
        if (self.niuxiong == 0) {
            if (self.bearsArr.count > 0) {
                return self.bearsArr.count;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            if (self.bullsArr.count > 0) {
                return self.bullsArr.count;
            }
            else
            {
                return 1;
            }
        }
    }
    else
    {
        if (self.askArr.count > 0) {
            AskModel *model = self.askArr[section];
            return model.ans_list.count + 3;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag == 0 || self.tag == 1 || self.tag == 3 || self.tag == 4) {
        NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            self.webview = [[WKWebView alloc] init];
            self.webview.navigationDelegate = self;
            self.webview.UIDelegate = self;
            self.webview.scrollView.delegate = self;
            [cell.contentView addSubview:self.webview];
            
            [self.webview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(0);
                make.left.equalTo(cell.contentView).with.offset(0);
                make.bottom.equalTo(cell.contentView).with.offset(0);
                make.right.equalTo(cell.contentView).with.offset(0);
                make.height.mas_equalTo(kScreenHeight-64-60);
            }];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(self.tag == 2)
    {
        if (self.niuxiong == 0) {
            if (self.bearsArr.count > 0) {
                BearBullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BearBullCell" forIndexPath:indexPath];
                NSDictionary *commentDic;
                commentDic = self.bearsArr[indexPath.row];
                [cell.faceMinImg sd_setImageWithURL:[NSURL URLWithString:commentDic[@"userinfo_facemin"]]];
                cell.nickNameLab.text = commentDic[@"user_nickname"];
                
                NSString *comment = commentDic[@"surveycomment_comment"];
                CGSize commentSize = CGSizeMake(kScreenWidth-15-30-10, 1000.0);
                commentSize = [comment calculateSize:commentSize font:[UIFont systemFontOfSize:16]];
                cell.commentLab.text = comment;
                [cell.commentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(commentSize.height);
                }];
                
                [cell.goodnumBtn setTitle:[NSString stringWithFormat:@"  %@",commentDic[@"surveycomment_goodnums"]] forState:UIControlStateNormal];
                [cell.goodnumBtn setTitleColor:self.daynightModel.titleColor forState:UIControlStateNormal];
                [cell.goodnumBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
                [cell.goodnumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
                
                cell.goodnumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_normal.png"] forState:UIControlStateNormal];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_pre.png"] forState:UIControlStateSelected];
                [cell.goodnumBtn addTarget:self action:@selector(good:) forControlEvents:UIControlEventTouchUpInside];
                cell.goodnumBtn.tag = [commentDic[@"surveycomment_id"] integerValue];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                NSString *identifier = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"当前还没有熊评";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else
        {
            if (self.bullsArr.count > 0) {
                BearBullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BearBullCell" forIndexPath:indexPath];
                NSDictionary *commentDic;
                commentDic = self.bullsArr[indexPath.row];
                [cell.faceMinImg sd_setImageWithURL:[NSURL URLWithString:commentDic[@"userinfo_facemin"]]];
                cell.nickNameLab.text = commentDic[@"user_nickname"];
                
                NSString *comment = commentDic[@"surveycomment_comment"];
                CGSize commentSize = CGSizeMake(kScreenWidth-15-30-10, 1000.0);
                commentSize = [comment calculateSize:commentSize font:[UIFont systemFontOfSize:16]];
                cell.commentLab.text = comment;
                [cell.commentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(commentSize.height);
                }];
                
                [cell.goodnumBtn setTitle:[NSString stringWithFormat:@"  %@",commentDic[@"surveycomment_goodnums"]] forState:UIControlStateNormal];
                [cell.goodnumBtn setTitleColor:self.daynightModel.titleColor forState:UIControlStateNormal];
                [cell.goodnumBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
                [cell.goodnumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
                
                cell.goodnumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_normal.png"] forState:UIControlStateNormal];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_pre.png"] forState:UIControlStateSelected];
                [cell.goodnumBtn addTarget:self action:@selector(good:) forControlEvents:UIControlEventTouchUpInside];
                cell.goodnumBtn.tag = [commentDic[@"surveycomment_id"] integerValue];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                NSString *identifier = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"当前还没有牛评";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    else
    {
        if (self.askArr.count > 0) {
            if (indexPath.row == 0) {
                AskQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"askCell" forIndexPath:indexPath];
                cell.askBtn.tag = indexPath.section;
                [cell.askBtn addTarget:self action:@selector(clickToComment:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if(indexPath.row == 1)
            {
                BearBullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BearBullCell" forIndexPath:indexPath];
                AskModel *model = self.askArr[indexPath.section];
                [cell.faceMinImg sd_setImageWithURL:[NSURL URLWithString:model.userinfo_facemin]];
                cell.nickNameLab.text = [NSString stringWithFormat:@"%@  %@",model.user_nickname,model.surveyask_addtime];
                
                NSString *content = model.surveyask_content;
                CGSize contentSize = CGSizeMake(kScreenWidth-15-30-10, 1000.0);
                contentSize = [content calculateSize:contentSize font:[UIFont systemFontOfSize:16]];
                cell.commentLab.text = content;
                [cell.commentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(contentSize.height);
                }];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if (indexPath.row == 2){
                NSString *identifier = @"askcell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"作者回答：";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                BearBullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BearBullCell" forIndexPath:indexPath];
                AskModel *askmodel = self.askArr[indexPath.section];
                AnsModel *ansmodel = askmodel.ans_list[indexPath.row -3];
                [cell.faceMinImg sd_setImageWithURL:[NSURL URLWithString:ansmodel.userinfo_facemin]];
                cell.nickNameLab.text = [NSString stringWithFormat:@"%@%@",ansmodel.user_nickname,ansmodel.surveyanswer_addtime];
                
                NSString *content = ansmodel.surveyanswer_content;
                CGSize contentSize = CGSizeMake(kScreenWidth-15-30-10, 1000.0);
                contentSize = [content calculateSize:contentSize font:[UIFont systemFontOfSize:16]];
                cell.commentLab.text = content;
                [cell.commentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(contentSize.height);
                }];
                
                [cell.goodnumBtn setTitle:[NSString stringWithFormat:@"  %@",ansmodel.surveyanswer_goodnums] forState:UIControlStateNormal];
                [cell.goodnumBtn setTitleColor:self.daynightModel.titleColor forState:UIControlStateNormal];
                [cell.goodnumBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
                [cell.goodnumBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
                [cell.goodnumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
                
                cell.goodnumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_normal.png"] forState:UIControlStateNormal];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_pre.png"] forState:UIControlStateSelected];
                [cell.goodnumBtn addTarget:self action:@selector(good:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else
        {
            NSString *identifier = @"askcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"当前还没有人提问";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

#pragma mark - tableview for header in section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tag == 2) {
        CGFloat bullRadio;
        if (self.bullsArr.count > 0 || self.bearsArr.count > 0) {
            bullRadio = self.bullsArr.count / (self.bullsArr.count + self.bearsArr.count);
        }
        else if(self.bullsArr.count == 0 && self.bearsArr.count == 0)
        {
            bullRadio = 0.5;
        }
        BearBullSelBtnView *view = [[BearBullSelBtnView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) andRatio:bullRadio];
        view.delegate = self;
        view.backgroundColor = self.daynightModel.navigationColor;
        
        if (self.niuxiong == 1) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, kScreenWidth/2, 2)];
            line.layer.borderWidth = 2;
            line.layer.borderColor = [HXColor hx_colorWithHexRGBAString:@"#E83C3D"].CGColor;
            [view addSubview:line];
        }
        else
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 58, kScreenWidth/2, 2)];
            line.layer.borderWidth = 2;
            line.layer.borderColor = [HXColor hx_colorWithHexRGBAString:@"#1BCE8D"].CGColor;
            [view addSubview:line];
        }
        
        return view;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tag == 2) {
        return 60;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.tag == 5) {
        return 10;
    }
    else
    {
        return 0;
    }
}

#pragma mark - BearBullSelBtnViewDelegate
- (void)selBearBull:(UIButton *)sender
{
    self.niuxiong = (int)sender.tag;
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate childScrollViewDidScroll:scrollView];
    }
}

#pragma mark - 点赞
- (void)good:(UIButton *)sender{
    if (US.isLogIn) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        NSString *url = @"http://192.168.1.103/Survey/addCommentGoodAccess";
        NSDictionary *dic = @{@"user_id":@"956",
                              @"comment_id":[NSString stringWithFormat:@"%ld",(long)sender.tag]};
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            sender.selected = YES;
            [sender setTitle:responseObject[@"good_num"] forState:UIControlStateSelected];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - 点击跳转
- (void)clickToComment:(UIButton *)sender{
    CommentViewController *comView = [[CommentViewController alloc] init];
    comView.tag = 5;
    comView.type = @"ans";
    AskModel *model = self.askArr[sender.tag];
    comView.model = model;
    if (US.isLogIn) {
        [self.navigationController pushViewController:comView animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

@end
