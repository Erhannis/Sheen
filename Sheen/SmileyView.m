//
//  SmileyView.m
//  Sheen
//
//  Created by Matthew Ewer on 12/7/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SmileyView.h"

@implementation SmileyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

#define DEFAULT_STROKE_WIDTH (5.0)
#define DEFAULT_EYE_WIDTH (8.0)

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [path addClip];
    path.lineWidth = DEFAULT_STROKE_WIDTH;
    
    [[UIColor yellowColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    [[UIColor blackColor] setFill];
    
    UIBezierPath *eyeLeft = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.bounds.size.width * 0.3) - (DEFAULT_EYE_WIDTH * 0.5), (self.bounds.size.height * 0.3) - (DEFAULT_EYE_WIDTH * 0.5), DEFAULT_EYE_WIDTH, DEFAULT_EYE_WIDTH)];
    [eyeLeft fill];
    UIBezierPath *eyeRight = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.bounds.size.width * 0.7) - (DEFAULT_EYE_WIDTH * 0.5), (self.bounds.size.height * 0.3) - (DEFAULT_EYE_WIDTH * 0.5), DEFAULT_EYE_WIDTH, DEFAULT_EYE_WIDTH)];
    [eyeRight fill];
    
    UIBezierPath *smile = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
                                                         radius:(self.bounds.size.width * 0.5 * 0.7)
                                                     startAngle:M_PI * (7.0 / 8.0)
                                                       endAngle:M_PI * (1.0 / 8.0)
                                                      clockwise:NO];
    smile.lineWidth = DEFAULT_STROKE_WIDTH;
    [smile stroke];
}

@end
