//
//  InventoryCDTVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "InventoryCDTVC.h"
#import "Item+Create.h"
#import "OptionsManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface InventoryCDTVC ()
@property (strong, nonatomic) NSTimer *refreshTokenTimer;
@end

@implementation InventoryCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"InventoryCDTVC nav %@", self.navigationController);
	// Do any additional setup after loading the view.
}

- (void)setPlayer:(Player *)player
{
    _player = player;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"player == %@", player];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:player.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Item Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ix %@", item.count.integerValue, item.name];
    cell.detailTextLabel.text = item.descriptionText;
    cell.imageView.image = [UIImage imageNamed:item.imageFilename];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"InventoryCDTV didSelectRow");
    //TODO Do this.
    //TODO Also, think hard about the iPad view.
//    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

// Not actually a refresh, since that means nothing here.
//   Instead, it gives you an item.
- (IBAction)refresh:(id)sender {
    //TODO What's up with timers?
    //TODO Also, don't forget to turn off zombies.
    //self.refreshTokenTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addRefreshToken:) userInfo:nil repeats:NO];
    if ([OptionsManager sillyFeaturesMode]) {
        [self addRefreshToken:nil];
    }
}

- (void)addRefreshToken:(NSTimer *)timer
{
    [self.player.managedObjectContext performBlock:^{
        [Item itemWithID:DEFAULT_ITEM_REFRESH_PURPLE forPlayer:self.player].count = [NSNumber numberWithInteger:([Item itemWithID:DEFAULT_ITEM_REFRESH_PURPLE forPlayer:self.player].count.integerValue + 1)];
    }];
    [self.refreshControl endRefreshing];
}

@end
