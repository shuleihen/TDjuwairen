//
//  PlayIndividualStockContentViewController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayIndividualStockViewController;

@interface PlayIndividualStockContentViewController : UIViewController

- (void)reloadPlayIndividualStockTableView;
- (CGFloat)viewHeight;
@property (nonatomic, strong) PlayIndividualStockViewController *superVC;

@property (nonatomic, strong) NSArray *listArr;

@end
