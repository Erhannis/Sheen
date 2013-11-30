//
//  SaveLoadCDTVC.m
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SaveLoadCDTVC.h"
#import "Savegame+Create.h"

@interface SaveLoadCDTVC ()
@property (strong, nonatomic) UIImage *cleanImage;
@end

@implementation SaveLoadCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // If I do this in viewDidLoad, self.naviagtionController is still null.
    //      ...but this is the only view for which this is the case, so far.
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setSaveMode:(BOOL)saveMode
{
    _saveMode = saveMode;
	self.title = _saveMode ? @"Save" : @"Load";
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    //TODO Deal with duality.
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Savegame"];
//    request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"savegameID"
                                                              ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Savegame Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Savegame *savegame = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = savegame.savegameID;
    cell.detailTextLabel.text = @"health, etc.";
    cell.imageView.image = [UIImage imageWithData:savegame.thumbnail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO Do this.
    //TODO Also, think hard about the iPad view.
//    id detail = self.splitViewController.viewControllers[1];
//    if ([detail isKindOfClass:[UINavigationController class]]) {
//        detail = [((UINavigationController *)detail).viewControllers firstObject];
//    }
//    if ([detail isKindOfClass:[ImageViewController class]]) {
//        [self prepareImageViewController:detail toDisplayPhoto:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//    }
}

@end
