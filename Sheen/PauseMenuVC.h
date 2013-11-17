//
//  PauseMenuVC.h
//  Sheen
//
//  Created by Matthew Ewer on 11/16/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGImageRecipient.h"

@interface PauseMenuVC : UIViewController <BGImageRecipient>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
