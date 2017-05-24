//
//  ViewPointListModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/25.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewPointListModel : NSObject

@property (nonatomic,copy) NSString *view_id;             //文章id
@property (nonatomic,copy) NSString *view_title;          //文章标题
@property (nonatomic,copy) NSString *view_content;

@property (nonatomic,copy) NSString *view_imgurl;         //文章图片url
@property (nonatomic,copy) NSString *view_wtime;          //文章发表时间
@property (nonatomic, assign) NSInteger wtime;

@property (nonatomic,copy) NSString *user_facemin;         //发表人头像
@property (nonatomic,copy) NSString *user_nickname;        //发表人昵称
@property (nonatomic,copy) NSString *view_visitnum;        //访问数

@property (nonatomic,copy) NSString *view_isoriginal;//是否原创


+(ViewPointListModel *)getInstanceWithDictionary:(NSDictionary *)dic;

@end
