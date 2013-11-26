//
//  OptionsManager.m
//  Sheen
//
//  Created by Matthew Ewer on 11/26/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "OptionsManager.h"

@implementation OptionsManager

#define OPTION_KEY_MUSIC_VOLUME @"Music volume"
#define OPTION_KEY_SOUND_VOLUME @"Sound volume"
#define OPTION_KEY_GRAPHICS_LEVEL @"Graphics level"
#define OPTION_KEY_SILLY_FEATURES_MODE @"Silly features mode"

#define DEFAULT_MUSIC_VOLUME (1.0)
#define DEFAULT_SOUND_VOLUME (1.0)
#define DEFAULT_GRAPHICS_LEVEL (2)
#define DEFAULT_SILLY_FEATURES_MODE YES

+ (void)initOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:OPTION_KEY_MUSIC_VOLUME]) {
        [defaults setFloat:DEFAULT_MUSIC_VOLUME
                    forKey:OPTION_KEY_MUSIC_VOLUME];
    }
    if (![defaults objectForKey:OPTION_KEY_SOUND_VOLUME]) {
        [defaults setFloat:DEFAULT_SOUND_VOLUME
                    forKey:OPTION_KEY_SOUND_VOLUME];
    }
    if (![defaults objectForKey:OPTION_KEY_GRAPHICS_LEVEL]) {
        [defaults setInteger:DEFAULT_GRAPHICS_LEVEL
                      forKey:OPTION_KEY_GRAPHICS_LEVEL];
    }
    if (![defaults objectForKey:OPTION_KEY_SILLY_FEATURES_MODE]) {
        [defaults setBool:DEFAULT_SILLY_FEATURES_MODE
                   forKey:OPTION_KEY_SILLY_FEATURES_MODE];
    }
    [defaults synchronize];
}

+ (float)musicVolume
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:OPTION_KEY_MUSIC_VOLUME];
}

+ (float)soundVolume
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:OPTION_KEY_SOUND_VOLUME];
}

+ (NSInteger)graphicsLevel
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:OPTION_KEY_GRAPHICS_LEVEL];
}

+ (BOOL)sillyFeaturesMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:OPTION_KEY_SILLY_FEATURES_MODE];
}

//#pragma

+ (void)setMusicVolume:(float)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:value
                forKey:OPTION_KEY_MUSIC_VOLUME];
    [defaults synchronize];
}

+ (void)setSoundVolume:(float)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:value
                forKey:OPTION_KEY_SOUND_VOLUME];
    [defaults synchronize];
}

+ (void)setGraphicsLevel:(NSInteger)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value
                  forKey:OPTION_KEY_GRAPHICS_LEVEL];
    [defaults synchronize];
}

+ (void)setSillyFeaturesMode:(BOOL)isOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isOn
               forKey:OPTION_KEY_SILLY_FEATURES_MODE];
    [defaults synchronize];
}

@end
