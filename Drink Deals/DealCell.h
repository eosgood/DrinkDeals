//
//  DealCell.h
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

enum{
    FoodDeal,
    DrinkDeal
};

@interface DealCell : UITableViewCell {
    IBOutlet UIImageView *dealTypeView;
    IBOutlet UILabel *dealDescription;
    IBOutlet UILabel *dealTime;
    IBOutlet UILabel *specials;
}

@property (nonatomic, retain) Deal *deal;


@end
