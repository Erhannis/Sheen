//
//  BluetoothPageTVC.m
//  Sheen
//
//  Created by Matthew Ewer on 12/7/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "BluetoothPageTVC.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothPageTVC ()<CBCentralManagerDelegate>
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *peripherals; // of CBPerhipheral
@end

@implementation BluetoothPageTVC

- (NSMutableArray *)peripherals
{
    if (!_peripherals) _peripherals = [[NSMutableArray alloc] init];
    return _peripherals;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (void)viewDidAppear:(BOOL)animated
{
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.centralManager stopScan];
    self.centralManager = nil;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (self.centralManager && self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil
                                                    options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    [self.peripherals addObject:peripheral];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bluetooth Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
    
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    
    return cell;
}

@end
