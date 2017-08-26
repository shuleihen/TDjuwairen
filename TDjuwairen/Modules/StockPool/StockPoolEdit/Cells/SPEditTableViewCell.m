//
//  SPEditTableViewCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SPEditTableViewCell.h"
#import "UIImage+Create.h"

@implementation SPEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.stockNameBtn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#76A5BC"].CGColor;
    self.stockNameBtn.layer.borderWidth = TDPixel;
    self.stockNameBtn.layer.cornerRadius = 3.0f;
    self.stockNameBtn.clipsToBounds = YES;
    
    self.percentageField.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#76A5BC"].CGColor;
    self.percentageField.layer.borderWidth = TDPixel;
    self.percentageField.layer.cornerRadius = 3.0f;
    self.percentageField.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    self.stockNameBtn.enabled = enabled;
    
    if (!enabled) {
        UIImage *image = [UIImage imageWithSize:CGSizeMake(60, 27) backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#67C587"] borderColor:[UIColor hx_colorWithHexRGBAString:@"#67C587"] cornerRadius:13.5];
        [self.optionBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        [self.optionBtn setTitle:@"清仓" forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage imageWithSize:CGSizeMake(60, 27) backgroudColor:[UIColor hx_colorWithHexRGBAString:@"#FF523B"] borderColor:[UIColor hx_colorWithHexRGBAString:@"#FF523B"] cornerRadius:13.5];
        [self.optionBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        [self.optionBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

- (void)setModel:(SPEditRecordModel *)model {
    _model = model;
    
    NSString *title = [NSString stringWithFormat:@"%@%@",model.stockName?:@"",model.stockCode?:@""];
    [self.stockNameBtn setTitle:title forState:UIControlStateNormal];
    
    self.percentageField.text = model.ratio;
}

- (IBAction)textDidChanged:(UITextField *)sender {
    self.model.ratio = sender.text;
}


- (IBAction)stockNamePressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(spEditTableViewCell:stockNamePressed:)]) {
        [self.delegate spEditTableViewCell:self stockNamePressed:sender];
    }
}

- (IBAction)optionPressed:(id)sender {
    
    if (self.model.cellType == kSPEidtCellNormal) {
        // 清仓
        self.model.ratio = @"0";
        self.percentageField.text = @"0";
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(spEditTableViewCell:optionPressed:)]) {
            [self.delegate spEditTableViewCell:self optionPressed:sender];
        }
    }
}
@end
