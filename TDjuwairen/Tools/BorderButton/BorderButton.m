//
//  BorderButton.m
//  Pods
//
//  Created by Frank Michael on 4/10/14.
//
//

#import "BorderButton.h"

@interface BorderButton ()

@property CAShapeLayer *circleLayer;

- (void)setupButton;
@end

@implementation BorderButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupButton];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setupButton];
    }
    return self;
}

- (void)setupButton{
//    _borderColor = self.titleLabel.textColor;
    
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        [[self layer] insertSublayer:_circleLayer below:self.titleLabel.layer];
    }
    
    _circleLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    _circleLayer.path = path.CGPath;
    
    if (self.selected) {
        _circleLayer.fillColor = self.selectedColor.CGColor;
    } else if (self.highlighted) {
        _circleLayer.fillColor = self.heightlightColor.CGColor;
    } else {
        _circleLayer.fillColor = nil;
    }
    
    _circleLayer.strokeColor = self.borderColor.CGColor;
    _circleLayer.lineWidth = self.borderWidth;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
//    if (highlighted) {
//        _circleLayer.fillColor = _heightlightColor.CGColor;
//        self.titleLabel.textColor = [UIColor whiteColor];
//    } else {
//        self.titleLabel.textColor = _borderColor;
//        _circleLayer.fillColor = nil;
//    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
//    if (selected) {
//        _circleLayer.fillColor = _selectedColor.CGColor;
//        self.titleLabel.textColor = [UIColor whiteColor];
//    } else {
//        self.titleLabel.textColor = _borderColor;
//        _circleLayer.fillColor = nil;
//    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    [super setTitleColor:color forState:state];
//    _borderColor = color;
//    _circleLayer.strokeColor = _borderColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupButton];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
