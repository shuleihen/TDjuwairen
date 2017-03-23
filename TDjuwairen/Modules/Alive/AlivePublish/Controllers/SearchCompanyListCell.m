//
//  SearchCompanyListCell.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SearchCompanyListCell.h"


@interface SearchCompanyListCell ()
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SearchCompanyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

+ (instancetype)loadSearchCompanyListCellWithTableView:(UITableView *)tableView {
    SearchCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCodeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCompanyListCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
    
}


- (void)setResultModel:(SearchCompanyListModel *)resultModel {

    _resultModel = resultModel;

    self.codeLabel.text = resultModel.company_code;
    self.nameLabel.text = resultModel.company_name;
    
}

@end
