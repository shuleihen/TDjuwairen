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
@property (nonatomic, copy) NSString *plat_id;
@property (nonatomic, copy) NSString *plat_info;
@property (nonatomic, copy) NSString *plat_keynum;
@property (nonatomic, copy) NSString *plat_logo;
@property (nonatomic, copy) NSString *plat_name;
@property (nonatomic, strong) NSArray *plat_phone;
@property (nonatomic, copy) NSString *plat_url;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
