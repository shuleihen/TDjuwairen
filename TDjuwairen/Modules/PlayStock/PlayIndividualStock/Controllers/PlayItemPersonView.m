//
//  PlayItemPersonView.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayItemPersonView.h"
#import "HexColors.h"
#import "UIImageView+WebCache.h"

#define BLACKCOLOR  [UIColor hx_colorWithHexRGBAString:@"#333333"]
#define REDCOLOR  [UIColor hx_colorWithHexRGBAString:@"#e64920"]

@interface PlayItemPersonView()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *vipIcon;
@property (weak, nonatomic) IBOutlet UILabel *label_desc;

@end
@implementation PlayItemPersonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlayItemPersonView" owner:nil options:nil] lastObject];
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    _icon.layer.cornerRadius  = 18;
    _icon.layer.masksToBounds = YES;
}


- (void)setUserModel:(PSIndividualUserListModel *)userModel {
    _userModel = userModel;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:userModel.userinfo_facemin] placeholderImage:TDDefaultUserAvatar];
    self.vipIcon.hidden = !userModel.is_winner;
    if (userModel.showItemPoints == YES) {
        
        self.label_desc.text = [NSString stringWithFormat:@"%.2f",[userModel.item_points floatValue]];
        self.label_desc.textColor = [UIColor hx_colorWithHexRGBAString:@"#e64920"];
        
    }else {
        self.label_desc.text = @" ？？";
        self.label_desc.textColor = TDDetailTextColor;
        
    }
    
    
    
}

@end
