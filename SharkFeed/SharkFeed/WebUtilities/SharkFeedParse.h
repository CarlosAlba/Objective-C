//
//  SharkFeedParse.h
//  SharkFeed
//
//  Created by Alfredo Alba on 2/4/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const k_SharkAPI;
extern NSString * const k_SharkURL;

// delegate

@protocol SharkFeedParseDelegate <NSObject>

@required
- (void)apiResponse:(NSDictionary*)sharkAPIResponse;

@end

@interface SharkFeedParse : NSObject

@property (nonatomic, weak) id <SharkFeedParseDelegate> delegate;

- (void)sharkAPICall:(NSString *)sharkURL;
- (void)sharkSearchParseResponse:(NSDictionary *)response Onload:(void(^)(NSArray *result, BOOL success))onLoaded;
- (void)sharkGetInfoParseResponse:(NSDictionary *)response Onload:(void(^)(NSString *result, BOOL success))onLoaded;

@end
