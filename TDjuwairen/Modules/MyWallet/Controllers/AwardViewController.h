//
//  AwardViewController.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeModel.h"

typedef void (^exchangeModelBlock)();

@interface AwardViewController : UIViewController

@property (nonatomic, strong) ExchangeModel *model;

@property (nonatomic,copy )exchangeModelBlock block;

@end
