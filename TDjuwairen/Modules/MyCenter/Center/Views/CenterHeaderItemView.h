//
//  CenterHeaderItemView.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterHeaderItemView : UIView
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

- (void)setupNumber:(NSInteger)number;
@end
