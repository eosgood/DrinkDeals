//
//  PostCheckinRequestResult.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "PostCheckinRequestResult.h"

@implementation PostCheckinRequestResult

- (id) initializeWithDelegate:(id )delegate {
    
	self = [super init];
	_postCheckinRequestDelegate = [delegate retain];
    
	return self;
}

/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
	[_postCheckinRequestDelegate postCheckinRequestCompleted];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    
	NSLog(@"Post Checkin Failed:%@", [error localizedDescription]);
    
	[_postCheckinRequestDelegate postCheckinRequestFailed];
}

@end