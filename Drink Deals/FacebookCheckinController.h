//
//  FacebookCheckinController.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "NearbyPlacesRequestResult.h"
#import "PostCheckinRequestResult.h"
#import "Business.h"

@interface FacebookCheckinController : UITableViewController <FBSessionDelegate, NearbyPlacesRequestDelegate, PostCheckinRequestDelegate>
{
    
}

@property (nonatomic, retain) NSArray *places;
@property CLLocationCoordinate2D location;
@property (nonatomic, retain) Business *theBus;

@end
