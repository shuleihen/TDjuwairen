//
//  StockCollectionTableViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

// 调研和热点收藏
typedef enum : NSUInteger {
    kCollectionViewpoint    =0,
    kCollectionSurvey       =1,
    kCollectionHot          =2,
} CollectionType;

@interface StockCollectionTableViewController : UITableViewController

@property (nonatomic, assign) CollectionType type;
@end
