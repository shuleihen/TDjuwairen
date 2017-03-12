//
//  ImagePickerHandler.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImagePickerHandler;
@protocol ImagePickerHanderlDelegate <NSObject>
- (void)imagePickerHanderl:(ImagePickerHandler *)imagePicker didFinishPickingImages:(NSArray *)images;
@end

@interface ImagePickerHandler : NSObject
@property (nonatomic, weak) id<ImagePickerHanderlDelegate> delegate;

- (id)initWithDelegate:(id<ImagePickerHanderlDelegate>)aDelegate;
- (void)showImagePickerInController:(UIViewController *)controller withLimitSelectedCount:(NSInteger)limit;
@end
