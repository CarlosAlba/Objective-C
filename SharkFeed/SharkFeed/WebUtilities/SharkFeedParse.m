//
//  SharkFeedParse.m
//  SharkFeed
//
//  Created by Alfredo Alba on 2/4/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//


#import "SharkFeedParse.h"
#import "SFShark.h"

NSString * const k_SharkAPI = @"949e98778755d1982f537d56236bbb42";
NSString * const k_SharkURL = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&text=Animal_Sharks&format=json&nojsoncallback=1&page=1&extras=url_t,url_c,url_l,url_o&api_key=";

@implementation SharkFeedParse

NSURLSession *sharkSession;

#pragma mark API Methods

- (void)sharkAPICall:(NSString *)sharkURL {
    NSURLSessionConfiguration* configurationSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    configurationSession.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    configurationSession.timeoutIntervalForResource = 60.0;
    
    sharkSession = [NSURLSession sessionWithConfiguration:configurationSession];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",
                                       k_SharkURL,
                                       k_SharkAPI,
                                       sharkURL]];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [sharkSession dataTaskWithRequest:req completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(),^{
                                              
                                              NSMutableDictionary *httpResponse = [[NSMutableDictionary alloc]init];
                                              
                                              if(data) {
                                                  [httpResponse setObject:data forKey:@"data"];
                                              }
                                              if(response) {
                                                  [httpResponse setObject:response forKey:@"response"];
                                              }
                                              if(error) {
                                                  [httpResponse setObject:error forKey:@"error"];
                                              }
                                              if([[httpResponse allKeys]count] > 0) {
                                                  [self.delegate apiResponse:[httpResponse copy]];
                                              }
                                              
                                              [sharkSession finishTasksAndInvalidate];
                                          });
                                          
                                      }];
    [dataTask resume];
}

#pragma mark Parse Methods

- (void)sharkSearchParseResponse:(NSDictionary *)response Onload:(void(^)(NSArray *result, BOOL success))onLoaded {
    NSMutableArray *sharkElements = [[NSMutableArray alloc] init];
    NSData *data = response[@"data"];
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if(jsonData) {
        NSArray *photoElements = jsonData[@"photos"][@"photo"];
        
        for (NSDictionary *element in photoElements)
        {
            SFShark *sharkObject = [[SFShark alloc] init];
            
            sharkObject.sharkID =        element[@"id"];
            sharkObject.sharkOriginal =  [self cleanURL:element[@"url_o"]];
            sharkObject.sharkMedium =    [self cleanURL:element[@"url_c"]];
            sharkObject.sharkLarge =     [self cleanURL:element[@"url_l"]];
            sharkObject.sharkThumbnail = [self cleanURL:element[@"url_t"]];
            
            [sharkElements addObject:sharkObject];
        }
        
        onLoaded([NSArray arrayWithArray:sharkElements] , YES);
    } else {
        onLoaded(nil, NO);
    }
}

- (void)sharkGetInfoParseResponse:(NSDictionary *)response Onload:(void(^)(NSString *result, BOOL success))onLoaded {
    NSData *data = response[@"data"];
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if(jsonData) {
        NSString *sharkDescription = jsonData[@"photo"][@"description"][@"_content"];
        
        onLoaded([sharkDescription
                  stringByReplacingOccurrencesOfString:@"\n" withString:@""], YES);
    } else {
        onLoaded(nil, NO);
    }
}

#pragma mark Other Methods

- (NSString *)cleanURL:(NSString *)url {
    NSString *outputURL = @"";
    
    BOOL notNSNull = ![url isKindOfClass:[NSNull class]];
    BOOL isAString = [url isKindOfClass:[NSString class]];
    BOOL isANumber = [url isKindOfClass:[NSNumber class]];
    
    if(url && isAString && notNSNull) {
        outputURL = url;
    }
    if(isANumber) {
        NSNumber *numberURL = (NSNumber*)url;
        outputURL = [numberURL stringValue];
    }
    return outputURL;
}

@end
