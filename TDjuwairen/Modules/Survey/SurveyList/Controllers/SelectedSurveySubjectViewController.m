//
//  SelectedSurveySubjectViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/4/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#define kMargin 12

#import "SelectedSurveySubjectViewController.h"
#import "SurveySubjectModel.h"
#import "HexColors.h"
#import "UIImage+Create.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"

@interface SelectedSurveySubjectViewController ()<MBProgressHUDDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArrM;
@end

@implementation SelectedSurveySubjectViewController
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat cellWH = (kScreenWidth-5*kMargin)/4;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(cellWH, 40);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
        flowLayout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"chooseCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"chooseHeader"];
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_collectionView addGestureRecognizer:longPress];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.title = @"关注选择";
    self.dataArrM = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self querySurveySubject];
}

- (void)querySurveySubject {
    __weak SelectedSurveySubjectViewController *wself = self;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    activity.hidesWhenStopped = YES;
    [self.view addSubview:activity];
    self.collectionView.userInteractionEnabled = NO;
    [activity startAnimating];
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveySubject parameters:nil completion:^(id data, NSError *error) {
        [activity stopAnimating];
        wself.navigationItem.rightBarButtonItem.enabled = YES;
        
        if (!error && data) {
            self.dataArrM = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                SurveySubjectModel *model = [[SurveySubjectModel alloc] initWithDict:dict];
                if (!model.isAtten) {
                    [self.dataArrM addObject:model];
                }
            }
            
            
        } else {
            
        }
        self.collectionView.userInteractionEnabled = YES;
        [wself.collectionView reloadData];
    }];
}

- (void)donePressed:(id)sender {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    for (SurveySubjectModel *sub in self.selectedArray) {
        if (sub.isAtten) {
            [array addObject:sub.subjectId];
        }
    }
    
    NSString *subIds = [NSString stringWithFormat:@"[%@]",[array componentsJoinedByString:@","]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"提交中";
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_SurveyAddSubject parameters:@{@"sub_ids": subIds} completion:^(id data, NSError *error) {
        
        if (!error && data) {
            hud.delegate = self;
            hud.label.text = @"提交成功";
            [hud hideAnimated:YES afterDelay:0.6];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kSubjectChangedNotification object:self.selectedArray];
            
        } else {
            hud.label.text = @"添加关注失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:self.collectionView];
    //从长按开始
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
        if (indexPath.section == 1) {
            [self.collectionView cancelInteractiveMovement];
        }else {
            SurveySubjectModel *model = self.selectedArray[indexPath.item];
            if ([model.subjectId integerValue] == 154 || [model.subjectId integerValue] == 155 || [model.subjectId integerValue] == 156) {
                [self.collectionView cancelInteractiveMovement];
            }else {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            
        }
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [self.collectionView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        
        [self.collectionView endInteractiveMovement];
        
        //其他情况
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
    
}
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    if (proposedIndexPath.section == 1 || proposedIndexPath.item<3) {
        return originalIndexPath;
    }else {
        return proposedIndexPath;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //记录要移动的数据
    id object= self.selectedArray[sourceIndexPath.item];
    //删除要移动的数据
    [self.selectedArray removeObjectAtIndex:sourceIndexPath.item];
    //添加新的数据到指定的位置
    [self.selectedArray insertObject:object atIndex:destinationIndexPath.item];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectedArray.count;
    }else {
        
        return self.dataArrM.count;
    }
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chooseCell" forIndexPath:indexPath];
    for (UILabel *lb in cell.subviews) {
        [lb removeFromSuperview];
    }
    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0];
    label.frame = cell.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:label];
    
    SurveySubjectModel *model = nil;
    if (indexPath.section == 0) {
        label.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#5d9cec"];
        model = self.selectedArray[indexPath.item];
    }else {
        label.textColor = TDTitleTextColor;
        cell.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f1f1f1"];
        model = self.dataArrM[indexPath.item];
    }
    
    if ([model.subjectId integerValue] == 154 || [model.subjectId integerValue] == 155 || [model.subjectId integerValue] == 156) {
        cell.userInteractionEnabled = NO;
    }else {
        cell.userInteractionEnabled = YES;
    }
    
    label.text = model.subjectTitle;
    return cell;
}

- (__kindof UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"chooseHeader" forIndexPath:indexPath];
        for (UILabel *lb in headerView.subviews) {
            [lb removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 0, 100, 50);
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#111111"];
        label.font = [UIFont systemFontOfSize:16];
        [headerView addSubview:label];
        if (indexPath.section == 0) {
            label.text = @"已选板块";
            UILabel *desLabel = [[UILabel alloc] init];
            desLabel.frame = CGRectMake(kScreenWidth-200, 0, 180, 50);
            desLabel.text = @"按住拖动调整排序";
            desLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#c8c8c8"];
            desLabel.font = [UIFont systemFontOfSize:16];
            desLabel.textAlignment = NSTextAlignmentRight;
            [headerView addSubview:desLabel];
        }else {
            label.text = @"常规板块";
        }
        reusableView = headerView;
    }
    return reusableView;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 选中模块
        SurveySubjectModel *subject = self.selectedArray[indexPath.item];
        subject.isAtten = NO;
        [self.dataArrM insertObject:subject atIndex:0];
        [self.selectedArray removeObjectAtIndex:indexPath.item];
    }else {
        SurveySubjectModel *subject = self.dataArrM[indexPath.item];
        subject.isAtten = YES;
        [self.selectedArray addObject:subject];
        [self.dataArrM removeObjectAtIndex:indexPath.item];
    }
    [self.collectionView reloadData];
}



@end
