//
//  SearchCompanyListTableView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ChoiceCompanyCodeBlock)(NSString *code);

//@protocol SearchCompanyListDelegate <NSObject>
//
//
//- (void)choiceCompanyCode:(NSString *)companyCodeStr;
//
//@end

@interface SearchCompanyListTableView : UITableView
//@property (weak, nonatomic) id<SearchCompanyListDelegate> delegate;
@property (copy, nonatomic) ChoiceCompanyCodeBlock  choiceCode;
@property (strong, nonatomic) NSArray *resultDataArr;
- (instancetype)initWithSearchCompanyListTableViewWithFrame:(CGRect)rect;


@end
