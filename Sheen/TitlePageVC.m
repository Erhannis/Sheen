//
//  TitlePageVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/15/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "TitlePageVC.h"
#import "debugging.h"
#import "TitlePageScene.h"

@interface TitlePageVC ()

@end

@implementation TitlePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = DEBUGGING;
    skView.showsNodeCount = DEBUGGING;
    skView.showsDrawCount = DEBUGGING;

    //TODO Investigate the merits of other options.
    SKScene *scene = [TitlePageScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
