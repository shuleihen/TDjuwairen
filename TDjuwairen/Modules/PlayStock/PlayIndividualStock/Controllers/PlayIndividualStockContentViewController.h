//
//  PlayIndividualStockContentViewController.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeTabelViewH)(CGFloat height);

@class PlayIndividualStockViewController;
@class PlayGuessIndividua;
@interface PlayIndividualStockContentViewController : UIViewController
@property (nonatomic, strong) PlayIndividualStockViewController *superVC;
@property (nonatomic, strong) NSArray *listArr;//PlayListModel
@property (nonatomic, strong) PlayGuessIndividua *guessModel;
@property (copy, nonatomic) ChangeTabelViewH  changeH;
@end
