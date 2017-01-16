//
//  GradeView.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeNode : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat radian;
@property (nonatomic, assign) CGFloat offx;
@property (nonatomic, assign) CGFloat offy;
@end

@interface GradeView : UIView
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *stockId;

@property (nonatomic, strong) NSArray *nodes;

// 按照 德、智、财、势、创、观、透、行
@property (nonatomic, strong) NSArray *grades;
@end
