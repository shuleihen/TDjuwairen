//
//  PlayGuessViewController.h
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GPlayGuessViewControllerDelegate <NSObject>
- (void)addWithGuessId:(NSString *)stockId pri:(float)pri keyNum:(NSInteger)keyNum;
@end

@interface PlayGuessViewController : UIViewController

@property (nonatomic, assign) id<GPlayGuessViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger userKeyNum;
@property (nonatomic, copy) NSString *guessId;
@end
