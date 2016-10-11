//
//  PaperDetailViewController.h
//  TDjuwairen
//
//  Created by zdy on 16/10/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPaperTypeSurvey,
    kPaperTypeViewpoint,
} PaperType;

@interface PaperDetailViewController : UIViewController
@property (nonatomic, assign) PaperType paperType;
@property (nonatomic, strong) NSString *paperId;

@end
