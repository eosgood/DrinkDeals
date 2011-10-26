//
//  BusCell.h
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BusCell : UITableViewCell {
    IBOutlet UIImageView *busImage;
    IBOutlet UILabel *busText;
}

@property (nonatomic, retain) UIImage *theImage;
@property (nonatomic, retain) NSString *theText;

@end
