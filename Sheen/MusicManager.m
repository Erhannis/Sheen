//
//  MusicManager.m
//  Sheen
//
//  Created by Matthew Ewer on 11/19/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "MusicManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicManager ()
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSString *currentSongFilename;
@end

@implementation MusicManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
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
    [self.player play];
}

- (void)transitionToSongWithFilename:(NSString *)filename
{
    //TODO Do this better.
    [self stopCurrentSong];
    [self startSongWithFilename:filename];
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

@end
