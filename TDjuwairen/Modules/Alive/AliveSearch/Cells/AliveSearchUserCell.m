//
//  AliveSearchUserCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchUserCell.h"
#import "AliveSearchResultModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Border.h"

@interface AliveSearchUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *uImageView;
@property (weak, nonatomic) IBOutlet UILabel *uNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *uAddAttentionButton;

@end

@implementation AliveSearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.uImageView cutCircular:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
+ (instancetype)loadAliveSearchUserCellWithTableView:(UITableView *)tableView {
    
    AliveSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveSearchUserCell"];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"AliveSearchUserCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUserModel:(AliveSearchResultModel *)userModel {
    _userModel = userModel;
    [self.uImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userIcon] placeholderImage:TDDefaultUserAvatar];
    if (userModel.searchTextStr.length > 0) {
        
        NSMutableArray *arrM = [self getRangeStr:userModel.userNickName findText:userModel.searchTextStr];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:userModel.userNickName];
        for (NSNumber *num in arrM) {
            NSRange rang = NSMakeRange([num integerValue], userModel.searchTextStr.length);
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] range:rang];
        }
        self.uNameLabel.attributedText = attri;
        
        
    }else {
        self.uNameLabel.text = userModel.userNickName;
    }
    
    
    if (userModel.isAttend == YES) {
        [self.uAddAttentionButton setTitleColor:TDThemeColor forState:UIControlStateNormal];
        [self.uAddAttentionButton cutCircularRadius:4 addBorder:1 borderColor:TDThemeColor];
        [self.uAddAttentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.uAddAttentionButton setBackgroundColor:[UIColor whiteColor]];
    }else {
        [self.uAddAttentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.uAddAttentionButton cutCircularRadius:4 addBorder:0 borderColor:[UIColor clearColor]];
        [self.uAddAttentionButton setTitle:@"加关注" forState:UIControlStateNormal];
        [self.uAddAttentionButton setBackgroundColor:TDThemeColor];
    }
    
    
}

/// 添加关注
- (IBAction)addAttentionBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addAttendWithAliveSearchResultModel: andCellIndex:)]) {
        [self.delegate addAttendWithAliveSearchResultModel:self.userModel andCellIndex:self.tag];
    }
}


- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""])
    {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {
                
                //去掉这个abc字符串
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            else
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                
                break;
                
            }
            else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}


@end
