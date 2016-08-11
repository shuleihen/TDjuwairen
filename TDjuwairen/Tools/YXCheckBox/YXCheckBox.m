//
//  YXCheckBox.m
//  baiwandian
//
//  Created by zdy on 15/11/13.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import "YXCheckBox.h"

@implementation YXCheckBox

- (id)initWithCheckImage:(UIImage *)image checkedImage:(UIImage *)checkedImage withCheckedBlock:(void (^)(BOOL checked))checkedBlock
{
    if (self = [super init]) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:checkedImage forState:UIControlStateSelected];
        
        _checkedBoxBlock = checkedBlock;
        
        [self addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)awakeFromNib
{
    [self addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.selected) {
        NSString *title = [self titleForState:UIControlStateSelected];
        UIImage *image = [self imageForState:UIControlStateSelected];
        
        [self setTitle:title forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    else {
        NSString *title = [self titleForState:UIControlStateNormal];
        UIImage *image = [self imageForState:UIControlStateNormal];
        
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateHighlighted];
        
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        NSString *title = [self titleForState:UIControlStateSelected];
        UIImage *image = [self imageForState:UIControlStateSelected];
        
        [self setTitle:title forState:UIControlStateSelected|UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    else {
        NSString *title = [self titleForState:UIControlStateNormal];
        UIImage *image = [self imageForState:UIControlStateNormal];
        
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateHighlighted];
    }
    
    [super setSelected:selected];
}


- (void)checkPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.checked = btn.selected;
    
    if (_checkedBoxBlock) {
        _checkedBoxBlock(btn.selected);
    }
}
@end
