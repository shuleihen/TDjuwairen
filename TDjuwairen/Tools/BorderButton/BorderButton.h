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
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@end
