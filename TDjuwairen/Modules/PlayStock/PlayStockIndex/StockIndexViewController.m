//
//  StockIndexViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/12/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "StockIndexViewController.h"
#import "TDWebViewController.h"
#import "StockIndexCell.h"

@interface StockIndexViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StockIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(messagePressed:)];
    
    UINib *nib = [UINib nibWithNibName:@"StockIndexCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StockIndexCellID"];
}

#pragma mark - Action
- (IBAction)walletPressed:(id)sender {
}

- (IBAction)myGuessPressed:(id)sender {
}

- (IBAction)rulePressed:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PlayStockIndexRule" withExtension:@"html"];
    TDWebViewController *vc = [[TDWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messagePressed:(id)sender {
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockIndexCellID"];
    
    return cell;
}
@end
