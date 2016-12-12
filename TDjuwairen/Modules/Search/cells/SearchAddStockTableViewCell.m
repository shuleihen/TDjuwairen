//
//  SearchAddStockTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define font15 [UIFont systemFontOfSize:15]

#import "SearchAddStockTableViewCell.h"

@implementation SearchAddStockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.code = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 50)];
        self.code.font = font15;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 80, 50)];
        self.name.font = font15;
        
        self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-20, 15, 20, 20)];
        self.addBtn.contentMode = UIViewContentModeScaleAspectFit;
        [self.addBtn addTarget:self action:@selector(clickAddOptionalStock:) forControlEvents:UIControlEventTouchUpInside];
        
        self.line = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, 1)];
        self.line.layer.borderWidth = 1;
        
        [self addSubview:self.name];
        [self addSubview:self.code];
        [self addSubview:self.addBtn];
        [self addSubview:self.line];
        
        
    }
    return self;
}

- (void)setupWithModel:(SurveyListModel *)model
{
    self.code.text = model.survey_conpanycode;
    self.name.text = model.company_name;
    if (model.is_mystock) {
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"btn_quxiao"] forState:UIControlStateNormal];
    }
    else
    {
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    }
}

- (void)clickAddOptionalStock:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickAddOptionalStock:)]) {
        [self.delegate clickAddOptionalStock:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
