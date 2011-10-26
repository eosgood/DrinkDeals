
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "DealCell.h"
#import "DealsEngine.h"
#import "BusinessViewController.h"
#import "MapViewController.h"

@interface RootViewController : UITableViewController <MKReverseGeocoderDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate,DealsUpdatedDelegate>
{

}

@property (nonatomic, assign) DealsEngine *engine;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UISegmentedControl *days;
@property (nonatomic, retain) NSNumber *dayOfTheWeek;

-(IBAction) segmentedControlIndexChanged;


@end
