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
    
    self.articleView.backgroundColor = [UIColor clearColor];
    self.articleView.titleColor = [UIColor hx_colorWithHexRGBAString:@"#9F9FA1"];
    self.articleView.titleFont = [UIFont systemFontOfSize:13.0f];
    self.articleView.scrollTimeInterval = 5;
    self.articleView.delegate = self;
}

- (void)setModel:(PSIndividualListModel *)model {
    _model = model;
    
    self.label_title.text = [NSString stringWithFormat:@"%@(%@)",model.stockName,model.stockCode];
    self.label_money.text = [NSString stringWithFormat:@"%@把钥匙",model.guess_key_num];
    
    NSString *join = [NSString stringWithFormat:@"参与人数 %ld",(long)model.guess_item_num];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:join attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [attr setAttributes:@{NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#666666"]} range:NSMakeRange(0, 4)];
    self.label_enjoy.attributedText = attr;
    
    // 文章类型，0表示没有，1表示调研，2表示热点，3表示观点，4表示直播
    self.articleView.titles = model.artileTimeArray;
    
    self.button_guess.enabled = [self joinButtonEnabled];
    [self.button_guess setTitle:[self joinButtonTitle] forState:UIControlStateNormal];
    self.rewardView.hidden = !model.isReward;
}

- (void)setupStock:(StockInfo *)stock {
    if (![stock enabled]) {
        NSString *string = [NSString stringWithFormat:@"--"];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#999999"]}
                      range:NSMakeRange(0, string.length)];
        
        self.label_left.attributedText = attr;
        self.label_mid.text = @"";
        self.label_right.text = @"";
    } else {
        float value = [stock priValue];            //跌涨额
        float valueB = [stock priPercentValue];     //跌涨百分比
        
        if (value >= 0.00) {
            self.label_left.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF0000"];
            self.label_mid.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF0000"];
            self.label_right.textColor = [UIColor hx_colorWithHexRGBAString:@"#FF0000"];
            
        } else {
            self.label_left.textColor = [UIColor hx_colorWithHexRGBAString:@"#14C76A"];
            self.label_mid.textColor = [UIColor hx_colorWithHexRGBAString:@"#14C76A"];
            self.label_right.textColor = [UIColor hx_colorWithHexRGBAString:@"#14C76A"];
        }
        
        NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
        
        self.label_left.text = nowPriString;
        self.label_mid.text = [NSString stringWithFormat:@"%+.2lf",value];
        self.label_right.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
    }
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


- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(playIndividualCell:articlePressedWithIndex:)]) {
        [self.delegate playIndividualCell:self articlePressedWithIndex:index];
    }
}

- (BOOL)joinButtonEnabled {
    return (self.model.status == kPSGuessExecuting);
}

- (NSString *)joinButtonTitle {
    if (self.model.status == kPSGuessExecuting) {
        return @"参与竞猜";
    }else if (self.model.status == kPSGuessStop){
        return @"已封盘";
    } else return @"已结束";
}

@end
