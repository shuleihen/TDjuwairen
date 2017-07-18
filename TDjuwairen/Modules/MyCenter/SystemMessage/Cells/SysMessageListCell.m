//
//  SysMessageListCell.m
//  TDjuwairen
//
//  Created by zdy on 2017/7/18.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SysMessageListCell.h"

@implementation SysMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.typeLabel.layer.borderWidth = TDPixel;
    self.typeLabel.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#666666"].CGColor;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(showMenu)];
    [self addGestureRecognizer:tapGesture];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action==@selector(deleteAction:);
}

- (void)deleteAction:(id)sendr {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

-(void)showMenu
{
    if(self.isFirstResponder){
        [self resignFirstResponder];
    }else{
        [self becomeFirstResponder];
    }
    
    UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteAction:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    menuController.menuItems = @[deleteItem];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
