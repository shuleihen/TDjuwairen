//
//  ImagePickerHandler.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ImagePickerHandler.h"
#import "ELCImagePickerController.h"
#import "UIImage+Resize.h"
#import "ACActionSheet.h"

@interface ImagePickerHandler () <ELCImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *controller;
@end

@implementation ImagePickerHandler
- (id)initWithDelegate:(id<ImagePickerHanderlDelegate>)aDelegate {
    if (self = [super init]) {
        self.delegate = aDelegate;
    }
    
    return self;
}

- (void)showImagePickerInController:(UIViewController *)controller withLimitSelectedCount:(NSInteger)limit{
    
    self.controller = controller;
    
    __weak ImagePickerHandler *wself = self;
    ACActionSheet *sheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"] actionSheetBlock:^(NSInteger index){
        if (index == 0) {
            [wself takePhoto];
        } else if (index == 1) {
            [wself selectPhotoAlbumWithLimit:limit];
        }
    }];
    [sheet show];
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
//        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        picker.showsCameraControls = NO;
//        picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//            self.controller.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//        }
        [self.controller presentViewController:picker animated:YES completion:nil];
        
    } else {
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:@"无法打开相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self.controller presentViewController:alert animated:YES completion:nil];
    }
}

- (void)selectPhotoAlbumWithLimit:(NSInteger)limit {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = limit;
    elcPicker.returnsOriginalImage = NO;
    elcPicker.imagePickerDelegate = self;
    [self.controller presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    UIImage *reSizeImg = [UIImage imageWithData:data];

    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerHanderl:didFinishPickingImages:)]) {
        [self.delegate imagePickerHanderl:self didFinishPickingImages:@[reSizeImg]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:info.count];
    
    for (NSDictionary *dict in info) {
        UIImage *img = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *data = UIImageJPEGRepresentation(img, 0.9);
        UIImage *reSizeImg = [UIImage imageWithData:data];
        [array addObject:reSizeImg];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerHanderl:didFinishPickingImages:)]) {
        [self.delegate imagePickerHanderl:self didFinishPickingImages:array];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}
@end
