//
//  YXLocationPicker.m
//  baiwandian
//
//  Created by zdy on 15/12/15.
//  Copyright © 2015年 xinyunlian. All rights reserved.
//

#import "YXLocationPicker.h"

static CGFloat ToolBarHeight    = 44;
static CGFloat PickerHeight     = 200;

@interface YXLocationPicker ()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, copy) void (^completeBlock)(NSString *province,NSString *city,NSString *strict);
@property (nonatomic, strong) NSArray *items;
@end

@implementation YXLocationPicker

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *contentView = [[UIView alloc] init];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, ToolBarHeight)];
        UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        
        UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        toolBar.items=@[lefttem,centerSpace,right];
        [contentView addSubview:toolBar];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ToolBarHeight, [UIScreen mainScreen].bounds.size.width, PickerHeight)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        _pickerView = pickerView;
        [contentView addSubview:pickerView];
        
        contentView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ToolBarHeight+PickerHeight);
        contentView.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;
        [self addSubview:contentView];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ChineseSubdivisions" ofType:@"plist"];
        _items = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

- (UIWindow *)window {
    
    if (_window == nil) {
        
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel       = UIWindowLevelStatusBar;
        _window.backgroundColor   = [UIColor clearColor];
        _window.hidden = NO;
    }
    
    return _window;
}

#pragma mark 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [_items count];
    }
    else if (component == 1){
        NSInteger row = [pickerView selectedRowInComponent:0];
        NSDictionary *province = _items[row];
        NSArray *citys = [[province allValues] firstObject];
        return [citys count];
    }
    else if (component == 2) {
        NSInteger row0 = [pickerView selectedRowInComponent:0];
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        NSDictionary *province = _items[row0];
        NSArray *citys = [[province allValues] firstObject];
        NSDictionary *city = citys[row1];
        NSArray *districts = [[city allValues] firstObject];
        
        return [districts count];
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *province = _items[row];
        return [[province allKeys] firstObject];
    }
    else if (component == 1){
        NSInteger row0 = [pickerView selectedRowInComponent:0];
        NSDictionary *provinces = _items[row0];
        NSArray *citys = [[provinces allValues] firstObject];
        NSDictionary *city = citys[row];
        
        return [[city allKeys] firstObject];
    }
    else if (component == 2) {
        NSInteger row0 = [pickerView selectedRowInComponent:0];
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        
        NSDictionary *provinces = _items[row0];
        NSArray *citys = [[provinces allValues] firstObject];
        NSArray *distircts = [[citys[row1] allValues] firstObject];
        
        return distircts[row];
    }
    
    return @"1";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for (NSInteger i = component+1; i<3; i++) {
        [pickerView reloadComponent:i];
    }
}

- (void)setDefaultLocationWithProvinceId:(NSString *)provinceId CityId:(NSString *)cityId districtId:(NSString *)districtId
{
//    NSInteger row0 = 0;
//    NSInteger row1 = 0;
//    NSInteger row2 = 0;
//    
//    int i = 0;
//    for (NSDictionary *p in _items) {
//        if ([[[p allKeys] firstObject] isEqualToString:provinceId]) {
//            row0 = i;
//            break;
//        }
//        i++;
//    }
//    
//    if (row0 < [_items count]) {
//        NSArray *province = _items[row0];
//        NSArray *cityitem = [_db getCityListWithProvinceId:province.code];
//        
//        int i = 0;
//        for (YXLocationOrigin *location in cityitem) {
//            if (location.code == [cityId integerValue]) {
//                row1 = i;
//                break;
//            }
//            i++;
//        }
//        
//        
//        if (row1 < [cityitem count]) {
//            YXLocationOrigin *city = cityitem[row1];
//            NSArray *districtItem = [_db getDistrictWithCityId:city.code];
//            
//            int i = 0;
//            for (YXLocationOrigin *location in districtItem) {
//                if (location.code == [districtId integerValue]) {
//                    row2 = i;
//                    break;
//                }
//                i++;
//            }
//        }
//    }
    
//    [self.pickerView selectRow:row0 inComponent:0 animated:YES];
//    [self.pickerView selectRow:row1 inComponent:1 animated:YES];
//    [self.pickerView selectRow:row2 inComponent:2 animated:YES];
//    [self.pickerView reloadAllComponents];
}

- (void)showWithCompleteBlock:(void(^)(NSString *province,NSString *city,NSString *strict))completeBlock
{
    if (self.isShowing) {
        return;
    }
    self.completeBlock = completeBlock;
    self.contentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, CGRectGetHeight([UIScreen mainScreen].bounds)+CGRectGetHeight(self.contentView.bounds)/2);
    
    self.frame = self.window.bounds;
    [self.window addSubview:self];
    self.window.hidden = NO;
    
    __weak YXLocationPicker *wself = self;
    [UIView animateWithDuration:0.4 animations:^{
        wself.contentView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, CGRectGetHeight([UIScreen mainScreen].bounds)-CGRectGetHeight(wself.contentView.bounds)/2);
    } completion:^(BOOL isFinish){
    }];
    
}

- (void)done
{
    NSInteger row0 = [_pickerView selectedRowInComponent:0];
    NSInteger row1 = [_pickerView selectedRowInComponent:1];
    NSInteger row3 = [_pickerView selectedRowInComponent:2];
    NSDictionary *province = _items[row0];
    NSString *provinceName = [[province allKeys] firstObject];
    NSArray *citys = [[province allValues] firstObject];
    NSDictionary *city = citys[row1];
    NSString *cityName = [[city allKeys] firstObject];
    NSArray *districts = [[city allValues] firstObject];
    NSString *dirstictName = districts[row3];
    
    __weak YXLocationPicker *wself = self;
    [self dismissWithBlock:^{
        
        if (wself.completeBlock) {
            wself.completeBlock(provinceName,cityName,dirstictName);
        }
    }];
}

- (void)dismiss
{
    [self dismissWithBlock:nil];
}


- (void)dismissWithBlock:(void (^)(void))block
{
    __weak YXLocationPicker *wself = self;
    [UIView animateWithDuration:0.4 animations:^{
        wself.contentView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, CGRectGetHeight([UIScreen mainScreen].bounds)+CGRectGetHeight(self.contentView.bounds)/2);
    } completion:^(BOOL isFinish){
        if (block) {
            block();
        }
        [wself removeFromSuperview];
        wself.window.hidden = YES;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self;
}
@end
