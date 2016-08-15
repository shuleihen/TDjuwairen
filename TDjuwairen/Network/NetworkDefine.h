//
//  NetworkDefine.h
//  TDjuwairen
//
//  Created by zdy on 16/8/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#ifndef NetworkDefine_h
#define NetworkDefine_h

#define API_HOST    @"http://appapi.juwairen.net/"

#define kAPI_bendi @"http://192.168.1.106/tuanda_web/Appapi/index.php/"

#define API_GetBrowseHistory    @"index.php/Public/getBrowseHistory"
#define API_DelBrowseHistory    @"index.php/Public/delBrowseHistory"
#define API_GetApiValidate      @"Public/getapivalidate/"
#define API_GetUserViewList1_2  @"View/getUserViewList1_2"
#define API_GetCollectionList   @"index.php/Collection/getCollectionlist"
#define API_DelCollection       @"index.php/Collection/delCollect"
#define API_AddCollection       @"index.php/Collection/addCollect"
#define API_GetUserComment      @"index.php/User/getUserComnment"
#define API_AddViewCommont      @"View/addViewCommont1_2"
#define API_AddUserFeedback     @"User/addUserFeedback/"
#define API_GetUserFeedbackList @"Feedback/getUserFeedbackList1_2"
#define API_ResetPasswordk      @"Login/telFindpwd"
#define API_Login               @"Login/loginDo"
#define API_CheckWeixinLogin    @"Login/checkWXAccount1_2"
#define API_LoginWithWeixin     @"Login/WXLoginDo1_2"
#define API_CheckQQLogin        @"Login/checkQQAccount1_2"
#define API_LoginWithQQ         @"Login/qqLoginDo1_2"
#define API_LoginWithPhone      @"Login/phoneLogin1_2"
#define API_CheckPhone          @"Reg/checkTelephone/"
#define API_UpdateUserName      @"User/updateUsername"
#define API_UpdateCompanyName   @"User/updateCompanyName"
#define API_UpdateOccupationName @"User/updateOccupationName"
#define API_UpdateUserInfo      @"User/updateUserinfo"
#define API_UploadUserface      @"User/userfaceImgUp"

#endif /* NetworkDefine_h */

//NetworkManager *manager = [[NetworkManager alloc] init];
//NSDictionary*para=@{@"validatestring":self.loginstate.userId};
//
//[manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
//    if (!error) {
//
//    } else {
//        
//    }
//}];