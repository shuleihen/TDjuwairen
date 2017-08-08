//
//  DYRefreshBaseView.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/8.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DYRefreshBaseView.h"

@implementation DYRefreshBaseView

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0f) {
        progress = 1.0f;
    } else if (progress < 0.0) {
        progress = 0.0f;
    }
    
    _progress = progress;
}

- (void)setResult:(NSString *)result {
    _result = result;
}

- (void)reset {
    
}

- (void)startAnimation {
    
}

- (void)stopAnimation {
    
}
@end
