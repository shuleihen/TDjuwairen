//
//  SurveyDetailStockCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailStockCommentViewController.h"
#import "StockCommentModel.h"

@interface SurveyDetailStockCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *stockComments;
@property (nonatomic, strong) UITableView *tableVie;
@end

@implementation SurveyDetailStockCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)loadWebWithUrl:(NSString *)url {
    // 牛熊说 不是有url
    
}

- (void)setupStockComments:(NSArray *)stockComments {
    
}
@end
