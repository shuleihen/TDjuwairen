//
//  AliveSearchStockCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchStockCell.h"
#import "AliveSearchResultModel.h"

@interface AliveSearchStockCell ()
@property (weak, nonatomic) IBOutlet UILabel *sNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addChoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *surveyButton;


@end

@implementation AliveSearchStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)loadAliveSearchStockCellWithTableView:(UITableView *)tableView {

    AliveSearchStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveSearchStockCell"];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"AliveSearchStockCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setStockModel:(AliveSearchResultModel *)stockModel {

    _stockModel = stockModel;
    NSString *str = [NSString stringWithFormat:@"%@(%@)",stockModel.company_name,stockModel.company_code];
    
    if (stockModel.searchTextStr.length > 0) {
        NSMutableArray *arrM = [self getRangeStr:str findText:stockModel.searchTextStr];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
        for (NSNumber *num in arrM) {
            NSRange rang = NSMakeRange([num integerValue], stockModel.searchTextStr.length);
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"] range:rang];
        }
        
         self.sNameLabel.attributedText = attri;
        
    }else {
        self.sNameLabel.text = str;
    }
    if (stockModel.isMyStock == YES) {
        [self.addChoiceButton setTitle:@"取消自选" forState:UIControlStateNormal];
        [self.addChoiceButton setTitleColor:TDDetailTextColor forState:UIControlStateNormal];
    } else {
        [self.addChoiceButton setTitle:@"加自选" forState:UIControlStateNormal];
        [self.addChoiceButton setTitleColor:TDThemeColor forState:UIControlStateNormal];
        
    }
    
}

/// 加自选
- (IBAction)addChoiceButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addChoiceStockWithSearchResultModel: andCellIndex:)]) {
        [self.delegate addChoiceStockWithSearchResultModel:self.stockModel andCellIndex:self.tag];
    }
}

/// 调研
- (IBAction)surveyButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(surveyButtonClickWithSearchResultModel:)]) {
        [self.delegate surveyButtonClickWithSearchResultModel:self.stockModel];
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
