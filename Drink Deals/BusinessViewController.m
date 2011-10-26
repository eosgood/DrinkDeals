//
//  BusinessViewController.m
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "BusinessViewController.h"

/*
 Predefined colors to alternate the background color of each cell row by row
 (see tableView:cellForRowAtIndexPath: and tableView:willDisplayCell:forRowAtIndexPath:).
 */
#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]

@implementation BusinessViewController

@synthesize bus = _bus;
@synthesize engine = _engine;

- (void)dealloc
{
    [_bus release];
    [super dealloc];
}

-(void) edit 
{
    NewDealViewController *addController = [[NewDealViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addController.theBus = self.bus;
    addController.newBus = NO;
    addController.engine = self.engine;
    UINavigationController *newNavController = [[UINavigationController alloc]
                                                initWithRootViewController:addController];
    
    [[self navigationController] presentModalViewController:newNavController                                                   animated:YES];
    [addController release];
    [newNavController release];
   
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.bus.name;
    
    NSLog(@"ID: %@", self.bus.ID);
    
    self.tableView.backgroundColor = DARK_BACKGROUND;
    
    self.tableView.rowHeight = 48.0;
    
    self.tableView.bounces = NO;
    
    
    // configure map button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
                                  initWithTitle:@"Edit" 
                                  style:UIBarButtonSystemItemAction
                                  target:self 
                                  action:@selector(edit)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    [editButton release];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.bus = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 3;
            break;
        case 1: 
            rows = [self.bus.deals count];
            break;
        default:
            break;
    }
    return  rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
        case Address:
            cell.imageView.image = [UIImage imageNamed:@"map.png"];
            cell.textLabel.text = self.bus.address;
            break;
        case Phone:
            cell.imageView.image = [UIImage imageNamed:@"phone.png"];
            cell.textLabel.text = self.bus.phone;
            break;
        case Fb:
            cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
            cell.textLabel.text = @"Check-in";
            break;
        }
    } else {
        cell.selectionStyle = UITableViewCellAccessoryNone;
        Deal *deal = [self.bus.deals objectAtIndex: indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = deal.description;
        cell.detailTextLabel.text = deal.time;
        
        int dealType = [deal.type intValue];        
        switch (dealType) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"food.png"];
            break;
            
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"drink.png"];
            break;
        }
    }
    return cell;    
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return @"Business Information";
        case 1: return @"Todays Deals";
    }
    return nil;
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case Address:
            {
                MapViewController *detailViewController = [[MapViewController alloc] init];
                detailViewController.bus = self.bus;
                [self.navigationController pushViewController:detailViewController animated:YES];
                [detailViewController release];
                break;
            }  
            case Phone:
            {
                NSString *phone = [NSString stringWithFormat:@"tel://%@", self.bus.phone];
                NSURL *URL = [NSURL URLWithString:phone];
                [[UIApplication sharedApplication] openURL:URL];
            }
            case Fb: {
                FacebookCheckinController *detailViewController = [[FacebookCheckinController alloc] init];
                detailViewController.location = CLLocationCoordinate2DMake([self.bus.latitude floatValue], [self.bus.longitude floatValue]);
                
                [self.navigationController pushViewController:detailViewController animated:YES];
                [detailViewController release];
                
            }
            default:
                break;
        }
    }
}

@end
