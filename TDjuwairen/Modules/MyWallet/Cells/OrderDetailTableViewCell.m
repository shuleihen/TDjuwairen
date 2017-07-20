//
//  OrderDetailTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 2016/11/22.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define redTextColor [HXColor hx_colorWithHexRGBAString:@"#E83C3D"]

#define yelloTextColor [HXColor hx_colorWithHexRGBAString:@"#F2BA2C"]

#import "OrderDetailTableViewCell.h"
#import "Masonry.h"
#import "NSString+Ext.h"
#import "HexColors.h"

@interface OrderDetailTableViewCell ()

@end

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor = [UIColor whiteColor];
        
        self.IDLab = [[UILabel alloc] init];
        self.IDLab.font = [UIFont boldSystemFontOfSize:12];
        self.IDLab.textColor = TDTitleTextColor;
        
        self.orderID = [[UILabel alloc] init];
        self.orderID.font = [UIFont boldSystemFontOfSize:12];
        self.orderID.textColor = TDTitleTextColor;
        
        self.orderStatus = [[UILabel alloc] init];
        self.orderStatus.font = [UIFont systemFontOfSize:14];
        self.orderStatus.textAlignment = NSTextAlignmentRight;
        
        self.line1 = [[UILabel alloc] init];
        self.line1.layer.borderColor = TDSeparatorColor.CGColor;
        self.line1.layer.borderWidth = 1;
        
        self.orderTitle = [[UILabel alloc] init];
        self.orderTitle.font = [UIFont systemFontOfSize:18];
        self.orderTitle.textColor = TDTitleTextColor;
        
        self.timeLab = [[UILabel alloc] init];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textColor = TDTitleTextColor;
        
        self.orderTime = [[UILabel alloc] init];
        self.orderTime.font = [UIFont systemFontOfSize:14];
        self.orderTime.textColor = TDTitleTextColor;
        
        self.moneyImg = [[UIImageView alloc] init];
        
        self.moneyImg.contentMode = UIViewContentModeScaleAspectFit;
        
        self.orderMoney = [[UILabel alloc] init];
        self.orderMoney.font = [UIFont systemFontOfSize:14];
        
        self.line2 = [[UILabel alloc] init];
        self.line2.layer.borderColor = TDSeparatorColor.CGColor;
        self.line2.layer.borderWidth = 1;
        
        self.cleanBtn = [[UIButton alloc] init];
        self.cleanBtn.layer.borderWidth = 1;
        self.cleanBtn.layer.borderColor = TDSeparatorColor.CGColor;
        self.cleanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.cleanBtn setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
        [self.cleanBtn addTarget:self action:@selector(clickDeleteOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backView];
        [self addSubview:self.IDLab];
        [self addSubview:self.orderID];
        [self addSubview:self.orderStatus];
        [self addSubview:self.line1];
        [self addSubview:self.orderTitle];
        [self addSubview:self.timeLab];
        [self addSubview:self.orderTime];
        [self addSubview:self.moneyImg];
        [self addSubview:self.orderMoney];
        [self addSubview:self.line2];
        [self addSubview:self.cleanBtn];
    }
    return self;
}

- (void)setupUIWithString:(NSString *)num andIndexPath:(NSIndexPath *)indexPath{
    NSString *amount = num;
    CGSize moneySize = CGSizeMake(100, 20);
    moneySize = [amount calculateSize:moneySize font:[UIFont systemFontOfSize:14]];
    self.orderMoney.text = amount;
    
    [self.orderID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).with.offset(0);
        make.left.equalTo(self.IDLab.mas_right).with.offset(5);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(35);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(-10);
        make.right.equalTo(self).with.offset(0);
    }];
    
    [self.IDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).with.offset(0);
        make.left.equalTo(self.backView).with.offset(15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
    }];
    
    [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).with.offset(0);
        make.right.equalTo(self.backView).with.offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).with.offset(35);
        make.left.equalTo(self.backView).with.offset(15);
        make.right.equalTo(self.backView).with.offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    [self.orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).with.offset(15);
        make.left.equalTo(self.backView).with.offset(15);
        make.right.equalTo(self.backView).with.offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTitle.mas_bottom).with.offset(15);
        make.left.equalTo(self.backView).with.offset(15);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(20);
    }];
    
    [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTitle.mas_bottom).with.offset(15);
        make.left.equalTo(self.timeLab.mas_right).with.offset(5);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(20);
    }];
    
    [self.orderMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTitle.mas_bottom).with.offset(15);
        make.right.equalTo(self.backView).with.offset(-15);
        make.width.mas_equalTo(moneySize.width);
        make.height.mas_equalTo(20);
    }];
    
    [self.moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderMoney);
        make.right.equalTo(self.orderMoney.mas_left).with.offset(-5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).with.offset(15);
        make.left.equalTo(self.backView).with.offset(15);
        make.right.equalTo(self.backView).with.offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    [self.cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).with.offset(5);
        make.right.equalTo(self.backView).with.offset(-15);
        make.bottom.equalTo(self.backView).with.offset(-10);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(30);
    }];
}

- (void)clickDeleteOrder:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickDeleteCell:)]) {
        [self.delegate clickDeleteCell:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
