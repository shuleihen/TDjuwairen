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
{
    __weak IBOutlet UILabel *label_title;
    __weak IBOutlet UILabel *label_left;
    __weak IBOutlet UILabel *label_mid;
    __weak IBOutlet UILabel *label_right;
    __weak IBOutlet UILabel *label_enjoy;
    __weak IBOutlet UILabel *label_detailTitle;
    __weak IBOutlet UILabel *label_detailDesc;
    __weak IBOutlet UILabel *label_money;
    __weak IBOutlet UIButton *button_guess;
    __weak IBOutlet UIButton *enjoyBtn;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [enjoyBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -20, -10, -20)];
    label_money.userInteractionEnabled = YES;
    UITapGestureRecognizer *money_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyClick)];
    [label_money addGestureRecognizer:money_Tap];

}
+ (instancetype)loadCell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"PlayIndividualContentCell" owner:self options:nil] lastObject];
}

- (void)setModel:(PlayListModel *)model
{
    /**
     文章类型，0表示没有，1表示调研，2表示热点，3表示观点，4表示直播
     */
    _model = model;
    label_title.text = [NSString stringWithFormat:@"%@(%@)",model.guess_company,model.com_code];
    label_enjoy.text = [NSString stringWithFormat:@"%@",model.guess_item_num];
    label_detailDesc.text = SafeValue(model.artile_info[@"article_title"]);
    label_money.text = [NSString stringWithFormat:@"%@把",model.guess_key_num];
    
    if ([model.artile_info[@"article_type"] isEqual:@1]) {
        label_detailTitle.text = @"调研";
    }else if ([model.artile_info[@"article_type"] isEqual:@2]) {
        label_detailTitle.text = @"热点";
    }else if ([model.artile_info[@"article_type"] isEqual:@3]) {
        label_detailTitle.text = @"观点";
    }else if ([model.artile_info[@"article_type"] isEqual:@4]) {
        label_detailTitle.text = @"直播";
    }else{
        label_detailTitle.text = @"";
    }
    
    button_guess.enabled = [self joinButtonEnabled];
    [button_guess setTitle:[self joinButtonTitle] forState:UIControlStateNormal];
}

- (void)setupStock:(StockInfo *)stock {
    float value = [stock priValue];            //跌涨额
    float valueB = [stock priPercentValue];     //跌涨百分比
    
    if (value >= 0.00) {
        label_left.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        label_mid.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        label_right.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        
    } else {
        label_left.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        label_mid.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
        label_right.textColor = [UIColor hx_colorWithHexRGBAString:@"#1fcc67"];
    }
    
    NSString *nowPriString = [NSString stringWithFormat:@"%.2lf",stock.nowPriValue];
    
    label_left.text = nowPriString;
    label_mid.text = [NSString stringWithFormat:@"%+.2lf",value];
    label_right.text = [NSString stringWithFormat:@"%+.2lf%%",valueB*100];
}

- (IBAction)enjoyClick:(id)sender {
    if (_enjoyBlock) {
        _enjoyBlock();
    }
}

- (IBAction)buttonClick:(id)sender {
    
    if (_guessBlock) {
        _guessBlock(sender);
    }
}


- (void)moneyClick
{
    if (_moneyBlock) {
        _moneyBlock();
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
