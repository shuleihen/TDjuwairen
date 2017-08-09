//
//  TDPopuMenuViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDPopupMenuViewController.h"
#import "TDPopupMenuButton.h"

@interface TDPopupMenuViewController ()
@property (nonatomic, strong) NSMutableArray *itemButtons;

@end

@implementation TDPopupMenuViewController

- (NSMutableArray *)itemButtons
{
    if (_itemButtons == nil) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}


-(void)loadView{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:_backImg];
    imgView.frame = view.bounds;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = imgView.bounds;
    [imgView addSubview:effectView];
    
    [view addSubview:imgView];
    
    self.view = view;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupUI];
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePressed:)];
    [self.view addGestureRecognizer:touch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showAnimationMenu];
}

- (void)setupUI {
    UIImageView *bannerImageView = [[UIImageView alloc] init];
    [self.view addSubview:bannerImageView];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
//    [self.view addSubview:sep];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"ico_close.png"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake((kScreenWidth-44)/2, kScreenHeight-44, 44, 44);
    [closeBtn addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = 300;
    [self.view addSubview:closeBtn];
    
    // 按钮
    NSArray *arrTitle = @[@"观点",@"推单",@"话题",@"记录股票池"];
    NSArray *arrImage = @[@"button_viewpoint.png",@"button_list.png",@"button_topic.png",@"button_gupiaochi.png"];
    
    CGFloat offx = (kScreenWidth - 60*3 - 40*2)/2;
    
    for (int i=0; i<arrTitle.count; i++) {
        TDPopupMenuButton *one = [TDPopupMenuButton buttonWithType:UIButtonTypeCustom];
        [one setTitle:arrTitle[i] forState:UIControlStateNormal];
        [one setImage:[UIImage imageNamed:arrImage[i]] forState:UIControlStateNormal];

        if (i < 3 ) {
            one.frame = CGRectMake(offx + 100*i, kScreenHeight- 307, 60, 80);
            one.transform = CGAffineTransformMakeTranslation(0, 310);
        } else {
            one.frame = CGRectMake((kScreenWidth-60)/2, kScreenHeight -182, 80, 80);
            one.transform = CGAffineTransformMakeTranslation(0, 185);
        }
        
        
        one.tag = 200 + i;
        [one addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:one];
        
        [self.itemButtons addObject:one];
    }
    
}

- (void)showAnimationMenu {
    [self.itemButtons enumerateObjectsUsingBlock:^(TDPopupMenuButton *btn, NSUInteger idx, BOOL *stop){
        [UIView animateWithDuration:0.8 delay:idx *0.03 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
    }];
}

- (void)hiddenMenuAnimation {

    UIButton *closeBtn = [self.view viewWithTag:300];
    [UIView animateWithDuration:0.2 animations:^{
        closeBtn.transform = CGAffineTransformRotate(closeBtn.transform, M_PI_4);
    }];
    
    [self.itemButtons enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TDPopupMenuButton *btn, NSUInteger idx, BOOL *stop){
        [UIView animateWithDuration:0.8 delay:idx *0.03 usingSpringWithDamping:0.8 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (idx < 3 ) {
                btn.transform = CGAffineTransformMakeTranslation(0, 310);
            } else {
                btn.transform = CGAffineTransformMakeTranslation(0, 190);
            }
        } completion:^(BOOL finished){
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (void)buttonPressed:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    
    [UIView animateWithDuration:0.5 animations:^{
        sender.transform = CGAffineTransformMakeScale(2.0, 2.0);
        sender.alpha = 0;
    } completion:^(BOOL finished){
        
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenu:withIndex:)]) {
                [self.delegate popupMenu:self withIndex:index];
            }
        }];
    }];
}

- (void)closePressed:(id)sender {
    [self hiddenMenuAnimation];
}
@end
