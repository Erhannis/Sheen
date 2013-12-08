//
//  AboutVC.m
//  Sheen
//
//  Created by Matthew Ewer on 12/7/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "AboutVC.h"
#import <SafariServices/SafariServices.h>
#import "OptionsManager.h"

@interface AboutVC ()
@property (weak, nonatomic) IBOutlet UIButton *buttonAddAWebcomic;
@end

@implementation AboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.buttonAddAWebcomic.hidden = ![OptionsManager sillyFeaturesMode];
    if (!self.buttonAddAWebcomic.hidden) {
        self.buttonAddAWebcomic.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.buttonAddAWebcomic.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view updateConstraints];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedAddAWebcomic:(id)sender {
    switch (arc4random() % 4) {
        case 0:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.gunnerkrigg.com"];
            if ([SSReadingList supportsURL:url]) {
                SSReadingList *list = [SSReadingList defaultReadingList];
                [list addReadingListItemWithURL:url
                                          title:@"(Testing) Gunnerkrigg Court"
                                    previewText:@"(It's a webcomic Matthew likes.)"
                                          error:NULL];
            }
            break;
        }
        case 1:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.girlgeniusonline.com"];
            if ([SSReadingList supportsURL:url]) {
                SSReadingList *list = [SSReadingList defaultReadingList];
                [list addReadingListItemWithURL:url
                                          title:@"(Testing) Girl Genius"
                                    previewText:@"(It's a webcomic Matthew likes.)"
                                          error:NULL];
            }
            break;
        }
        case 2:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.dresdencodak.com"];
            if ([SSReadingList supportsURL:url]) {
                SSReadingList *list = [SSReadingList defaultReadingList];
                [list addReadingListItemWithURL:url
                                          title:@"(Testing) Dresden Codak"
                                    previewText:@"(It's a webcomic Matthew likes.)"
                                          error:NULL];
            }
            break;
        }
        case 3:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.drmcninja.com"];
            if ([SSReadingList supportsURL:url]) {
                SSReadingList *list = [SSReadingList defaultReadingList];
                [list addReadingListItemWithURL:url
                                          title:@"(Testing) Dr. McNinja"
                                    previewText:@"(It's a webcomic Matthew likes.)"
                                          error:NULL];
            }
            break;
        }
    }
}

@end
