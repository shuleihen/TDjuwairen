//
//  GuideViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/6/27.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIPageControl *page;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    for (int i = 0; i<3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d-%.0lfH",(i+1),kScreenHeight*[UIScreen mainScreen].scale];
        CGFloat imagex = kScreenWidth * i;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(imagex, 0, kScreenWidth, kScreenHeight)];
        image.image = [UIImage imageNamed:imageName];
        [self.scrollview addSubview:image];
    }
    self.scrollview.pagingEnabled = YES;//设置分页
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.alwaysBounceHorizontal = YES;
    self.scrollview.contentSize = CGSizeMake(kScreenWidth *3, kScreenHeight);
    self.scrollview.delegate = self;
    [self.view addSubview:self.scrollview];
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenHeight-44-10, kScreenWidth, 44)];
    self.page.numberOfPages = 3;
    self.page.currentPage = 0;
    [self.view addSubview:self.page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > 2*kScreenWidth) {
        UITabBarController *tabbarView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        [self presentViewController:tabbarView animated:YES completion:nil];
    }
    int page = floor((scrollView.contentOffset.x - kScreenWidth/2)/kScreenWidth)+1;
    self.page.currentPage = page;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
