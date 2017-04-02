//
//  PlayGuessViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockManager.h"

@protocol PlayGuessViewControllerDelegate <NSObject>
- (void)addWithGuessId:(NSString *)stockId pri:(float)pri season:(NSInteger)season;
@end

@interface PlayGuessViewController : UIViewController

@property (nonatomic, assign) id<PlayGuessViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger season;
@property (nonatomic, copy) NSString *guess_date;
@property (nonatomic, strong) StockInfo *stockInfo;
@property (nonatomic, weak) IBOutlet UITextField *inputView;
@end
