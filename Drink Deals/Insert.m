//
//  Insert.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/6/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "Insert.h"


@implementation Insert

- (id) initializeWithDelegate: (id)delegate
{
    self = [super init];

    _businessInsertedDelegate = [delegate retain];
    
    return self;   
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{
    switch (request.tag) {
        case BusinessInsert:
        {
            NSInteger busID = [[request responseString] intValue];
            [_businessInsertedDelegate busCreated:busID];
            break;
        }
        case DealInsert:
            [_businessInsertedDelegate dealAdded];
            break;
        default:
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"ASI http request: %@", [error localizedDescription]);
    [_businessInsertedDelegate dataError];
}

@end
