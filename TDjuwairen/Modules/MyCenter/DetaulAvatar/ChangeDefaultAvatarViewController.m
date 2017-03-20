//
//  ChangeDefaultAvatarViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ChangeDefaultAvatarViewController.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "UIMacroDef.h"
#import "MBProgressHUD.h"

@interface ChangeDefaultAvatarViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *items;
@end

@implementation ChangeDefaultAvatarViewController

static NSString * const reuseIdentifier = @"ChangeAvatarCell";

- (id)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置每个cell的大小
    layout.itemSize = CGSizeMake(80, 80);
    //设置每个cell间的最小水平间距
    layout.minimumInteritemSpacing = 5;
    //设置每个cell间的行间距
    layout.minimumLineSpacing = 5;
    //设置每一组距离四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout.headerReferenceSize = CGSizeMake(0, 20);
    layout.footerReferenceSize = CGSizeMake(0, 40);
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.title = @"头像选择";
    self.collectionView.backgroundColor = TDViewBackgrouondColor;
    
    [self queryDefaultAvatarList];
}

- (void)queryDefaultAvatarList {
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_UserGetDetailAvatar parameters:nil completion:^(id data,NSError *error){
        if (!error && [data isKindOfClass:[NSArray class]]) {
            
            self.items = data;
            [self.collectionView reloadData];
        } else {
            
        }
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    
    // Configure the cell
    
    UIImageView *imageView = [cell.contentView viewWithTag:200];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = 200;
        [cell.contentView addSubview:imageView];
    }
    
    NSString *url = self.items[indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:TDDefaultUserAvatar];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = self.items[indexPath.row];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_UserUpdateDetailAvatar parameters:@{@"avatar_url": url} completion:^(id data,NSError *error){
        if (!error) {
            hud.delegate = self;
            [hud hide:YES];
        } else {
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:0.7];
        }
        
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
