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

#define API_H5UserPointsDesc    @"https://appapi.juwairen.net/Page/index/p/PointDesc"
#define API_H5UserPointsList    @"https://www.juwairen.net/index.php/UserCenter/showUserPoints"
#define API_H5UserWalletList    @"https://www.juwairen.net/UserCenter/showUserWallet"
#define API_H5UserMission       @"https://www.juwairen.net/UserCenter/showUserMission"
#define API_H5UserVipCenter     @"https://appapi.juwairen.net/User/vipCenter3_3"

// 广告
#define API_GetBanner           @"Index/indexBanner"
#define API_SaveDeviceInfo      @"Index/saveDeviceInfo"
#define API_IndexStartupPage    @"Index/startupPage3_1"
#define API_IndexSurveyBanner   @"Index/surveyBanner"
#define API_IndexDeepBanner     @"Index/deepBanner"

#define API_AliyunUpload        @"Upload/getAliyunUploadConfig"

#define API_AddBrowseHistory    @"Public/addBrowseHistory"
#define API_GetBrowseHistory    @"Public/getBrowseHistory"
#define API_DelBrowseHistory    @"Public/delBrowseHistory"
#define API_GetApiValidate      @"Public/getapivalidate"
#define API_GetCollectionList   @"Collection/getCollectList3_1"
#define API_DelCollection       @"Collection/delCollect"
#define API_AddCollection       @"Collection/addCollect"
#define API_CancelCollection    @"Collection/cancelCollectById"
#define API_GetUserFeedbackList @"Feedback/getUserFeedbackList1_2"

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

#define API_GetUserComment      @"User/getUserComnment"
#define API_AddUserFeedback     @"User/addUserFeedback/"
#define API_UpdateUserName      @"User/updateUsername"
#define API_UpdateNickName      @"User/updateUserNickname"
#define API_UpdateCompanyName   @"User/updateCompanyName"
#define API_UpdateOccupationName @"User/updateOccupationName"
#define API_UpdateUserInfo      @"User/updateUserinfo"
#define API_GetUserInfo         @"User/getLoginUser"
#define API_UploadUserface      @"User/userfaceImgUp"
#define API_UserBindInfo        @"User/userbindInfo"
#define API_UpdateUserPhone     @"User/updateUserphone"
#define API_BindWeixin          @"User/bindWXAccount"
#define API_UnbindWeixin        @"User/unbindWXAccount"
#define API_BindQQ              @"User/bindQQAccount"
#define API_UnbindQQ            @"User/unbindQQAccount"
#define API_UserGetDetailAvatar @"User/getDefaultHeadImg"
#define API_UserUpdateDetailAvatar  @"User/chooseDefaultHeadImg"
#define API_GetUserKeyRecord    @"User/getUserKeyRecord"
#define API_DeleteUserKeyRecord @"User/delKeyRecord"
#define API_GetUserOrder        @"User/getUserOrder"
#define API_DeleteUserOrder     @"User/delUserOrder"
#define API_UserVipCenter       @"User/vipCenter"
#define API_UserGetKeyRecordList        @"User/getKeyRecordList3_3"
#define API_UserGetIntegral     @"User/getUserPoints"
#define API_UserGetIntegralList @"User/getUserPointsRecord"
#define API_UserGetNotify       @"User/getUserNotify"

#define API_FirmAccount_firmPlatList    @"FirmAccount/firmPlatList"
#define API_ShowFirmAccountInfo         @"FirmAccount/showFirmAccountInfo"
#define API_FirmAccount_AddFirmAccount  @"FirmAccount/addFirmAccount"



#define API_Search                  @"Search/search2_2"
#define API_AliveSearch             @"Search/search3_2"

#define API_PayIsShow               @"Pay/isPayShow"
#define API_IAPVerify               @"Pay/iapVerify"
#define API_IAPGuesVerify           @"Pay/guestIapVerify"
#define API_PayGetVipList           @"Pay/getVipPrice"

#define API_AddSharpComment         @"Sharp/addSharpComnment"
#define API_VideoGetList            @"Sharp/videoList3_1"
#define API_VideoGetInfo            @"Sharp/getVideoInfo"

// 观点
#define API_ViewGetList             @"View/getViewList3_3"
#define API_ViewAddLike             @"View/addViewAssess"
#define API_ViewCancelLike          @"View/cancelViewAssess"
#define API_ViewGetLikeList         @"View/showViewAssess"
#define API_ViewGetShareList        @"View/howViewShare"
#define API_ViewGetDetail           @"View/view_show1_2"
#define API_ViewGetDetailWebContent @"View/url_view_conten"

#define API_UploadContentPic        @"View/upViewContenPic1_2"
#define API_PushViewDo1_2           @"View/publishViewDo1_2"
#define API_AddGoodComment1_2       @"View/AddCommentAssessGood1_2"
#define API_GetUserViewList1_2      @"View/getUserViewList1_2"
#define API_ViewSearchCompnay       @"View/getCompanyCode"
#define API_AddViewCommont          @"View/addViewCommont1_2"
#define API_GetViewComment          @"View/GetViewComment1_2"


