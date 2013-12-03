//
//  GamePageScene.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LevelInstance.h"
#import "Player.h"

@interface GamePageScene : SKScene

- (id)initWithSize:(CGSize)size
     levelInstance:(LevelInstance *)levelInstance
         andPlayer:(Player *)player;

- (void)didTap:(UITapGestureRecognizer *)sender;
- (void)didPinch:(UIPinchGestureRecognizer *)sender;
- (void)didRotation:(UIRotationGestureRecognizer *)sender;
- (void)didPan:(UIPanGestureRecognizer *)sender;
- (void)didLongPress:(UILongPressGestureRecognizer *)sender;

- (void)updateDatabase;
- (void)loadFromDatabase;

@end
