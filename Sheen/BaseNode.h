//
//  BeingNode.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BaseNode : SKSpriteNode

@property (nonatomic) CGPoint lastPosition;
@property (strong, nonatomic) NSString *imageFilename; //TODO Not really applicable for Mote?

@end
