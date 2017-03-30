//
//  MyGuessCell.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "MyGuessCell.h"
#import "HexColors.h"


@implementation MyGuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setupGuessInfo:(MyGuessModel *)guess {
    self.guessNameLabel.text = guess.stockName;
    self.dateLabel.text = guess.addTime;
//    self.sessionLabel.text = guess.seasonString;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSDate *d = [df dateFromString:guess.addTime];
    [df setDateFormat:@"M月dd日"];
    self.sessionLabel.text = [NSString stringWithFormat:@"%@%@",[df stringFromDate:d],guess.seasonString];
    
    self.guessIndexLabel.text = [NSString stringWithFormat:@"%.02f",guess.buyPri];
    
    if (guess.isClosed) {
        self.realIndexLabel.text = [NSString stringWithFormat:@"%.02f",guess.endPri];
    } else {
        self.realIndexLabel.text = @"--";
    }
    
    NSString *key = [NSString stringWithFormat:@"x %ld",(long)guess.buyKeyNum];
    [self.betBtn setTitle:key forState:UIControlStateNormal];
    [self.betBtn setTitle:key forState:UIControlStateHighlighted];
    
    self.prizeBtn.hidden = YES;//!(guess.status == 1);
    
    if (guess.status == 0) {
        // 待结算
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:@" 待开奖"
                                                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#ff0000"]}];
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(0, -3, 17, 17);
        attatch.image = [UIImage imageNamed:@"icon_waiting.png"];
        
        NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
        [strAtt insertAttributedString:wait atIndex:0];
        self.statusLabel.attributedText = strAtt;
        
    } /*else if (guess.status == 1) {
        // 完全猜中
        NSString *str = [NSString stringWithFormat:@"赢取%ld把钥匙 + 1500", (long)(guess.odds*guess.buyKeyNum),(long)guess.buyKeyNum];
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str
                                                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#ff0000"]}];
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(0, -4, 19, 22);
        attatch.image = [UIImage imageNamed:@"icon_key_small.png"];
        
        NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
        NSRange range = [str rangeOfString:@"钥匙"];
        if (range.location != NSNotFound) {
            [strAtt replaceCharactersInRange:range withAttributedString:wait];
        }
        self.statusLabel.attributedText = strAtt;
        
    }*/ else if (guess.status == 1 ||
               guess.status == 2) {
        // 获胜钥匙
        NSString *str = [NSString stringWithFormat:@"恭喜您，赢取%ld把",(long)(guess.odds*guess.buyKeyNum)];
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str
                                                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#ff0000"]}];
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(0, -5, 19, 22);
        attatch.image = [UIImage imageNamed:@"icon_key_small.png"];
        
        NSAttributedString *wait = [NSAttributedString attributedStringWithAttachment:attatch];
        [strAtt appendAttributedString:wait];
        self.statusLabel.attributedText = strAtt;
        
    } else if (guess.status == 3 ||
               guess.status == 4) {
        // 3表示失败 4表示平局
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:guess.statusString
                                                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}];
        self.statusLabel.attributedText = strAtt;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[event.allTouches anyObject] locationInView:self.contentView];
    BOOL contain = CGRectContainsPoint(self.prizeBtn.frame, point);
    
    if (contain) {
        [super touchesBegan:touches withEvent:event];
    }
}
@end
