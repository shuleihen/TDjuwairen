//
//  SearchCompanyListTableView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SearchCompanyListTableView.h"
#import "SearchCompanyListCell.h"


@interface SearchCompanyListTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchCompanyListTableView

- (instancetype)initWithSearchCompanyListTableViewWithFrame:(CGRect)rect{
    
    if (self = [super initWithFrame:rect style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void)setResultDataArr:(NSArray *)resultDataArr {
    
    _resultDataArr = resultDataArr;
    self.delegate = self;
    self.dataSource = self;
    if (resultDataArr.count <= 0) {
        self.hidden = YES;
    }else {
        
        self.hidden = NO;
    }
    
    CGFloat tableViewH = MIN(resultDataArr.count*24, kScreenHeight-CGRectGetMinY(self.frame));
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), tableViewH);
    [self reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.resultDataArr.count > 0?1:0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resultDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCompanyListCell *cell = [SearchCompanyListCell loadSearchCompanyListCellWithTableView:tableView];
    cell.resultModel = self.resultDataArr[indexPath.row];
    return cell;
}




#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchCompanyListModel *model =self.resultDataArr[indexPath.row];
    if (self.choiceCode) {
        self.choiceCode(model.company_code);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 24;
}



@end
