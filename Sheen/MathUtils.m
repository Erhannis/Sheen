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

+ (SKColor *)colorInterpolateFromColor:(SKColor *)colorA
                               toColor:(SKColor *)colorB
                               atValue:(CGFloat)value
{
    CGFloat ARed = 0.0;
    CGFloat AGreen = 0.0;
    CGFloat ABlue = 0.0;
    CGFloat AAlpha = 0.0;
    CGFloat BRed = 0.0;
    CGFloat BGreen = 0.0;
    CGFloat BBlue = 0.0;
    CGFloat BAlpha = 0.0;
    [colorA getRed:&ARed green:&AGreen blue:&ABlue alpha:&AAlpha];
    [colorB getRed:&BRed green:&BGreen blue:&BBlue alpha:&BAlpha];
    SKColor *result = [SKColor colorWithRed:(ARed * (1 - value)) + (BRed * value)
                           green:(AGreen * (1 - value)) + (BGreen * value)
                            blue:(ABlue * (1 - value)) + (BBlue * value)
                           alpha:(AAlpha * (1 - value)) + (BAlpha * value)];
    NSLog(@"interpolate %@", result);
    return result;
}

@end
