//
//  AliveListHotTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/19.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListHotTableViewCell.h"
#import "SurveyHandler.h"

@implementation AliveListHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupAliveModel:(AliveListModel *)model {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.aliveTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]}];
    AliveListExtra *extra = model.extra;
    
    UIImage *image = [SurveyHandler imageWithSurveyType:extra.surveyType];
    if (image) {
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(2, -2, 17, 17);
        attatch.image = image;
        
        NSAttributedString *video = [NSAttributedString attributedStringWithAttachment:attatch];
        [attri appendAttributedString:video];
    }
    
    if (!extra.isUnlock) {
        NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        attatch.bounds = CGRectMake(5, 0, 10, 12);
        attatch.image = [UIImage imageNamed:@"ico_lock.png"];
        
        NSAttributedString *lock = [NSAttributedString attributedStringWithAttachment:attatch];
        [attri appendAttributedString:lock];
    }
    
    CGSize size = [attri boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.titleHeight.constant = size.height+2;
    self.titleLabel.attributedText = attri;
    
    self.contentLabel.text = extra.surveyDesc;
    
    NSString *stock = [NSString stringWithFormat:@"%@(%@)",extra.companyName,extra.companyCode];
    CGSize stockSize = [stock boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil].size;
    self.stockNameWidth.constant = stockSize.width+6;
    self.stockNameLabel.text = stock;
    
    self.dateTimeLabel.text = model.aliveTime;
}
@end