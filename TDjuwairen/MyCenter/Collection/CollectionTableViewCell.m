//
//  CollectionTableViewCell.m
//  TDjuwairen
//
//  Created by tuanda on 16/6/1.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIdaynightModel.h"

@interface CollectionTableViewCell ()
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@end
@implementation CollectionTableViewCell

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
    self.titleLabel.text=dic[@"sharp_title"];
    self.nicknameLabel.text=dic[@"user_nickname"];
    
    NSString*head=dic[@"userinfo_facesmall"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:nil];
    
    
    NSString*sharp=dic[@"sharp_pic280"];
    NSArray*arr=[sharp pathComponents];
    NSString*imageName=[arr objectAtIndex:[arr count]-1];
    
    NSString*rootPath=NSHomeDirectory();
    NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",rootPath,imageName];
    
    //如果图片存在，那么直接获取到图片
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        UIImage *image = [UIImage imageNamed:path];
        self.sharpImageView.image = image;
        return;
    }
    else
    {
        //如果不存在，那么使用多线程来下载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url1 = [NSURL URLWithString:sharp];
            NSData *data = [NSData dataWithContentsOfURL:url1];
            UIImage *img = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.sharpImageView.image = img;
                //保存到本地
                // NSLog(@"%@",url1);
                [data writeToFile:path atomically:YES];
            });
        });
    }
}
@end
