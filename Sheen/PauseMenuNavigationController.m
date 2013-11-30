//
//  BGImageNavigationController.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PauseMenuNavigationController.h"
#import "BGImageRecipient.h"

@interface PauseMenuNavigationController ()

@end

@implementation PauseMenuNavigationController

- (void)setBackground:(UIImage *)background
{
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc conformsToProtocol:@protocol(BGImageRecipient) ]) {
            [((UIViewController<BGImageRecipient> *)vc) setBackgroundImage:background];
        }
    }
}

@end
