//
//  PhotosViewController.m
//  Cole Dunsby
//
//  Created by Cole Dunsby on 2014-04-03.
//  Copyright (c) 2014 Cole Dunsby. All rights reserved.
//

#import "PhotosViewController.h"

#define CELL_IMAGE_TAG 1
#define BACKGROUND_VIEW_TAG 2
#define FULL_IMAGE_TAG 3
#define CLOSE_BUTTON_TAG 4
#define CAPTION_BACKGROUND_TAG 5
#define CAPTION_TAG 6

@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSArray *images;
@end

@implementation PhotosViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photos" ofType:@"plist"]];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - Private Methods

- (void)dismissImage
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
    UIView *backgroundView = [self.view viewWithTag:BACKGROUND_VIEW_TAG];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:FULL_IMAGE_TAG];
    UIButton *closeButton = (UIButton *)[self.view viewWithTag:CLOSE_BUTTON_TAG];
    UIView *captionBackground = [self.view viewWithTag:CAPTION_BACKGROUND_TAG];
    UILabel *caption = (UILabel *)[self.view viewWithTag:CAPTION_TAG];
    
    [UIView animateWithDuration:0.5f animations:^{
        backgroundView.alpha = 0.0f;
        closeButton.alpha = 0.0f;
        caption.alpha = 0.0f;
        captionBackground.alpha = 0.0f;
        imageView.frame = [self.view convertRect:cell.frame fromView:self.collectionView];
    }completion:^(BOOL finished){
        [backgroundView removeFromSuperview];
        [imageView removeFromSuperview];
        [closeButton removeFromSuperview];
        [caption removeFromSuperview];
        [captionBackground removeFromSuperview];
    }];
}

#pragma mark - IBActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.image = [UIImage imageNamed:self.images[indexPath.row][@"image"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = CELL_IMAGE_TAG;
    [cell addSubview:imageView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.tag = BACKGROUND_VIEW_TAG;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0f;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self.view convertRect:cell.frame fromView:self.collectionView]];
    imageView.tag = FULL_IMAGE_TAG;
    imageView.image = ((UIImageView *)[cell viewWithTag:CELL_IMAGE_TAG]).image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    closeButton.tag = CLOSE_BUTTON_TAG;
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"close_selected"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(dismissImage) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha = 0.0f;
    
    UIView *captionBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30)];
    captionBackground.tag = CAPTION_BACKGROUND_TAG;
    captionBackground.backgroundColor = [UIColor blackColor];
    captionBackground.alpha = 0.0f;
    captionBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.view.bounds.size.height - 25, self.view.bounds.size.width - 10, 20)];
    captionLabel.tag = CAPTION_TAG;
    captionLabel.text = self.images[indexPath.row][@"caption"];
    captionLabel.textColor = [UIColor whiteColor];
    captionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    captionLabel.alpha = 0.0f;
    captionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:imageView];
    [self.view addSubview:closeButton];
    [self.view addSubview:captionBackground];
    [self.view addSubview:captionLabel];
    
    [UIView animateWithDuration:0.5f animations:^{
        backgroundView.alpha = 1.0f;
        closeButton.alpha = 1.0f;
        captionBackground.alpha = 0.5f;
        captionLabel.alpha = 1.0f;
        imageView.frame = self.view.bounds;
    }];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
