//
//  GamePageScene.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GamePageScene : SKScene

- (void)didTap:(UITapGestureRecognizer *)sender;
- (void)didPinch:(UIPinchGestureRecognizer *)sender;
- (void)didRotation:(UIRotationGestureRecognizer *)sender;
- (void)didPan:(UIPanGestureRecognizer *)sender;
- (void)didLongPress:(UILongPressGestureRecognizer *)sender;

@end
