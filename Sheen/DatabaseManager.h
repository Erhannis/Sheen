//
//  DatabaseManager.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

#define DatabaseAvailabilityNotification @"DatabaseAvailabilityNotification"
#define DatabaseAvailabilityContext @"Context"

#define DATABASE_THUMBNAIL_EDGE_LENGTH (50)

@property (nonatomic, strong) UIManagedDocument *document;

@end
