//
//  Business.m
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "Business.h"


@implementation Business

@synthesize name = _name;
@synthesize address = _address;
@synthesize icon = _icon;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize deals = _deals;
@synthesize phone = _phone;
@synthesize ID = _id;

- (void) dealloc
{
    [_name release];
    [_latitude release];
    [_longitude release];
    [_address release];
    [_deals release];
    [_icon release];
    [_id release];
    
    [super dealloc];
}

-(id) initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    
    NSArray *deals = [dictionary objectForKey:@"deals"];
    self.deals = [[NSMutableArray alloc] initWithCapacity:[deals count]];
    for (NSDictionary *dealDict in deals){
        Deal *deal = [[Deal alloc] initWithDictionary:dealDict];
        [self.deals addObject:deal];
        [deal release];
    }
    
    NSMutableDictionary *mutableDict = [dictionary mutableCopy];
    [mutableDict removeObjectForKey:@"deals"];
    
    [self setValuesForKeysWithDictionary:mutableDict];
    
    [mutableDict release];
    
    return self;
}

@end
