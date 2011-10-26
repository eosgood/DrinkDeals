//
//  BusinessViewController.h
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusCell.h"
#import "Business.h"
#import "MapViewController.h"
#import "NewDealViewController.h"
#import "FacebookCheckinController.h"

enum{
    Address, 
    Phone, 
    Fb
};

@interface BusinessViewController : UITableViewController {
    
}

@property (nonatomic, retain) Business *bus;
@property (nonatomic, assign) DealsEngine *engine;

@end
