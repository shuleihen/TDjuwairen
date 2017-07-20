//
//  PAStepper.m
//  Leroy Merlin
//
//  Created by Miroslav Perovic on 11/30/12.
//  Copyright (c) 2012 Pure Agency. All rights reserved.
//

#import "PAStepper.h"

@interface ADNoActionTextField : UITextField

@end

@implementation ADNoActionTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

@end

@interface PAStepper ()<UITextFieldDelegate> {
	UIImageView *backgroundImageView;
	
    ADNoActionTextField *_textField;
    
	UIImage *normalStateImage;
	UIImage *selectedStateImage;
	UIImage *highlightedStateImage;
	UIImage *disabledStateImage;
	
	NSNumber *changingValue;
    
    dispatch_source_t _timerSource;
}

@end

@implementation PAStepper
@synthesize incrementButton = _incrementButton;
@synthesize decrementButton = _decrementButton;

- (void)awakeFromNib
{
    [super awakeFromNib];
	[self setInitialValues];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 116.0, 29.0)]) {
		[self setInitialValues];
	}
	
	return self;
}

- (void)setInitialValues
{
	_value = 0;
	_continuous = YES;
	_minimumValue = 0;
	_maximumValue = 100;
	_stepValue = 1;
	_wraps = NO;
	_autorepeat = YES;
	_autorepeatInterval = 0.2;
    _editableManually = YES;
    
    // background image
	backgroundImageView = [[UIImageView alloc] init];
	[self addSubview:backgroundImageView];
    
    // init left button
    _decrementButton = [[UIButton alloc] init];
    [_decrementButton setTitle:@"-" forState:UIControlStateNormal];
    [_decrementButton setAutoresizingMask:UIViewAutoresizingNone];
    [_decrementButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [_decrementButton addTarget:self action:@selector(didBeginLongTap:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [_decrementButton addTarget:self action:@selector(didEndLongTap) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
    [self addSubview:_decrementButton];
    
    //TextField the number
    _textField = [[ADNoActionTextField alloc] init];
    _textField.font = [UIFont boldSystemFontOfSize:15.0];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.clearButtonMode = UITextFieldViewModeNever;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.inputView = nil;
    _textField.placeholder = [self formatedStringForValue:_value];
    _textField.delegate = self;
    [_textField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_textField addTarget:self action:@selector(didChangeTextField) forControlEvents: UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(didEndEditingTextField) forControlEvents: UIControlEventEditingDidEnd];
    [self addSubview:_textField];
    
	// init right button
	_incrementButton = [[UIButton alloc] init];
	[_incrementButton setTitle:@"+" forState:UIControlStateNormal];
    [_incrementButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [_incrementButton addTarget:self action:@selector(didBeginLongTap:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [_incrementButton addTarget:self action:@selector(didEndLongTap) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
	[self addSubview:_incrementButton];
    
    
    dispatch_queue_t timerQueue = dispatch_queue_create("com.jwr.timerQueue", 0);
    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
    
    // 长按每0.5秒 递增0.02，最大到2
    double interval = 0.5 * NSEC_PER_SEC; // 间隔0.5秒
    dispatch_source_set_timer(_timerSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(_timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _stepValue += 0.02;
            if (_stepValue > 2) {
                _stepValue = 2;
            }
        });
        
    });
}

- (NSString *)formatedStringForValue:(double)value{
    if (value == 0.0) {
        return @"--";
    } else {
        NSString *formatedValueString = [NSString stringWithFormat:@"%.02lf",value];
        return formatedValueString;
    }
}

- (void)layoutSubviews {
    backgroundImageView.frame = self.bounds;
    
    if (self.enabled) {
        backgroundImageView.image = normalStateImage;
    } else {
        if (disabledStateImage) {
            backgroundImageView.image = disabledStateImage;
        }
    }
    
    if (self.highlighted && highlightedStateImage) {
        backgroundImageView.image = highlightedStateImage;
    } else {
        backgroundImageView.image = normalStateImage;
    }
    
    if (self.selected && selectedStateImage) {
        backgroundImageView.image = selectedStateImage;
    } else {
        backgroundImageView.image = normalStateImage;
    }
    
    _decrementButton.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    
    [_decrementButton setTitleColor:self.textColor forState:UIControlStateNormal];
    
    _incrementButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.bounds));
    [_incrementButton setTitleColor:self.textColor forState:UIControlStateNormal];
    
    _textField.frame = CGRectMake(CGRectGetHeight(self.frame), 0, CGRectGetWidth(self.bounds)-2*CGRectGetHeight(self.frame), CGRectGetHeight(self.bounds));
    _textField.textColor = self.textColor;
}

- (void)updateViews
{
    NSString *formatedValueString = [self formatedStringForValue:_value];
    _textField.text = formatedValueString;
    
    [self checkButtonState];
    
}

- (void)checkButtonState{
    BOOL canDecrese = (_value > _minimumValue);
    BOOL canIncrese = (_value < _maximumValue);
    
    _decrementButton.enabled = canDecrese;
    _incrementButton.enabled = canIncrese;
}

#pragma mark - Set Values

- (void)setMinimumValue:(CGFloat)minValue
{
	if (minValue > _maximumValue) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"Invalid minimumValue"
												userInfo:nil];
		@throw ex;
	}
    _minimumValue = minValue;
    _textField.placeholder = [self formatedStringForValue:_minimumValue];
    if (_value < _minimumValue) {
        _value = _minimumValue;
        [self updateViews];
    }
}

- (void)setStepValue:(CGFloat)stepValue {
    _stepValue = stepValue;
}

- (void)setMaximumValue:(CGFloat)maxValue
{
	if (maxValue < _minimumValue) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"Invalid maximumValue"
												userInfo:nil];
		@throw ex;
	}
    _maximumValue = maxValue;
    if (_value > _maximumValue) {
        _value = _maximumValue;
        [self updateViews];
    }
}

