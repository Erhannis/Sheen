//
//  PauseMenuVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PauseMenuVC.h"

@interface PauseMenuVC ()
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

- (void)setBackground:(UIImage *)background
{
    _background = background;
    self.imageView.image = background;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PauseMenu did load");
    self.imageView.image = self.background;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
