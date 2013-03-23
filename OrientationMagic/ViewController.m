//
//  ViewController.m
//  OrientationMagic
//
//  Created by Johnny Moralez on 3/21/13.
//  Copyright (c) 2013 Johnny Moralez. All rights reserved.
//

#import "ViewController.h"
#import "PortraitViewController.h"
#import "LandscapeViewController.h"

@interface ViewController ()

@property (nonatomic,strong) PortraitViewController *portrait;
@property (nonatomic,strong) LandscapeViewController *landscape;
@property (nonatomic,assign) BOOL splitViewMode;

@end

@implementation ViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setFrameForCurrentView];
    });
}

- (void)printSupportedInterfaceOrientations {
    UIInterfaceOrientationMask supported = [self supportedInterfaceOrientations];
    NSLog(@"Portrait:             %@", supported & UIInterfaceOrientationMaskPortrait ? @"Yes" : @"No");
    NSLog(@"Portrait Upside Down: %@", supported & UIInterfaceOrientationMaskPortraitUpsideDown ? @"Yes" : @"No");
    NSLog(@"Landscape Left:       %@", supported & UIInterfaceOrientationMaskLandscapeLeft ? @"Yes" : @"No");
    NSLog(@"Landscape Right:      %@", supported & UIInterfaceOrientationMaskLandscapeRight ? @"Yes" : @"No");
}

- (NSUInteger)supportedInterfaceOrientations {
    UIInterfaceOrientationMask supportedOrientations = UIInterfaceOrientationMaskPortrait;
    if (self.splitViewMode) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return supportedOrientations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.portrait = [[PortraitViewController alloc] initWithNibName:@"PortraitViewController" bundle:nil];
    [self addChildViewController:self.portrait];
    self.portrait.view.frame = self.view.frame;
    [self.view addSubview:self.portrait.view];
    [self.portrait didMoveToParentViewController:self];
    
    self.landscape = [[LandscapeViewController alloc] initWithNibName:@"LandscapeViewController" bundle:nil];
    [self addChildViewController:self.landscape];
    
    self.splitViewMode = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            toOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            return;
        case UIDeviceOrientationLandscapeLeft:
            toOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            toOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        default:
            return;
    };
    
    [self setSplitViewMode:UIInterfaceOrientationIsLandscape(toOrientation)];
}

- (void)displayContentController:(UIViewController<ViewControllerProtocol>*) content;
{
    [self addChildViewController:content];
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)hideContentController:(UIViewController<ViewControllerProtocol>*)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (void)setSplitViewMode:(BOOL)splitViewMode {
    _splitViewMode = splitViewMode;
    
    if (_splitViewMode) {
        [self displayContentController:self.landscape];
        [self hideContentController:self.portrait];
    } else {
        [self displayContentController:self.portrait];
        [self hideContentController:self.landscape];
    }
}

- (void)cycleFromViewController:(UIViewController<ViewControllerProtocol>*)content {
    if ([content isKindOfClass:[PortraitViewController class]]) {
        [self setSplitViewMode:YES];
        [self forceRotation:UIInterfaceOrientationLandscapeLeft];
    } else if ([content isKindOfClass:[LandscapeViewController class]]) {
        [self setSplitViewMode:NO];
        [self forceRotation:UIInterfaceOrientationPortrait];
    }
}

- (void)setFrameForCurrentView {
    UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat deviceWidth =  [[_window screen] bounds].size.width;
    CGFloat deviceHeight = [[_window screen] bounds].size.height;
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = deviceWidth;
    frame.size.height = deviceHeight - self.view.frame.origin.y;
    
    if (self.splitViewMode) {
        frame.size.width = deviceHeight;
        frame.size.height = deviceWidth - self.view.frame.origin.x;
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.landscape.view setFrame:frame];
        }];
    } else {
        frame.size.width = deviceWidth;
        frame.size.height = deviceHeight - self.view.frame.origin.y;
        
        [UIView animateWithDuration:0.4 animations:^{
            [self.portrait.view setFrame:frame];
        }];
    }
}

- (void)forceRotation:(UIInterfaceOrientation)orientation {
    UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat deviceWidth =  [[_window screen] bounds].size.width;
    CGFloat deviceHeight = [[_window screen] bounds].size.height;
    
    CGFloat angle = 0.0f;
	CGFloat newX = 0.0f;
	CGFloat newY = 0.0f;
    CGFloat newWidth = deviceWidth;
    CGFloat newHeight = deviceHeight;
	
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            angle = 0.0f;
            newWidth = deviceWidth;
            newHeight = deviceHeight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI / 2;
			newY = -1 * deviceHeight / 2;
            newWidth = deviceHeight;
            newHeight = deviceWidth;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -1 * M_PI / 2;
			newY = deviceHeight / 2;
            newWidth = deviceHeight;
            newHeight = deviceWidth;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        default:
            // Do Nothing
            return;
    }
	
	CGRect newFrame = CGRectMake(newX, newY, newWidth, newHeight);
	
	NSLog(@"Forcing Rotation, Angle: %f, Frame: %@", angle, NSStringFromCGRect(newFrame));
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setTransform:CGAffineTransformMakeRotation(angle)];
        [self.view setFrame:newFrame];
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    }];
}

@end
