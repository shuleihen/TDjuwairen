//
//  FirmPlatListModel.h
//  TDjuwairen
//
//  Created by deng shu on 2017/4/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirmPlatListModel : NSObject

//** 当前用户开户状态，0表示没有开户，1表示正在审核，2表示开户成功，3表示开户失败*/
@property (nonatomic, strong) NSNumber *account_status;
/// 平台ID
@property (nonatomic, copy) NSString *plat_id;
/// 平台简介
@property (nonatomic, copy) NSString *plat_info;
/// 开户成功后赠送的钥匙数
@property (nonatomic, copy) NSString *plat_keynum;
/// 图片
@property (nonatomic, copy) NSString *plat_logo;
/// 平台名
@property (nonatomic, copy) NSString *plat_name;
/// 联系电话
@property (nonatomic, strong) NSArray *plat_phone;
/// 开户地址
@property (nonatomic, copy) NSString *plat_url;

- (id)initWithDictionary:(NSDictionary *)dict;

///  状态描述
- (NSString *)account_statusStr;

@end
