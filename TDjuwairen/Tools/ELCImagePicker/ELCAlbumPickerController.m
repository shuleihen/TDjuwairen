//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"

@interface ELCAlbumPickerController ()
{
    UIView *statusView;
}

@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation ELCAlbumPickerController

//Using auto synthesizers

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.contentInset=UIEdgeInsetsMake(-25, 0, 0, 0);
    [self setNavigationBar];
//	[self.navigationItem setTitle:@"加载中"];

//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
    
    //    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelImagePicker)];
    
    //	[self.navigationItem setRightBarButtonItem:cancelBtn];
    
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self.parent action:@selector(cancelImagePicker)];
    cancelBtn.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=cancelBtn;
    

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;

    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
    {
        @autoreleasepool {
        
        // Group enumerator Block
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
            {
                if (group == nil) {
                    return;
                }
                
                // added fix for camera albums order
                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                
                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                    [self.assetGroups insertObject:group atIndex:0];
                }
                else {
                    [self.assetGroups addObject:group];
                }

                // Reload albums
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            };
            
            // Group Enumerator Failure Block
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                NSLog(@"A problem occured %@", [error description]);	                                 
            };	
                    
            // Enumerate Albums
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator 
                                 failureBlock:assetGroupEnumberatorFailure];
        
        }
    });    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [statusView removeFromSuperview];
}

-(void)setNavigationBar{
    UILabel *navTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    navTitle.text=@"选择相册";
    navTitle.font=[UIFont boldSystemFontOfSize:17];
    navTitle.textColor=[UIColor blackColor];
    self.navigationItem.titleView=navTitle;
    statusView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen ].bounds.size.width, 20)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
   // UIColor *color=[UIColor colorWithRed:217/255.0 green:64/255.0 blue:26/255.0 alpha:1];
    //    UIColor *color=[UIColor colorWithRed:74.0/255 green:234.0/255 blue:189.0/255 alpha:0];
   // statusView.backgroundColor=color;
    [self.navigationController.navigationBar addSubview:statusView];
   // [self.navigationController.navigationBar setBackgroundColor:color];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage* image = [UIImage imageNamed:@"back"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)reloadTableView
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"选择相册"];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    cell.textLabel.textAlignment=NSTextAlignmentRight;
    
//    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
//    cell.imageView.center=cell.center;
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 70, 70)];
    imgView.image=[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]];
    [cell addSubview:imgView];
    
//	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
	picker.parent = self;

    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
	
	[self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end

