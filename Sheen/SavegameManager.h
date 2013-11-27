//
//  SavegameManager.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavegameManager : NSObject

#define SavegameDatabaseAvailabilityNotification @"SavegameDatabaseAvailabilityNotification"
#define SavegameDatabaseAvailabilityContext @"Context"

@property (nonatomic, strong) UIManagedDocument *document;

@end
