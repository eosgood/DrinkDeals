//
//  NewDealViewController.m
//  Drink Deals
//
//  Created by Eric Osgood on 6/2/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "NewDealViewController.h"

/*
 Predefined colors to alternate the background color of each cell row by row
 (see tableView:cellForRowAtIndexPath: and tableView:willDisplayCell:forRowAtIndexPath:).
 */
#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]

@implementation NewDealViewController

@synthesize newBus;
@synthesize engine = _engine;
@synthesize theBus = _bus;
@synthesize placemark = _place;
@synthesize dealType = _dealType;
@synthesize dealDays = _dealDays;
@synthesize daysOfTheWeek = _days;
@synthesize newDeal = _newDeal;


- (void)dealloc
{
    [_newDeal release];
    [_bus release];
    
    [_dealDays release];
    [_days release];
    
    [_dealType release];
    [_place release];
    
    
    
    [super dealloc];
}

-(void) addDaysToDeal
{
    NSMutableArray *days = [[NSMutableArray alloc] init];
    int index = 0;
    for (NSString *day in self.dealDays){
        if ([day boolValue]){
            [days addObject:[NSNumber numberWithInt:index]];
        }
        index++;
    }
    self.newDeal.days = [[NSArray alloc] initWithArray:days];
    [days release];
}

- (void)save
{
    [self addDaysToDeal];
    
    if (self.newDeal.type == nil){
        self.newDeal.type = [NSNumber numberWithInt: self.dealType.selectedSegmentIndex];
    }
    
    if (self.newBus){
        self.theBus.latitude = [NSNumber numberWithFloat: self.placemark.coordinate.latitude];
        self.theBus.longitude = [NSNumber numberWithFloat: self.placemark.coordinate.longitude];
        self.theBus.deals = [[NSMutableArray alloc] initWithCapacity:1];
        [self.theBus.deals addObject:self.newDeal];
        [self.engine addNewDeal:self.theBus];
    } else {
        self.newDeal.bus_id = self.theBus.ID;
        [self.engine addDealToBus:self.newDeal];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.newDeal = [[Deal alloc] init];
    
    // setup days 
    self.dealDays = [[NSMutableArray alloc] initWithObjects: @"NO", @"NO",@"NO",@"NO",@"NO",@"NO",@"NO",nil];
    self.daysOfTheWeek = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    
    self.tableView.rowHeight = 48.0;
    self.tableView.backgroundColor = DARK_BACKGROUND;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(save)];
    
    [[self navigationItem] setRightBarButtonItem:saveButton];
    [saveButton release];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(cancel)];
    
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    [cancelButton release];

    
    if (!self.newBus){
        self.title = self.theBus.name;
    } else {
        self.title = @"Add a New Deal";
        self.theBus = [[Business alloc] init];
        self.theBus.deals = [[NSMutableArray alloc] initWithCapacity:1];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UITextFieldDelegate Protocol
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField tag] == DealTime)
    {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    NSString *text = [textField text];
    
    switch ([textField tag])
    {
        case BusName: 
            self.theBus.name = text; 
            break;
        case BusAddress: self.theBus.address = text; break;
        case BusPhone: self.theBus.phone = text; break;
            
        case DealDesc: self.newDeal.description = text; break;
        case DealSpecials: self.newDeal.specials = text; break;
        case DealTime: self.newDeal.time = text; break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] != UIReturnKeyDone)
    {
        NSInteger nextTag = [textField tag] + 1;
        UIView *nextTextField = [[self tableView] viewWithTag:nextTag];
        
        [nextTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        return YES;
    }
        
    return YES;
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 3;
        case 1: return 4;
        case 2: return 7;
            
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    EditableDetailCell *cell = (EditableDetailCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EditableDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:CellIdentifier] autorelease];
        [cell.textField setDelegate:self];
    }
    
    // reset the cell incase its being reused
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.textField.text = nil;
    cell.textField.placeholder = nil;
    [cell.textField setKeyboardType:UIKeyboardTypeDefault];
    cell.textField.enabled = YES;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    // Configure the cell...
    if (indexPath.section == 0){
       
        switch (indexPath.row) {
            case 0:
                cell.textField.placeholder = @"Name";
                cell.textField.tag = BusName;
                cell.textField.text = self.theBus.name;
                break;
            case 1: 
                cell.textField.tag = BusAddress;
                cell.textField.placeholder = @"Address";
                if (!self.newBus){
                    cell.textField.text = self.theBus.address;
                } else {
                    cell.textField.text = self.placemark.thoroughfare;
                }
                break;
            case 2:
                cell.textField.tag = BusPhone;
                cell.textField.placeholder = @"Phone";
                [cell.textField setKeyboardType:UIKeyboardTypePhonePad];
                [cell.textField setReturnKeyType:UIReturnKeyNext];
                cell.textField.text = self.theBus.phone;
                break;
        }
    } else if ( indexPath.section == 1){
        [cell.textField setKeyboardType:UIKeyboardTypeDefault];
        switch (indexPath.row) {
            case 0:
                cell.textField.placeholder = @"Description";
                cell.textField.tag = DealDesc;
                cell.textField.text = self.newDeal.description;
                break;
            case 1:
                cell.textField.tag = DealSpecials;
                cell.textField.placeholder = @"Specials";
                cell.textField.text = self.newDeal.specials;
                break;
            case 2:
                cell.textField.tag = DealTime;
                cell.textField.placeholder = @"Time";
                cell.textField.text = self.newDeal.time;
                break;
            case 3:
            {
                NSArray *segmentItems = [NSArray arrayWithObjects:@"Food", @"Drink", nil];
                self.dealType = [[UISegmentedControl alloc] initWithItems:segmentItems];
                 self.dealType.selectedSegmentIndex = [self.newDeal.type intValue];
                 self.dealType.frame  = CGRectMake(2, 2, 296, 44);
                [self.dealType addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
                [cell.contentView addSubview: self.dealType];
                break;
            } 
        }
    } else if (indexPath.section == 2) {
        cell.textField.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.textField.text = [self.daysOfTheWeek objectAtIndex:indexPath.row];
        
        NSString *checked = [self.dealDays objectAtIndex:indexPath.row];
        
        if([checked boolValue]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    
    }
    return cell;
}

- (void)onSegmentedControlChanged:(id)sender
{
    self.newDeal.type = [NSNumber numberWithInt: self.dealType.selectedSegmentIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 2:
        {
            NSString *checked = [self.dealDays objectAtIndex:indexPath.row];
            BOOL chk = [checked boolValue];
            chk = !chk;
            [self.dealDays replaceObjectAtIndex:indexPath.row withObject:chk ? @"YES" : @"NO"];
            break;
        }
    }
    
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section) {
        case 0: return @"Business Information";
        case 1: return @"New Deal Information";
        case 2: return @"Deal Days";
    }
    return nil;
}

@end
