//
//  PlayStockDefine.h
//  TDjuwairen
//
//  Created by zdy on 2017/7/15.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#ifndef PlayStockDefine_h
#define PlayStockDefine_h

// 1表示上午场，2表示下午场
typedef enum : NSUInteger {
    kPSSeasonAM   =1,
    kPSSeasonPM   =2,
} PSSeason;

// 0表示正在进行，1表示封盘，2表示收盘
typedef enum : NSUInteger {
    kPSGuessExecuting   =0,
    kPSGuessStop        =1,
    kPSGuessFinish      =2,
} PSGuessStatus;

// 0表示没有结束，1表示获胜，2表示完全获胜，3表示没有获胜
typedef enum : NSUInteger {
    kPSWinNoFinish  =0,
    kPSWinYes       =1,
    kPSWinEntirely  =2,
    kPSWinNo        =3,
} PSWinStatus;

#endif /* PlayStockDefine_h */
