//
//  AliveRoomHeaderView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomHeaderView.h"
#import "AliveRoomMasterModel.h"
#import "UIImageView+WebCache.h"
#import "AliveAlertView.h"

@interface AliveRoomHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UILabel *aNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *aAttentionButton;
@property (weak, nonatomic) IBOutlet UIButton *aFansButton;

@property (weak, nonatomic) IBOutlet UILabel *aRoomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aSexImageView;
@property (weak, nonatomic) IBOutlet UIButton *aLevelButton;

@property (weak, nonatomic) IBOutlet UIButton *aGuessRateButton;

@property (weak, nonatomic) IBOutlet UIButton *aAddAttentionBtn;

@end

@implementation AliveRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aImageView.layer.cornerRadius = 25;
    self.aImageView.layer.masksToBounds = YES;
    
}

+ (instancetype)loadAliveRoomeHeaderView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"AliveRoomHeaderView" owner:nil options:nil] lastObject];
}

- (void)setHeaderModel:(AliveRoomMasterModel *)headerModel {
    
    _headerModel = headerModel;
    [self.aLevelButton setTitle:[NSString stringWithFormat:@"%@",headerModel.level] forState:UIControlStateNormal];
    [self.aGuessRateButton setTitle:[NSString stringWithFormat:@"%@",headerModel.guessRate] forState:UIControlStateNormal];
    
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:headerModel.avatar] placeholderImage:nil];
    self.aNickNameLabel.text = headerModel.masterNickName;
    self.aAddressLabel.text = headerModel.city;
    [self.aAttentionButton setTitle:[NSString stringWithFormat:@"关注%@",headerModel.attenNum] forState:UIControlStateNormal];
    [self.aFansButton setTitle:[NSString stringWithFormat:@"粉丝%@",headerModel.fansNum] forState:UIControlStateNormal];
    self.aRoomInfoLabel.text = [NSString stringWithFormat:@"直播间介绍：%@",headerModel.roomInfo];
    if ([headerModel.sex isEqualToString:@"女"]) {
        self.aSexImageView.highlighted = NO;
    }else {
        
        self.aSexImageView.highlighted = YES;
    }
    
    
    if (headerModel.isAtten == YES) {
        self.aAddAttentionBtn.selected = YES;
        
    }else {
    
        self.aAddAttentionBtn.selected = NO;
    }
    
}
- (IBAction)backButtonClick {
    if (self.backBlock) {
        self.backBlock();
    }
    
}


- (IBAction)attentionButton:(UIButton *)sender {
    
    
    
    
    switch (sender.tag-1000) {
        case 0:
        {
            [[AliveAlertView alloc] initWithAliveAlertView:@"等级说明" detail:@"等级根据：关注数1级0-20人；2级21-40人；100以内，每增加20个关注度，增加一级；500以内，每增加50个关注度，增加一级"];
            
        }
            
            break;
        case 1:
            [[AliveAlertView alloc] initWithAliveAlertView:@"股神指数规则" detail:@"1.用户起始指数为50，指数上不封顶\n2.比谁准中指数竞猜获得大奖（猜中）+20，5倍+10，2倍+1，lose-1\n3.个股竞猜中，赢一场+4，输一场-0.5\n4.pc猜红绿赢一场+2，输一场-2\n5、分享、评论、点赞成功后，数量+1"];
            break;
        case 2:
        {
            
            if (self.btnClickBlock) {
                
                self.btnClickBlock(ButtonAttentionType);
                
                
            }
        }
            break;
        case 3:
        {
            if (self.btnClickBlock) {
                
                self.btnClickBlock(ButtonFansType);
                
                
            }
            
        }
            break;
        case 4:
        {
            // 添加关注
            if (self.addAttentionBlock) {
               
            
                self.addAttentionBlock(self.headerModel.isAtten);
            }
                
              
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
    
    
    
    
    
}


@end
