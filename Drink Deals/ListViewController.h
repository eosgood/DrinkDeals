
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FBConnect.h"
#import "DealsEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "DealCell.h"

@interface ListViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate,DealsUpdatedDelegate, FBSessionDelegate>
{
    BOOL _reloading;
}

@property (nonatomic, retain) IBOutlet UITableView *dealsTable;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) DealsEngine *engine;
@property (nonatomic, retain) CLGeocoder *reverseGeocoder;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UISegmentedControl *days;
@property (nonatomic, retain) NSNumber *dayOfTheWeek;

@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet DealCell *dealCell;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(IBAction) segmentedControlIndexChanged;


@end
