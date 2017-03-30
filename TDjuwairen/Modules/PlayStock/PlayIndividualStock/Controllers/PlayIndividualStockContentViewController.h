//
//  PlayIndividualStockContentViewController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeHeightBlock)(CGFloat h);

@class PlayIndividualStockViewController;
@class PlayGuessIndividua;
@interface PlayIndividualStockContentViewController : UIViewController

- (void)reloadPlayIndividualStockTableView;

@property (nonatomic, strong) PlayIndividualStockViewController *superVC;

@property (nonatomic, strong) NSArray *listArr;//PlayListModel
@property (nonatomic, strong) PlayGuessIndividua *guessModel;

@property (copy, nonatomic) ChangeHeightBlock  changeHBlock;
@end
