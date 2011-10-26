//
//  NearbyPlacesRequestResult.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "NearbyPlacesRequestResult.h"

@implementation NearbyPlacesRequestResult

- (id) initializeWithDelegate:(id )delegate {
    
	self = [super init];
	_nearbyPlacesRequestDelegate = [delegate retain];
    
	return self;
}

/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
	NSArray *placesArray = [result objectForKey:@"data"];
    
	[_nearbyPlacesRequestDelegate nearbyPlacesRequestCompletedWithPlaces: placesArray];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    
	NSLog(@"NearbyPlaces %@", [error localizedDescription]);
    
	[_nearbyPlacesRequestDelegate nearbyPlacesRequestFailed];
}

@end
