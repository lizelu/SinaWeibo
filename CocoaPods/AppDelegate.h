//
//  AppDelegate.h
//  CocoaPods
//
//  Created by ibokan on 14-9-2.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate ,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
