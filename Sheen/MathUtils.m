//
//  MathUtils.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "MathUtils.h"

@implementation MathUtils

+ (CGFloat)mod:(CGFloat)value
       between:(CGFloat)min
           and:(CGFloat)max
{
    // Ugh.  Frigging weird mod operators.
    return fmodf(fmodf(value - min, max - min) + (max - min), max - min) + min;
}

+ (CGPathRef)circleOfRadius:(CGFloat)radius
                   centeredOn:(CGPoint)center
{
    return [MathUtils circleOfRadius:radius centeredOnX:center.x andOnY:center.y];
}

+ (CGPathRef)circleOfRadius:(CGFloat)radius
                  centeredOnX:(CGFloat)x
                       andOnY:(CGFloat)y
{
    return CGPathCreateWithEllipseInRect(CGRectMake(x - radius, y - radius, 2 * radius, 2 * radius), NULL);
}

@end
