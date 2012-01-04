//
//  Business.h
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Deal.h"

@interface Business : NSObject {
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSMutableArray *deals;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *ID;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString*) toString;

@end
