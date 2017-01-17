//
//  GradeHeanderView.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeHeaderView.h"
#import "GradeView.h"

@implementation GradeHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"bg_grade.png"];
        [self addSubview:imageView];
        
        _gradeView = [[GradeView alloc] initWithFrame:CGRectMake(0, 0, 164, 164)];
        _gradeView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_gradeView];
        
        _stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 20, 200, 20)];
        _stockNameLabel.textAlignment = NSTextAlignmentCenter;
        _stockNameLabel.font = [UIFont systemFontOfSize:14.0f];
        _stockNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stockNameLabel];
        
        _stockIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 40, 200, 20)];
        _stockIdLabel.textAlignment = NSTextAlignmentCenter;
        _stockIdLabel.font = [UIFont systemFontOfSize:12.0f];
        _stockIdLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stockIdLabel];
    }
    return self;
}

- (void)setupGradeModel:(GradeDetailModel *)model {
    self.stockNameLabel.text = model.stockName;
    self.stockIdLabel.text = [NSString stringWithFormat:@"(%@)",model.stockId];
    
    NSMutableArray *grades = [NSMutableArray arrayWithCapacity:[model.itemGrades count]];
    for (GradeItem *item in model.itemGrades) {
        [grades addObject:item.score];
    }
    self.gradeView.grades = grades;
}
@end
