//
//  MessageChildTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/23.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MessageChildTableViewController.h"
#import "ReplyRemindTableViewCell.h"
#import "NothingTableViewCell.h"
#import "DetailPageViewController.h"

#import "NetworkManager.h"
#import "NSString+Ext.h"

#import "LoginState.h"
#import "UIdaynightModel.h"

@import UserNotifications;
@interface MessageChildTableViewController ()
{
    CGSize titlesize;
}

@property (nonatomic,assign) int typeID;
@property (nonatomic,strong) UIdaynightModel *daynightModel;
@property (nonatomic,strong) NSMutableArray *replyArray;
@property (nonatomic,strong) NSDictionary *replyDic;

@property (nonatomic,strong) NSMutableArray *notArray;


@end

@implementation MessageChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.daynightModel = [UIdaynightModel sharedInstance];
    self.replyArray = [NSMutableArray array];
    self.notArray = [NSMutableArray array];
    
    self.tableView.backgroundColor = self.daynightModel.backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
    
}

- (void)requestShowList:(int)typeId
{
    self.typeID = typeId;
    if (typeId == 0) {
        NetworkManager *manager = [[NetworkManager alloc]initWithBaseUrl:API_HOST];
        NSDictionary *dic = @{@"user_id":US.userId};
        NSString *url = @"index.php/Blog/getCommentMsg";
        [manager POST:url parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                self.replyArray = data;
                [self.tableView reloadData];
            }
            else
            {
                [self.tableView reloadData];
            }
            
        }];
    }
    else
    {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
//            __weak MessageChildTableViewController *wself = self;
//            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter] ;
//            [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
//                [wself.notArray removeAllObjects];
//                for (UNNotification *notification in notifications) {
//                    NSDictionary *alert = notification.request.content.userInfo[@"aps"];
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    [dic setValue:[NSString stringWithFormat:@"%@",notification.date] forKey:@"date"];
//                    [dic setValue:alert[@"alert"] forKey:@"alert"];
//                    [dic setValue:notification.request.content.userInfo[@"view_id"] forKey:@"view_id"];
//                    [wself.notArray addObject:dic];
//                    
//                }
//                [wself.tableView reloadData];
//            }];
//        }
//        else
//        {
//            NSArray *arr = [[UIApplication sharedApplication] scheduledLocalNotifications];
//            //这里改为直接请求出十条数据
//        }
        
        NetworkManager *manager = [[NetworkManager alloc]initWithBaseUrl:API_HOST];
        NSDictionary *dic = @{@"user_id":US.userId
                              };
        NSString *url = @"index.php/Index/getPushAllMsg";
        [manager POST:url parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                self.notArray = data;
                [self.tableView reloadData];
            }
            else
            {
                [self.tableView reloadData];
            }
        }];
        
    }
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
    if (self.typeID == 0) {
        if (self.replyArray.count > 0) {
            return self.replyArray.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (self.notArray.count > 0) {
            return self.notArray.count;
        }
        else
        {
            return 1;
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeID == 0) {
        if (self.replyArray.count > 0) {
            NSString *identifier = @"cell";
            self.replyDic = self.replyArray[indexPath.row];
            ReplyRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ReplyRemindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *type = [NSString stringWithFormat:@"%@",self.replyDic[@"type"]];
            if ([type isEqualToString:@"2"]) {
                cell.titleLab.text = [NSString stringWithFormat:@"您的观点 %@ 有了%@条新的回复",self.replyDic[@"view_title"],self.replyDic[@"comment_count"]];
                cell.titleLab.textColor = [UIColor lightGrayColor];
                NSMutableAttributedString *attrString = [cell.titleLab.attributedText mutableCopy];
                [attrString addAttribute:NSForegroundColorAttributeName value:self.daynightModel.textColor range:[cell.titleLab.text rangeOfString:self.replyDic[@"view_title"]]];
                cell.titleLab.attributedText = attrString;
            }
            else if([type isEqualToString:@"1"])
            {
                cell.titleLab.text = [NSString stringWithFormat:@"%@在观点 %@ 中回复了您：\"%@\"",self.replyDic[@"user_name"],
                                      self.replyDic[@"view_title"],
                                      self.replyDic[@"comment"]];
                cell.titleLab.textColor = [UIColor lightGrayColor];
                NSMutableAttributedString *attrString = [cell.titleLab.attributedText mutableCopy];
                [attrString addAttribute:NSForegroundColorAttributeName value:self.daynightModel.textColor range:[cell.titleLab.text rangeOfString:self.replyDic[@"user_name"]]];
                [attrString addAttribute:NSForegroundColorAttributeName value:self.daynightModel.textColor range:[cell.titleLab.text rangeOfString:self.replyDic[@"view_title"]]];
                [attrString addAttribute:NSForegroundColorAttributeName value:self.daynightModel.textColor range:[cell.titleLab.text rangeOfString:self.replyDic[@"comment"]]];
                cell.titleLab.attributedText = attrString;
            }
            
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            cell.titleLab.font = font;
            cell.titleLab.numberOfLines = 0;
            titlesize = CGSizeMake(kScreenWidth-16-90-15, 20000.0f);
            titlesize = [cell.titleLab.text calculateSize:titlesize font:font];
            [cell.titleLab setFrame:CGRectMake(15, 10, kScreenWidth-30, titlesize.height)];
            
            cell.timeLab.text = self.replyDic[@"comment_time"];
            [cell.timeLab setFrame:CGRectMake(15, 10 + titlesize.height + 10, kScreenWidth-30, 15)];
            
            [cell.line setFrame:CGRectMake(0, 10+titlesize.height+10+15+14, kScreenWidth, 1)];
            cell.line.layer.borderWidth = 1;
            
            cell.timeLab.textColor = self.daynightModel.titleColor;
            cell.line.layer.borderColor = self.daynightModel.lineColor.CGColor;
            cell.backgroundColor = self.daynightModel.navigationColor;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightModel.backColor;
            cell.label.text = @"你当前没有收到回复哦~";
            cell.label.textColor = self.daynightModel.textColor;
            return cell;
        }
    }
    else
    {
        if (self.notArray.count > 0) {
            NSString *identifier = @"cell";
            NSDictionary *dic = self.notArray[indexPath.row];
            ReplyRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ReplyRemindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.titleLab.text = dic[@"message_title"];
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            cell.titleLab.font = font;
            cell.titleLab.numberOfLines = 0;
            titlesize = CGSizeMake(kScreenWidth-16-90-15, 20000.0f);
            titlesize = [cell.titleLab.text calculateSize:titlesize font:font];
            [cell.titleLab setFrame:CGRectMake(15, 10, kScreenWidth-30, titlesize.height)];
            
            cell.timeLab.text = dic[@"message_time"];
            [cell.timeLab setFrame:CGRectMake(15, 10 + titlesize.height + 10, kScreenWidth-30, 15)];
            
            [cell.line setFrame:CGRectMake(0, 10+titlesize.height+10+15+14, kScreenWidth, 1)];
            cell.line.layer.borderWidth = 1;
            
            cell.timeLab.textColor = self.daynightModel.titleColor;
            cell.line.layer.borderColor = self.daynightModel.lineColor.CGColor;
            cell.backgroundColor = self.daynightModel.navigationColor;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightModel.backColor;
            cell.label.text = @"你当前没有收到回复哦~";
            cell.label.textColor = self.daynightModel.textColor;
            return cell;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.typeID == 0) {
        if (self.replyArray.count > 0) {
            return 10+titlesize.height+10+15+15;
        }
        else
        {
            return kScreenHeight-64;
        }
    }
    else
    {
        if (self.notArray.count > 0) {
            return 10+titlesize.height+10+15+15;
        }
        else
        {
            return kScreenHeight-64;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.typeID == 0) {
        if (self.replyArray.count > 0) {
            self.replyDic = self.replyArray[indexPath.row];
            NSString *detailID = @"";
            NSString *type = @"view";
            if (self.replyDic[@"viewcomment_id"]) {
                detailID = self.replyDic[@"viewcomment_id"];
                type = @"comment";
            }
            else
            {
                detailID = self.replyDic[@"view_id"];
                type = @"view";
            }
            
            //点击后不再提醒
            NetworkManager *manager = [[NetworkManager alloc]initWithBaseUrl:API_HOST];
            NSString *url = @"index.php/Blog/updateCommentsState";
            NSDictionary *para = @{@"id":detailID,
                                   @"type":type};
            [manager POST:url parameters:para completion:^(id data, NSError *error) {
                if (!error) {
                    
                }
                else
                {
                    
                }
            }];
            DetailPageViewController *detail = [[DetailPageViewController alloc]init];
            detail.view_id = self.replyDic[@"view_id"];
            detail.pageMode = @"view";
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
    else
    {
        if (self.notArray.count > 0) {
            NSDictionary *dic = self.notArray[indexPath.row];
            DetailPageViewController *detail = [[DetailPageViewController alloc]init];
            detail.view_id = dic[@"message_itemid"];
            detail.pageMode = @"view";
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
    
}


@end
