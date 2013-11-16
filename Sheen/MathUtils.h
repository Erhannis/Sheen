//
//  MathUtils.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathUtils : NSObject

+ (CGFloat)mod:(CGFloat)value
       between:(CGFloat)min
           and:(CGFloat)max;

@end
