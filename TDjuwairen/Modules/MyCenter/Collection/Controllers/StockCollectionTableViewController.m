//
//  StockCollectionTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockCollectionTableViewController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "UIViewController+Loading.h"
#import "StockHotModel.h"
#import "StockSurveyModel.h"
#import "HotTableViewCell.h"
#import "SpotTableViewCell.h"
#import "SurveyDetailWebViewController.h"
#import "VideoDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIViewController+NoData.h"

@interface StockCollectionTableViewController ()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *itemList;
@end

@implementation StockCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, self.tableView.bounds.size.height/2)];
    
    [self setupNoDataImage:[UIImage imageNamed:@"no_result.png"] message:@"您还没有过收藏"];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    
    if (self.type == kCollectionHot) {
        UINib *nib = [UINib nibWithNibName:@"HotTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"HotTableViewCellID"];
    } else {
        UINib *nib = [UINib nibWithNibName:@"SpotTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"SpotTableViewCellID"];
    }
    
    self.tableView.rowHeight = 90;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self refreshActions];
}

- (void)refreshActions {
    self.currentPage = 1;
    [self queryCollectionListWithPage:self.currentPage];
}

- (void)loadMoreActions{
    [self queryCollectionListWithPage:self.currentPage];
}

- (void)queryCollectionListWithPage:(NSInteger)page {
    __weak StockCollectionTableViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"tag": @(self.type),@"page": @(page)};
    
    [manager GET:API_GetCollectionList parameters:dict completion:^(id data, NSError *error){
        
        if (!error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *dataArray = data;
                BOOL scrollToTop = NO;
                
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    if (wself.currentPage == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                        scrollToTop = YES;
                    } else {
                        list = [NSMutableArray arrayWithArray:wself.itemList];
                    }
                    
                    if (self.type == kCollectionHot) {
                        for (NSDictionary *dic in dataArray) {
                            StockHotModel *model = [[StockHotModel alloc] initWithCollectionDict:dic];
                            [list addObject:model];
                        }
                    } else {
                        for (NSDictionary *dic in dataArray) {
                            StockSurveyModel *model = [[StockSurveyModel alloc] initWithCollectionDict:dic];
                            [list addObject:model];
                        }
                    }
                    
                    wself.itemList = [NSArray arrayWithArray:list];
                    
                    wself.currentPage++;
                } else {
                    if (wself.currentPage == 1) {
                        wself.itemList = nil;
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (wself.tableView.mj_footer.isRefreshing) {
                        [wself.tableView.mj_footer endRefreshing];
                    }
                    
                    [wself removeLoadingAnimation];
                    [wself.tableView reloadData];
                    [wself showNoDataView:(wself.itemList.count == 0)];
                    
                    if (scrollToTop) {
                        [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
                    }
                });
                
            });
            
        } else if (error.code == kErrorNoLogin){
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself removeLoadingAnimation];
            
            
            wself.itemList = nil;
            [wself.tableView reloadData];
        } else {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself removeLoadingAnimation];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == kCollectionHot) {
        HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotTableViewCellID"];
        
        StockHotModel *model = self.itemList[indexPath.row];
        [cell setupSpotModel:model];
        return cell;
    } else {
        SpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotTableViewCellID"];
        
        StockSurveyModel *model = self.itemList[indexPath.row];
        [cell setupSpotModel:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == kCollectionHot) {
        StockHotModel *model = self.itemList[indexPath.row];
        
        SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
        vc.contentId = model.hotId;
//        vc.stockCode = self.stockCode;
//        vc.stockName = self.stockName;
        vc.surveyType = kSurveyTypeHot;
        vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:model.hotId withTag:kSurveyTypeHot];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        StockSurveyModel *model = self.itemList[indexPath.row];
        
        if (model.surveyType == kSurveyTypeVido) {
            VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithVideoId:model.surveyId];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            SurveyDetailWebViewController *vc = [[SurveyDetailWebViewController alloc] init];
            vc.contentId = model.surveyId;
//            vc.stockCode = self.stockCode;
//            vc.stockName = self.stockName;
            vc.surveyType = model.surveyType;
            vc.url = [SurveyDetailContentViewController contenWebUrlWithContentId:model.surveyId withTag:model.surveyType];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消收藏" message:@"\n取消收藏，将不在列表中显示\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self cancelEditWithIndexPath:indexPath];
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self deleteWithIndexPath:indexPath];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelEditWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict;
    
    if (self.type == kCollectionHot) {
        StockHotModel *model = self.itemList[indexPath.row];
        dict = @{@"collect_id": model.collectedId};
    } else {
        StockSurveyModel *model = self.itemList[indexPath.row];
        dict = @{@"collect_id": model.collectedId};
    }
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"取消收藏";
    [manager POST:API_CancelCollection parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            [hud hideAnimated:YES];
            [self deleteSuccessedWithIndexPath:indexPath];
        } else {
            hud.label.text = @"取消收藏失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
        
    }];
}

- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.itemList];
    [array removeObjectAtIndex:indexPath.row];
    self.itemList = array;
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}
@end
