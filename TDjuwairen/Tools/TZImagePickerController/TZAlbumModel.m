//
//  TZAlbumModel.m
//  TZImagePickerController
//
//  Created by ZYP-MAC on 2017/8/29.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import "TZAlbumModel.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"


@implementation TZAlbumModel

- (void)setResult:(id)result {
    _result = result;
    [[TZImageManager manager] getAssetsFromFetchResult:result  completion:^(NSArray<TZAssetModel *> *models) {
        _models = models;
        if (_selectedModels) {
            [self checkSelectedModels];
        }
    }];
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (TZAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (TZAssetModel *model in _models) {
        if ([[TZImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount ++;
        }
    }
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end
