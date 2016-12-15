//
//  CommentsChildTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/19.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsChildTableViewController.h"
#import "CommentManagerModel.h"
#import "CommentsModel.h"

#import "SurDetailViewController.h"
#import "DetailPageViewController.h"
#import "CommentsTableViewCell.h"
#import "NothingTableViewCell.h"
#import "UserCommentTableViewCell.h"

#import "NetworkManager.h"
#import "MJRefresh.h"
#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"

#import "UIdaynightModel.h"
#import "LoginState.h"
@interface CommentsChildTableViewController ()
{
    CGSize commentsize;
    CGSize floorviewsize;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NSMutableArray *surveyComArr;
@property (nonatomic,strong) NSMutableArray *viewComArr;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) int typeID;

@end

@implementation CommentsChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.surveyComArr = [NSMutableArray array];
    self.viewComArr = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NothingTableViewCell" bundle:nil] forCellReuseIdentifier:@"NothingCell"];
    
    [self addRefreshView];     //设置刷新
}

- (void)addRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestComment:self.typeID];
}

- (void)loadMoreAction {
    self.page++;
    //继续请求
    [self requestComment:self.typeID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestComment:(int)typeID
{
    self.typeID = typeID;
    __weak CommentsChildTableViewController *wself= self;
    NSDictionary *para;
    if (typeID == 0) {
        para = @{@"userid":US.userId,
                 @"module_id":@"2",
                 @"page":[NSString stringWithFormat:@"%d",self.page]};
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_songsong];
        NSString *url = @"User/getUserComment2_1";
        [manager POST:url parameters:para completion:^(id data, NSError *error){
            if (!error) {
                NSArray *dataArray = data;
                
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    if (wself.page == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                    } else {
                        list = [NSMutableArray arrayWithArray:wself.surveyComArr];
                    }
                    
                    for (NSDictionary *d in dataArray) {
                        CommentManagerModel *model = [CommentManagerModel getInstanceWithDictionary:d];
                        [list addObject:model];
                    }
                    wself.surveyComArr = [NSMutableArray arrayWithArray:list];
                }
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
                [wself.tableView reloadData];
                
            } else {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }];
    }
    else
    {
        para = @{
                 @"userid":US.userId,
                 @"module_id":@"3",
                 @"page":[NSString stringWithFormat:@"%d",self.page],
                 };
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:kAPI_songsong];
        [manager POST:API_GetUserComment parameters:para completion:^(id data, NSError *error){
            if (!error) {
                NSArray *dataArray = data;
                
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    if (wself.page == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                    } else {
                        list = [NSMutableArray arrayWithArray:wself.viewComArr];
                    }
                    
                    for (NSDictionary *d in dataArray) {
                        CommentsModel *model = [CommentsModel getInstanceWithDictionary:d];
                        [list addObject:model];
                    }
                    wself.viewComArr = [NSMutableArray arrayWithArray:list];
                }
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
                [wself.tableView reloadData];
                
            } else {
                [wself.tableView.mj_header endRefreshing];
                [wself.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.typeID == 0) {
        if (self.surveyComArr.count > 0) {
            return self.surveyComArr.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (self.viewComArr.count > 0) {
            return self.viewComArr.count;
        }
        else
        {
            return 1;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeID == 0) {
        if (self.surveyComArr.count > 0) {
            CommentManagerModel *model = self.surveyComArr[indexPath.row];
            CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
            [cell setCellWithDic:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightmodel.backColor;
            cell.label.text = @"暂无评论，快去发表吧~";
            cell.label.textColor = self.daynightmodel.textColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        if (self.viewComArr.count > 0) {
            NSString *identifier = @"cell";
            UserCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            CommentsModel *model = self.viewComArr[indexPath.row];
            if (cell == nil) {
                cell = [[UserCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andArr:model.secondArr];
            }
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
            cell.numfloor.text = [NSString stringWithFormat:@"%d楼",(int)self.viewComArr.count-(int)indexPath.row+1];
            cell.commentLab.text = model.viewcomment;
            
            [cell.originalLab setFrame:CGRectMake(15, 10+15+10+floorviewsize.height+15+commentsize.height+15, kScreenWidth-30, 40)];
            cell.originalLab.text = [NSString stringWithFormat:@"  %@",model.view_title];
            
            [cell.line setFrame:CGRectMake(15, 10+15+10+floorviewsize.height+15+commentsize.height+15+40+14, kScreenWidth-30, 1)];
            
            cell.nickNameLab.textColor = self.daynightmodel.titleColor;
            cell.numfloor.textColor = self.daynightmodel.titleColor;
            cell.commentLab.textColor = self.daynightmodel.textColor;
            cell.originalLab.backgroundColor = self.daynightmodel.backColor;
            cell.originalLab.textColor = self.daynightmodel.titleColor;
            cell.line.layer.borderColor = self.daynightmodel.lineColor.CGColor;
            cell.backgroundColor = self.daynightmodel.navigationColor;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NothingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NothingCell"];
            cell.backgroundColor = self.daynightmodel.backColor;
            cell.label.text = @"暂无评论，快去发表吧~";
            cell.label.textColor = self.daynightmodel.textColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.typeID == 0) {
        if (self.surveyComArr.count > 0) {
            return 136;
        }
        else
        {
            return kScreenHeight-64;
        }
    }
    else
    {
        if (self.viewComArr.count > 0) {
            return 10+15+10+floorviewsize.height+15+commentsize.height+15+40+15;
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
        if (self.surveyComArr.count > 0) {
            CommentManagerModel *model = self.surveyComArr[indexPath.row];
            SurDetailViewController *vc = [[SurDetailViewController alloc] init];
            NSString *code = [model.company_code substringWithRange:NSMakeRange(0, 1)];
            NSString *companyCode ;
            if ([code isEqualToString:@"6"]) {
                companyCode = [NSString stringWithFormat:@"sh%@",model.company_code];
            }
            else
            {
                companyCode = [NSString stringWithFormat:@"sz%@",model.company_code];
            }
            vc.company_code = companyCode;
            vc.survey_cover = model.survey_cover;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        if (self.viewComArr.count > 0) {
            CommentsModel *model = self.viewComArr[indexPath.row];
            DetailPageViewController *view = [[DetailPageViewController alloc]init];
            view.view_id = model.view_id;
            view.pageMode = @"view";
            [self.navigationController pushViewController:view animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

@end