// 调研
#define API_SurveyDetailHeader      @"Survey/survey_show_header2_2"
#define API_SurveyDetail            @"Survey/survey_show_tag2_3"
#define API_SurveyDetailResearch    @"Survey/survey_show_research3_3"
#define API_SurveyDetailAnnounce    @"Survey/survey_show_announce"
#define API_SurveyDetailHot         @"Survey/survey_show_topline"
#define API_SurveyDetailAsk         @"Survey/survey_show_qa3_1"
#define API_SurveyDetailComment     @"Survey/survey_show_comment2_2"
#define API_SurveyDetailContent     @"Survey/url_get_content2_2"
#define API_SurveyAddComment        @"Survey/addComment"
#define API_SurveyAddFavour         @"Survey/addCommentGoodAccess"
#define API_SurveyAddQuestion       @"Survey/addQuestion"
#define API_SurveyAnswerQuestion    @"Survey/answerQuestion"
#define API_SurveyGetShareInfo      @"Survey/getSurveyInfo"
#define API_SurveyAskLike           @"Survey/addUpvoteCompanyAnswer"
#define API_SurveyAskUnLike         @"Survey/cancelUpvoteCompanyAnswer"

#define API_SurveyUnlockCompany     @"Survey/unlockCompany"
#define API_SurveyIsUnlock          @"Survey/isUserUnlockCompany"
#define API_SurveySubject           @"Survey/surveySubject3_1"
#define API_SurveyAddSubject        @"Survey/addAttenSurveySubject"
#define API_SurveyAttenSubject      @"Survey/getAttenSurveySubject"
#define API_SurveySubjectList       @"Survey/lists3_3"
#define API_SurveyGetMyStockList    @"Survey/getMyStockList3_1"
#define API_SurveyGradeList         @"Survey/companyRank"
#define API_SurveyCompanyGrade      @"Survey/companyGrade"
#define API_SurveyCompanyReview     @"Survey/companyReview3_1"
#define API_SurveyCompanyGradeAdd   @"Survey/addCompanyGrade"
#define API_SurveyCompanyGrade      @"Survey/companyGrade"
#define API_SurveyCompanyReplyReview @"Survey/replyCompanyReview"
#define API_SurveyAddSurvey         @"Survey/addSurveyOrder"
#define API_SurveyAddStock          @"Survey/addMyStock"
#define API_SurveyDeleteStock       @"Survey/delMyStockCode"
#define API_QueryKeyNumber          @"Survey/getUserKeyNum"
#define API_AliPay                  @"Survey/alipayKey"
#define API_WXPay                   @"Survey/wxpayKey"
#define API_SurveyGetDeepList       @"Survey/getDeepList"
#define API_SurveyIsUnlockDeep      @"Survey/isUserUnlockDeep"
#define API_SurveyUnlockDeep        @"Survey/unlockSurveyDeep"
#define API_SurveyIsUnlockSurvey    @"Survey/isUserUnlockSurvey"
#define API_SurveyUnlockSurvey      @"Survey/unlockSurvey"


// 订阅
#define API_SubscriptionInfo        @"Subscribe/subscribeInfo"
#define API_SubscriptionAdd         @"Subscribe/addCompanySubscribe"
#define API_SubscriptionHistory     @"Subscribe/subscribeRecord"


// 游戏
#define API_GetGuessMessage         @"Game/getGuessMessage"
#define API_GetGuessIndividual      @"Game/guessIndividual"
#define API_GetGuessIndividualList  @"Game/getGuessIndividualList3_1"
#define API_AddGuessIndividual          @"Game/addGuessIndividual"
#define API_GetGuessIndividualEndtime   @"Game/getGuessIndividualEndtime"
#define API_GetGuessIndividualUserList  @"Game/getGuessIndividualUserList"
#define API_CheckStockAndPointsValid    @"Game/checkStockAndPointsValid"
#define API_GetGuessInfo            @"Game/getGuessInfo3_1"
#define API_GetGuessDetail          @"Game/getGuessIndividualDetail"
#define API_GetGuessDetailUserList  @"Game/getGuessIndividualUserList3_1"
#define API_AddShareGuessToAlive    @"Game/addShareGuessToAlive"
#define API_GameImage               @"Game/guessImage"
#define API_GuessIndexList          @"Game/indexGuessing"
#define API_GuessAddJoin            @"Game/addUserGuessing"
#define API_GameCommentList         @"Game/getGuessComment"
#define API_GameAddComment          @"Game/addGuessComment"
#define API_GameAddAddress          @"Game/saveReciveAwardInfo"
#define API_GameQueryAddress        @"Game/getAwardInfo"
#define API_GameMyGuess             @"Game/myGuessList"
#define API_GameMyIndividualGuess   @"Game/myGuessList2_1"
#define API_GetGuessRule            @"Game/guessRule"

