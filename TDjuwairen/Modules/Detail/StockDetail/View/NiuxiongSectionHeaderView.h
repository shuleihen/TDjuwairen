//
//  NiuxiongSectionHeaderView.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NiuxiongSectionHeaderView : UIView
@property (nonatomic, assign) BOOL isNiu;
@property (nonatomic, copy) void (^buttonBlock)(NSInteger);

- (void)setupXiong:(NSInteger)xiongCount niu:(NSInteger)niuCount;
@end
