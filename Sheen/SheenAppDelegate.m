//
//  SheenAppDelegate.m
//  Sheen
//
//  Created by Matthew Ewer on 11/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SheenAppDelegate.h"
#import "MusicManager.h"
#import "OptionsManager.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SheenAppDelegate ()
@property (strong, nonatomic) MusicManager *musicManager;
@end

@implementation SheenAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [OptionsManager initOptions];
    self.musicManager = [[MusicManager alloc] init];
    //TODO Do checking and locking and all that jazz.
    self.databaseManager = [[DatabaseManager alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    //TODO This doesn't work.
    UIView *view = self.window.rootViewController.view;
    NSLog(@"view %@", view);
    if ([view isKindOfClass:[SKView class]]) {
        NSLog(@"pausing");
        ((SKView *)view).paused = YES;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    //TODO This doesn't work.
    UIView *view = self.window.rootViewController.view;
    NSLog(@"view %@", view);
    if ([view isKindOfClass:[SKView class]]) {
        NSLog(@"unpausing");
        ((SKView *)view).paused = NO;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //TODO Remove MusicManager observers.
}

@end
