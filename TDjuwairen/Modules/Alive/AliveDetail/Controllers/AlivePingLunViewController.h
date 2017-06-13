//
//  AlivePingLunViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"


typedef void(^DataArrMCountBlock)(NSInteger dataCount);

@interface AlivePingLunViewController : UIViewController
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSString *aliveID;
@property (nonatomic, assign) AliveType aliveType;

@property (copy, nonatomic) DataArrMCountBlock  dataBlock;
@property (nonatomic, strong) id superVC;
@end
