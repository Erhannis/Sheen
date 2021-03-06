//
//  MusicManager.m
//  Sheen
//
//  Created by Matthew Ewer on 11/19/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "MusicManager.h"
#import <AVFoundation/AVFoundation.h>
#import "OptionsManager.h"

@interface MusicManager ()
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSString *currentSongFilename;
@property (nonatomic) float internalVolume;
@end

@implementation MusicManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.internalVolume = 1.0;
        [self updateMusicVolume];
        __weak MusicManager *weakself = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:ChangeSongRequestNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [weakself transitionToSongWithFilename:note.userInfo[ChangeSongRequestFilename]];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:StopParticularSongRequestNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [weakself stopParticularSongWithFilename:note.userInfo[StopParticularSongRequestFilename]];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:StartSongRequestNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [weakself startSongWithFilename:note.userInfo[StartSongRequestFilename]];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:StopCurrentSongRequestNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [weakself stopCurrentSong];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:MusicVolumeChangedNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [weakself updateMusicVolume];
                                                      }];
    }
    
    return self;
}

// Should probably also support non-mp3.
// Note that this basically assumes no other songs are playing.  Otherwise, upredictable.
- (void)startSongWithFilename:(NSString *)filename
{
    self.currentSongFilename = filename;
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:self.currentSongFilename ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.player.numberOfLoops = -1; //infinite loop
    [self updateMusicVolume];
    [self.player play];
}

/*
 Changes songs.  If given song is already playing, does nothing.
 */
- (void)transitionToSongWithFilename:(NSString *)filename
{
    //TODO Do this better.
    if (![self.currentSongFilename isEqualToString:filename]){
        [self stopCurrentSong];
        [self startSongWithFilename:filename];
    }
}

- (void)stopParticularSongWithFilename:(NSString *)filename
{
    if ([self.currentSongFilename isEqualToString:filename]) {
        [self.player stop];
        self.player = nil;
        self.currentSongFilename = nil;
    }
}

- (void)stopCurrentSong
{
    [self.player stop];
    self.player = nil;
    self.currentSongFilename = nil;
}

- (void)updateMusicVolume
{
    self.player.volume = self.internalVolume * [OptionsManager musicVolume];
}

@end
