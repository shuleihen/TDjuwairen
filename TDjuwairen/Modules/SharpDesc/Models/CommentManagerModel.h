//
//  CommentManagerModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentManagerModel : NSObject

@property (nonatomic,copy) NSString *sharpcomment_sharpid;
@property (nonatomic,copy) NSString *userinfo_facesmall;
@property (nonatomic,copy) NSString *user_nickname;
@property (nonatomic,copy) NSString *sharpcomment_ptime;
@property (nonatomic,copy) NSString *sharpcomment_text;
@property (nonatomic,copy) NSString *sharp_pic280;
@property (nonatomic,copy) NSString *sharp_title;

+(CommentManagerModel *)getInstanceWithDictionary:(NSDictionary *)dic;

@end
