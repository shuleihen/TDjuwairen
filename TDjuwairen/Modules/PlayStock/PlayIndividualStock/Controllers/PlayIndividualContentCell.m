//
//  PlayIndividualContentCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayIndividualContentCell.h"
#import "StockManager.h"
#import "UIButton+Align.h"
@implementation PlayIndividualContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.enjoyBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -20, -10, -20)];
    
    self.label_detailDesc.userInteractionEnabled = YES;
    UITapGestureRecognizer *money_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(surveyClick:)];
    [self.label_detailDesc addGestureRecognizer:money_Tap];
}

- (void)setModel:(PSIndividualListModel *)model
{
    /**
     文章类型，0表示没有，1表示调研，2表示热点，3表示观点，4表示直播
     */
    _model = model;
    
    self.label_title.text = [NSString stringWithFormat:@"%@(%@)",model.guess_company,model.com_code];
    self.label_enjoy.text = [NSString stringWithFormat:@"%ld",(long)model.guess_item_num];
    self.label_detailDesc.text = SafeValue(model.artile_info[@"article_title"]);
    self.label_money.text = [NSString stringWithFormat:@"%@把",model.guess_key_num];
    
    if ([model.artile_info[@"article_type"] isEqual:@1]) {
        self.label_detailTitle.text = @"调研";
    }else if ([model.artile_info[@"article_type"] isEqual:@2]) {
        self.label_detailTitle.text = @"热点";
    }else if ([model.artile_info[@"article_type"] isEqual:@3]) {
        self.label_detailTitle.text = @"观点";
    }else if ([model.artile_info[@"article_type"] isEqual:@4]) {
        self.label_detailTitle.text = @"直播";
    }else{
        self.label_detailTitle.text = @"";
    }
    
    self.button_guess.enabled = [self joinButtonEnabled];
    [self.button_guess setTitle:[self joinButtonTitle] forState:UIControlStateNormal];
}

- (void)setupStock:(StockInfo *)stock {
    float value = [stock priValue];            //跌涨额
    float valueB = [stock priPercentValue];     //跌涨百分比
    
    if (value >= 0.00) {
        self.label_left.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        self.label_mid.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        self.label_right.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        
    } else {
        self.label_left.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        self.label_mid.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        self.label_right.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
    }
    
    NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
    
    self.label_left.text = nowPriString;
    self.label_mid.text = [NSString stringWithFormat:@"%+.2lf",value];
    self.label_right.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
}

- (IBAction)enjoyListClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(playIndividualCell:enjoyListPressed:)]) {
        [self.delegate playIndividualCell:self enjoyListPressed:sender];
    }
}

- (IBAction)guessClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(playIndividualCell:guessPressed:)]) {
        [self.delegate playIndividualCell:self guessPressed:sender];
    }
}

- (void)surveyClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(playIndividualCell:surveyPressed:)]) {
        [self.delegate playIndividualCell:self surveyPressed:sender];
    }
}

- (BOOL)joinButtonEnabled {
    if (self.model.has_join) {
        return NO;
    } else {
        return ([self.model.guess_status intValue] == 0);
    }
}

- (NSString *)joinButtonTitle {
    if (self.model.has_join) {
        return @"已参与";
    } else {
        if ([self.model.guess_status isEqual:@0]) {
            return @"参与竞猜";
        }else if ([self.model.guess_status isEqual:@1]){
            return @"已封盘";
        }return @"已结束";
    }
}

@end
