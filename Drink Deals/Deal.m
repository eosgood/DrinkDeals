//
//  Deal.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/2/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "Deal.h"


@implementation Deal

@synthesize type = _type;
@synthesize description = _description;
@synthesize time = _time;
@synthesize days = _days;
@synthesize ID = _id;
@synthesize bus_id = _bid;
@synthesize specials = _specials;

-(id) initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    
    NSString *tmpDays = [dictionary objectForKey:@"days"];
    
    self.days = [tmpDays componentsSeparatedByString:@" "];
        
    NSMutableDictionary *mutableDict = [dictionary mutableCopy];
    [mutableDict removeObjectForKey:@"days"];
    
    [self setValuesForKeysWithDictionary:mutableDict];
    
    [mutableDict release];
        
    return self;
}

-(void) dealloc
{
    [_specials release];
    [_type release];
    [_description release];
    [_time release];
    [_days release];
    [_id release];
    [_bid release];
    
    [super dealloc];
}


@end
