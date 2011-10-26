//
//  BusAnnotation.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/6/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Business.h"

@interface BusAnnotation : NSObject <MKAnnotation>{
    
}

@property (nonatomic, assign) Business *bus;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
