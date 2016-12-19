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
#import "NetworkManager.h"
#import "StockMarketModel.h"
#import "StockMarketComparisonView.h"
#import "UIButton+WebCache.h"
#import "LoginState.h"


@interface StockMarketViewController ()
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockTypeLabel;
@property (weak, nonatomic) IBOutlet StockMarketComparisonView *comparison;
@property (weak, nonatomic) IBOutlet UILabel *kanzhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *kandieLabel;
@property (weak, nonatomic) IBOutlet UIButton *expressBtn;
@property (weak, nonatomic) IBOutlet UILabel *keyNumberLabel;

@property (nonatomic, strong) StockMarketModel *stockMarket;
@end

@implementation StockMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topView.layer.shadowOpacity = 0.24f;
    self.topView.layer.shadowOffset = CGSizeMake(0, 1);
    
    // 用户头像
    self.avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarBtn.imageView.layer.cornerRadius = 15.0f;
    self.avatarBtn.imageView.clipsToBounds = YES;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav_unLoginAvatar.png"]];
    
    // 背景颜色渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor hx_colorWithHexRGBAString:@"fbae34"].CGColor,(__bridge id)[UIColor hx_colorWithHexRGBAString:@"f57618"].CGColor];
    gradientLayer.locations = @[@(0.47),@(0.83)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight-154);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    if (self.stockType == kStockTypeSZ) {
        self.stockTypeLabel.text = @"上证指数猜涨跌";
    } else {
        self.stockTypeLabel.text = @"创业板指数猜涨跌";
    }
        
    [self requestUserKeysNum];
    [self queryStockMarket];
}


- (void)requestUserKeysNum{

    if (US.isLogIn) {
        NSDictionary *para = @{@"user_id":US.userId};
        NetworkManager *ma = [[NetworkManager alloc] init];
        [ma POST:API_QueryKeyNumber parameters:para completion:^(id data, NSError *error){
            if (!error) {
                NSString *keyNumber = data[@"keyNum"];
                self.keyNumberLabel.text = keyNumber;
            }
        }];
    }
    
    
}

- (void)queryStockMarket {
    
    NSString *type = @"";
    switch (self.stockType) {
        case kStockTypeSZ:
            type = @"sz";
            break;
        case kStockTypeCY:
            type = @"cy";
            break;
        default:
            break;
    }
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    NSDictionary *dict = @{@"block": type};
    if (US.isLogIn) {
        NSAssert(US.userId, @"用户Id不能为空");
        dict = @{@"block": type,@"user_id": US.userId};
    }
    
    [ma GET:@"" parameters:dict completion:^(id data, NSError *error){
        StockMarketModel *model = [[StockMarketModel alloc] initWithDictionary:data];
        self.stockMarket = model;
        [self reloadView];
    }];
}

- (void)reloadView {
//    self.stockLabel.text =
    
    self.kanzhangLabel.text = [NSString stringWithFormat:@"%.0lf%%",self.stockMarket.upPre];
    self.kandieLabel.text = [NSString stringWithFormat:@"%.0lf%%",(1-self.stockMarket.upPre)];
    self.comparison.kandie = 1-self.stockMarket.upPre/100;
}
@end
