//
//  ViewModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/9/21.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject

@property (nonatomic,copy) NSString *view_id;
@property (nonatomic,copy) NSString *view_title;

@property (nonatomic, copy) NSString *view_thumb;

@property (nonatomic,strong) NSArray *tags;

@property (nonatomic,copy) NSString *userinfo_facesmall;

@property (nonatomic,copy) NSString *view_addtime;

@property (nonatomic,copy) NSString *view_userid;

@property (nonatomic,copy) NSString *view_author;

@property (nonatomic,copy) NSString *view_content_url;
@property (nonatomic, copy) NSString *view_share_url;

@property (nonatomic, assign) BOOL view_isAtten;
@property (nonatomic, assign) BOOL view_isCollected;
@property (nonatomic, assign) BOOL view_isOriginal;
@property (nonatomic, assign) BOOL view_isLike;

@property (nonatomic, copy) NSNumber *view_visintnum;
@property (nonatomic, assign) NSInteger view_share_num;
@property (nonatomic, assign) NSInteger view_assess_num;

+ (id)shareWithDictionary:(NSDictionary *)dic;

@end
