//
//  SystemAudioHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/27.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SystemAudioHandler.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SystemAudioHandler
+ (void)playRemoteBell {
    AudioServicesPlaySystemSound(1007);
}

+ (void)playRemoteShake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
