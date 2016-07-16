//
//  SurveyListModel.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyListModel : NSObject

@property (nonatomic,copy) NSString *sharp_id;             //文章id
@property (nonatomic,copy) NSString *sharp_title;          //文章标题
@property (nonatomic,copy) NSString *sharp_desc;           //文章简介
@property (nonatomic,copy) NSString *sharp_imgurl;         //文章图片url
@property (nonatomic,copy) NSString *sharp_wtime;          //文章发表时间

@property (nonatomic,copy) NSString *user_facemin;         //发表人头像
@property (nonatomic,copy) NSString *user_nickname;        //发表人昵称

@property (nonatomic,copy) NSString *sharp_goodNumber;     //文章点赞数
@property (nonatomic,assign) int sharp_commentNumber;  //文章评论数

+(SurveyListModel *)getInstanceWithDictionary:(NSDictionary *)dic;
@end
