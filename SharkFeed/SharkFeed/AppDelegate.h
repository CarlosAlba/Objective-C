//
//  AppDelegate.h
//  SharkFeed
//
//  Created by Alfredo Alba on 2/3/18.
//  Copyright © 2018 Carlos Alba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

