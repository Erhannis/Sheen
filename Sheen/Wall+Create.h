//
//  Wall+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/28/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Wall.h"

@interface Wall (Create)

+ (Wall *)blankWallInManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSData *)dataFromPath:(CGPathRef)path;
+ (CGPathRef)pathFromData:(NSData *)data;

@end
