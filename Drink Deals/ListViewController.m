
#import "ListViewController.h"

#import "Drink_DealsAppDelegate.h"
#import "NewDealViewController.h"
#import "MapViewController.h"
#import "BusinessViewController.h"

/*
 Predefined colors to alternate the background color of each cell row by row
 (see tableView:cellForRowAtIndexPath: and tableView:willDisplayCell:forRowAtIndexPath:).
 */
#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]


@implementation ListViewController

@synthesize reverseGeocoder = _coder;
@synthesize engine = _engine;
@synthesize locationManager = _locManager;
@synthesize days = _days;
@synthesize dayOfTheWeek = _dayOfTheWeek;

@synthesize cellNib = _cellNib;
@synthesize dealCell = _dealCell;
@synthesize refreshHeaderView = _refreshHeaderView;

@synthesize dealsTable = _dealsTable;

#pragma mark -
#pragma mark View controller methods

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    [_locManager release];
	[_coder release];
    [super dealloc];
}

-(void) refreshBusinesses
{   
    [self.engine setDay:self.dayOfTheWeek];
    //set the day of the week 
    [self.days setSelectedSegmentIndex: [self.dayOfTheWeek intValue]];
    
    [self.dealsTable reloadData];
}

-(void) dealsDownloaded
{
    [self refreshBusinesses];
}

- (void) setupSwipeRecognition
{
    UISwipeGestureRecognizer *recognizer;
   
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer 
{
    NSInteger currDay = [self.dayOfTheWeek intValue];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        currDay--;
        if (currDay < 0){
            currDay = 6;
        }
        
        
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        currDay++;
        if (currDay > 6){
            currDay = 0;
        }
    }
    
    self.dayOfTheWeek = [NSNumber numberWithInt:currDay];
    [self refreshBusinesses];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Drink Deals";
    
    
	// Configure the table view.
    self.dealsTable.rowHeight = 61.0;
    self.dealsTable.backgroundColor = DARK_BACKGROUND;
    self.dealsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = DARK_BACKGROUND;
    
    // configure map button
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Map" 
                                   style:UIBarButtonItemStylePlain
                                   target:self 
                                   action:@selector(map)];
    [[self navigationItem] setLeftBarButtonItem:mapButton];
    [mapButton release];
    
    //  Configure the Add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(add)];
    
    [[self navigationItem] setRightBarButtonItem:addButton];
    [addButton release];
    
    if (self.refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.dealsTable.bounds.size.height, self.view.frame.size.width, self.dealsTable.bounds.size.height)];
		view.delegate = self;
		[self.dealsTable addSubview:view];
		self.refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[self.refreshHeaderView refreshLastUpdatedDate];
    
    self.cellNib = [UINib nibWithNibName:@"DealCell" bundle:nil];
    
    [self setupSwipeRecognition];
    
   
}

-(void) viewWillAppear:(BOOL)animated
{
     NSArray* permissions = [NSArray arrayWithObjects: @"user_checkins", @"friends_checkins", @"publish_checkins", nil];
    
    Drink_DealsAppDelegate *delegate = (Drink_DealsAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize: permissions];
    } else {
        [self refreshBusinesses];
    }
}

#pragma mark - FBSessionDelegate Methods

/**
 * FBSession delegate
 */

-(void)fbDidLogin
{   
    
    Drink_DealsAppDelegate *delegate = (Drink_DealsAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Save authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[delegate facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[delegate facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self refreshBusinesses];
}

-(void)fbDidNotLogin:(BOOL)cancelled
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Facebook Failed to Login"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction) segmentedControlIndexChanged
{
    self.dayOfTheWeek = [NSNumber numberWithInt:self.days.selectedSegmentIndex];
    [self refreshBusinesses];
    
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)add
{
    if([CLLocationManager locationServicesEnabled]) {
		self.locationManager = [[CLLocationManager alloc] init]; 
		self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
	} else {
		[[[[UIAlertView alloc] initWithTitle:@"Error" 
									 message:@"Location services are disabled." 
									delegate:nil 
						   cancelButtonTitle:@"OK" 
						   otherButtonTitles:nil] autorelease] show];		
	}

    
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

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
	
   
    self.reverseGeocoder = [[[CLGeocoder alloc] init] autorelease];
    
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude] autorelease];
    
    
    [self.reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        [self displayPlacemarks:placemarks];
    }];
    
    [self.locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot obtain address."
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    [self.locationManager stopUpdatingLocation];
}

-(void) map
{
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.engine = self.engine;
    UINavigationController *newNavController = [[UINavigationController alloc]
                                                initWithRootViewController:mapViewController];
    
    [[self navigationController] presentModalViewController:newNavController                                                   animated:YES];
    [mapViewController release];
    [newNavController release];
}

#pragma mark Table view methods

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section 
{
    if ([self.engine.busForGivenDay count] == 0){
        return @"No Deals Today";
    }
    Business *bus = [self.engine.busForGivenDay objectAtIndex:section];
    return bus.name;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    if ([self.engine.busForGivenDay count] == 0){
        return 1;
    }
    return [self.engine.busForGivenDay count];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
     if ([self.engine.busForGivenDay count] == 0){
         return 0;
     }
    Business *bus = [self.engine.busForGivenDay objectAtIndex:section];
    return [bus.deals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DealCell";
    
    DealCell *cell = (DealCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        [self.cellNib instantiateWithOwner:self options:nil];
        cell = self.dealCell;
        self.dealCell = nil;
    }
	
	// Configure the data for the cell.
    Business *bus = [self.engine.busForGivenDay objectAtIndex:indexPath.section];
    cell.deal = [bus.deals objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tv willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2) ? DARK_BACKGROUND : LIGHT_BACKGROUND;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Business *bus = [self.engine.busForGivenDay objectAtIndex:indexPath.section];
    BusinessViewController *controller = [[BusinessViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.engine = self.engine;
    controller.bus = bus;
    [[self navigationController] pushViewController:controller
                                           animated:YES];
	[controller release];

}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self refreshBusinesses];
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.dealsTable];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)vie
{
	
	return [NSDate date]; // should return date data source was last changed
	
}



- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}



@end