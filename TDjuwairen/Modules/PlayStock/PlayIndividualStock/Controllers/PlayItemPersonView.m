//
//  PlayItemPersonView.m
//  TDjuwairen
//
//  Created by deng shu on 2017/3/28.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "PlayItemPersonView.h"
#import "HexColors.h"

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
        [self initValue];
    }
    return self;
}

- (void)initValue
{
   
}

- (void)initViews
{
    _icon.layer.cornerRadius  = 18;
    _icon.layer.masksToBounds = YES;
}
@end
