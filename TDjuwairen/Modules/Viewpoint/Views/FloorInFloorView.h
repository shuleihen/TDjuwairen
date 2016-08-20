//
//  FloorInFloorView.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorView.h"

@protocol FloorInFloorViewDelegate <NSObject>

- (void)replyThis:(FloorView *)sender;

@end

@interface FloorInFloorView : UIView

@property (nonatomic,assign) int height;
@property (nonatomic,strong) UIView *view;

@property (nonatomic,assign) id<FloorInFloorViewDelegate>delegate;

- (instancetype)initWithArr:(NSArray *)arr;

@end
