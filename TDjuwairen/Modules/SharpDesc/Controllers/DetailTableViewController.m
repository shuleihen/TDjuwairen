//
//  DetailTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "DetailTableViewController.h"
#import "CommentsModel.h"
#import "TimeHotComView.h"
#import "ShowTableViewCell.h"
#import "CommentsCell.h"
#import "LoginViewController.h"

#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"

#import "LoginState.h"
#import "UIdaynightModel.h"

@interface DetailTableViewController ()<TimeHotComViewDelegate,CommentsCellDelegate,FloorInFloorViewDelegate>
{
    CGSize commentsize;
    CGSize floorviewsize;
    BOOL timehot;
}
@property (nonatomic,strong) TimeHotComView *thview;
@property (nonatomic,strong) UIButton *selTimeHotBtn;

@property (nonatomic,strong) NSMutableArray *sharpComDataArr;
@property (nonatomic,strong) NSMutableArray *viewComDataArr;

@property (nonatomic,strong) MBProgressHUD *hudloadCom;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.sharpComDataArr = [NSMutableArray array];
    self.viewComDataArr = [NSMutableArray array];
    timehot = YES;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)requestCommentDataWithPage:(int)currentPage{
    NSString *string = [NSString stringWithFormat:@"index.php/Sharp/getSharpComnment/id/%@/page/%d",self.sharp_id,currentPage];
    
    NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:@"http://192.168.1.107/Appapi/"];
    [ma GET:string parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *d in data) {
                CommentsModel *model = [CommentsModel getInstanceWithDictionary:d];
                [array addObject:model];
            }
            
            if (currentPage == 1) {
                self.sharpComDataArr = array;
            } else {
                [self.sharpComDataArr addObjectsFromArray:array];
            }

            [self.tableView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(didfinishReload)]) {
                [self.delegate didfinishReload];
            }
        } else {
            [self.tableView reloadData];
        }
    }];
}

