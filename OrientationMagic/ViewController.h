//
//  ViewController.h
//  OrientationMagic
//
//  Created by Johnny Moralez on 3/21/13.
//  Copyright (c) 2013 Johnny Moralez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerProtocol <NSObject>

- (IBAction)cycleFromViewController:(id)sender;

@end

@interface ViewController : UIViewController

- (void)displayContentController:(UIViewController<ViewControllerProtocol>*)content;
- (void)hideContentController:(UIViewController<ViewControllerProtocol>*)content;
- (void)cycleFromViewController:(UIViewController<ViewControllerProtocol>*)content;

@end