//
//  GamePageVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "GamePageVC.h"

@interface GamePageVC ()
@property (strong, nonatomic) NSTimer *navHideTimer;
@end

@implementation GamePageVC

#define NAV_BAR_HIDE_DELAY (2)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [self hideNavBar];
}

@end
