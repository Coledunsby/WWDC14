//
//  MainViewController.m
//  Cole Dunsby
//
//  Created by Cole Dunsby on 2014-04-03.
//  Copyright (c) 2014 Cole Dunsby. All rights reserved.
//

#import "MainViewController.h"
#import "AnimationController.h"
#import "ZoomAnimationController.h"
#import "FBShimmering/FBShimmeringView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define ACCELEROMETER_TOLERANCE 0.5

@interface MainViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, weak) IBOutlet UIButton *imageView;
@property (nonatomic, weak) IBOutlet FBShimmeringView *shimmeringView;
@property (nonatomic, strong) id<AnimationController> animationController;
@property (nonatomic, strong) UIView *ringView;
@end

@implementation MainViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animationController = [[ZoomAnimationController alloc] init];

    [self setupUI];
    [self setupAnimations];
    [self setupMotionEffects];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0f
                          delay:1.0f
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseOut
                     animations:^{ self.ringView.alpha = 0.0f; self.ringView.transform = CGAffineTransformMakeScale(1.25, 1.25); }
                     completion:^(BOOL finished){ self.ringView.alpha = 1.0f; self.ringView.transform = CGAffineTransformIdentity; }];
}

#pragma mark - Private Methods

- (void)setupUI
{
    self.shimmeringView.shimmering = YES;
    self.shimmeringView.shimmeringBeginFadeDuration = 0.3f;
    self.shimmeringView.shimmeringOpacity = 0.3f;
    self.shimmeringView.shimmeringSpeed = 100.0f;
    self.shimmeringView.contentView = [self.shimmeringView viewWithTag:1];
    
    self.imageView.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
    
    self.ringView = [[UIView alloc] initWithFrame:self.imageView.frame];
    self.ringView.backgroundColor = [UIColor clearColor];
    self.ringView.center = self.imageView.center;
    self.ringView.layer.borderWidth = 1.0f;
    self.ringView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ringView.layer.cornerRadius = self.ringView.frame.size.width / 2;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    
    [self.view addSubview:self.ringView];
    [self.view bringSubviewToFront:self.imageView];
    
    for (UIButton *button in self.buttons) {
        button.center = self.imageView.center;
        button.hidden = YES;
    }
    
    for (UILabel *label in self.labels) {
        label.alpha = 0.0f;
    }
}

- (void)setupAnimations
{
    [UIView animateWithDuration:1.0f animations:^{
        for (UILabel *label in self.labels) {
            label.alpha = 1.0f;
        }
    }];
}

- (void)setupMotionEffects
{
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    for (UIButton *button in self.buttons) {
        [button addMotionEffect:group];
    }
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"id"] isEqual:@"toggle"])
    {
        for (UIButton *button in self.buttons) {
            button.hidden = YES;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
            self.ringView.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
        } completion:^(BOOL finished){
            self.ringView.hidden = NO;
            for (UIButton *button in self.buttons) {
                button.center = self.imageView.center;
            }
        }];
    }
}

#pragma mark - IBActions

- (IBAction)buttonPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *controller;
    
    if ([sender tag] == 0)
    {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    }
    else if ([sender tag] == 1)
    {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"ResumeViewController"];
    }
    else if ([sender tag] == 2)
    {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
    }
    else
    {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"AppsViewController"];
    }
    
    controller.transitioningDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)picturePressed:(id)sender
{
    if (CGPointEqualToPoint([sender center], CGPointMake(self.view.center.x, self.view.center.y + 20))) {
        self.ringView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.center = CGPointMake(225, self.view.center.y + 20);
            self.ringView.center = CGPointMake(225, self.view.center.y + 20);
        } completion:^(BOOL finished){
            for (UIButton *button in self.buttons) {
                button.hidden = NO;
                
                NSValue *from = [NSValue valueWithCGPoint:self.imageView.center];
                NSValue *to;
                
                if (button.tag == 0) {
                    to = [NSValue valueWithCGPoint:CGPointMake(97, (self.view.center.y + 20) - 75)];
                } else if (button.tag == 1) {
                    to = [NSValue valueWithCGPoint:CGPointMake(71, (self.view.center.y + 20) - 25)];
                } else if (button.tag == 2) {
                    to = [NSValue valueWithCGPoint:CGPointMake(72, (self.view.center.y + 20) + 25)];
                } else {
                    to = [NSValue valueWithCGPoint:CGPointMake(103, (self.view.center.y + 20) + 75)];
                }
                
                NSString *keypath = @"position";
                
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keypath];
                [animation setDelegate:self];
                [animation setFromValue:from];
                [animation setToValue:to];
                [animation setDuration:0.6];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 : 1.8 : .8 : 0.8]];
                
                [button.layer addAnimation:animation forKey:@"bounce"];
                [button.layer setValue:to forKeyPath:keypath];
            }
        }];
    } else {
        for (UIButton *button in self.buttons)
        {
            button.hidden = NO;
            
            NSValue *from = [NSValue valueWithCGPoint:button.center];
            NSValue *to = [NSValue valueWithCGPoint:self.imageView.center];
            
            NSString *keypath = @"position";
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keypath];
            [animation setValue:@"toggle" forKey:@"id"];
            [animation setDelegate:self];
            [animation setFromValue:from];
            [animation setToValue:to];
            [animation setDuration:0.6];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 : 1.8 : .8 : 0.8]];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            
            [button.layer addAnimation:animation forKey:@"bounce"];
            [button.layer setValue:to forKeyPath:keypath];
        }
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    return self.animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animationController.isPresenting = NO;
    return self.animationController;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

@end
