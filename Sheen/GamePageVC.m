//
//  GamePageVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "GamePageVC.h"
#import <CoreImage/CoreImage.h>
#import "BGImageNavigationController.h"

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
