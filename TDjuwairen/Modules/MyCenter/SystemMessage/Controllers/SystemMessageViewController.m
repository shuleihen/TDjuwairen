//
//  SystemMessageViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SysMessageListCell.h"
#import "SysMessageListModel.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "UIViewController+Loading.h"
#import "MBProgressHUD.h"
#import "TDWebViewHandler.h"

@interface SystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger page;
@end

@implementation SystemMessageViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"SysMessageListCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"SysMessageListCellID"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"系统消息";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, self.tableView.bounds.size.height/2)];
    
    [self refreshActions];
}

- (void)clearPressed:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清空列表" message:@"清空列表消息将永久删除，确认清空？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self sendClearRequest];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)sendClearRequest {
    __weak typeof(self)weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"清空";
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_MessageSystemClear parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            
            weakSelf.items = nil;
            [weakSelf.tableView reloadData];
            
            hud.label.text = @"清空成功";
            [hud hideAnimated:YES];
        } else {
            [weakSelf.tableView reloadData];
            hud.label.text = error.localizedDescription?:@"清空失败";
            [hud hideAnimated:YES afterDelay:0.6];
        }
    }];
}


- (void)refreshActions{
    self.page = 1;
    [self requestDataWithPage:self.page];
}

- (void)loadMoreActions{
    [self requestDataWithPage:self.page];
}

- (void)requestDataWithPage:(NSInteger)aPage{
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *dict = @{@"page":@(aPage)};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_MessageGetSystemList parameters:dict completion:^(id data, NSError *error){
        
        [self removeLoadingAnimation];
        
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:dataArray.count];
                
                for (NSDictionary *d in dataArray) {
                    SysMessageListModel *model = [[SysMessageListModel alloc] initWithDictionary:d];
                    [list addObject:model];
                }
                
                if (weakSelf.page == 1) {
                    weakSelf.items = [NSMutableArray arrayWithArray:list];
                } else {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
                    [array addObjectsFromArray:list];
                    weakSelf.items = array;
                }
            }
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.page++;
            [weakSelf.tableView reloadData];
            
            weakSelf.navigationItem.rightBarButtonItem.enabled = weakSelf.items.count?YES:NO;
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        }
    }];
    
}

- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    
    SysMessageListModel *model = self.items[indexPath.section];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"msg_id":model.msgId,@"msg_type":@(model.msgType)};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"删除消息";
    [manager POST:API_MessageSystemDelete parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            hud.label.text = @"删除功能";
            [hud hideAnimated:YES afterDelay:0.3];
            [self deleteSuccessedWithIndexPath:indexPath];
        } else {
            hud.label.text = @"删除失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
        
    }];
}

- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array removeObjectAtIndex:indexPath.section];
    self.items = array;
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMessageListCellID"];
    
    SysMessageListModel *model = self.items[indexPath.section];
    
    CGSize size = [model.typeString boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil].size;
    cell.typeLableWidth.constant = size.width+8;
    cell.typeLabel.text = model.typeString;
    
    cell.timeLabel.text = model.msgTime;
    
    NSData *data=[model.msgContent dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *optoins=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:data
                                                                         options:optoins
                                                              documentAttributes:nil
                                                                           error:nil];
    cell.contentLabel.attributedText = attributeString;
    cell.contentLabel.numberOfLines = 0;
    
    __weak SystemMessageViewController *wself = self;
    cell.deleteBlock = ^{
        [wself deleteWithIndexPath:indexPath];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageListModel *model = self.items[indexPath.section];
    
    NSData *data=[model.msgContent dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *optoins=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:data
                                                                         options:optoins
                                                              documentAttributes:nil
                                                                           error:nil];
    CGSize size = [attributeString boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size.height+10+20 + 38;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.menuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SysMessageListModel *model = self.items[indexPath.section];
    if ((model.msgType == 1) && (model.msgLinkType == 5)) {
        [TDWebViewHandler openURL:model.msgLink inNav:self.navigationController];
    }
}
@end
