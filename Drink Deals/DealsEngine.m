//
//  DealsEngine.m
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "DealsEngine.h"

#define DEAL_URL @"http://thedrinkdeals.com/getDeals.php"
#define INSERT_URL @"http://thedrinkdeals.com/insert.php"

@implementation DealsEngine

@synthesize businesses = _businesses;
@synthesize busForGivenDay = _bfgd;
@synthesize business = _bus;

-(void) dealloc
{
    [_bus release];
    [_dealsDelegate release];
    [_bfgd release];
    [_businesses release];
    [super dealloc];
}

- (id) initializeWithDelegate: (id)delegate
{
    self = [super init];
    
    _businesses = [[NSMutableArray alloc] init];
    _bfgd = [[NSMutableArray alloc] init];
    _dealsDelegate = [delegate retain];
    
    return self;   
}

-(void) startAysncUrlDownload: (NSString*) url
{
    NSURL *theUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:theUrl];
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request 
{
    NSString *responseString = [request responseString];
    
    JSONDecoder* decoder = [JSONDecoder decoder];

    NSArray *businesses = [decoder objectWithData:[responseString dataUsingEncoding: NSASCIIStringEncoding]];
    
    [self.businesses removeAllObjects];
    
    for (NSDictionary *currBus in businesses){
        Business *tmpBus = [[Business alloc] initWithDictionary:currBus];
        [self.businesses addObject:tmpBus];
        [tmpBus release];
    }
    [_dealsDelegate dealsDownloaded];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"ASI http request: %@", [error localizedDescription]);
}

-(void) downloadDeals
{
    [self startAysncUrlDownload:DEAL_URL];
}


-(void) addNewDeal: (Business*) newBus
{
    Insert *insertDelegate = [[[[Insert alloc] initializeWithDelegate:self] retain] autorelease];
    
    NSURL *theUrl = [NSURL URLWithString:INSERT_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:theUrl];
    request.tag = BusinessInsert;
    [request setPostValue:@"Businesses" forKey:@"table"];
    [request setPostValue:newBus.name forKey:@"name"];
    [request setPostValue:newBus.address forKey:@"address"];
    [request setPostValue:newBus.phone forKey:@"phone"];
    [request setPostValue:newBus.latitude forKey:@"latitude"];
    [request setPostValue:newBus.longitude forKey:@"longitude"];
    [request setDelegate:insertDelegate];
    [request startAsynchronous];
    self.business = newBus;
    
}

-(void) addDealToBus: (Deal*) deal
{
    Insert *insertDelegate = [[[[Insert alloc] initializeWithDelegate:self] retain] autorelease];
    
    NSURL *theUrl = [NSURL URLWithString:INSERT_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:theUrl];
    request.tag = DealInsert;
    [request setDelegate:insertDelegate];
    [request setPostValue:@"Deals" forKey:@"table"];
    [request setPostValue: deal.bus_id forKey:@"bus_id"];
    [request setPostValue:deal.description forKey:@"description"];
    [request setPostValue:deal.type forKey:@"type"];
    [request setPostValue:deal.time forKey:@"time"];
    
    NSMutableString * days = [[NSMutableString alloc] init];
    for (NSString * day in deal.days)
    {
        [days appendString:[NSString stringWithFormat:@"%@ ", day]];
    }
    NSString *trimmedDays = [days stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [request setPostValue:trimmedDays forKey:@"days"];
    [days release];
    [request startAsynchronous]; 

    
}

-(void) busCreated:(NSInteger)busID
{
    NSLog(@"BUS added id: %d", busID);
    if (self.business != nil){
        for (Deal *deal in self.business.deals){
            Insert *insertDelegate = [[[[Insert alloc] initializeWithDelegate:self] retain] autorelease];
            
            NSURL *theUrl = [NSURL URLWithString:INSERT_URL];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:theUrl];
            request.tag = DealInsert;
            [request setDelegate:insertDelegate];
            [request setPostValue:@"Deals" forKey:@"table"];
            [request setPostValue: [NSString stringWithFormat:@"%d",busID] forKey:@"bus_id"];
            [request setPostValue:deal.description forKey:@"description"];
            [request setPostValue:deal.type forKey:@"type"];
            [request setPostValue:deal.time forKey:@"time"];
            [request setPostValue:deal.specials forKey:@"specials"];
            
            NSMutableString * days = [[NSMutableString alloc] init];
            for (NSString * day in deal.days)
            {
                [days appendString:[NSString stringWithFormat:@"%@ ", day]];
            }
            NSString *trimmedDays = [days stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [request setPostValue:trimmedDays forKey:@"days"];
            [days release];
            [request startAsynchronous]; 
        }
    } else {
        NSLog(@"No new business");
    }
}

-(void) dealAdded
{
    NSLog(@"Deal Added");
    [self startAysncUrlDownload:DEAL_URL];
}

-(void) dataError
{
    NSLog(@"error");
}

-(void) setDay: (NSNumber*) dayOfTheWeek
{
    [self.busForGivenDay removeAllObjects];
    for (Business *bus in self.businesses){
        NSMutableArray *dealsForDay = [[NSMutableArray alloc] init];
        for (Deal *deal in bus.deals){
            for (NSString *day in deal.days){
                if ([dayOfTheWeek intValue] == [day intValue]){
                    [dealsForDay addObject:deal];
                }
            }
        }
        if ([dealsForDay count] > 0){
            Business *tmpBus = [[Business alloc] init];
            
            tmpBus.name = bus.name;
            tmpBus.phone = bus.phone;
            tmpBus.address = bus.address;
            tmpBus.latitude = bus.latitude;
            tmpBus.longitude = bus.longitude;
            tmpBus.icon = bus.icon;
            tmpBus.ID = bus.ID;
            
            tmpBus.deals = dealsForDay;
            
            [self.busForGivenDay addObject:tmpBus];
            [tmpBus release];
        }
        [dealsForDay release];
    }
}



@end
