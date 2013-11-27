//
//  Portal.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Portal : NSManagedObject

@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSManagedObject *fromPlace;
@property (nonatomic, retain) NSManagedObject *fromLevel;
@property (nonatomic, retain) NSManagedObject *toLevel;
@property (nonatomic, retain) NSManagedObject *toPlace;

@end
