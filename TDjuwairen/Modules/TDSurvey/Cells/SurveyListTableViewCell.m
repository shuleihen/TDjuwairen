//
//  SurveyListTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "SurveyListTableViewCell.h"

#import "Masonry.h"
#import "NSString+Ext.h"

@implementation SurveyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgView = [[UIView alloc] init];
        
        self.stockName = [[UILabel alloc] init];
        self.stockName.text = @"武钢";
        self.stockName.font = [UIFont systemFontOfSize:20];
        
        self.stockDate1 = [[UILabel alloc] init];
        self.stockDate1.text = @"9.55";
        self.stockDate1.font = [UIFont boldSystemFontOfSize:24];
        
        self.stockDate2 = [[UILabel alloc] init];
        self.stockDate2.text = @"-0.42%";
        self.stockDate2.font = [UIFont systemFontOfSize:14];
        
        self.stockDate3 = [[UILabel alloc] init];
        self.stockDate3.text = @"-1.22";
        self.stockDate3.font = [UIFont systemFontOfSize:14];
        
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
        [self addSubview:self.stockDate1];
        [self addSubview:self.stockDate2];
        [self addSubview:self.stockDate3];
        [self addSubview:self.stockImg];
        [self addSubview:self.line];
        [self addSubview:self.stockSurvey];
        
        [self.bgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(-15);
        }];
        
        [self.stockName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).with.offset(15);
            make.left.equalTo(self.bgView).with.offset(15);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
        
        [self.stockDate1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockName).with.offset(8+30);
            make.left.equalTo(self.bgView).with.offset(15);
            make.width.equalTo(60);
            make.height.equalTo(30);
        }];
        
        [self.stockDate2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockName).with.offset(8+30);
            make.left.equalTo(self.stockDate1).with.offset(8+60);
            make.width.equalTo(60);
            make.height.equalTo(30);
        }];
        
        [self.stockDate3 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockName).with.offset(8+30);
            make.left.equalTo(self.stockDate2).with.offset(8+60);
            make.width.equalTo(60);
            make.height.equalTo(30);
        }];
        
        [self.stockImg makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).with.offset(15);
            make.right.equalTo(self.bgView).with.offset(-15);
            make.width.equalTo(100);
            make.height.equalTo(70);
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
