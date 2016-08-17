//
//  FeedbackTableViewCell.h
//  juwairen
//
//  Created by tuanda on 16/5/25.
//  Copyright © 2016年 tuanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)cellforDic:(NSDictionary*)dic;
-(void)setContentText:(NSString*)text;
@end
