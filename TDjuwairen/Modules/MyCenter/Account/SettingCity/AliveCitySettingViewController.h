//
//  AliveCitySettingViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AliveCitySettingViewController : UITableViewController
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *parent;
@property (nonatomic, strong) NSArray *items;
@end
