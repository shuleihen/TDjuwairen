//
//  GuessAddPourViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuessAddPourDelegate <NSObject>

- (void)guessAddWithStockId:(NSString *)stockId pri:(float)pri keyNum:(NSInteger)keyNum;
@end

@interface GuessAddPourViewController : UIViewController
@property (nonatomic, assign) id<GuessAddPourDelegate> delegate;
@property (nonatomic, copy) NSString *stockId;
@property (nonatomic, assign) float nowPri;
@end
