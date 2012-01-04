
#import "RootViewController.h"

#import "Drink_DealsAppDelegate.h"
#import "NewDealViewController.h"
#import "MapViewController.h"
#import "DealCell.h"
#import "BusinessViewController.h"

/*
 Predefined colors to alternate the background color of each cell row by row
 (see tableView:cellForRowAtIndexPath: and tableView:willDisplayCell:forRowAtIndexPath:).
 */
#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]


@implementation RootViewController

@synthesize reverseGeocoder = _coder;
@synthesize engine = _engine;
@synthesize locationManager = _locManager;
@synthesize days = _days;
@synthesize dayOfTheWeek = _dayOfTheWeek;


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
    
    [self.tableView reloadData];
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
    self.tableView.rowHeight = 61.0;
    self.tableView.backgroundColor = DARK_BACKGROUND;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.bounces = YES;
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if ([self.engine.busForGivenDay count] == 0){
        return @"No Deals Today";
    }
    Business *bus = [self.engine.busForGivenDay objectAtIndex:section];
    return bus.name;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.engine.busForGivenDay count] == 0){
        return 1;
    }
    return [self.engine.busForGivenDay count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DealCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
	
	// Configure the data for the cell.
    Business *bus = [self.engine.busForGivenDay objectAtIndex:indexPath.section];
    cell.deal = [bus.deals objectAtIndex:indexPath.row];
    
    // Display dark and light background in alternate rows
    cell.useDarkBackground = (indexPath.row % 2 == 0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = ((DealCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Business *bus = [self.engine.busForGivenDay objectAtIndex:indexPath.section];
    BusinessViewController *controller = [[BusinessViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.engine = self.engine;
    controller.bus = bus;
    [[self navigationController] pushViewController:controller
                                           animated:YES];
	[controller release];

}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
    headerLabel.textAlignment = UITextAlignmentCenter;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
    if (section % 2 == 0){
        headerLabel.backgroundColor = LIGHT_BACKGROUND;
    }
    
	// If you want to align the header text as centered
	//headerLabel.frame = CGRectMake(120.0, 0.0, 300.0, 44.0);
    
    if ([self.engine.busForGivenDay count] == 0){
        headerLabel.text = @"No Deals Today";
    } else {
        Business *bus = [self.engine.busForGivenDay objectAtIndex:section];
        headerLabel.text = bus.name;
    }
    
	[customView addSubview:headerLabel];
    
	return customView;
}*/

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}



@end