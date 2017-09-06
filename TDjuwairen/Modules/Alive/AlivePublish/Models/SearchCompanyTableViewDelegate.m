//
//  SearchCompanyTableViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/9/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SearchCompanyTableViewDelegate.h"
#import "SearchCompanyListCell.h"
#import "SearchCompanyListModel.h"
#import "NetworkManager.h"

@implementation SearchCompanyTableViewDelegate

- (id)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 44;
        tableView.separatorInset = UIEdgeInsetsZero;
        _tableView = tableView;
    }
    return self;
}

- (void)reloadWithSearchText:(NSString *)searchText {
    if (searchText.length == 0) {
        self.resultArray = nil;
        [self.tableView reloadData];
        return;
    }
    
    NSDictionary *dict = @{@"keyword": searchText};
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager POST:API_ViewSearchCompnay parameters:dict completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *dataArray = data;
            NSMutableArray *resultModelArrM = [NSMutableArray array];
            for (NSDictionary *d in dataArray) {
                SearchCompanyListModel *model = [[SearchCompanyListModel alloc] initWithDictionary:d];
                [resultModelArrM addObject:model];
            }
            
            self.resultArray = resultModelArrM;
        }else{
            
        }
        
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.resultArray.count > 0?1:0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCompanyListCell *cell = [SearchCompanyListCell loadSearchCompanyListCellWithTableView:tableView];
    cell.resultModel = self.resultArray[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchCompanyListModel *model =self.resultArray[indexPath.row];
    if (self.didSelectedWithSearchCompnayModle) {
        self.didSelectedWithSearchCompnayModle(model);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
@end
