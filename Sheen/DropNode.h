//
//  Drop.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseNode.h"

@interface DropNode : BaseNode

#define DEFAULT_DROP_RADIUS (50.0)

@property (nonatomic) CGFloat radius;

@end
