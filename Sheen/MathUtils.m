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

@end
