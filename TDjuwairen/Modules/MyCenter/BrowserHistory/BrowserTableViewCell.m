//
//  BrowserTableViewCell.m
//  juwairen
//
//  Created by tuanda on 16/5/27.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "BrowserTableViewCell.h"
#import "UIdaynightModel.h"
#import "UIImageView+WebCache.h"

@interface BrowserTableViewCell ()
@end

@implementation BrowserTableViewCell

-(void)setCellWithDic:(NSDictionary *)dic
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@浏览",[self setLabelsTime:[dic[@"history_item_time"]integerValue]]];
    self.SharpTitle.text = dic[@"sharp_title"];
    
    NSString*url=dic[@"sharp_pic280"];
    [self.SharpImage sd_setImageWithURL:[NSURL URLWithString:url]];
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
