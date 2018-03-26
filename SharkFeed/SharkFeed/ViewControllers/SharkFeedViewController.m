//
//  SharkFeedViewController.m
//  SharkFeed
//
//  Created by Alfredo Alba on 2/3/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

#import "SharkFeedViewController.h"
#import "SharkFeedCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SharkFeedLightBoxViewController.h"

@interface SharkFeedViewController ()

@end

@implementation SharkFeedViewController

static NSString * const reuseIdentifier = @"sharkCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // additional setup after loading the view.
    
    UIImage *imgageLogo = [UIImage imageNamed:@"SharkFeed_logosmall.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:imgageLogo];
    
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    
    self.sharkObjecjSelected = [[SFShark alloc] init];
    
    self.sharkParse = [[SharkFeedParse alloc] init];
    self.sharkParse.delegate = self;
    
    [self.sharkParse sharkAPICall:@""];
    
    // Refresh
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.sharkCollectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SharkFeedLightBoxViewController *lightBoxVC = (SharkFeedLightBoxViewController *)segue.destinationViewController;
    lightBoxVC.sharkObjecj = self.sharkObjecjSelected;
}

#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sharkElements count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SharkFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSLog(@"%@\n",[NSURL URLWithString:((SFShark *)[self.sharkElements objectAtIndex:indexPath.row]).sharkThumbnail]);
    
    NSString *imageURL = ((SFShark *)[self.sharkElements objectAtIndex:indexPath.row]).sharkThumbnail;
    
    [cell.sharkImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]
                           placeholderImage:[UIImage imageNamed:@"Pull to refresh 2.png"]
                                    success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                        [UIView transitionWithView:cell.sharkImage
                                                          duration:0.3
                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                        animations:^{
                                                            cell.sharkImage.image = image;
                                                        }
                                                        completion:NULL];
                                    } failure:nil];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    if(translation.y > 0) {
        self.refreshView.hidden = NO;

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.refreshView.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.sharkObjecjSelected = [self.sharkElements objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"SFLightBoxSegue" sender:self];
}

#pragma mark CollectionView DataSource

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

#pragma mark CollectionView Paddings

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 5, 20); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

#pragma mark Refresh UI

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    
    [self.sharkParse sharkAPICall:@""];
    
    [self.sharkCollectionView reloadData];
}

#pragma mark SharkFeedParse Delegate

- (void)apiResponse:(NSDictionary *)sharkAPIResponse {
    
    [self.sharkParse sharkSearchParseResponse:sharkAPIResponse Onload:^(NSArray *result, BOOL success) {
        self.sharkElements = [NSArray arrayWithArray:result];
        
        if (success) {
            [self.sharkCollectionView reloadData];
        }
    }];
}

@end
