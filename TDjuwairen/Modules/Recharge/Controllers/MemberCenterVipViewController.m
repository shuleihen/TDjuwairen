//
//  MemberCenterVipViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/29.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MemberCenterVipViewController.h"
#import "STPopup.h"
#import "MemberCenterVipModel.h"
#import "UIImage+Create.h"

@interface MemberCenterVipViewController ()

@end

@implementation MemberCenterVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setVipList:(NSArray *)vipList {
    _vipList = vipList;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, kScreenWidth-24, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = TDTitleTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"开通会员";
    [self.view addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-11-30, 6, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"unlock_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 42, kScreenWidth-24, 1)];
    sep.backgroundColor = TDSeparatorColor;
    [self.view addSubview:sep];
    
    CGFloat offy = 52;
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(kScreenWidth-24, 64) backgroudColor:[UIColor whiteColor] borderColor:TDSeparatorColor cornerRadius:0];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(kScreenWidth-24, 64) backgroudColor:TDSeparatorColor borderColor:TDSeparatorColor cornerRadius:0];
    
    int i=0;
    for (MemberCenterVipModel *model in vipList) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, offy, kScreenWidth-24, 64)];
        [btn setBackgroundImage:normal forState:UIControlStateNormal];
        [btn setBackgroundImage:pressed forState:UIControlStateHighlighted];
        
        if (self.isRenew == NO) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 80, 18)];
            title.font = [UIFont systemFontOfSize:16.0f];
            title.textColor = TDTitleTextColor;
            title.text = model.levelString;
            [btn addSubview:title];
            
            UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 140, 18)];
            detail.font = [UIFont systemFontOfSize:12.0f];
            detail.textColor = TDLightGrayColor;
            detail.text = [NSString stringWithFormat:@"首充送%@把钥匙和%@积分",model.keyNum,model.pointsNum];
            [btn addSubview:detail];
        } else {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 21, 150, 18)];
            title.font = [UIFont systemFontOfSize:16.0f];
            title.textColor = TDTitleTextColor;
            title.text = model.levelString;
            [btn addSubview:title];
        }
        
        NSString *price = [NSString stringWithFormat:@"￥%@/%@",model.price,model.validTime];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#FF6C00"]}];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#333333"]} range:NSMakeRange(price.length-model.validTime.length, model.validTime.length)];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-136, 21, 100, 18)];
        priceLabel.font = [UIFont systemFontOfSize:16.0f];
        priceLabel.textColor = TDTitleTextColor;
        priceLabel.attributedText = attr;
        priceLabel.textAlignment = NSTextAlignmentRight;
        [btn addSubview:priceLabel];
        
        offy += 74;
        
        btn.tag = i++;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    self.contentSizeInPopup = CGSizeMake(kScreenWidth, 290);
}

- (IBAction)closePressed:(id)sender {
    [self.popupController dismiss];
}

- (void)buttonPressed:(UIButton *)sender {
    NSInteger tag = sender.tag;
    MemberCenterVipModel *model = self.vipList[tag];
    
    [self.popupController dismissWithCompletion:^{
        if (self.delegate) {
            [self.delegate didSelectedWithMemberCenterVipModel:model];
        }
    }];
    
}
@end
