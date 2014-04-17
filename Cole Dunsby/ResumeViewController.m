//
//  ResumeViewController.m
//  Cole Dunsby
//
//  Created by Cole Dunsby on 2014-04-03.
//  Copyright (c) 2014 Cole Dunsby. All rights reserved.
//

#import "ResumeViewController.h"

@interface ResumeViewController ()
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray *views;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

@implementation ResumeViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 1422);
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    for (UIView *view in self.views)
    {
        for (UIView *subview in view.subviews)
        {
            if ([subview isKindOfClass:[UILabel class]])
            {
                ((UILabel *)subview).textColor = [UIColor whiteColor];
            }
        }
        
        view.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
