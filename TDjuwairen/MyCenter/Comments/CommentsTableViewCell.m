//
//  CommentsTableViewCell.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/2.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithDic:(NSDictionary *)dic
{
    NSString*head=dic[@"userinfo_facesmall"];
    [self.headImageView setImageWithURL:[NSURL URLWithString:head] placeholderImage:nil];
    
    self.nicknameLabel.text=dic[@"user_nickname"];
    self.timeLabel.text=[self setLabelsTime:[dic[@"sharpcomment_ptime"] integerValue]];
    self.commentsLabel.text=dic[@"sharpcomment_text"];
    
    NSString*sharp=dic[@"sharp_pic280"];
    [self.sharpImageView setImageWithURL:[NSURL URLWithString:sharp] placeholderImage:nil];
    
    self.titleLabel.text=dic[@"sharp_title"];
}

-(NSString*)setLabelsTime:(NSInteger)time{
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    NSDateFormatter* tempday = [[NSDateFormatter alloc] init];
    NSDateFormatter* tempYear = [[NSDateFormatter alloc] init];
    NSInteger timeNow=[[self currentTime] integerValue];
    
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
    NSDateFormatter *commentTime=[[NSDateFormatter alloc] init];
    [commentTime setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
    NSDate *tempDate=[NSDate date];
    NSString *date=[NSString stringWithFormat:@"%ld",(long)[tempDate timeIntervalSince1970]];
    return date;
}
@end
