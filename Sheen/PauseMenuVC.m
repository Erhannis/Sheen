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
#import "SmileyView.h"
#import <SafariServices/SafariServices.h>

@interface PauseMenuVC ()
@property (strong, nonatomic) UIImage *background;
@property (weak, nonatomic) IBOutlet UIButton *buttonExchangeData;
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
@property (strong, nonatomic) NSMutableArray *smileys;
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

- (NSMutableArray *)smileys
{
    if (!_smileys) _smileys = [[NSMutableArray alloc] init];
    return _smileys;
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

- (void)endSilliness
{
    [self.motionManager stopAccelerometerUpdates];
    // Why doesn't UIDynamicAnimator have a `pause` method?
    self.gravity.gravityDirection = CGVectorMake(0, 0);
    self.resistance.resistance = 10.0;

    // I think the animator was hanging on for a while after the view was hidden, and it seriously impacted performance.
    [self.animator removeAllBehaviors];
    self.animator = nil;
    self.gravity = nil;
    self.collision = nil;
    self.elasticity = nil;
    self.resistance = nil;
}

- (void)startSilliness
{
    [self initSilliness];
    
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

    NSArray *movingButtons = [self getMovingButtons];
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([movingButtons containsObject:constraint.firstItem] || [movingButtons containsObject:constraint.secondItem]) {
            [self.view removeConstraint:constraint];
        }
    }

    for (UIView *view in movingButtons) {
        [self.collision addItem:view];
        [self.gravity addItem:view];
        [self.elasticity addItem:view];
        [self.resistance addItem:view];
    }
    
    for (UIView *smiley in self.smileys) {
        [self.collision addItem:smiley];
        [self.gravity addItem:smiley];
        [self.elasticity addItem:smiley];
        [self.resistance addItem:smiley];
    }
}

- (NSArray *)getMovingButtons
{
    return @[self.buttonSave, self.buttonLoad, self.buttonOptions, self.buttonHelp, self.buttonAbout, self.buttonQuitToTitle];
}

- (void)resetConstraints
{
    NSArray *movingButtons = [self getMovingButtons];
    
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([movingButtons containsObject:constraint.firstItem] || [movingButtons containsObject:constraint.secondItem]) {
            [self.view removeConstraint:constraint];
        }
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonOptions
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonOptions
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[save]-[load]-[options]-[help]-[about]"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:@{@"save":self.buttonSave, @"load":self.buttonLoad, @"options":self.buttonOptions, @"help":self.buttonHelp, @"about":self.buttonAbout}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonQuitToTitle
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[quit]-|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:@{@"quit":self.buttonQuitToTitle}]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PauseMenuVC nav %@", self.navigationController);
    self.imageView.image = self.background;
    
    [self resetConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      if (self.sillinessEngaged) {
                                                          [self endSilliness];
                                                      }
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      if (self.sillinessEngaged) {
                                                          [self startSilliness];
                                                      }
                                                  }];
}

#define BUTTON_MOVE_DURATION (0.25)
#define BUTTON_MOVE_DELAY_INCREMENT (0.1)

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.buttonSilly.hidden = ![OptionsManager sillyFeaturesMode];
    self.buttonExchangeData.hidden = ![OptionsManager sillyFeaturesMode];
    
    if ([OptionsManager sillyFeaturesMode]) {
        CGFloat origX = 0;
        CGFloat origY = 0;
        CGFloat sideX = 0;
        CGFloat sideY = 0;
        CGFloat delay = 0;
        for (UIView *view in @[self.buttonSave, self.buttonLoad, self.buttonOptions, self.buttonHelp, self.buttonAbout, self.buttonQuitToTitle]) {
            origX = view.frame.origin.x;
            origY = view.frame.origin.y;
            sideX = origX + self.view.frame.size.width;
            sideY = origY;
            view.frame = CGRectMake(sideX, sideY, view.frame.size.width, view.frame.size.height);
            [UIView animateWithDuration:BUTTON_MOVE_DURATION
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 view.frame = CGRectMake(origX, origY, view.frame.size.width, view.frame.size.height);
                             }
                             completion:nil];
            delay += BUTTON_MOVE_DELAY_INCREMENT;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.sillinessEngaged) {
        [self startSilliness];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.sillinessEngaged) {
        [self endSilliness];
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

#define SMILEY_RADIUS (30.0)

- (void)addSmiley
{
    SmileyView *smiley = [[SmileyView alloc] initWithFrame:CGRectMake((drand48() * (self.view.frame.size.width - (3 * SMILEY_RADIUS))) + (1.5 * SMILEY_RADIUS), SMILEY_RADIUS * 1.5, SMILEY_RADIUS * 2.0, SMILEY_RADIUS * 2.0)];
    [self.view addSubview:smiley];
    [self.collision addItem:smiley];
    [self.gravity addItem:smiley];
    [self.elasticity addItem:smiley];
    [self.resistance addItem:smiley];
    [self.smileys addObject:smiley];
}

- (IBAction)clickSillyButton:(id)sender {
    if (!self.sillinessEngaged) {
        [self startSilliness];
    }
    [self addSmiley];
}

@end
