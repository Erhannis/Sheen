//
//  MusicManager.h
//  Sheen
//
//  Created by Matthew Ewer on 11/19/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject

#define ChangeSongRequestNotification @"ChangeSongRequestNotification"
#define ChangeSongRequestFilename @"ChangeSongRequestFilename"

#define StopParticularSongRequestNotification @"StopParticularSongRequestNotification"
#define StopParticularSongRequestFilename @"StopParticularSongRequestFilename"

#define StartSongRequestNotification @"StartSongRequestNotification"
#define StartSongRequestFilename @"StartSongRequestFilename"

#define StopCurrentSongRequestNotification @"StopCurrentSongRequestNotification"

- (instancetype)init;

@end