- (void)setValue:(CGFloat)val
{
	if (val < _minimumValue) {
		val = _minimumValue;
	} else if (val > _maximumValue) {
		val = _maximumValue;
	}
	_value = val;

    [self updateViews];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setAutorepeatValue:(double)autorepeatInterval
{
	if (autorepeatInterval > 0.0) {
		_autorepeatInterval = autorepeatInterval;
	} else if (autorepeatInterval == 0) {
		_autorepeatInterval = autorepeatInterval;
		_autorepeat = NO;
	}
}

- (void)setEditableManually:(BOOL)editableManually{
    _editableManually = editableManually;
    _textField.enabled = _editableManually;
    if (!_editableManually) {
        [_textField resignFirstResponder];
    }
}

# pragma mark - Public Methods

- (UIImage *)backgroundImageForState:(UIControlState)state
{
	switch (state) {
		case UIControlStateNormal:
			return normalStateImage;
			break;
			
		case UIControlStateHighlighted:
			if (highlightedStateImage) {
				return highlightedStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		case UIControlStateDisabled:
			if (disabledStateImage) {
				return disabledStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		case UIControlStateSelected:
			if (selectedStateImage) {
				return selectedStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		default:
			return normalStateImage;
			break;
	}
	
	return normalStateImage;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
{
	switch (state) {
		case UIControlStateNormal:
			normalStateImage = image;
			break;
			
		case UIControlStateHighlighted:
			highlightedStateImage = image;
			break;
			
		case UIControlStateDisabled:
			disabledStateImage = image;
			break;
			
		case UIControlStateSelected:
			selectedStateImage = image;
			break;
			
		default:
			break;
	}
}

#pragma mark - Actions

- (void)didPressButton:(id)sender
{
	[self setHighlighted:YES];
	if (changingValue) {
		return;
	}
	
	UIButton *button = (UIButton *)sender;
	double changeValue;
	if (button == _decrementButton) {
		changeValue = -1 ;
	} else {
		changeValue = 1;
	}
	changingValue = [NSNumber numberWithDouble:changeValue];
	[self performSelector:@selector(changeValue:) withObject:changingValue afterDelay:0];
}

- (void)didBeginLongTap:(id)sender {
    // 唤起定时器任务.
    if (_timerSource) {
        dispatch_resume(_timerSource);
    }
    
	[self setHighlighted:YES];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	UIButton *button = (UIButton *)sender;
	    
    double changeValue;
	if (button == _decrementButton) {
		changeValue = -1;
	} else {
		changeValue = 1;
	}
	changingValue = [NSNumber numberWithDouble:changeValue];
	if (_continuous) {
		[self changeValue:changingValue];
	}
	[self performSelector:@selector(longTapLoop) withObject:nil afterDelay:_autorepeatInterval];
}

- (void)didEndLongTap {
    // 唤起定时器任务.
    if (_timerSource) {
        dispatch_suspend(_timerSource);
        _stepValue = 0.01;
    }
    
	[self setHighlighted:NO];

	if (!_continuous) {
		[self performSelectorOnMainThread:@selector(changeValue:) withObject:changingValue waitUntilDone:YES];
	}

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	changingValue = nil;
}

- (void)longTapLoop
{
	if (_autorepeat) {
		[self performSelector:@selector(longTapLoop) withObject:nil afterDelay:_autorepeatInterval];
		[self performSelectorOnMainThread:@selector(changeValue:) withObject:changingValue waitUntilDone:YES];
	}
}


#pragma mark - UITextFieldDelegate

-(void)didChangeTextField
{
    NSString *text = _textField.text;
    if (text.length > 0) {
        CGFloat val = [text floatValue];
        
        if (val < _minimumValue) {
            val = _minimumValue;
        } else if (val > _maximumValue) {
            val = _maximumValue;
        }
        _value = val;
    } else {
        _value = 0.0f;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didEndEditingTextField{
    NSString *text = _textField.text;
    [self setValue:[text doubleValue]];
}

- (BOOL)isValidTextFieldValue:(NSString *)valueString{
    if ([valueString isEqualToString:@""]) {
        return YES;
    }
    double valueDouble = [valueString doubleValue];
    if (valueDouble < _minimumValue || valueDouble > _maximumValue) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *text = textField.text;
//    NSString *replacesString = [text stringByReplacingCharactersInRange:range withString:string];
//    BOOL validInput = [self isValidTextFieldValue:replacesString];
//    if (!validInput) {
//        return NO;
//    }
    return YES;
}

#pragma mark - Overwrite UIControl methods

- (void)setEnabled:(BOOL)enabled
{
	if (enabled) {
		backgroundImageView.image = normalStateImage;
	} else {
		if (disabledStateImage) {
			backgroundImageView.image = disabledStateImage;
		}
	}
}

- (void)setHighlighted:(BOOL)highlighted
{
	if (highlighted && highlightedStateImage) {
		backgroundImageView.image = highlightedStateImage;
	} else {
		backgroundImageView.image = normalStateImage;
	}
}

- (void)setSelected:(BOOL)selected
{
	if (selected && selectedStateImage) {
		backgroundImageView.image = selectedStateImage;
	} else {
		backgroundImageView.image = normalStateImage;
	}
}


#pragma mark - Other methods
- (void)changeValue:(NSNumber *)change
{
	double toChange = [change doubleValue];
	double newValue = _value + toChange * _stepValue;
	if (toChange < 0) {
		if (newValue < _minimumValue) {
			if (!_wraps) {
				return;
			} else {
				newValue = _maximumValue;
			}
		}
	} else {
		if (newValue > _maximumValue) {
			if (!_wraps) {
				return;
			} else {
				newValue = _minimumValue;
			}
		}
	}
	[self setValue:newValue];
}

@end
