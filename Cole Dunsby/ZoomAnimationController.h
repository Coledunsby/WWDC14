//
//  ZoomAnimationController.h
//  Notes
//
//  Created by Tope Abayomi on 26/07/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationController.h"

@interface ZoomAnimationController : NSObject <AnimationController>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@property (nonatomic, assign) NSTimeInterval presentationDuration;
@property (nonatomic, assign) NSTimeInterval dismissalDuration;
@property (nonatomic, assign) BOOL isPresenting;

@end
