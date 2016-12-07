//
//  UIdaynightModel.m
//  TDjuwairen
//
//  Created by 团大 on 16/7/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "UIdaynightModel.h"

#import "HexColors.h"

@implementation UIdaynightModel

+ (UIdaynightModel *)sharedInstance
{
    static UIdaynightModel *model = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc]init];
    });
    return model;
}

- (void)day
{
    self.titleColor = [HXColor hx_colorWithHexRGBAString:@"#646464"];
    self.textColor = [HXColor hx_colorWithHexRGBAString:@"#222222"];
    self.secTextColor = [HXColor hx_colorWithHexRGBAString:@"999999"];
    self.navigationColor = [UIColor whiteColor];
    self.backColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    self.lineColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.inputColor = [UIColor whiteColor];
}

- (void)night
{
    self.titleColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.secTextColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.navigationColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    self.backColor = [UIColor colorWithRed:47/255.0 green:48/255.0 blue:49/255.0 alpha:1.0];
    self.lineColor = [UIColor colorWithRed:47/255.0 green:48/255.0 blue:49/255.0 alpha:1.0];
    self.inputColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
}

@end
