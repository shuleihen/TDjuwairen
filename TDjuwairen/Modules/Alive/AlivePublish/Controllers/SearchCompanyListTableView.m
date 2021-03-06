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
@property (strong, nonatomic) NSArray *resultDataArr;

@end

@implementation SearchCompanyListTableView

- (instancetype)initWithSearchCompanyListTableViewWithFrame:(CGRect)rect{
    
    if (self = [super initWithFrame:rect style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#EFEFEF"];
        self.hidden = YES;
        self.alwaysBounceVertical = YES;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}


- (void)setResultDataArr:(NSArray *)resultDataArr {
    
    _resultDataArr = resultDataArr;
    [self reloadData];
    
}

- (void)configResultDataArr:(NSArray *)arr andRectY:(CGFloat)orginY {
    [self configResultDataArr:arr andRectY:orginY andBottomH:0];
    
}


- (void)configResultDataArr:(NSArray *)arr andRectY:(CGFloat)orginY andBottomH:(CGFloat)bottomH {
    self.delegate = self;
    self.dataSource = self;
    if (arr.count <= 0) {
        self.hidden = YES;
    }else {
        
        self.hidden = NO;
    }
    
    CGFloat tableViewH = MIN(arr.count*24, kScreenHeight-orginY-64-bottomH);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), orginY, CGRectGetWidth(self.frame), tableViewH);
    self.resultDataArr = arr;
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
    
    
    if (self.vcType) {
        
        if (self.backBlock) {
            self.backBlock(model.company_code,model.company_name);
        }
    }else {
        
        if (self.choiceModel) {
            self.choiceModel(model);
        }
        
    }
    
    self.hidden = YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 24;
}

/// 更改tableview高度
- (void)changeTableViewHeightWithRectY:(CGFloat)orginY {
    
    CGFloat tableViewH = MIN(self.resultDataArr.count*24, kScreenHeight-orginY-64);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), orginY, CGRectGetWidth(self.frame), tableViewH);
    [self reloadData];
    
}


@end
