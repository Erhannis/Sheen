//
//  PauseMenuVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//
//  Code for the silliness was adapted from Bouncer.
//

#import "PauseMenuVC.h"
#import "SaveLoadCDTVC.h"
#import "PauseMenuNavigationController.h"
#import "OptionsManager.h"
#import <CoreMotion/CoreMotion.h>

@interface PauseMenuVC ()
@property (strong, nonatomic) UIImage *background;
@property (weak, nonatomic) IBOutlet UIButton *buttonSilly;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoad;
@property (weak, nonatomic) IBOutlet UIButton *buttonOptions;
@property (weak, nonatomic) IBOutlet UIButton *buttonHelp;
@property (weak, nonatomic) IBOutlet UIButton *buttonAbout;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuitToTitle;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) UIGravityBehavior *gravity;
@property (weak, nonatomic) UICollisionBehavior *collision;
@property (weak, nonatomic) UIDynamicItemBehavior *elasticity;
@property (weak, nonatomic) UIDynamicItemBehavior *resistance;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) BOOL sillinessEngaged;
@end

@implementation PauseMenuVC

- (void)setBackgroundImage:(UIImage *)image
{
    self.background = image;
}

- (void)setBackground:(UIImage *)background
{
    _background = background;
    self.imageView.image = background;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    return _animator;
}

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
        [self.animator addBehavior:gravity];
        _gravity = gravity;
    }
    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision) {
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:collision];
        _collision = collision;
    }
    return _collision;
}

- (UIDynamicItemBehavior *)elasticity
{
    if (!_elasticity) {
        UIDynamicItemBehavior *elasticity = [[UIDynamicItemBehavior alloc] init];
        elasticity.elasticity = 0.25;
        [self.animator addBehavior:elasticity];
        _elasticity = elasticity;
    }
    return _elasticity;
}

- (UIDynamicItemBehavior *)resistance
{
    if (!_resistance) {
        UIDynamicItemBehavior *resistance = [[UIDynamicItemBehavior alloc] init];
        resistance.resistance = 0.0;
        [self.animator addBehavior:resistance];
        _resistance = resistance;
    }
    return _resistance;
}

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.1;
    }
    return _motionManager;
}

- (void)pauseSilliness
{
    [self.motionManager stopAccelerometerUpdates];
    // Why doesn't UIDynamicAnimator have a `pause` method?
    self.gravity.gravityDirection = CGVectorMake(0, 0);
    self.resistance.resistance = 10.0;
}

- (void)resumeSilliness
{
    self.resistance.resistance = 0.0;
    self.gravity.gravityDirection = CGVectorMake(0, 0);

    if (!self.motionManager.accelerometerActive) {
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     CGFloat x = accelerometerData.acceleration.x;
                                                     CGFloat y = accelerometerData.acceleration.y;
                                                     switch (self.interfaceOrientation) {
                                                         case UIInterfaceOrientationLandscapeRight:
                                                             self.gravity.gravityDirection = CGVectorMake(-y, -x);
                                                             break;
                                                         case UIInterfaceOrientationLandscapeLeft:
                                                             self.gravity.gravityDirection = CGVectorMake(y, x);
                                                             break;
                                                         case UIInterfaceOrientationPortrait:
                                                             self.gravity.gravityDirection = CGVectorMake(x, -y);
                                                             break;
                                                         case UIInterfaceOrientationPortraitUpsideDown:
                                                             self.gravity.gravityDirection = CGVectorMake(-x, y);
                                                             break;
                                                     }
                                                 }];
    }
}

- (void)initSilliness
{
    self.sillinessEngaged = YES;
    for (UIView *view in @[self.buttonSave, self.buttonLoad, self.buttonOptions, self.buttonHelp, self.buttonAbout, self.buttonQuitToTitle]) {
        [self.collision addItem:view];
        [self.gravity addItem:view];
        [self.elasticity addItem:view];
        [self.resistance addItem:view];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PauseMenuVC nav %@", self.navigationController);
//    if ([self.navigationController isKindOfClass:[BGImageNavigationController class]]) {
//        self.background = ((BGImageNavigationController *)self.navigationController).background;
//    }
    self.imageView.image = self.background;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      if (self.sillinessEngaged) {
                                                          [self pauseSilliness];
                                                      }
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      if (self.sillinessEngaged) {
                                                          [self resumeSilliness];
                                                      }
                                                  }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.buttonSilly.hidden = ![OptionsManager sillyFeaturesMode];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.sillinessEngaged) {
        [self resumeSilliness];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.sillinessEngaged) {
        [self pauseSilliness];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Go Save"]) {
        SaveLoadCDTVC *saveCDTV = ((SaveLoadCDTVC *)segue.destinationViewController);
        saveCDTV.saveMode = YES;
        saveCDTV.fromTitlePage = NO;
        if ([self.navigationController isKindOfClass:[PauseMenuNavigationController class]]) {
            saveCDTV.managedObjectContext = ((PauseMenuNavigationController *)self.navigationController).context;
        }
    } else if ([segue.identifier isEqualToString:@"Go Load"]) {
        SaveLoadCDTVC *loadCDTV = ((SaveLoadCDTVC *)segue.destinationViewController);
        loadCDTV.saveMode = NO;
        loadCDTV.fromTitlePage = NO;
        if ([self.navigationController isKindOfClass:[PauseMenuNavigationController class]]) {
            loadCDTV.managedObjectContext = ((PauseMenuNavigationController *)self.navigationController).context;
        }
    }
}

- (IBAction)clickSillyButton:(id)sender {
    [self initSilliness];
    [self resumeSilliness];
}

@end
