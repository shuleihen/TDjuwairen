//
//  ChildBlogTableViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/24.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "ChildBlogTableViewController.h"
#import "NetworkManager.h"

@interface ChildBlogTableViewController ()

@property (nonatomic,assign) int typeID;

@end

@implementation ChildBlogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestShowList:(int)typeID
{
    if (typeID == 0) {
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@index.php/Blog/blogSurveyList",kAPI_bendi];
        NSDictionary *dic = @{
                              @"user_id":@"85",
                              @"page":@"1",
                              };
        [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                NSLog(@"%@",data);
            }
            else
            {
                NSLog(@"%@",error);
            }
        }];
    }
    else if (typeID == 1)
    {
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@index.php/Blog/blogViewLists",kAPI_bendi];
        NSDictionary *dic = @{
                              @"user_id":@"478",
                              @"page":@"1",
                              };
        [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
            if (!error) {
                NSLog(@"%@",data);
            }
            else
            {
                NSLog(@"%@",error);
            }
        }];
    }
    else
    {
        //
        NSLog(@"这里要报错");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"苍茫的天涯是我的爱";
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
