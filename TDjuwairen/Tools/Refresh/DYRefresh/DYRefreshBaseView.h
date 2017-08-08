//
//  DYRefreshBaseView.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYRefreshBaseView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSString *result;

- (void)reset;
- (void)startAnimation;
- (void)stopAnimation;
@end
