//
//  GradeListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeListCell.h"

@implementation GradeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupGradeListModel:(GradeListModel *)assessed {
    if (assessed.sortNumber == 1) {
        self.sortNumberImageView.image = [UIImage imageNamed:@"gold_medal.png"];
    } else if (assessed.sortNumber == 2) {
        self.sortNumberImageView.image = [UIImage imageNamed:@"silver_medal.png"];
    } else if (assessed.sortNumber == 3) {
        self.sortNumberImageView.image = [UIImage imageNamed:@"bronze_medal.png"];
    }
    
    self.sortNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)assessed.sortNumber];
    
    BOOL showSortImage = (assessed.sortNumber > 3);
    self.sortNumberImageView.hidden = showSortImage;
    self.sortNumberLabel.hidden = !showSortImage;
    
    self.nameLabel.text = assessed.stockName;
    self.gradeLabel.text =  [NSString stringWithFormat:@"%.0lf分",assessed.grade];
    
    if (assessed.type == 1) {
        self.typeImageView.image = [UIImage imageNamed:@"ranking_drop.png"];
    } else if (assessed.type == 2) {
        self.typeImageView.image = [UIImage imageNamed:@"ranking_rise.png"];
    } else {
        self.typeImageView.image = nil;
    }
    
}
@end
