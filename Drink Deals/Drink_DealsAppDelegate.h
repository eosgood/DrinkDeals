//
//  Drink_DealsAppDelegate.h
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface Drink_DealsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) DealsEngine *engine;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end
