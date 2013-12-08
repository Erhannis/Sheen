//
//  Item+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 12/4/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Item+Create.h"
#import "Player+Create.h"

@implementation Item (Create)

+ (Item *)itemWithID:(NSString *)itemID
           forPlayer:(Player *)player
{
    Item *item = nil;
    
    if (itemID.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        request.predicate = [NSPredicate predicateWithFormat:@"itemID = %@ && player = %@", itemID, player];
        
        NSError *error;
        NSArray *matches = [player.managedObjectContext executeFetchRequest:request
                                                                      error:&error];
        
        if (!matches || error) {
            NSLog(@"Error dbFetching item - err: %@", error.localizedDescription);
        } else if (!matches.count) {
            if ([itemID isEqualToString:DEFAULT_ITEM_REFRESH_PURPLE]) {
                item = [self createDefaultItemRefreshPurpleInContext:player.managedObjectContext];
                item.player = player;
            } else {
                NSLog(@"Error - unknown item \"%@\"", itemID);
            }
        } else {
            item = [matches firstObject];
        }
    }
    
    return item;
}

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
    item.itemID = original.itemID;
    item.name = original.name;
    item.descriptionText = original.descriptionText;
    item.count = original.count;
    item.imageFilename = original.imageFilename;
    
    return item;
}

+ (Item *)createDefaultItemRefreshPurpleInContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                         inManagedObjectContext:context];
    item.itemID = DEFAULT_ITEM_REFRESH_PURPLE;
    item.name = @"Refresh token";
    item.descriptionText = @"Received for refreshing the inventory.";
    item.count = 0;
    item.imageFilename = @"mote-purple";
    return item;
}

@end
