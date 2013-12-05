//
//  Item+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 12/4/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Item+Create.h"

@implementation Item (Create)

+ (Item *)blankItemInManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                           inManagedObjectContext:context];
    return item;
}

+ (Item *)twinItem:(Item *)original
{
    Item *item = [Item blankItemInManagedObjectContext:original.managedObjectContext];
    item.name = original.name;
    item.count = original.count;
    
    return item;
}

@end
