//
//  PortraitViewController.m
//  OrientationMagic
//
//  Created by Johnny Moralez on 3/21/13.
//  Copyright (c) 2013 Johnny Moralez. All rights reserved.
//

#import "PortraitViewController.h"
#import "ViewController.h"

@interface PortraitViewController ()

@end

@implementation PortraitViewController


- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"Portrait VC Will Rotate");
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cycleFromViewController:(id)sender {
    NSLog(@"Portrait Toggle");
    if ([self parentViewController] && [[self parentViewController] respondsToSelector:@selector(cycleFromViewController:)]) {
        [(ViewController*)[self parentViewController] cycleFromViewController:self];
    }
}

@end
