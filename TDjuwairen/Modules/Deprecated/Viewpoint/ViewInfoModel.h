//
//  ViewInfoModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/8/12.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewInfoModel : NSObject

@property (nonatomic,copy) NSString *is_attention_author;

@property (nonatomic,copy) NSString *is_collection;

@property (nonatomic,strong) NSMutableArray *tagsArr;

@property (nonatomic,copy) NSString *view_content_url;

@property (nonatomic,copy) NSString *userinfo_facesmall;

@property (nonatomic,copy) NSString *view_addtime;

@property (nonatomic,copy) NSString *view_author;

@property (nonatomic,copy) NSString *view_title;

@property (nonatomic,copy) NSString *view_id;


+ (id)viewWithDictionary:(NSDictionary *)dic;

@end
