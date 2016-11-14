//
//  AskQuestionTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/14.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "AskQuestionTableViewCell.h"
#import "Masonry.h"

@implementation AskQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"提问：";
        self.askBtn = [[UIButton alloc] init];
        [self.askBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [self.askBtn setImage:[UIImage imageNamed:@"comment_blue"] forState:UIControlStateHighlighted];
        self.askBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.askBtn setTitle:@" 回答" forState:UIControlStateNormal];
        [self.askBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.askBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self addSubview:self.askBtn];
        
        [self.askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.right.equalTo(self).with.offset(-15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
