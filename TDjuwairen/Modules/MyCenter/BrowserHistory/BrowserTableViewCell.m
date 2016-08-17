//
//  BrowserTableViewCell.m
//  juwairen
//
//  Created by tuanda on 16/5/27.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import "BrowserTableViewCell.h"
#import "UIdaynightModel.h"

@interface BrowserTableViewCell ()

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@end
@implementation BrowserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.line.layer.borderColor = self.daynightmodel.backColor.CGColor;
    self.line.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.SelectImageView.image=[UIImage imageNamed:@"选中"];
    }
    else
    {
        self.SelectImageView.image=[UIImage imageNamed:@"未选中"];
    }
}

-(void)setCellWithDic:(NSDictionary *)dic
{
    self.timeLabel.text=[NSString stringWithFormat:@"%@浏览",[self setLabelsTime:[dic[@"history_item_time"]integerValue]]];
    
    self.SharpTitle.text=dic[@"sharp_title"];
    
    //加载头像
    NSString*url=dic[@"sharp_pic280"];
    NSArray*arr=[url pathComponents];
    NSString*imageName=[arr objectAtIndex:[arr count]-1];
    NSString*rootPath=NSHomeDirectory();
    NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",rootPath,imageName];
    
    //如果图片存在，那么直接获取到图片
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        UIImage *image = [UIImage imageNamed:path];
        self.SharpImage.image = image;
        return;
    }
    else
    {
    //如果不存在，那么使用多线程来下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url1 = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:url1];
        UIImage *img = [UIImage imageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.SharpImage.image = img;
            //保存到本地
            // NSLog(@"%@",url1);
            [data writeToFile:path atomically:YES];
        });
    });
    }

    
    
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
