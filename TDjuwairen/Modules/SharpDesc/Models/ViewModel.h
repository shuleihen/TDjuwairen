//
//  ViewModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject

@property (nonatomic,copy) NSString *is_attention_author;

@property (nonatomic,assign) BOOL view_isCollected; // 是否收藏

@property (nonatomic,strong) NSArray *tags;

@property (nonatomic,copy) NSString *userinfo_facesmall;

@property (nonatomic,copy) NSString *view_addtime;

@property (nonatomic,copy) NSString *view_userid;

@property (nonatomic,copy) NSString *view_author;

@property (nonatomic,copy) NSString *view_content_url;

@property (nonatomic,copy) NSString *view_id;

@property (nonatomic,copy) NSString *view_isoriginal;

@property (nonatomic,copy) NSString *view_title;

@property (nonatomic, assign) BOOL view_isAtten;
+ (id)shareWithDictionary:(NSDictionary *)dic;

@end
