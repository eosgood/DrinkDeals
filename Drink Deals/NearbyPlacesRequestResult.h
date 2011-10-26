//
//  NearbyPlacesRequestResult.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@protocol NearbyPlacesRequestDelegate;

@interface NearbyPlacesRequestResult : NSObject <FBRequestDelegate> {
    
	id _nearbyPlacesRequestDelegate;
    
}

- (id) initializeWithDelegate: (id)delegate;

@end

@protocol NearbyPlacesRequestDelegate

- (void) nearbyPlacesRequestCompletedWithPlaces:(NSArray *)placesArray;
- (void) nearbyPlacesRequestFailed;

@end

