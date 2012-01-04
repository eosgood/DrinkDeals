
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FBConnect.h"
#import "DealsEngine.h"

@interface RootViewController : UITableViewController <CLLocationManagerDelegate, UIGestureRecognizerDelegate,DealsUpdatedDelegate, FBSessionDelegate>
{
    
}

@property (nonatomic, assign) DealsEngine *engine;
@property (nonatomic, retain) CLGeocoder *reverseGeocoder;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UISegmentedControl *days;
@property (nonatomic, retain) NSNumber *dayOfTheWeek;

-(IBAction) segmentedControlIndexChanged;


@end
