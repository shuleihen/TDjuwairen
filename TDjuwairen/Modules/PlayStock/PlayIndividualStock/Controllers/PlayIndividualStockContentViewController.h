//
//  PlayIndividualStockContentViewController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"

typedef enum : NSUInteger {
    PlayIndividualContentNewType     =0, // 最新列表
    PlayIndividualContentHostType  =1 // 最热列表
} PlayIndividualContentType;

@class PlayIndividualStockViewController;
@class PlayGuessIndividua;

@interface PlayIndividualStockContentViewController : UIViewController
/// 1表示上午场，2表示下午场	是
@property (assign, nonatomic) NSInteger listSeason;
@property (copy, nonatomic) NSString *listTag;

@property (nonatomic, strong) PlayIndividualStockViewController *superVC;
//PlayListModel
@property (nonatomic, strong) PlayGuessIndividua *guessModel;
@property (nonatomic, strong) NSDictionary *stockInfo;

- (id)initWithPlayIndividualStockContentViewControllerWithFrame:(CGRect)rect andListType:(PlayIndividualContentType)listType;

@end
