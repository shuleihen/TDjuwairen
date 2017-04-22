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
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        imageView.image = [UIImage imageNamed:@"bg_grade.png"];
        [self addSubview:_imageView];
        
        _gradeView = [[GradeView alloc] initWithFrame:CGRectMake(0, 0, 164, 164)];
        _gradeView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_gradeView];
        
        _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _gradeLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        _gradeLabel.textColor = [UIColor whiteColor];
        _gradeLabel.textAlignment = NSTextAlignmentCenter;
        _gradeLabel.center = _gradeView.center;
        [self addSubview:_gradeLabel];
        
        _stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 20, 60, 20)];
        _stockNameLabel.textAlignment = NSTextAlignmentCenter;
        _stockNameLabel.font = [UIFont systemFontOfSize:14.0f];
        _stockNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stockNameLabel];
        
        _stockIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 40, 60, 20)];
        _stockIdLabel.textAlignment = NSTextAlignmentCenter;
        _stockIdLabel.font = [UIFont systemFontOfSize:12.0f];
        _stockIdLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stockIdLabel];
    }
    return self;
}

- (void)setupGradeModel:(GradeDetailModel *)model {
    
    NSString *imageName;
    if (model.totalGrade < 50) {
        imageName = @"bg_grade1.png";
    } else if (model.totalGrade >= 50 &&
               model.totalGrade < 80) {
        imageName = @"bg_grade2.png";
    } else {
        imageName = @"bg_grade3.png";
    }
    self.imageView.image = [[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    CGSize size = [model.stockName boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.stockNameLabel.font} context:nil].size;
    
    CGSize stockIdSize = [model.stockId boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.stockIdLabel.font} context:nil].size;
    
    CGFloat labelWidth = MAX(stockIdSize.width, size.width);
    self.stockNameLabel.frame = CGRectMake(25, 20, labelWidth+3, 20);
    self.stockIdLabel.frame = CGRectMake(25, 40, labelWidth+3, 20);
    
    self.stockNameLabel.text = model.stockName;
    self.stockIdLabel.text = model.stockId;
    
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld",(long)model.totalGrade];
    
    NSMutableArray *grades = [NSMutableArray arrayWithCapacity:[model.itemGrades count]];
    for (GradeItem *item in model.itemGrades) {
        [grades addObject:item.score];
    }
    self.gradeView.grades = grades;
}
@end
