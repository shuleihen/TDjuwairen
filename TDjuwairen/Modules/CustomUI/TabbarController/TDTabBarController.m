//
//  TDTabBarController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/2.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDTabBarController.h"
#import "HexColors.h"

@interface TDTabBarController ()

@end

@implementation TDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = TDThemeColor;
    
    [self performSelector:@selector(showTabBarAnimation) withObject:nil afterDelay:0.2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)showTabBarAnimation {
    UIImageView *aliveImageView,*playImageView;
    int i=0;
    
    for (UIView *tabBarItem in self.tabBar.subviews) {
        if ([tabBarItem isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            
            for (UIView *barItem in tabBarItem.subviews) {
                if ([barItem isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    if (i == 1) {
                        // 玩票
                        playImageView = (UIImageView *)barItem;
                    } else if (i == 2) {
                        // 直播
                        aliveImageView = (UIImageView *)barItem;
                    }
                }
            }
            
            i++;
        }
    }
    

    playImageView.animationImages = [self animationImagesWithTag:1];
    playImageView.animationDuration = 2.0f;
    [playImageView startAnimating];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [playImageView stopAnimating];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            aliveImageView.animationImages = [self animationImagesWithTag:2];
            aliveImageView.animationDuration = 1.0f;
            [aliveImageView startAnimating];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [aliveImageView stopAnimating];
            });
        });

    });
}

- (NSArray *)animationImagesWithTag:(NSInteger)tag {
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:50];
    
    if (tag == 1) {
        // 玩票
        for (int i=1; i<=49; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"play_%d.png",i]]];
        }
    } else if (tag == 2) {
        // 直播
        for (int i=1; i<=25; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"aliv_%d.png",i]]];
        }
    }
    
    return images;
}


@end
