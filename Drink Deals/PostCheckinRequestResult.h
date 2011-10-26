//
//  PostCheckinRequestResult.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FBConnect.h"

@protocol PostCheckinRequestDelegate;

@interface PostCheckinRequestResult : NSObject <FBRequestDelegate> {
    
	id _postCheckinRequestDelegate;
}

- (id) initializeWithDelegate: (id)delegate;

@end

@protocol PostCheckinRequestDelegate

- (void) postCheckinRequestCompleted;
- (void) postCheckinRequestFailed;

@end