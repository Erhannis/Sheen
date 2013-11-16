//
//  Mote.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Mote : SKSpriteNode

@property (nonatomic) CGFloat radius;

// Note that this is technically derived from zPosition and the height of the "camera".
//   However, it's a frequently used and seldom changed property.
@property (nonatomic) CGFloat scale;

@end
