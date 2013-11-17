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
#import <AVFoundation/AVFoundation.h>

@interface GamePageVC ()
@property (strong, nonatomic) NSTimer *navHideTimer;
@property (strong, nonatomic) SKView *skView;
@property (strong, nonatomic) AVAudioPlayer *player;
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
    
    //TODO Music manager?
    // Start music
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"gurdonark_-_Snow_Geese_at_Hagerman_Wildlife_Preserve" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.player.numberOfLoops = -1; //infinite loop
    [self.player play];
    
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
