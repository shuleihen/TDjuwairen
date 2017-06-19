//
//  MessageListModel.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kMessageTypeSurveyPublish   =1,
    kMessageTypeSurveyAsk       =3,
    kMessageTypeSurveyAns       =4,
    kMessageTypeGradeReply      =8,
    kMessageTypeTopicPublish    =10,
    kMessageTypePostPublish     =11,
    kMessageTypeForward         =12,
    kMessageTypeViewpointPublish=13,
    kMessageTypeAliveComment    =14,
    kMessageTypeVideoPublish    =15,
    kMessageTypeViewpointComment=16,
    kMessageTypeAliveReply      =17,
    kMessageTypeViewpointReply  =19,
    kMessageTypeTopicLike       =20,
    kMessageTypePostLike        =21,
    kMessageTypeViewpointLike   =22,
    kMessageTypePlayStock       =23,
    kMessageTypeIndividualStock =24,
    kMessageTypeFans            =25
} MessageType;

@interface MessageListModel : NSObject
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, assign) MessageType msgType;
@property (nonatomic, copy) NSString *rightContent;
@property (nonatomic, assign) NSInteger rightType;
@property (nonatomic, strong) NSDictionary *rightExtra;
@property (nonatomic, assign) BOOL isRead;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
