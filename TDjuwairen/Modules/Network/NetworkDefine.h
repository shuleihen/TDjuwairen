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

#define kAPI_bendi @"http://192.168.1.100/tuanda_web/Appapi/"

#define kAPI_songsong @"http://192.168.1.103/"

#define API_AddBrowseHistory    @"index.php/Public/addBrowseHistory"
#define API_GetBrowseHistory    @"index.php/Public/getBrowseHistory"
#define API_DelBrowseHistory    @"index.php/Public/delBrowseHistory"
#define API_GetApiValidate      @"Public/getapivalidate/"
#define API_GetUserViewList1_2  @"index.php/View/getUserViewList1_2"//
#define API_GetCollectionList   @"index.php/Collection/getCollectionlist"
#define API_DelCollection       @"index.php/Collection/delCollect"
#define API_AddCollection       @"index.php/Collection/addCollect"
#define API_GetUserComment      @"index.php/User/getUserComnment"
#define API_AddViewCommont      @"index.php/View/addViewCommont1_2"
#define API_AddUserFeedback     @"User/addUserFeedback/"
#define API_GetUserFeedbackList @"index.php/Feedback/getUserFeedbackList1_2"//
#define API_ResetPasswordk      @"Login/telFindpwd"
#define API_Login               @"Login/loginDo"
#define API_CheckWeixinLogin    @"index.php/Login/checkWXAccount1_2"//
#define API_LoginWithWeixin     @"index.php/Login/WXLoginDo1_2"//
#define API_CheckQQLogin        @"index.php/Login/checkQQAccount1_2"//
#define API_LoginWithQQ         @"index.php/Login/qqLoginDo1_2"//
#define API_LoginWithPhone      @"index.php/Login/phoneLogin1_2"//

#define API_SendChannel_id      @"index.php/Login/saveUserChannelID"  //发送channel_id

#define API_CheckPhone          @"Reg/checkTelephone/"
#define API_RegWithPhone        @"Reg/doTelReg"
#define API_CheckNickName       @"Reg/checkNickname"
#define API_UpdateUserName      @"User/updateUsername"
#define API_UpdateCompanyName   @"User/updateCompanyName"
#define API_UpdateOccupationName @"User/updateOccupationName"
#define API_UpdateUserInfo      @"User/updateUserinfo"
#define API_UploadUserface      @"User/userfaceImgUp"
#define API_UploadContentPic    @"index.php/View/upViewContenPic1_2" //
#define API_PushViewDo1_2       @"index.php/View/publishViewDo1_2"//
#define API_AddGoodComment1_2   @"index.php/View/AddCommentAssessGood1_2"
#define API_Search              @"index.php/Search/search"
#define API_Search1_2           @"index.php/Search/search1_2"
#define API_AddSharpComment     @"index.php/Sharp/addSharpComnment"
#define API_GetSurveryList      @"index.php/Sharp/surveyList/page"
#define API_GetVideoList        @"index.php/Sharp/VideoList/page"//
#define API_GetViewComment      @"index.php/View/GetViewComment1_2"
#define API_GetBanner           @"index.php/Index/indexBanner"
#define API_QueryKeyNumber      @"Survey/getUserKeyNum"

#define API_GetGuessIndex       @"Game/guessIndex"

#endif /* NetworkDefine_h */
