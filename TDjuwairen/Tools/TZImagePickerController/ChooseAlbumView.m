//
//  ChooseAlbumView.m
//  TZImagePickerController
//
//  Created by ZYP-MAC on 2017/8/25.
//  Copyright © 2017年 谭真. All rights reserved.
//

#define pScreenW [UIScreen mainScreen].bounds.size.width
#define pScreenH [UIScreen mainScreen].bounds.size.height
#define kCellH 80

#import "ChooseAlbumView.h"
#import "TZImageManager.h"
#import "TZAlbumCell.h"
#import "TZAlbumModel.h"

@interface ChooseAlbumView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *bgView;
@property (assign, nonatomic) NSInteger selectedRow;
@property (copy, nonatomic) NSString *lastSelectedName;

@end
@implementation ChooseAlbumView

- (instancetype)initWithCommonViewWithFrame:(CGRect)rect {
    
    if (self = [super init]) {
        self.selectedRow = 0;
        self.bgView = [[UIView alloc] initWithFrame:rect];
        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDone)];
        [self.bgView addGestureRecognizer:tapGester];
        [self addSubview:self.bgView];
        [self addSubview:self.tableView];
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = rect;
    }
    return self;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, pScreenW, 230) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kCellH;
        _tableView.tableFooterView = [UIView new];
         [_tableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];
        
    }
    
    return _tableView;
}


- (void)setDataArr:(NSArray *)dataArr {
    
    _dataArr = dataArr;
    NSInteger selectedI = -1;
    for (TZAlbumModel *model in dataArr) {
        selectedI++;
        if ([model.name isEqualToString:self.lastSelectedName]) {
            self.selectedRow = selectedI;
            break;
            
        }
    }
    [self.tableView reloadData];
    
    
    self.tableView.frame = CGRectMake(0, 0, pScreenW, MIN(5, dataArr.count)*kCellH);
  
    
    if (dataArr.count > 5) {
        
        self.tableView.scrollEnabled = YES;
        
    }else {
        
        self.tableView.scrollEnabled = NO;
        
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell"];
    TZAlbumModel *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedRow == indexPath.row) {
        [self dismissVC:NO];
        return;
    }
    self.selectedRow = indexPath.row;
    TZAlbumModel *model = self.dataArr[indexPath.row];
    self.lastSelectedName = model.name;
    [self.tableView reloadData];
    [self dismissVC:YES];
    
}

#pragma mark - 手势
- (void)bgViewDone {
    [self dismissVC:NO];
}


- (void)dismissVC:(BOOL)needRefesh{
    if (needRefesh) {
        TZAlbumModel *model = self.dataArr[self.selectedRow];
        if (self.filterBlock) {
            self.filterBlock(model,needRefesh);
        }
    }
    
    self.hidden = YES;
}

@end
