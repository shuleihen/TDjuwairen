//
//  PublishSelectedStockCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/4/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PublishSelectedStockCell.h"
#import "SearchCompanyListModel.h"


@interface PublishSelectedStockCell ()
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;


@end

@implementation PublishSelectedStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (instancetype)loadPublishSelectedStockCellWithTableView:(UITableView *)tableView {
    PublishSelectedStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishSelectedStockCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PublishSelectedStockCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)setStockModel:(SearchCompanyListModel *)stockModel {
    _stockModel = stockModel;
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",stockModel.company_name,stockModel.company_code];
}

// 删除
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deletePublishSelectedCell:)]) {
        [self.delegate deletePublishSelectedCell:self.stockModel];
    }
}

@end
