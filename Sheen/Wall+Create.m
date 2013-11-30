//
//  Wall+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/28/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//
//  Thanks to Michael Heyeck of mlsite.net for the general idea of the path conversion functions.
//

#import "Wall+Create.h"

@implementation Wall (Create)

+ (Wall *)blankWallInManagedObjectContext:(NSManagedObjectContext *)context
{
    Wall *wall = nil;
    wall = [NSEntityDescription insertNewObjectForEntityForName:@"Wall"
                                         inManagedObjectContext:context];
    return wall;
}

+ (NSData *)dataFromPath:(CGPathRef)path
{
    NSMutableData *data = [[NSMutableData alloc] init];
    CGPathApply(path, (__bridge void *)(data), applier);
    return [data copy];
}

static void applier(void *info, const CGPathElement *element) {
    NSMutableData *data = (__bridge NSMutableData *)info;
    
    NSInteger pointCount = 0;
    switch (element->type) {
        case kCGPathElementAddCurveToPoint:
            pointCount = 3;
            break;
        case kCGPathElementAddLineToPoint:
            pointCount = 1;
            break;
        case kCGPathElementAddQuadCurveToPoint:
            pointCount = 2;
            break;
        case kCGPathElementCloseSubpath:
            pointCount = 0;
            break;
        case kCGPathElementMoveToPoint:
            pointCount = 1;
            break;
        default:
            break;
    }
    
    [data appendBytes:&(element->type) length:sizeof(CGPathElementType)];
    [data appendBytes:element->points length:(pointCount * sizeof(CGPoint))];
}

// You are responsible for releasing the path returned, whatever that means.
+ (CGPathRef)pathFromData:(NSData *)data
{
    NSUInteger pos = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathElementType *type = malloc(sizeof(CGPathElementType));
    CGPoint *points = malloc(3 * sizeof(CGPoint)); // 3 is the most points we should encounter
    while (pos < [data length]) {
        [data getBytes:type range:NSMakeRange(pos, sizeof(CGPathElementType))];
        pos += sizeof(CGPathElementType);
        
        NSInteger pointCount = 0;
        switch (*type) {
            case kCGPathElementAddCurveToPoint:
                pointCount = 3;
                [data getBytes:points range:NSMakeRange(pos, pointCount * sizeof(CGPoint))];
                pos += pointCount * sizeof(CGPoint);

                CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
                break;
            case kCGPathElementAddLineToPoint:
                pointCount = 1;
                [data getBytes:points range:NSMakeRange(pos, pointCount * sizeof(CGPoint))];
                pos += pointCount * sizeof(CGPoint);
                
                CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                break;
            case kCGPathElementAddQuadCurveToPoint:
                pointCount = 2;
                pos += pointCount * sizeof(CGPoint);
                [data getBytes:points range:NSMakeRange(pos, pointCount * sizeof(CGPoint))];
                
                CGPathAddQuadCurveToPoint(path, NULL, points[0].x, points[0].y, points[1].x, points[1].y);
                break;
            case kCGPathElementCloseSubpath:
                pointCount = 0;
                [data getBytes:points range:NSMakeRange(pos, pointCount * sizeof(CGPoint))];
                pos += pointCount * sizeof(CGPoint);
                
                CGPathCloseSubpath(path);
                break;
            case kCGPathElementMoveToPoint:
                pointCount = 1;
                [data getBytes:points range:NSMakeRange(pos, pointCount * sizeof(CGPoint))];
                pos += pointCount * sizeof(CGPoint);

                CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                break;
            default:
                //TODO Consider whether we DO want to error on invalid element type.
                break;
        }
    }
    free(type);
    free(points);
    
    return path;
}

@end
