//
//  Deal.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/2/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Deal : NSObject {
    
}

@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSArray *days;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *bus_id;
@property (nonatomic, retain) NSString *specials;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
