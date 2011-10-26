//
//  FacebookCheckinController.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBConnect.h"
#import "NearbyPlacesRequestResult.h"
#import "PostCheckinRequestResult.h"

@interface FacebookCheckinController : UITableViewController <FBSessionDelegate, NearbyPlacesRequestDelegate, PostCheckinRequestDelegate>{
    
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSArray *places;
@property CLLocationCoordinate2D location;

@end
