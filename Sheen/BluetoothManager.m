//
//  BluetoothManager.m
//  Sheen
//
//  Created by Matthew Ewer on 12/7/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "BluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothManager () <CBCentralManagerDelegate>
@property (strong, nonatomic) CBCentralManager *centralManager;
@end

@implementation BluetoothManager

- (instancetype)initAndStartScanning
{
    self = [super init];
    
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    
    return self;
}

- (void)startScanning
{
    NSLog(@"%i", self.centralManager.state);
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil
                                                    options:nil];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self startScanning];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"perhipheral %@", peripheral);
    NSLog(@"advisementData %@", advertisementData);
    NSLog(@"RSSI %@", RSSI);
}

- (NSArray *)getResults
{
    return nil;
}

- (void)stopScanning
{
    [self stopScanning];
}

@end
