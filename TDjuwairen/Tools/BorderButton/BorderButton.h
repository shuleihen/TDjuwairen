//
//  BorderButton.h
//  Pods
//
//  Created by Frank Michael on 4/10/14.
//
//

#import <UIKit/UIKit.h>

@interface BorderButton : UIButton
@property (nonatomic, assign) IBInspectable float cornerRadius;
@property (nonatomic, assign) IBInspectable float borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *heightlightColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;
@end
