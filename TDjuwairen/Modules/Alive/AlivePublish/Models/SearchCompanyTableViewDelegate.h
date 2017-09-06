//
//  SearchCompanyTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/9/5.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchCompanyListModel.h"

@interface SearchCompanyTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, copy) void (^didSelectedWithSearchCompnayModle)(SearchCompanyListModel *);

- (id)initWithTableView:(UITableView *)tableView;
- (void)reloadWithSearchText:(NSString *)searchText;

@end
