//
//  SharkFeedLightBoxViewController.m
//  SharkFeed
//
//  Created by Alfredo Alba on 2/3/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

#import "SharkFeedLightBoxViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SharkFeedLightBoxViewController ()

@end

@implementation SharkFeedLightBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Change color of NavigationBar Items.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Adding Space in UIButtons
    CGFloat spacing = 10; // the amount of spacing to appear between image and title
    self.SFDownloadButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.SFDownloadButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    self.SFFlicrButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.SFFlicrButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    [self initLightBoxWithSharkObject:self.sharkObjecj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Methods

- (void)initLightBoxWithSharkObject:(SFShark *)shark {
    self.sharkImageUrl = [NSURL URLWithString:shark.sharkThumbnail];
    
    if (![shark.sharkMedium isEqualToString:@""]) {
        self.sharkImageUrl = [NSURL URLWithString:shark.sharkMedium];
    } else if (![shark.sharkLarge isEqualToString:@""]) {
        self.sharkImageUrl = [NSURL URLWithString:shark.sharkLarge];
    } else if (![shark.sharkOriginal isEqualToString:@""]) {
        self.sharkImageUrl = [NSURL URLWithString:shark.sharkOriginal];
    }
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:self.sharkImageUrl];
    
    [self.activityIndicator startAnimating];
    
    [self.SFLighboxImage setImageWithURLRequest:imageRequest
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         [self.activityIndicator stopAnimating];
         self.SFLighboxImage.image = image;
     }
    failure:nil];
    
    self.SFDownloadButton.enabled = YES;
    self.SFFlicrButton.enabled = YES;
    
    self.sharkParse = [[SharkFeedParse alloc] init];
    self.sharkParse.delegate = self;
    
    NSString *sharkGetInfoURL = @"&photo_id=";
    NSString *sharkGetInfoID = self.sharkObjecj.sharkID;
    NSString *sharkGetInfoSuffix =  @"";
    
    [self.sharkParse sharkAPICall:[NSString stringWithFormat:@"%@%@%@",
                                   sharkGetInfoURL,
                                   sharkGetInfoID,
                                   sharkGetInfoSuffix]];
}

#pragma mark IBActions

- (IBAction)SFDownloadActionButton:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.SFLighboxImage.image, self, @selector(completitionSaveImage:savedPhotoInAlbumWithError:completition:), NULL);
}

- (void)completitionSaveImage:(UIImage *)image savedPhotoInAlbumWithError:(NSError *)error completition:(void*)context {
    NSString *messageFromSaving = @"";
    
    if (error) {
        messageFromSaving = @"Image can not be Save, Try later.";
    } else {
        messageFromSaving = @"Saved Successfully.";
    }
    
    UIAlertController *saveImageAlert = [UIAlertController alertControllerWithTitle:@"Save Image" message:messageFromSaving preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *okAction) {
        
    [self dismissViewControllerAnimated:NO completion:^(){}];
        
    }];
    
    [saveImageAlert addAction:okAction];
    
    [self presentViewController:saveImageAlert animated:YES completion:nil];
}

- (IBAction)SFFlicrActionButton:(UIButton *)sender {
    
    if(self.sharkImageUrl) {
        [[UIApplication sharedApplication] openURL:self.sharkImageUrl options:@{} completionHandler:nil];
    }
}

#pragma mark SharkFeedParse Delegate

- (void)apiResponse:(NSDictionary *)sharkAPIResponse {
    
    [self.sharkParse sharkGetInfoParseResponse:sharkAPIResponse Onload:^(NSString *result, BOOL success) {
        
        if (success) {
            self.SFDescriptionLabel.text = result;
        }
    }];
}

@end
