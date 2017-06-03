//
//  AliveListViewpointImageView.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/3.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AliveListViewpointImageView : UIView
@property (nonatomic, strong) UIImageView *imageView;

- (void)setupViewpointUrl:(NSString *)imageUrl;
@end
