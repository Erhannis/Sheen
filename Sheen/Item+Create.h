//
//  Item+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 12/4/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Item.h"

@interface Item (Create)

+ (Item *)blankItemInManagedObjectContext:(NSManagedObjectContext *)context;

+ (Item *)twinItem:(Item *)original;

@end
