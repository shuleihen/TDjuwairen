//
//  FeedbackTableViewCell.m
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LoginState.h"

@interface FeedbackTableViewCell ()
@property (nonatomic,strong) LoginState *loginState;
@end
@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)cellforDic:(NSDictionary *)dic
{
    self.loginState = [LoginState addInstance];
    self.timeLabel.text=[self setLabelsTime:[dic[@"feedback_time"]integerValue]];
    self.contentLabel.text=dic[@"feedback_content"];
    //加载头像
    NSString *imagePath = [NSString stringWithFormat:@"%@",self.loginState.headImage];
    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:SDWebImageRefreshCached];
}

-(NSString*)setLabelsTime:(NSInteger)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * tempday = [[NSDateFormatter alloc] init];
    NSDateFormatter * tempYear = [[NSDateFormatter alloc] init];
    NSInteger timeNow = [[self currentTime] integerValue];
    
    [tempday setDateFormat:@"dd"];
    [tempYear setDateFormat:@"YYYY"];
    
    NSInteger minute=(timeNow-time)/60;
    
    if (0<=minute&&minute<=5) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    
    else if (5<minute&&minute<=60) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }
    
    else if ([[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] isEqualToString:[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]]){
        [formatter setDateFormat:@"HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        return [NSString stringWithFormat:@"今天 %@",[formatter stringFromDate:date]];
    }
    
    else if ([[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] intValue]-[[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]intValue ]==1) {
        [formatter setDateFormat:@"HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        return [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:date]];
    }
    
    else if ([[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] intValue]-[[tempday stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]intValue ]!=1 && [[tempYear stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]] isEqualToString:[tempYear stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]]) {
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }
    
    else{
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }
    
    
}

-(NSString*)currentTime{
    NSDateFormatter *commentTime = [[NSDateFormatter alloc] init];
    [commentTime setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
    NSDate *tempDate = [NSDate date];
    NSString *date = [NSString stringWithFormat:@"%ld",(long)[tempDate timeIntervalSince1970]];
    return date;
}

-(void)setContentText:(NSString *)text
{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.contentLabel.text = text;
    //设置label的最大行数
    self.contentLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(150, 1000);

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
    CGSize labelSize = [self.contentLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    
    //计算出自适应的高度
    frame.size.height = labelSize.height+50;
    
    self.frame = frame;
}
@end
