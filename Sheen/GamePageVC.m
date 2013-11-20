//
//  GamePageVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "GamePageVC.h"
#import <CoreImage/CoreImage.h>
#import <SpriteKit/SpriteKit.h>
#import "BGImageNavigationController.h"
#import "debugging.h"
#import "GamePageScene.h"
#import "MusicManager.h"

@interface GamePageVC ()
@property (strong, nonatomic) NSTimer *navHideTimer;
@property (strong, nonatomic) SKView *skView;
@end

@implementation GamePageVC

#define NAV_BAR_HIDE_DELAY (2)

- (SKView *)skView
{
    if (!_skView) _skView = (SKView *)self.view;
    return _skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // Start music
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeSongRequestNotification
                                                        object:self
                                                      userInfo:@{ChangeSongRequestFilename : @"gurdonark_-_Snow_Geese_at_Hagerman_Wildlife_Preserve"}];
    
    // Set up scene
    self.skView.showsFPS = DEBUGGING;
    self.skView.showsNodeCount = DEBUGGING;
    self.skView.showsDrawCount = DEBUGGING;
    
    //TODO Investigate the merits of other options.
    SKScene *scene = [GamePageScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.skView presentScene:scene];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"GamePageVC did appear");
    [self hideNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickPause:(id)sender {
    //TODO Pause.
}

- (IBAction)clickShow:(id)sender {
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
        //TODO Pause
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, self.view.window.screen.scale);
        [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CIImage *ciImage = image.CIImage ? image.CIImage : [CIImage imageWithCGImage:image.CGImage];
        CGRect origExtent = ciImage.extent;
        CIFilter *filter;
        
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

        ((BGImageNavigationController *)(segue.destinationViewController)).background = image;
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"GamePageVC did disappear");
}

@end
