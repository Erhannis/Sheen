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
#import "MusicManager.h"

@interface TitlePageVC ()
@property (strong, nonatomic) SKView *skView;
@end

@implementation TitlePageVC

- (SKView *)skView
{
    if (!_skView) _skView = (SKView *)self.view;
    return _skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set up scene
    self.skView.showsFPS = DEBUGGING;
    self.skView.showsNodeCount = DEBUGGING;
    self.skView.showsDrawCount = DEBUGGING;

    //TODO Investigate the merits of other options.
    SKScene *scene = [TitlePageScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"TitlePageVC did disappear");
    self.skView.paused = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.skView.paused = NO;
    // Start music
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeSongRequestNotification
                                                        object:self
                                                      userInfo:@{ChangeSongRequestFilename : @"_ghost_-_Reverie_(small_theme)"}];
}

@end
