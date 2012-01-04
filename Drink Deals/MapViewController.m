//
//  MapViewController.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/1/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "MapViewController.h"

#import "NewDealViewController.h"
#import "BusinessViewController.h"


@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize reverseGeocoder = _reverseGeocoder;
@synthesize bus =_bus;
@synthesize engine = _engine;
@synthesize isUpdated;

- (void)dealloc
{
    [_bus release];
    [_mapView release];
    [_reverseGeocoder release];
    
    [super dealloc];
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

-(void) addBusToMap{
    for (Business *bus in self.engine.busForGivenDay){
        BusAnnotation *busPoint = [[BusAnnotation alloc] init];
        busPoint.coordinate = CLLocationCoordinate2DMake([bus.latitude floatValue], [bus.longitude floatValue]);
        busPoint.bus = bus;
        [self.mapView addAnnotation:busPoint];
        [busPoint release];

    }
}

- (BOOL)isModal
{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    UIViewController *rootViewController = [viewControllers objectAtIndex:0];
    
    return rootViewController == self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - CLGeocoder Delegates

- (void)displayError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot obtain address."
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) displayPlacemarks: (NSArray *) placemarks 
{
    NewDealViewController *addController = [[NewDealViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addController.engine = self.engine;
    addController.placemarks = placemarks;
    addController.newBus = YES;
    UINavigationController *newNavController = [[UINavigationController alloc]
                                                initWithRootViewController:addController];
    
    [[self navigationController] presentModalViewController:newNavController animated:YES];
    [addController release];
    [newNavController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self isModal]){
        
        self.isUpdated = NO;
        
        self.title = @"Drink Deals";
        
        // configure map button
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] 
                                      initWithTitle:@"List" 
                                      style:UIBarButtonItemStylePlain
                                      target:self 
                                      action:@selector(list)];
        [[self navigationItem] setLeftBarButtonItem:mapButton];
        [mapButton release];
        
        //  Configure the Add button
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(add)];
        
        [[self navigationItem] setRightBarButtonItem:addButton];
        [addButton release];
        
        self.mapView.showsUserLocation = YES;
    } else {
        self.title = self.bus.name;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.bus.latitude floatValue], [self.bus.longitude floatValue]);
        
        [self.mapView setRegion:MKCoordinateRegionMake(coordinate,  
												   MKCoordinateSpanMake(.02, .02)) animated:YES];
        
        
        BusAnnotation *busPoint = [[BusAnnotation alloc] init];
        
        busPoint.coordinate = coordinate;
        busPoint.bus = self.bus;
        [self.mapView addAnnotation:busPoint];
        [busPoint release];
    }
}



- (void)add
{
    
    self.reverseGeocoder = [[[CLGeocoder alloc] init] autorelease];
    
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude] autorelease];

    
    [self.reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        [self displayPlacemarks:placemarks];
    }];
}

-(void) list
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.mapView = nil;
}

#pragma mark - Delegate Functions

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
    MKPinAnnotationView* customPinView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
    
    if (!customPinView)
    {
        // if an existing pin view was not available, create one
        customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];    
    }
    
    customPinView.pinColor = MKPinAnnotationColorGreen;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    UIImageView *sfIconView;
    
    Deal *deal = [((BusAnnotation*) annotation).bus.deals objectAtIndex:0];
       
    
    int dealType = [deal.type intValue];
    
    switch (dealType) {
        case 0:
            sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"food.png"]];                
            break;
        case 1:
            sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drink.png"]];  
            break;
    
    }
    
    
    customPinView.leftCalloutAccessoryView = sfIconView;
    [sfIconView release];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    rightButton.tag = [((BusAnnotation*) annotation).bus.ID intValue];
    
    return customPinView;

    
}

- (void)showDetails:(UIButton*)sender
{
    
    BusinessViewController *controller = [[BusinessViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.engine = self.engine;
    
    for (Business *bus in self.engine.busForGivenDay){
        if ([bus.ID intValue] == sender.tag){
            controller.bus = bus;
        }
    }
   
    
    [[self navigationController] pushViewController:controller
                                           animated:YES];
	[controller release];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if ([self isModal] && !self.isUpdated){
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = userLocation.coordinate.latitude;
        newRegion.center.longitude = userLocation.coordinate.longitude;
        newRegion.span.latitudeDelta = 0.03;
        newRegion.span.longitudeDelta = 0.03;
        
        [self.mapView setRegion:newRegion animated:YES];
        
        [self addBusToMap];
        
        self.isUpdated = YES;
    }
}
@end
