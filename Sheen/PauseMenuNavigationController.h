//
//  BGImageNavigationController.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Savegame.h"

@interface PauseMenuNavigationController : UINavigationController

@property (strong, nonatomic) UIImage *background;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
