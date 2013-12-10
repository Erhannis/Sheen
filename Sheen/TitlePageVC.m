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
#import "SaveLoadCDTVC.h"
#import "GamePageVC.h"
#import "LevelInstance+Create.h"
#import "LevelTemplate+Create.h"
#import "Player+Create.h"
#import "SheenAppDelegate.h"
#import "Savegame+Create.h"

@interface TitlePageVC () <UINavigationControllerDelegate>
@property (strong, nonatomic) SKView *skView;
@property (strong, nonatomic) NSManagedObjectContext *context;
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
    NSLog(@"TitlePageVC nav %@", self.navigationController);
    self.navigationController.delegate = self;
    
    UIManagedDocument *document = ((SheenAppDelegate *)([UIApplication sharedApplication].delegate)).databaseManager.document;
    if (document) {
        self.context = document.managedObjectContext;
    } else {
        __weak TitlePageVC *weakself = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          weakself.context = note.userInfo[DatabaseAvailabilityContext];
                                                      }];
    }
    
    
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

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    self.skView.paused = NO;
    // Start music
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeSongRequestNotification
                                                        object:self
                                                      userInfo:@{ChangeSongRequestFilename : @"_ghost_-_Reverie_(small_theme)"}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    self.skView.paused = YES;
    if ([segue.identifier isEqualToString:@"Go New Game"]) {
        ((GamePageVC *)segue.destinationViewController).levelInstance = [LevelInstance createLevelInstanceWithTemplate:[LevelTemplate levelTemplateWithID:DEFAULT_CONNECTED_LEVEL_TEST_1_0
                                                                                                                                   inManagedObjectContext:self.context]
                                                                                                          withSavegame:[Savegame overwriteWithBlankAutosaveInManagedObjectContext:self.context]
                                                                                                inManagedObjectContext:self.context];
        ((GamePageVC *)segue.destinationViewController).player = [Player defaultPlayerInManagedObjectContext:self.context];
        ((GamePageVC *)segue.destinationViewController).player.savegame = ((GamePageVC *)segue.destinationViewController).levelInstance.savegame;
        ((GamePageVC *)segue.destinationViewController).player.curLevel = ((GamePageVC *)segue.destinationViewController).levelInstance;
        NSLog(@"levelInstance %@", ((GamePageVC *)segue.destinationViewController).levelInstance);
        NSLog(@"levelInstance.savegame %@", ((GamePageVC *)segue.destinationViewController).levelInstance.savegame);
        NSLog(@"player %@", ((GamePageVC *)segue.destinationViewController).player);
        NSLog(@"player.savegame %@", ((GamePageVC *)segue.destinationViewController).player.savegame);
        NSLog(@"player.curLevel %@", ((GamePageVC *)segue.destinationViewController).player.curLevel);
    } else if ([segue.identifier isEqualToString:@"Go Load"]) {
        SaveLoadCDTVC *loadCDTV = ((SaveLoadCDTVC *)segue.destinationViewController);
        loadCDTV.saveMode = NO;
        loadCDTV.fromTitlePage = YES;
        loadCDTV.managedObjectContext = self.context;
    } else if ([segue.identifier isEqualToString:@"Go Loaded Game"]) {
        NSLog(@"go loaded game");
        Savegame *savegame = [Savegame getAutosaveInManagedObjectContext:self.context];
        ((GamePageVC *)segue.destinationViewController).player = savegame.player;
        ((GamePageVC *)segue.destinationViewController).levelInstance = savegame.player.curLevel;
    }
}

- (IBAction)returningWithNoRequests:(UIStoryboardSegue *)segue
{
    
}

- (void)doGoLoadedGame
{
    [self performSegueWithIdentifier:@"Go Loaded Game" sender:self];
}

- (IBAction)returningWithGameLoad:(UIStoryboardSegue *)segue
{
    //TODO Currently has potential leaks - click buttons, etc.
    [self performSelector:@selector(doGoLoadedGame) withObject:nil afterDelay:1];
}

@end
