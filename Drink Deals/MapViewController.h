//
//  MapViewController.h
//  Drink Deals
//
//  Created by Eric Osgood on 6/1/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RootViewController.h"
#import "BusAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate>{
    
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) Business *bus;
@property (nonatomic, assign) DealsEngine *engine;
@property BOOL isUpdated;

- (BOOL)isModal;

@end
