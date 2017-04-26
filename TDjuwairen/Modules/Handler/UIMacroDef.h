//
//  UIMacroDef.h
//  TDjuwairen
//
//  Created by zdy on 2017/1/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef UIMacroDef_h
#define UIMacroDef_h
#import "HexColors.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define TDPixel (1.0/[UIScreen mainScreen].scale)

#define TDViewBackgrouondColor   [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"]
#define TDSeparatorColor         [UIColor hx_colorWithHexRGBAString:@"#eeeeee"]

#define TDTitleTextColor         [UIColor hx_colorWithHexRGBAString:@"#333333"]
#define TDDetailTextColor        [UIColor hx_colorWithHexRGBAString:@"#999999"]
// 辅助文字
#define TDAssistTextColor        [UIColor hx_colorWithHexRGBAString:@"#cccccc"]

#define TDBrickRedColor        [UIColor hx_colorWithHexRGBAString:@"#DF402E"]



#define TDThemeColor [UIColor hx_colorWithHexRGBAString:@"#3371E2"]

#define TDDefaultUserAvatar     [UIImage imageNamed:@"icon_avatar.png"]
#define TDCenterUserAvatar      [UIImage imageNamed:@"center_avatar.png"]
#define TDDefaultLoginAvatar    [UIImage imageNamed:@"login_avatar.png"]
#define SetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define MBAlert(title) [Tool alertWithTitle:title];

#endif /* UIMacroDef_h */
