//
//  OptionsTVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/26/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "OptionsTVC.h"
#import "OptionsManager.h"
#import "MusicManager.h"

@interface OptionsTVC ()
@property (weak, nonatomic) IBOutlet UISlider *musicVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *soundVolumeSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *graphicsLevelSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *sillyFeaturesModeSwitch;

@end

@implementation OptionsTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"OptionsTVC nav %@", self.navigationController);

    self.musicVolumeSlider.value = [OptionsManager musicVolume];
    self.soundVolumeSlider.value = [OptionsManager soundVolume];
    self.graphicsLevelSegmentedControl.selectedSegmentIndex = [OptionsManager graphicsLevel];
    self.sillyFeaturesModeSwitch.on = [OptionsManager sillyFeaturesMode];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)changedMusicVolume:(UISlider *)sender {
    [OptionsManager setMusicVolume:sender.value];
    [[NSNotificationCenter defaultCenter] postNotificationName:MusicVolumeChangedNotification
                                                        object:self
                                                      userInfo:nil];
}

- (IBAction)changedSoundVolume:(UISlider *)sender {
    [OptionsManager setSoundVolume:sender.value];
}

- (IBAction)changedGraphicsLevel:(UISegmentedControl *)sender {
    [OptionsManager setGraphicsLevel:sender.selectedSegmentIndex];
}

- (IBAction)changedSillyFeatures:(UISwitch *)sender {
    [OptionsManager setSillyFeaturesMode:sender.on];
}

@end
