//
//  FacebookCheckinController.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/5/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "FacebookCheckinController.h"

#import "Drink_DealsAppDelegate.h"


@implementation FacebookCheckinController

@synthesize places = _places;
@synthesize location = _location;
@synthesize theBus = _theBus;

- (void)dealloc
{
    [_theBus release];
    [_places release];
    [super dealloc];
}

/**
 * Get data / send data
 */

- (void) getNearbyPlaces {
    
    
	NSString *centerString = [NSString stringWithFormat: @"%f,%f", self.location.latitude, self.location.longitude];
    
	NearbyPlacesRequestResult *nearbyPlacesRequestResult =
	[[[[NearbyPlacesRequestResult alloc] initializeWithDelegate:self] retain] autorelease];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"place",@"type",
								   centerString,@"center",
								   @"1000",@"distance", // In Meters (1000m = 0.62mi)
								   nil];
    Drink_DealsAppDelegate *delegate = (Drink_DealsAppDelegate *) [[UIApplication sharedApplication] delegate];
    
	[[delegate facebook] requestWithGraphPath:@"search" andParams: params andDelegate:nearbyPlacesRequestResult];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Check-in";
    
    [self getNearbyPlaces];
    
}


/**
 * delegate for places request
 */
-(void) nearbyPlacesRequestCompletedWithPlaces:(NSArray *)placesArray
{
    self.places = [[NSArray alloc] initWithArray:placesArray];
    
    [self.tableView reloadData];
}


-(void) nearbyPlacesRequestFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"failed to load places"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 * post checkin to fb
 */
- (void) postCheckinWithDictionary:(NSMutableDictionary *)dictionary {
    
    PostCheckinRequestResult *postCheckinRequestResult =
	[[[[PostCheckinRequestResult alloc] initializeWithDelegate:self] retain] autorelease];

    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
	NSMutableDictionary *coordinatesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [NSString stringWithFormat: @"%f", self.location.latitude], @"latitude",
                                                  [NSString stringWithFormat: @"%f", self.location.longitude], @"longitude",
                                                  nil];
    
	NSString *coordinates = [jsonWriter stringWithObject:coordinatesDictionary];
    
    Deal *deal = [self.theBus.deals objectAtIndex:0];
    
    NSMutableString *info = [NSMutableString stringWithString:self.theBus.name];
    [info appendString:@" | "];
    [info appendString:deal.description];
    
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   [dictionary objectForKey:@"id"], @"place", //The PlaceID
								   coordinates, @"coordinates", 
                                   info, @"message",
								   nil];
    
    Drink_DealsAppDelegate *delegate = (Drink_DealsAppDelegate *) [[UIApplication sharedApplication] delegate];
    
	[[delegate facebook] requestWithGraphPath:@"me/checkins" andParams:params andHttpMethod:@"POST" andDelegate:postCheckinRequestResult];
}

/**
 * fb checkin delegate
 */
-(void) postCheckinRequestFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Failed to checkin"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void) postCheckinRequestCompleted
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successful Check-in"
														message:nil
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
	cell.textLabel.text = (NSString *)[[self.places objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.detailTextLabel.text = (NSString *)[[self.places objectAtIndex:indexPath.row] valueForKeyPath:@"location.street"];
    
	return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    [self postCheckinWithDictionary:[self.places objectAtIndex:indexPath.row]];
}

@end
