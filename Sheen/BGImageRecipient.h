//
//  BGImageRecipient.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGImageRecipient <NSObject>

- (void)setBackgroundImage:(UIImage *)image;

@end
