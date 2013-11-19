//
//  Debugging.m
//  Sheen
//
//  Created by Matthew Ewer on 11/19/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Debugging.h"

@implementation Debugging

+ (void)logMessage:(NSString *)msg
        andCGPoint:(CGPoint)point
{
    NSLog(@"%@ - %f,%f", msg, point.x, point.y);
}

@end
