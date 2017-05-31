//
//  DeleteCollectionPopController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/5/31.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DeleteCollectionPopController.h"
#import "STPopup.h"

@interface DeleteCollectionPopController ()

@end

@implementation DeleteCollectionPopController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



/// 取消
- (IBAction)cancelButtonClick {
    [self.popupController dismiss];
}

/// 确定
- (IBAction)doneButtonClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    [self cancelButtonClick];
    
}

@end
