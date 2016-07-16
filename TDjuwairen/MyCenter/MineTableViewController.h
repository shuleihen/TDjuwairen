//
//  MineTableViewController.h
//  juwairen
//
//  Created by tuanda on 16/5/16.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewController : UITableViewController
- (IBAction)commentBtn:(UIButton *)sender;
- (IBAction)collectionBtn:(UIButton *)sender;
- (IBAction)browserBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
