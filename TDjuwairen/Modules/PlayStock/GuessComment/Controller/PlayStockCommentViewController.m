//
//  PlayStockCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PlayStockCommentViewController.h"
#import "HexColors.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import "GuessCommentModel.h"
#import "SQTopicTableViewCell.h"
#import "SQTopicModel.h"
#import "SQCommentModel.h"
#import "SQTopicCellViewModel.h"
#import "SQCommentModel.h"
#import "SQCommentCellViewModel.h"
#import "STPopup.h"
#import "GuessCommentPublishViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "NotificationDef.h"

@interface PlayStockCommentViewController ()<UITableViewDelegate, UITableViewDataSource, SQTopicTableViewCellDelegate, GuessCommentPublishDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (copy, nonatomic) NSArray *items;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation PlayStockCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView registerClass:[SQTopicTableViewCell class] forCellReuseIdentifier:@"GuessCommentCellID"];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
    [self queryGuessComment];
}

- (void)refreshAction {
    self.page = 1;
    [self queryGuessComment];
}

- (void)loadMoreAction {
    [self queryGuessComment];
}

- (void)queryGuessComment {
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *dict = nil;
    if (!US.isLogIn) {
        dict = @{@"page": @(self.page)};
    } else {
        dict = @{@"user_id": US.userId, @"page": @(self.page)};
    }

    __weak PlayStockCommentViewController *wself = self;
    [ma GET:API_GameCommentList parameters:dict completion:^(id data, NSError *error){
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (!error && data) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                SQTopicModel *topic = [[SQTopicModel alloc] initWithDict:dict];
                SQTopicCellViewModel *viewModel = [[SQTopicCellViewModel alloc] init];
             
                viewModel.topicModel = topic;
                [array addObject:viewModel];
            }

            if ([array count] == 20) {
                [self.tableView.mj_footer resetNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            wself.page += 1;
            wself.dataArray = array;
        }
    
        [wself.tableView reloadData];
    }];
}

- (void)reloadWithCommentList:(NSArray *)array {
    
}

- (IBAction)addCommentPressed:(id)sender {
    if (US.isLogIn) {
        [self showPublishControllerWithType:kGuessPublishAdd withReplyCommentId:nil];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)showPublishControllerWithType:(GuessPublishType)type withReplyCommentId:(NSString *)replyCommentId{
    GuessCommentPublishViewController *vc = (GuessCommentPublishViewController *)[[UIStoryboard storyboardWithName:@"PlayStock" bundle:nil] instantiateViewControllerWithIdentifier:@"GuessCommentPublishViewController"];
    vc.delegate = self;
    vc.type = type;
    vc.replyCommentId = replyCommentId;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:vc];
    popupController.navigationBarHidden = YES;
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (void)publishCommentType:(GuessPublishType)type withContent:(NSString *)content withReplyCommentId:(NSString *)commentId{
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (US.isLogIn) {
        NSAssert(US.userId, @"用户Id不能为空");
        dict[@"user_id"] = US.userId;
    }
    
    if (type == kGuessPublishReply) {
        NSAssert(commentId, @"回复评论的Id不能为空");
        dict[@"comment_id"] = commentId;
    }
    
    dict[@"content"] = content;
    
    __weak PlayStockCommentViewController *wself = self;
    [ma POST:API_GameAddComment parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发布成功";
            hud.labelFont = [UIFont systemFontOfSize:14.0f];
            [hud hide:YES afterDelay:0.4];
            
            if (type == kGuessPublishAdd) {
                [wself addNewTopicWithContent:content];
            } else if (type == kGuessPublishReply) {
                [wself addNewReplayWithReplyCommentId:commentId withContent:content];
            }
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发布失败";
            hud.labelFont = [UIFont systemFontOfSize:14.0f];
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

- (void)addNewTopicWithContent:(NSString *)content {
    SQTopicModel *topic = [[SQTopicModel alloc] init];
    topic.userId = US.userId;
    topic.icon = US.headImage;
    topic.userName = US.nickName;
    topic.content = content;
    
    SQTopicCellViewModel *viewModel = [[SQTopicCellViewModel alloc] init];
    viewModel.topicModel = topic;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.dataArray count]+1];
    [array addObject:viewModel];
    [array addObjectsFromArray:self.dataArray];
    
    self.dataArray = array;
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGuessCommentChanged  object:nil];
}

- (void)addNewReplayWithReplyCommentId:(NSString *)replyCommentId withContent:(NSString *)content {
    SQCommentModel *reply = [[SQCommentModel alloc] init];
    reply.userId = US.userId;
    reply.icon = US.headImage;
    reply.userName = US.nickName;
    reply.content = content;
    
    int i = 0;
    for (SQTopicCellViewModel *topicCell in self.dataArray) {
        if ([topicCell.topicModel.commentId isEqualToString:replyCommentId]) {
            
            SQTopicModel *topic = topicCell.topicModel;
            [topic.commentModels insertObject:reply atIndex:0];
            topicCell.topicModel = topic;
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        i++;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGuessCommentChanged  object:nil];
}

#pragma mark - GuessCommentPublishDelegate
- (void)guessCommentPublishType:(GuessPublishType)type withContent:(NSString *)content withReplyCommentId:(NSString *)commentId {
    [self publishCommentType:type withContent:content withReplyCommentId:commentId];
}

#pragma mark - SQTopicTableViewCellDelegate
- (void)cell:(SQTopicTableViewCell *)cell didReplyTopicClicked:(SQTopicModel *)topicModel {
    
    if (US.isLogIn) {
        [self showPublishControllerWithType:kGuessPublishReply withReplyCommentId:topicModel.commentId];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)cellToggleExpentContent:(SQTopicTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    SQTopicCellViewModel *viewModel = self.dataArray[indexPath.row];
    SQTopicCellViewModel *newViewModel = [[SQTopicCellViewModel alloc] init];
    
    viewModel.topicModel.expanded = !viewModel.topicModel.expanded;
    newViewModel.topicModel = viewModel.topicModel;
    
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newViewModel];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQTopicCellViewModel *topicViewModel = self.dataArray[indexPath.row];
    
    return topicViewModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuessCommentCellID"];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull SQTopicTableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.topicViewModel = self.dataArray[indexPath.row];
    
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
@end
