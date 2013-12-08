//
//  Debugging.h
//  Sheen
//
//  Created by Matthew Ewer on 11/19/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUGGING NO

@interface Debugging : NSObject

+ (void)logMessage:(NSString *)msg
        andCGPoint:(CGPoint)point;

@end
