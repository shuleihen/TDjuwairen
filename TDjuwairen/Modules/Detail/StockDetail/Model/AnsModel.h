//
//  AnsModel.h
//  TDjuwairen
//
//  Created by 团大 on 2016/11/10.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnsModel : NSObject

@property (nonatomic,copy) NSString *surveyanswer_isdel;

@property (nonatomic,assign) BOOL isliked;

@property (nonatomic,copy) NSString *surveyanswer_id;

@property (nonatomic,copy) NSString *user_nickname;

@property (nonatomic,copy) NSString *surveyanswer_goodnums;

@property (nonatomic,copy) NSString *surveyanswer_content;

@property (nonatomic,copy) NSString *surveyanswer_userid;

@property (nonatomic,copy) NSString *userinfo_facemin;

@property (nonatomic,copy) NSString *surveyanswer_askid;

@property (nonatomic,copy) NSString *surveyanswer_addtime;


+ (AnsModel *)getInstanceWithDictionary:(NSDictionary *)dic;

@end
