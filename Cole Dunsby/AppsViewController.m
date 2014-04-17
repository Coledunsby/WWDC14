//
//  AppsViewController.m
//  Cole Dunsby
//
//  Created by Cole Dunsby on 2014-04-03.
//  Copyright (c) 2014 Cole Dunsby. All rights reserved.
//

#import "AppsViewController.h"
#import <StoreKit/StoreKit.h>

@interface AppsViewController () <SKStoreProductViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *nowAvailable;
@property (nonatomic, strong) NSArray *comingSoon;
@end

@implementation AppsViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *file = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"]];
    
    self.nowAvailable = [[NSArray alloc] initWithArray:[file objectForKey:@"Now Available"]];
    self.comingSoon = [[NSArray alloc] initWithArray:[file objectForKey:@"Coming Soon"]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 8, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [self.nowAvailable count] : [self.comingSoon count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? @"Now Available" : @"Coming Soon";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *app = (indexPath.section == 0) ? self.nowAvailable[indexPath.row] : self.comingSoon[indexPath.row];
    
    cell.textLabel.text = app[@"title"];
    cell.detailTextLabel.text = app[@"price"];
    cell.imageView.image = [UIImage imageNamed:app[@"image"]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.accessoryType = (indexPath.section == 0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        storeController.delegate = self;
        
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : self.nowAvailable[indexPath.row][@"id"] };
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error)
        {
            [self presentViewController:storeController animated:YES completion:nil];
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
