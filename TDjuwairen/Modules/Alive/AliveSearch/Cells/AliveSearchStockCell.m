//
//  AliveSearchStockCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/26.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveSearchStockCell.h"
#import "SearchResultModel.h"

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

- (void)setStockModel:(SearchResultModel *)stockModel {

    _stockModel = stockModel;
    self.sNameLabel.text = stockModel.title;
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
    if ([self.delegate respondsToSelector:@selector(addChoiceStockWithSearchResultModel:)]) {
        [self.delegate addChoiceStockWithSearchResultModel:self.stockModel];
    }
}

/// 调研
- (IBAction)surveyButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(surveyButtonClickWithSearchResultModel:)]) {
        [self.delegate surveyButtonClickWithSearchResultModel:self.stockModel];
    }
    
}

@end
