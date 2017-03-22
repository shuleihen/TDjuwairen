//
//  NetworkDefine.h
//  TDjuwairen
//
//  Created by zdy on 16/8/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#ifndef NetworkDefine_h
#define NetworkDefine_h

#define API_HOST    @"https://appapi.juwairen.net/"

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
#define API_GetUserFeedbackList @"index.php/Feedback/getUserFeedbackList1_2"

#define API_Login               @"Login/loginDo2_3"
#define API_LoginWithWeixin     @"Login/WXLogin2_3"
#define API_LoginWithWeixinAdd  @"Login/WXInfoComplete2_3"
#define API_LoginWithQQ         @"Login/qqLogin2_3"
#define API_LoginWithQQAdd      @"Login/qqInfoComplete2_3"
#define API_LoginWithPhone      @"Login/phoneLogin2_3"
#define API_LoginWithPhoneAdd   @"Login/phoneInfoComplete2_3"
#define API_ResetPasswordk      @"Login/telFindpwd2_3"
#define API_LoginGetPhoneCode   @"Login/phoneSendVerifyCode"
#define API_LoginCheckPhoneCode @"Login/phoneCheckVeirfy"
#define API_LoginSaveChannelid  @"Login/saveUserChannelID"  
#define API_GetAuthKey          @"Login/checkUniqueStrValid"

#define API_CheckPhone          @"Reg/checkTelephone/"
#define API_RegWithPhone        @"Reg/doTelReg"
#define API_CheckNickName       @"Reg/checkNickname"
#define API_UpdateUserName      @"User/updateUsername"
#define API_UpdateNickName      @"User/updateUserNickname"
#define API_UpdateCompanyName   @"User/updateCompanyName"
#define API_UpdateOccupationName @"User/updateOccupationName"
#define API_UpdateUserInfo      @"User/updateUserinfo"
#define API_GetUserInfo         @"User/getUserInfo"
#define API_UploadUserface      @"User/userfaceImgUp"
#define API_UserBindInfo        @"User/userbindInfo"
#define API_UpdateUserPhone     @"User/updateUserphone"
#define API_BindWeixin          @"User/bindWXAccount"
#define API_UnbindWeixin        @"User/unbindWXAccount"
#define API_BindQQ              @"User/bindQQAccount"
#define API_UnbindQQ            @"User/unbindQQAccount"
#define API_UserGetDetailAvatar @"User/getDefaultHeadImg"
#define API_UserUpdateDetailAvatar  @"User/chooseDefaultHeadImg"

#define API_UploadContentPic    @"index.php/View/upViewContenPic1_2" //
#define API_PushViewDo1_2       @"index.php/View/publishViewDo1_2"//
#define API_AddGoodComment1_2   @"index.php/View/AddCommentAssessGood1_2"
#define API_Search              @"Search/search2_2"
#define API_ViewSearchCompnay   @"View/getCompanyCode"

#define API_AddSharpComment     @"index.php/Sharp/addSharpComnment"
#define API_GetSurveryList      @"index.php/Sharp/surveyList/page"
#define API_GetVideoList        @"index.php/Sharp/VideoList/page"//
#define API_GetViewComment      @"index.php/View/GetViewComment1_2"
#define API_GetBanner           @"Index/indexBanner"

#define API_SurveyDetailHeader  @"Survey/survey_show_header2_2"
#define API_SurveyDetail        @"Survey/survey_show_tag2_3"
#define API_SurveyDetailHot     @"Survey/survey_show_topline"
#define API_SurveyDetailComment @"Survey/survey_show_comment2_2"
#define API_SurveyDetailContent @"Survey/url_get_content2_2"
#define API_SurveyAddComment    @"Survey/addComment"
#define API_SurveyAddFavour     @"Survey/addCommentGoodAccess"
#define API_SurveyAddQuestion         @"Survey/addQuestion"
#define API_SurveyAnswerQuestion      @"Survey/answerQuestion"
#define API_SurveyUnlock        @"Survey/unlockCompany"
#define API_SurveySubject       @"Survey/surveySubject"
#define API_SurveySubjectList   @"Survey/lists2_2"
#define API_SurveyGradeList     @"Survey/companyRank"
#define API_SurveyCompanyGrade  @"Survey/companyGrade"
#define API_SurveyCompanyReview @"Survey/companyReview"
#define API_SurveyCompanyGradeAdd    @"Survey/addCompanyGrade"
#define API_SurveyAddSurvey     @"Survey/addSurveyOrder"
#define API_SurveyAddStock      @"Survey/addMyStock"
#define API_SurveyDeleteStock   @"Survey/delMyStockCode"

#define API_QueryKeyNumber      @"Survey/getUserKeyNum"
#define API_AliPay              @"Survey/alipayKey"
#define API_WXPay               @"Survey/wxpayKey"
#define API_IAPVerify           @"Pay/iapVerify"

#define API_GetGuessIndex       @"Game/guessIndex"

#define API_GameImage           @"Game/guessImage"
#define API_GuessIndexList      @"Game/indexGuessing"
#define API_GuessAddJoin        @"Game/addUserGuessing"
#define API_GameMyGuess         @"Game/myGuessList"
#define API_GameCommentList     @"Game/getGuessComment"
#define API_GameAddComment      @"Game/addGuessComment"
#define API_GameAddAddress      @"Game/saveReciveAwardInfo"
#define API_GameQueryAddress    @"Game/getAwardInfo"

#define API_SubscriptionInfo    @"Subscribe/subscribeInfo"
#define API_SubscriptionAdd     @"Subscribe/addCompanySubscribe"
#define API_SubscriptionHistory @"Subscribe/subscribeRecord"

#define API_PayIsShow           @"Pay/isPayShow"

#define API_AliveGetRoomList        @"Room/lists"
#define API_AliveGetAliveInfo       @"Room/showLiveInfo"
#define API_AliveGetRoomComment     @"Room/showLiveComment"
#define API_AliveGetRoomLike        @"Room/showLiveAssess"
#define API_AlvieGetRoomShare       @"Room/showLiveShare"
#define API_AliveAddRoomComment     @"Room/addRoomLiveComment"
#define API_AliveAddRoomRemark      @"Room/addRoomLiveRemark"
#define API_AliveAddLike            @"Room/addLiveAssess"
#define API_AliveCancelLike         @"Room/cancelLiveAssess"
#define API_AliveAddShare           @"Room/addShareRecord"
#define API_AliveGetMasterList      @"Room/getRoomMasters"
#define API_AliveGetFansList        @"Room/getFansList"
#define API_AliveGetAttenList       @"Room/getAttenList"
#define API_AliveAddAttention       @"Blog/addAttention"
#define API_AliveDelAttention       @"Blog/cancelAttention"
#define API_AliveAddRoomPublish     @"Room/publish"
#define API_AliveGetRoomInfo        @"Room/getRoomInfo"
#define API_AliveGetRoomLiveList    @"Room/roomLiveList"
#define API_AliveUpdateUserSex      @"Room/updateUserSex"
#define API_AliveUpdateUserCity     @"Room/updateUserAddress"
#define API_AliveUpdateRoomInfo     @"Room/updateRoomInfo"
#define API_AliveGetRoomNotify      @"Room/getRoomNotify"
#define API_AliveClearRoomNotify    @"Room/clearRoomNotify"
#define API_AliveUpdateRoomCover    @"Room/uploadRoomCover"

#endif /* NetworkDefine_h */
