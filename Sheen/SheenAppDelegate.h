//
//  SheenAppDelegate.h
//  Sheen
//
//  Created by Matthew Ewer on 11/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface SheenAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DatabaseManager *databaseManager;
@end
