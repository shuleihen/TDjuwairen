//
//  ResponsListTableViewCell.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ResponsListTableViewCell.h"
#import "NSString+Ext.h"
#import "UIImageView+WebCache.h"

@interface ResponsListTableViewCell ()
{
    CGSize contentsize;
}
@end
@implementation ResponsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArr:(NSDictionary *)dic
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *arr = dic[@"ResponsList"];
        self.viewheight = 0;
        for ( int i = 0; i <= arr.count; i++) {
            
            if (i == arr.count) {
                UIView *view = [[UIView alloc]init];
                
                UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-15-45, 10, 45, 45)];
                [head sd_setImageWithURL:[NSURL URLWithString:self.loginState.headImage]];
                UILabel *content = [[UILabel alloc]init];
                
                NSString *text = dic[@"feedback_content"];
                UIFont *font = [UIFont systemFontOfSize:16];
                content.font = font;
                content.numberOfLines = 0;
                contentsize = CGSizeMake(kScreenWidth/3*2, 20000.0f);
                contentsize = [text calculateSize:contentsize font:font];
                content.text = text;
                content.frame = CGRectMake(kScreenWidth-15-45-kScreenWidth/3*2, 10, kScreenWidth/3*2, contentsize.height);
                content.textAlignment = NSTextAlignmentRight;
                
                UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-15-45-kScreenWidth/3*2, 10+contentsize.height+10, kScreenWidth/3*2, 14)];
                timeLab.textAlignment = NSTextAlignmentRight;
                
                NSString *str = dic[@"feedback_time"];
                NSTimeInterval time = [str doubleValue];
                NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeLab.text = [dateFormatter stringFromDate:detaildate];
                
                view.frame = CGRectMake(0, self.viewheight, kScreenWidth, 10+contentsize.height+8+14+10);
                
                self.viewheight = self.viewheight + 10+contentsize.height+8+14+10;
                
                [view addSubview:head];
                [view addSubview:content];
                [view addSubview:timeLab];
                
                [self addSubview:view];
            }
            else
            {
                NSDictionary *dic = arr[i];
                
                UIView *view = [[UIView alloc]init];
                
                UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
                [head sd_setImageWithURL:[NSURL URLWithString:@"http://static.juwairen.net/Pc/Static/Default/Images/facesmall.png"]];
                UILabel *content = [[UILabel alloc]init];
                
                NSString *text = dic[@"response_content"];
                UIFont *font = [UIFont systemFontOfSize:16];
                content.font = font;
                content.numberOfLines = 0;
                contentsize = CGSizeMake(kScreenWidth/3*2-15-45, 20000.0f);
                contentsize = [text calculateSize:contentsize font:font];
                content.text = text;
                content.frame = CGRectMake(15+45, 10, kScreenWidth/3*2, contentsize.height);
                
                UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(15+45, 10+contentsize.height+10, kScreenWidth/3*2, 14)];
                NSString *str = dic[@"view_addtime"];
                NSTimeInterval time = [str doubleValue];
                NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                timeLab.text = [dateFormatter stringFromDate:detaildate];
                
                view.frame = CGRectMake(0, self.viewheight, kScreenWidth, 10+contentsize.height+8+14+10);
                
                self.viewheight = self.viewheight + 10+contentsize.height+8+14+10;
                
                [view addSubview:head];
                [view addSubview:content];
                [view addSubview:timeLab];
                
                [self addSubview:view];
            }
            
        }
        
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
