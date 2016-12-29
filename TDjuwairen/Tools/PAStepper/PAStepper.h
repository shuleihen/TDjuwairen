//
//  PAStepper.h
//  Leroy Merlin
//
//  Created by Miroslav Perovic on 11/30/12.
//  Copyright (c) 2012 Pure Agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PAStepper : UIControl

@property (assign, nonatomic) CGFloat value;
@property (assign, nonatomic) CGFloat minimumValue;
@property (assign, nonatomic) CGFloat maximumValue;
@property (assign, nonatomic) CGFloat stepValue;
@property (assign, nonatomic) BOOL wraps;
@property (assign, nonatomic) BOOL continuous;
@property (assign, nonatomic) BOOL autorepeat;
@property (assign, nonatomic) CGFloat autorepeatInterval;

@property (assign, nonatomic) BOOL editableManually;    // whether we can input value using the builtin textfield

@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *textColor;


@property (readonly, strong, nonatomic) UIButton *incrementButton;
@property (readonly, strong, nonatomic) UIButton *decrementButton;

- (UIImage *)backgroundImageForState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
@end
