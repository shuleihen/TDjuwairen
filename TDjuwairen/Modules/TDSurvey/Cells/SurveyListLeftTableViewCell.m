//
//  SurveyListLeftTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/3.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "SurveyListLeftTableViewCell.h"

#import "Masonry.h"
#import "NSString+Ext.h"

@implementation SurveyListLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgView = [[UIView alloc] init];
        
        self.stockName = [[UILabel alloc] init];
        self.stockName.font = [UIFont systemFontOfSize:20];
        
        self.nowPri = [[UILabel alloc] init];
        self.nowPri.font = [UIFont boldSystemFontOfSize:24];
        
        self.increPer = [[UILabel alloc] init];
        self.increPer.font = [UIFont systemFontOfSize:13];
        
        self.increase = [[UILabel alloc] init];
        self.increase.font = [UIFont systemFontOfSize:13];
        
        self.stockImg = [[UIImageView alloc] init];
        self.stockImg.image = [UIImage imageNamed:@"NotLogin.png"];
        
        self.line = [[UILabel alloc] init];
        self.line.layer.borderWidth = 1;
        self.line.layer.borderColor = [UIColor redColor].CGColor;
        
        self.stockSurvey = [[UILabel alloc] init];
        self.stockSurvey.numberOfLines = 0;
        self.stockSurvey.text = @"调研:  金圆股份拟募资13亿元 进入固体废弃物治理行业";
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.stockSurvey.text];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] range:NSMakeRange(0, 3)];
        self.stockSurvey.attributedText = att;
        UIFont *font = [UIFont systemFontOfSize:16];
        self.stockSurvey.font = font;
        CGSize titleSize = CGSizeMake(kScreenWidth-30, 500.0);
        titleSize = [self.stockSurvey.text calculateSize:titleSize font:font];
        
        [self addSubview:self.bgView];
        [self addSubview:self.stockName];
        [self addSubview:self.nowPri];
        [self addSubview:self.increPer];
        [self addSubview:self.increase];
        [self addSubview:self.stockImg];
        [self addSubview:self.line];
        [self addSubview:self.stockSurvey];
        
        [self.bgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(-15);
        }];
        
        [self.stockImg makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).with.offset(15);
            make.left.equalTo(self.bgView).with.offset(15);
            make.width.equalTo(100);
            make.height.equalTo(70);
        }];
        
        [self.stockName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).with.offset(15);
            make.left.equalTo(self.stockImg).with.offset(15+100);
            make.width.equalTo(kScreenWidth-30-100-15);
            make.height.equalTo(30);
        }];
        
        [self.nowPri makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockName).with.offset(8+30);
            make.left.equalTo(self.stockImg).with.offset(15+100);
            make.width.equalTo(60);
            make.height.equalTo(30);
        }];
        
        [self.increPer makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockName).with.offset(8+40);
            make.left.equalTo(self.nowPri).with.offset(15+60);
            make.width.equalTo(60);
            make.height.equalTo(15);
        }];
        
        [self.increase makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockName).with.offset(8+40);
            make.left.equalTo(self.increPer).with.offset(15+60);
            make.width.equalTo(60);
            make.height.equalTo(15);
        }];
        
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockImg).with.offset(70+15);
            make.left.equalTo(self.bgView).with.offset(15);
            make.right.equalTo(self.bgView).with.offset(-15);
            make.height.equalTo(1);
        }];
        
        [self.stockSurvey makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line).with.offset(15);
            make.left.equalTo(self.bgView).with.offset(15);
            make.right.equalTo(self.bgView).with.offset(-15);
            make.bottom.equalTo(self.bgView).with.offset(-10);
            make.height.equalTo(titleSize.height);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
