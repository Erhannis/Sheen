//
//  InventoryCDTVC.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Player+Create.h"

@interface InventoryCDTVC : CoreDataTableViewController

@property (strong, nonatomic) Player *player;

@end
