//
//  Color+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Color.h"
#import <SpriteKit/SpriteKit.h>

@interface Color (Create)

+ (Color *)blankColorInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Color *)colorInManagedObjectContext:(NSManagedObjectContext *)context
                               withRed:(CGFloat)red
                                 green:(CGFloat)green
                                  blue:(CGFloat)blue
                                 alpha:(CGFloat)alpha;
+ (Color *)colorInManagedObjectContext:(NSManagedObjectContext *)context
                           withSKColor:(SKColor *)color;

+ (Color *)twinColor:(Color *)original;

@end
