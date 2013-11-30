//
//  PauseMenuVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PauseMenuVC.h"
#import "SaveLoadCDTVC.h"
#import "PauseMenuNavigationController.h"

@interface PauseMenuVC ()
@property (strong, nonatomic) UIImage *background;
@end

@implementation PauseMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)image
{
    self.background = image;
}

- (void)setBackground:(UIImage *)background
{
    _background = background;
    self.imageView.image = background;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PauseMenuVC nav %@", self.navigationController);
//    if ([self.navigationController isKindOfClass:[BGImageNavigationController class]]) {
//        self.background = ((BGImageNavigationController *)self.navigationController).background;
//    }
    self.imageView.image = self.background;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickUnpause:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Pause menu dismissed");
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Go Save"]) {
        SaveLoadCDTVC *saveCDTV = ((SaveLoadCDTVC *)segue.destinationViewController);
        saveCDTV.saveMode = YES;
        if ([self.navigationController isKindOfClass:[PauseMenuNavigationController class]]) {
            saveCDTV.managedObjectContext = ((PauseMenuNavigationController *)self.navigationController).context;
        }
    } else if ([segue.identifier isEqualToString:@"Go Load"]) {
        SaveLoadCDTVC *loadCDTV = ((SaveLoadCDTVC *)segue.destinationViewController);
        loadCDTV.saveMode = NO;
        if ([self.navigationController isKindOfClass:[PauseMenuNavigationController class]]) {
            loadCDTV.managedObjectContext = ((PauseMenuNavigationController *)self.navigationController).context;
        }
    }
}

@end
