//
//  GamePageVC.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelInstance.h"
#import "Player.h"

@interface GamePageVC : UIViewController
@property (strong, nonatomic) LevelInstance *levelInstance;
@property (strong, nonatomic) Player *player;
@end
