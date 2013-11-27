//
//  LevelTemplate+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelTemplate+Create.h"

@implementation LevelTemplate (Create)

+ (LevelTemplate *)levelTemplateWithID:(NSString *)levelID
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    
    if (levelID.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LevelTemplate"];
        request.predicate = [NSPredicate predicateWithFormat:@"levelID = %@", levelID];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request
                                                  error:&error];
        
        if (!matches || error) {
            NSLog(@"Error dbFetching levelTemplate - err: %@", error.localizedDescription);
        } else if (!matches.count) {
            if ([levelID isEqualToString:DEFAULT_LEVEL_TEST]) {
                
            }
        } else {
            levelTemplate = [matches firstObject];
        }
    }
    
    return levelTemplate;
}

+ (LevelTemplate *)createDefaultLevelTestInContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_LEVEL_TEST;
    return levelTemplate;
}

@end
