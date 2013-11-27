//
//  SavegameManager.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SavegameManager.h"

@implementation SavegameManager

- (void)openManagedDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"SheenSavegames";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    __weak SavegameManager *weakself = self;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:url.path];
    if (fileExists) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                weakself.document = document;
            } else {
                NSLog(@"Error; couldn't open db document");
            }
        }];
    } else {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  weakself.document = document;
              } else {
                  NSLog(@"Error; couldn't create db document");
              }
          }];
    }
}

- (void)setDocument:(UIManagedDocument *)document
{
    _document = document;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SavegameDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:@{SavegameDatabaseAvailabilityContext : self.document.managedObjectContext}];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self openManagedDocument];
    }
    
    return self;
}

@end
