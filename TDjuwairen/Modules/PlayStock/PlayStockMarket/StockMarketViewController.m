//
//  StockMarketViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockMarketViewController.h"
#import "HexColors.h"
#import "UIImage+Color.h"

@interface StockMarketViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation StockMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topView.layer.shadowOpacity = 0.24f;
    self.topView.layer.shadowOffset = CGSizeMake(0, 1);
    [self setupSegment];
}

- (void)setupSegment {
    
    [self.segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                           NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                           NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    self.segment.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f46503"];
    self.segment.tintColor = [UIColor hx_colorWithHexRGBAString:@"#e34f08"];
}

- (IBAction)segmentPressed:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex;
        
}
@end
