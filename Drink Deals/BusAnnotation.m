//
//  BusAnnotation.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/6/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "BusAnnotation.h"


@implementation BusAnnotation

@synthesize bus;
@synthesize coordinate;

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return bus.name;
}

// optional
- (NSString *)subtitle
{
    return bus.address;
}



@end
