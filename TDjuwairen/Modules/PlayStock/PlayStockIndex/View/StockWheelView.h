//
//  StockWheelView.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kStockSZ = 1,
    kStockCY = 2,
    kStockInd,
} StockType;

@interface WheelScale : NSObject
@property (nonatomic, assign) CGFloat du;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, assign) CGFloat offx;
@property (nonatomic, assign) CGFloat offy;
@end

@interface StockWheelView : UIView
@property (assign, nonatomic) StockType type;

@property (assign, nonatomic) CGFloat index;

@property (nonatomic, strong) NSArray *buyIndexs;

- (CGPoint)pointWithPri:(CGFloat)pri;
@end
