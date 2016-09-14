//
//  CompanySelTableView.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/14.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCompanyBlock)();

@interface CompanySelTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *companyArr;

@property (nonatomic,strong) NSMutableArray *showArr;

@property (nonatomic,copy) selectCompanyBlock block;

@end