- (void)requestWithCommentDataWithTimeHot{
    NSDictionary *dic;
    if (timehot == YES) {
        if (US.isLogIn == YES) {
            dic = @{
                    @"view_id":self.view_id,
                    @"user_id":US.userId,
                    @"loadedLength":@"0"
                    };
        }
        else
        {
            dic = @{
                    @"view_id":self.view_id,
                    @"loadedLength":@"0"
                    };
        }
        
    }
    else
    {
        if (US.isLogIn == YES) {
            dic = @{
                    @"type":@"hot",
                    @"view_id":self.view_id,
                    @"user_id":US.userId,
                    @"loadedLength":@"0"
                    };
        }
        else
        {
            dic = @{
                    @"type":@"hot",
                    @"view_id":self.view_id,
                    @"loadedLength":@"0"
                    };
        }
    }
    
    NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [ma POST:API_GetViewComment parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            [self.viewComDataArr removeAllObjects];
            NSArray *arr = data;
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                CommentsModel *fModel = [CommentsModel getInstanceWithDictionary:dic];
                [self.viewComDataArr addObject:fModel];
            }

            [self.tableView reloadData];
        }
        else
        {
            [self.tableView reloadData];
        }
    }];
    
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.pagemode isEqualToString:@"sharp"]) {
        if (self.sharpComDataArr.count == 0) {
            return 2;
        }
        else
        {
            return 1+self.sharpComDataArr.count;
        }
    }
    else
    {
        if (self.viewComDataArr.count == 0) {
            return 2;
        }
        else
        {
            return 1+self.viewComDataArr.count;

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pagemode isEqualToString:@"sharp"]) {
        /* 当前没有评论时 */
        if (self.sharpComDataArr.count == 0) {
            if (indexPath.row == 0) {
                NSString *identifier = @"about";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"相关评论";
                return cell;
            }
            else
            {
                NSString *identifier = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"当前文章还没有评论";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                /* cell的选中样式为无色 */
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.textLabel.textColor = self.daynightmodel.textColor;
                cell.backgroundColor = self.daynightmodel.navigationColor;
                return cell;
            }
        }
        else
        {
            if (indexPath.row == 0) {
                NSString *identifier = @"about";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"相关评论";
                return cell;
            }
            else
            {
                ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
                if (cell == nil) {
                    cell = [[ShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showcell"];
                }
                CommentsModel *model = self.sharpComDataArr[indexPath.row-1];
                
                [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.user_headImg]];
                cell.nicknameLabel.text = model.user_nickName;
                
                cell.timeLabel.text = model.commentTime;
                NSString *text = model.sharpcomment;
                cell.commentsLabel.text = text;
                UIFont *font = [UIFont systemFontOfSize:15];
                cell.commentsLabel.font = font;
                commentsize = CGSizeMake(kScreenWidth-55-15, 20000.0f);
                commentsize = [text calculateSize:commentsize font:font];
                [cell.commentsLabel setFrame:CGRectMake(15+30+10, 10+15+5+12+10, kScreenWidth-55-15, commentsize.height)];
                
                [cell.line setFrame:CGRectMake(15, 10+15+5+12+10+commentsize.height+10, kScreenWidth-30, 1)];
                
                cell.nicknameLabel.textColor = self.daynightmodel.textColor;
                cell.timeLabel.textColor = self.daynightmodel.titleColor;
                cell.commentsLabel.textColor = self.daynightmodel.textColor;
                cell.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
                /* cell的选中样式为无色 */
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = self.daynightmodel.navigationColor;
                return cell;
            }
        }
    }
    else
    {
        if (self.viewComDataArr.count == 0) {
            if (indexPath.row == 0) {
                NSString *identifier = @"timehot";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    self.thview = [[TimeHotComView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                    self.thview.delegate = self;
                    self.thview.timeBtn.selected = YES;
                    self.selTimeHotBtn = self.thview.timeBtn;
                    
                    [self.thview.timeBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
                    
                    [self.thview.hotBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
                    [cell.contentView addSubview:self.thview];
                }
                [self.thview.timeBtn setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
                [self.thview.hotBtn setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
                self.thview.backgroundColor = self.daynightmodel.navigationColor;
                [self.thview.just setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
                self.thview.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
                return cell;
            }
            else
            {
                NSString *identifier = @"commentCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                if (self.thview.louzhu.selected == YES) {
                    cell.textLabel.text = @"该作者没有对自己的文章发表评论";
                }
                else
                {
                    cell.textLabel.text = @"当前文章还没有评论";
                }
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                /* cell的选中样式为无色 */
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.textLabel.textColor = self.daynightmodel.textColor;
                cell.backgroundColor = self.daynightmodel.navigationColor;
                return cell;
            }
            
        }
        else
        {
            if (indexPath.row == 0) {
                NSString *identifier = @"timehot";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    self.thview = [[TimeHotComView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                    self.thview.delegate = self;
                    self.thview.timeBtn.selected = YES;
                    self.selTimeHotBtn = self.thview.timeBtn;
                    
                    [self.thview.timeBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
 
                    [self.thview.hotBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
                    [cell.contentView addSubview:self.thview];
                }
                [self.thview.timeBtn setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
                [self.thview.hotBtn setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
                self.thview.backgroundColor = self.daynightmodel.navigationColor;
                [self.thview.just setTitleColor:self.daynightmodel.textColor forState:UIControlStateNormal];
                self.thview.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
                return cell;
            }
            else
            {
                NSString *identifier = @"commentCell";
                CommentsModel *model = self.viewComDataArr[indexPath.row-1];
                CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                cell = [[CommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andArr:model.secondArr];
                
                cell.delegate = self;
                cell.floorView.delegate = self;
                floorviewsize = cell.floorView.frame.size;
                
                NSString *comment = model.viewcomment;
                UIFont *font = [UIFont systemFontOfSize:16];
                cell.commentLab.font = font;
                cell.commentLab.numberOfLines = 0;
                commentsize = CGSizeMake(kScreenWidth-70, 20000.0f);
                commentsize = [comment calculateSize:commentsize font:font];
                [cell.commentLab setFrame:CGRectMake(55, 10+15+10+cell.floorView.frame.size.height+15, kScreenWidth-70, commentsize.height)];
                
                [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.userinfo_facemedium]];
                cell.nickNameLab.text = [NSString stringWithFormat:@"%@  %@",model.user_nickName,model.viewcommentTime];
                cell.numfloor.text = [NSString stringWithFormat:@"%d楼",(int)self.viewComDataArr.count-(int)indexPath.row];
                cell.commentLab.text = model.viewcomment;
                
                
                [cell.goodnumBtn setTitle:[NSString stringWithFormat:@"  %@",model.comment_goodnum] forState:UIControlStateNormal];
                [cell.goodnumBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
                [cell.goodnumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
                
                cell.goodnumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                cell.goodnumBtn.tag = [model.viewcomment_id integerValue];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_normal.png"] forState:UIControlStateNormal];
                [cell.goodnumBtn setImage:[UIImage imageNamed:@"btn_dianzan_pre.png"] forState:UIControlStateSelected];
                //判断点过没有
                int status = [model.commentStatus intValue];
                if (status == 0) {
                    cell.goodnumBtn.selected = NO;
                }
                else
                {
                    cell.goodnumBtn.selected = YES;
                }
                
                [cell.line setFrame:CGRectMake(15, 10+15+10+floorviewsize.height+15+commentsize.height+14, kScreenWidth-30, 1)];
                
                [cell.goodnumBtn setTitleColor:self.daynightmodel.titleColor forState:UIControlStateNormal];
                cell.nickNameLab.textColor = self.daynightmodel.titleColor;
                cell.numfloor.textColor = self.daynightmodel.titleColor;
                cell.commentLab.textColor = self.daynightmodel.textColor;
                cell.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
                cell.backgroundColor = self.daynightmodel.navigationColor;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pagemode isEqualToString:@"sharp"]) {
        if (self.sharpComDataArr.count == 0) {
            if (indexPath.row == 0) {
                return 44;
            }
            else
            {
                return kScreenHeight-64-50;
            }
        }
        else
        {
            if (indexPath.row == 0) {
                return 44;
            }
            else
            {
                if (indexPath.row == self.sharpComDataArr.count) {
                    if (kScreenHeight-(10+15+5+12+10+commentsize.height+10)*(self.sharpComDataArr.count) > 10+15+5+12+10+commentsize.height+10) {
                        return kScreenHeight-(10+15+5+12+10+commentsize.height+10)*(self.sharpComDataArr.count);
                    }
                }
                /* 设置高度自适应 */
                return 10+15+5+12+10+commentsize.height+10;
            }
        }
    }
    else
    {
        if (self.viewComDataArr.count == 0) {
            if (indexPath.row == 0) {
                return 44;
            }
            else
            {
                return kScreenHeight-64-50;
            }
        }
        else
        {
            if (indexPath.row == 0) {
                return 44;
            }
            else
            {
                if (indexPath.row == self.viewComDataArr.count) {
                    if (kScreenHeight-(10+15+10+floorviewsize.height+15+commentsize.height+15)*(self.viewComDataArr.count-1) > 10+15+10+floorviewsize.height+15+commentsize.height+15) {
                        return kScreenHeight-(10+15+10+floorviewsize.height+15+commentsize.height+15)*(self.viewComDataArr.count-1);
                    }
                }
                return 10+15+10+floorviewsize.height+15+commentsize.height+15;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.viewComDataArr.count > 0) {
        if ([self.delegate respondsToSelector:@selector(didSelectCellforPid:andNickName:)]) {
            if ([self.pagemode isEqualToString:@"view"]) {
                CommentsModel *fModel = self.viewComDataArr[indexPath.row-1];
                [self.delegate didSelectCellforPid:fModel.viewcomment_id andNickName:fModel.user_nickName];
            }
        }
    }
    
}

#pragma mark - timehot Delegate
- (void)selectTime:(UIButton *)sender
{
    self.selTimeHotBtn.selected = NO;
    self.thview.louzhu.selected = NO;
    if (sender.selected == YES) {
        sender.selected = NO;
        timehot = YES;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
    else
    {
        sender.selected = YES;
        timehot = YES;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
}

- (void)selectHot:(UIButton *)sender
{
    self.selTimeHotBtn.selected = NO;
    self.thview.louzhu.selected = NO;
    if (sender.selected == YES) {
        sender.selected = NO;
        timehot = NO;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
    else
    {
        sender.selected = YES;
        timehot = NO;
        self.selTimeHotBtn = sender;
        [self requestWithCommentDataWithTimeHot];
    }
}

- (void)justLouzhu:(UIButton *)sender
{
    
    if (self.thview.louzhu.selected == YES) {
        self.thview.louzhu.selected = NO;
        [self requestWithCommentDataWithTimeHot];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        self.thview.louzhu.selected = YES;
        NSDictionary *dic ;
        if (!US.isLogIn) {
            dic = @{
                    @"type":@"my",
                    @"view_id":self.view_id,
                    @"loadedLength":@"0"
                    };
        }
        else
        {
            dic = @{
                    @"type":@"my",
                    @"view_id":self.view_id,
                    @"user_id":US.userId,
                    @"loadedLength":@"0"
                    };
        }
        
        NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        [ma POST:API_GetViewComment parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                [self.viewComDataArr removeAllObjects];
                NSArray *arr = data;
                for (int i = 0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    CommentsModel *fModel = [CommentsModel getInstanceWithDictionary:dic];
                    [self.viewComDataArr addObject:fModel];
                }
                
                hud.labelText = @"加载完成";
                [hud hide:YES afterDelay:0.1];
                [self.tableView reloadData];
            }
            else
            {
                hud.labelText = @"加载完成";
                [hud hide:YES afterDelay:0.1];
                [self.viewComDataArr removeAllObjects];
                [self.tableView reloadData];
                NSLog(@"%@",error);
            }
        }];
        
    }
}

#pragma mark - 点赞
- (void)good:(UIButton *)sender
{
    if (US.isLogIn == YES) {
        if (sender.selected == NO) {
            NSLog(@"%ld",(long)sender.tag);
            NSString *comment_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
            //点赞
            NSDictionary *dic = @{@"userid":US.userId,
                                  @"comment_id":comment_id};
            NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
            [ma POST:API_AddGoodComment1_2 parameters:dic completion:^(id data, NSError *error) {
                if (!error) {
                    NSLog(@"成功");
                    sender.selected = YES;
                    [sender setImage:[UIImage imageNamed:@"btn_dianzan_pre"] forState:UIControlStateNormal];
                    NSString *str = [NSString stringWithFormat:@"  %d",[sender.titleLabel.text intValue] + 1];
                    [sender setTitle:str forState:UIControlStateNormal];
                }
                else
                {
                    NSLog(@"%@",error);
                }
            }];
        }
    }
    else
    {
        //跳转到登录页面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)replyThis:(FloorView *)sender
{
    if (self.sharpComDataArr.count != 0 || self.viewComDataArr.count != 0) {
        if ([self.delegate respondsToSelector:@selector(replyThis:)]) {
            [self.delegate reply:sender];
        }
    }
}


@end
