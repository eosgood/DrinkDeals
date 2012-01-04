//
//  DealsEngine.h
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Insert.h"

@protocol DealsUpdatedDelegate;

@interface DealsEngine : NSObject <BusinessInsertedDelegate>{

    id _dealsDelegate;
}

@property (nonatomic, retain) NSMutableArray *businesses;
@property (nonatomic, retain) NSMutableArray *busForGivenDay;
@property (retain) Business *business;

- (id) initializeWithDelegate: (id)delegate;
-(void) addNewDeal: (Business*) newBus;
-(void) addDealToBus: (Deal*) deal;
-(void) setDay: (NSNumber*) dayOfTheWeek;
-(void) downloadDeals;

@end

@protocol DealsUpdatedDelegate

- (void) dealsDownloaded;

@end