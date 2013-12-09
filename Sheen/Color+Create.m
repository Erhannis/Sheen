//
//  Color+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Color+Create.h"

@implementation Color (Create)

+ (Color *)blankColorInManagedObjectContext:(NSManagedObjectContext *)context
{
    Color *color = nil;
    color = [NSEntityDescription insertNewObjectForEntityForName:@"Color"
                                          inManagedObjectContext:context];
    return color;
}

+ (Color *)colorInManagedObjectContext:(NSManagedObjectContext *)context
                               withRed:(CGFloat)red
                                 green:(CGFloat)green
                                  blue:(CGFloat)blue
                                 alpha:(CGFloat)alpha
{
    Color *color = [Color blankColorInManagedObjectContext:context];
    
    color.red = [NSNumber numberWithFloat:red];
    color.green = [NSNumber numberWithFloat:green];
    color.blue = [NSNumber numberWithFloat:blue];
    color.alpha = [NSNumber numberWithFloat:alpha];
    
    return color;
}

+ (Color *)twinColor:(Color *)original
{
    if (!original) {
        return nil;
    }
        
    Color *color = [Color blankColorInManagedObjectContext:original.managedObjectContext];
    
    color.red = original.red;
    color.green = original.green;
    color.blue = original.blue;
    color.alpha = original.alpha;
    
    return color;
}

@end
