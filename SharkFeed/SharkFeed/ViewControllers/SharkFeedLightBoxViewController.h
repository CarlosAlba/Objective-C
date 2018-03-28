//
//  SharkFeedLightBoxViewController.h
//  SharkFeed
//
//  Created by Alfredo Alba on 2/3/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFShark.h"
#import "SharkFeedParse.h"

@interface SharkFeedLightBoxViewController : UIViewController <SharkFeedParseDelegate>

@property (strong, nonatomic) SFShark          * sharkObjecj;
@property (strong, nonatomic) SharkFeedParse   * sharkParse;
@property (strong, nonatomic) NSURL            * sharkImageUrl;


// MARK: IBOutlet

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *SFLighboxImage;
@property (weak, nonatomic) IBOutlet UILabel     *SFDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton    *SFDownloadButton;
@property (weak, nonatomic) IBOutlet UIButton    *SFFlicrButton;


// MARK: IBAction
- (IBAction)SFBackButton:(UIButton *)sender;
- (IBAction)SFDownloadActionButton:(UIButton *)sender;
- (IBAction)SFFlicrActionButton:(UIButton *)sender;

@end
