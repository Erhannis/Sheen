//
//  GamePageVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//
//  Thanks to WALL of picopikopon.blogspot.com, from whose code I extrapolated the CIImage->NSData code.
//

#import "GamePageVC.h"
#import <CoreImage/CoreImage.h>
#import <SpriteKit/SpriteKit.h>
#import "PauseMenuNavigationController.h"
#import "debugging.h"
#import "GamePageScene.h"
#import "MusicManager.h"
#import "DatabaseManager.h"
#import "Savegame+Create.h"
#import "InventoryCDTVC.h"

@interface GamePageVC ()
@property (strong, nonatomic) NSTimer *navHideTimer;
@property (strong, nonatomic) GamePageScene *gamePageScene;
@property (strong, nonatomic) SKView *skView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

@implementation GamePageVC

#define NAV_BAR_HIDE_DELAY (2)

- (GamePageScene *)gamePageScene
{
    //TODO Investigate the merits of other options.
    if (!_gamePageScene) _gamePageScene = [[GamePageScene alloc] initWithSize:self.skView.bounds.size
                                                                levelInstance:self.levelInstance
                                                                    andPlayer:self.player];
    return _gamePageScene;
}

- (SKView *)skView
{
    if (!_skView) _skView = (SKView *)self.view;
    return _skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"GamePageVC did load");
    NSLog(@"GamePageVC dl %@", self);
    [self.navigationController setNavigationBarHidden:YES];
        
    // Set up scene
    self.skView.showsFPS = DEBUGGING;
    self.skView.showsNodeCount = DEBUGGING;
    self.skView.showsDrawCount = DEBUGGING;
    
    // Set up gesture recognizers
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedTap:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPinch:)];
    [self.view addGestureRecognizer:self.pinchGestureRecognizer];
    self.rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedRotation:)];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedLongPress:)];
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
    
    [self.skView presentScene:self.gamePageScene];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"GamePageVC did appear");
    [self hideNavBar];
    self.skView.paused = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickShow:(id)sender {
    //TODO We probably don't actually want the bar, here.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navHideTimer invalidate];
    self.navHideTimer = [NSTimer scheduledTimerWithTimeInterval:NAV_BAR_HIDE_DELAY
                                                         target:self
                                                       selector:@selector(hideNavBar)
                                                       userInfo:nil
                                                        repeats:NO];
//    [self performSegueWithIdentifier:@"Go To Inventory" sender:self];
}

- (void)hideNavBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    [self.navHideTimer invalidate];
    self.navHideTimer = nil;
    if ([segue.identifier isEqualToString:@"Pause Game"]) {
        //TODO Prepare for later rotation?
        self.skView.paused = YES;
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, self.view.window.screen.scale);
        [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CIImage *ciImage = image.CIImage ? image.CIImage : [CIImage imageWithCGImage:image.CGImage];
        CGRect origExtent = ciImage.extent;
        CIFilter *filter;
        
        CGFloat shortEdge = MIN(ciImage.extent.size.width, ciImage.extent.size.height);

        CIImage *thumbnail = [ciImage imageByCroppingToRect:CGRectMake((ciImage.extent.size.width / 2) - (shortEdge / 2), (ciImage.extent.size.height / 2) - (shortEdge / 2), shortEdge, shortEdge)];
        thumbnail = [thumbnail imageByApplyingTransform:CGAffineTransformMakeScale(DATABASE_THUMBNAIL_EDGE_LENGTH / shortEdge, DATABASE_THUMBNAIL_EDGE_LENGTH / shortEdge)];
        thumbnail = [thumbnail imageByApplyingTransform:CGAffineTransformMakeTranslation(-thumbnail.extent.origin.x, -thumbnail.extent.origin.y)];
        
        filter = [CIFilter filterWithName:@"CIAffineClamp"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
        [filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
        ciImage = [filter valueForKey:kCIOutputImageKey];
        
        filter = [CIFilter filterWithName:[CIFilter filterNamesInCategory:kCICategoryBlur].firstObject];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:10.0] forKey:kCIInputRadiusKey];
        ciImage = [filter valueForKey:kCIOutputImageKey];

        filter = [CIFilter filterWithName:@"CIColorMatrix"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        CGFloat white = 0.01;
        [filter setValue:[CIVector vectorWithX:(1-white) Y:0 Z:0 W:0] forKey:@"inputRVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:(1-white) Z:0 W:0] forKey:@"inputGVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:(1-white) W:0] forKey:@"inputBVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"];
        [filter setValue:[CIVector vectorWithX:white Y:white Z:white W:0] forKey:@"inputBiasVector"];
        ciImage = [filter valueForKey:kCIOutputImageKey];
        
        ciImage = [ciImage imageByCroppingToRect:origExtent];
        image = [UIImage imageWithCIImage:ciImage];

        UIGraphicsBeginImageContext(thumbnail.extent.size);
        [[UIImage imageWithCIImage:thumbnail] drawInRect:thumbnail.extent];
        //TODO Oh.  Hmm.  That whole 'queue' thing.  Hmm.  Do that.
        self.player.savegame.thumbnail = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.9);
        UIGraphicsEndImageContext();

        [self.gamePageScene updateDatabase];
        
        ((PauseMenuNavigationController *)(segue.destinationViewController)).background = image;
        ((PauseMenuNavigationController *)(segue.destinationViewController)).context = self.player.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"Go To Inventory"]) {
        ((InventoryCDTVC *)(segue.destinationViewController)).player = self.player;
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (IBAction)returningFromPause:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)returningFromPauseWithGameLoad:(UIStoryboardSegue *)segue
{
    //TODO Should these properties, perhaps, be owned by just one view?
    Savegame *savegame = [Savegame getAutosaveInManagedObjectContext:self.player.managedObjectContext];
    Player *player = savegame.player;
    LevelInstance *levelInstance = player.curLevel;
    self.player = player;
    self.levelInstance = levelInstance;
    [self.gamePageScene loadFromDatabase];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"GamePageVC did disappear");
    self.skView.paused = YES;
}

- (void)recognizedTap:(UITapGestureRecognizer *)sender {
    //TODO Abstract all these, somewhat?
    [self.gamePageScene didTap:sender];
}

- (void)recognizedPinch:(UIPinchGestureRecognizer *)sender {
    [self.gamePageScene didPinch:sender];
}

- (void)recognizedRotation:(UIRotationGestureRecognizer *)sender {
    [self.gamePageScene didRotation:sender];
}

- (void)recognizedPan:(UIPanGestureRecognizer *)sender {
    [self.gamePageScene didPan:sender];
}

- (void)recognizedLongPress:(UILongPressGestureRecognizer *)sender {
    [self.gamePageScene didLongPress:sender];
}

@end
