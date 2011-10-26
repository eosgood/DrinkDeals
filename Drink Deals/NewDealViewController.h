//
//  NewDealViewController.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/2/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableDetailCell.h"
#import "DealsEngine.h"

enum{
    BusName,
    BusAddress,
    BusPhone,
    DealDesc,
    DealSpecials,
    DealTime,
};

@interface NewDealViewController : UITableViewController <UITextFieldDelegate> {
    
}

@property BOOL newBus;
@property (nonatomic, retain) Business *theBus;
@property (nonatomic, retain) Deal *newDeal;
@property (nonatomic, assign) DealsEngine *engine;
@property (nonatomic, retain) MKPlacemark *placemark;
@property (nonatomic, retain) UISegmentedControl *dealType;
@property (nonatomic, retain) NSMutableArray *dealDays;
@property (nonatomic, retain) NSArray *daysOfTheWeek;

@end