// 直播
#define API_AliveGetRoomList        @"Room/lists"
#define API_AliveGetRecAliveList    @"RoomV3/getRecAliveList3_3"
#define API_AliveGetAttenAliveList  @"RoomV3/getAttenAliveList3_3"
#define API_AliveGetPostAliveList   @"Room/getBareList"
#define API_AliveGetHotAliveList    @"RoomV3/getHotList3_3"
#define API_AliveGetStockHolderList @"RoomV3/getStockMtList"
#define API_AliveGetAliveInfo       @"RoomV3/showLiveInfo3_3"
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
#define API_AliveGetAttenList       @"RoomV3/getAttenList3_3"
#define API_AliveAddAttention       @"Blog/addAttention"
#define API_AliveDelAttention       @"Blog/cancelAttention"
#define API_AliveAddRoomPublish     @"Room/publish3_3"
#define API_AliveGetRoomInfo        @"Room/getRoomInfo3_3"
#define API_AliveGetRoomLiveList    @"RoomV3/roomLiveList3_3"
#define API_AliveGetGuessRateInfo   @"Room/getGuessRateInfo"
#define API_AliveGetAttenInfo       @"Room/getAttenInfo"
#define API_AliveUpdateUserSex      @"Room/updateUserSex"
#define API_AliveUpdateUserCity     @"Room/updateUserAddress"
#define API_AliveUpdateRoomInfo     @"Room/updateRoomInfo"
#define API_AliveGetRoomNotify      @"Room/getRoomNotify"
#define API_AliveClearRoomNotify    @"Room/clearRoomNotify"
#define API_AliveUpdateRoomCover    @"Room/uploadRoomCover"
#define API_AliveDeleteRoomAlive    @"Room/deleteAlive"
#define API_AliveGetActivityMaster  @"Room/activeMasterList"
#define API_AliveClosedAD           @"Room/closeAliveAd"
/// 添加留言板、股票池评论、玩票评论 接口
#define API_AliveAddComment          @"RoomV3/addComment"
/// 添加留言板、股票池评论、玩票评论 接口
#define API_AliveGetCommentList          @"RoomV3/getCommentList"

#define API_MessageGetUnread        @"Message/getMessageCount"
#define API_MessageGetList          @"Message/getMessageList"
#define API_MessageClear            @"Message/clearMessageList"
#define API_MessageDelete           @"Message/deleteMessage"
#define API_MessageSetRead          @"Message/setMessageReadStatus"
#define API_MessageGetSystemList    @"Message/getSysNotifyList3_3"
#define API_MessageSystemClear      @"Message/clearSysNotify"
#define API_MessageSystemDelete     @"Message/deleteSysNotify"
#define API_MessageSystemNotice     @"Message/getSysNotice"


#define API_StockPoolGetList        @"StockPool/getStockPoolList"
/// 获取股票池简介
#define API_StockPoolGetDesc        @"StockPool/getStockPoolDesc"
/// 设置股票池简介
#define API_StockPoolSetDesc        @"StockPool/setStockPoolDesc"
/// 获取设置收费提示
#define API_StockPoolGetPrice        @"StockPool/getStockPoolPrice"
/// 设置股票池订阅收费
#define API_StockPoolSetPrice        @"StockPool/setStockPoolPrice"
/// 设置股票池 获取订阅用户列表
#define API_StockPoolGetSubscribeUser        @"StockPool/getSubscribeStockPoolUser"
/// 获取有记录的月份
#define API_StockPoolGetRecordMonths        @"StockPool/getRecordMonths"
/// 获取指定日期前的股票池记录
#define API_StockPoolGetRecordList        @"StockPool/getRecordList"
/// 股票池记录列表 的头部信息
#define API_StockPoolGetShowStockPool        @"StockPool/showStockPool"
/// 获取指定月份下的有记录的日期
#define API_StockPoolGetRecordDates       @"StockPool/getRecordDates"
#define API_StockPoolGetRecordPoint     @"StockPool/getRecordPositionInfo"
#define API_StockPoolPublish            @"StockPool/saveRecord"
#define API_StockPoolGetDetailInfo      @"StockPool/showRecordInfo"
#define API_StockPoolGetDraftList       @"StockPool/getRecordDraft"
#define API_StockPoolDeleteRecord       @"/StockPool/deleteRecord"
#define API_StockPoolGetSubscribe       @"StockPool/getSubscribeStockPoolInfo"
#define API_StockPoolSubscribe          @"StockPool/subscribeStockPool"
#define API_MyCenterGetUserSubscribeStockPool         @"StockPool/getUserSubscribeStockPool"
#define API_MyCenterCancelSubscribeStockPool          @"/StockPool/cancelSubscribeStockPool"
#define API_MyCenterDeleteSubscribeStockPool          @"/StockPool/deleteSubscribeStockPool"
#define API_StockPoolShare              @"StockPool/shareStockPool"
#define API_StockPoolGetCommentList     @"StockPool/getStockPoolComment"
#define API_StockPoolAddComment         @"StockPool/addStockPoolComment"
#define API_StockPoolReplyComment       @"StockPool/replyStockPoolComment"
#define API_StockPoolGetPublishInfo     @"StockPool/getPublishInfo"

#endif /* NetworkDefine_h */
