//
//  LandscsapeViewController.m
//  OrientationMagic
//
//  Created by Johnny Moralez on 3/21/13.
//  Copyright (c) 2013 Johnny Moralez. All rights reserved.
//

#import "ViewController.h"
#import "LandscapeViewController.h"

@interface LandscapeViewController ()

@end

@implementation LandscapeViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"Landscape VC Will Rotate");
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cycleFromViewController:(id)sender {
    NSLog(@"Landscape Toggle");
    if ([self parentViewController] && [[self parentViewController] respondsToSelector:@selector(cycleFromViewController:)]) {
        [(ViewController*)[self parentViewController] cycleFromViewController:self];
    }
}

@end
