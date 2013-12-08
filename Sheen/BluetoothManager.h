//
//  BluetoothManager.h
//  Sheen
//
//  Created by Matthew Ewer on 12/7/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetoothManager : NSObject

- (instancetype)initAndStartScanning;
- (void)startScanning;
- (NSArray *)getResults;
- (void)stopScanning;

@end
