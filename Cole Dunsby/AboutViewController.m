//
//  AboutViewController.m
//  Cole Dunsby
//
//  Created by Cole Dunsby on 2014-04-03.
//  Copyright (c) 2014 Cole Dunsby. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

@implementation AboutViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 380);
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openWebsite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jcdigitalapps.wordpress.com"]];
}

#pragma mark - Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    float x = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) ? MAX(self.view.bounds.size.width, self.view.bounds.size.height) / 2 : MIN(self.view.bounds.size.width, self.view.bounds.size.height) / 2;
    
    [UIView animateWithDuration:duration animations:^{
        self.contentView.center = CGPointMake(x, self.contentView.center.y);
    }];
}

@end
