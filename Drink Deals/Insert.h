//
//  Insert.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/6/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

enum{
    BusinessInsert,
    DealInsert,
};

@protocol BusinessInsertedDelegate;


@interface Insert : NSObject {
    
    id _businessInsertedDelegate;
}

- (id) initializeWithDelegate: (id)delegate;

@end

@protocol BusinessInsertedDelegate

-(void) busCreated: (NSInteger) busID;
-(void) dealAdded;
-(void) dataError;

@end