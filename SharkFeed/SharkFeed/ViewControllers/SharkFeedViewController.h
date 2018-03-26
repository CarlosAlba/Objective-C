//
//  SharkFeedViewController.h
//  SharkFeed
//
//  Created by Alfredo Alba on 2/3/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharkFeedParse.h"
#import "SFShark.h"

@interface SharkFeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, SharkFeedParseDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray          * sharkElements;
@property (strong, nonatomic) SharkFeedParse   * sharkParse;
@property (strong, nonatomic) SFShark          * sharkObjecjSelected;

@property (nonatomic, assign) CGFloat lastContentOffset;

// MARK: IBOutlet

@property (weak, nonatomic) IBOutlet UIView *refreshView;
@property (strong, nonatomic) IBOutlet UICollectionView *sharkCollectionView;

@end
