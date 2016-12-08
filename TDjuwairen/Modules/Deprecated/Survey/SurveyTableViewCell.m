//
//  SurveyTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyTableViewCell.h"

@implementation SurveyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelbackview = [[UIView alloc]initWithFrame:CGRectMake(0, self.usernickname.frame.origin.y-5-10, kScreenWidth-16, self.usernickname.frame.size.height+5+8+10)];
    [self.backview insertSubview:self.labelbackview atIndex:1];
    [self.userhead.layer setCornerRadius:self.userhead.frame.size.width/2];
    
    self.titlelabel.numberOfLines = 0;
    
    
    //透明度渐变
    UIColor *colorOne = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.8];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.labelbackview.bounds;
    self.labelbackview.backgroundColor = [UIColor clearColor];
    [self.labelbackview.layer insertSublayer:headerLayer atIndex:0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
