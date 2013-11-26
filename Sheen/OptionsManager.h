//
//  OptionsManager.h
//  Sheen
//
//  Created by Matthew Ewer on 11/26/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionsManager : NSObject

+ (void)initOptions;

+ (float)musicVolume;
+ (float)soundVolume;
+ (NSInteger)graphicsLevel;
+ (BOOL)sillyFeaturesMode;

+ (void)setMusicVolume:(float)value;
+ (void)setSoundVolume:(float)value;
+ (void)setGraphicsLevel:(NSInteger)value;
+ (void)setSillyFeaturesMode:(BOOL)isOn;

@end
