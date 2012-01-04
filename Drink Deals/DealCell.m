//
//  DealCell.m
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "DealCell.h"


@implementation DealCell

@synthesize useDarkBackground = _useDarkBackground;
@synthesize deal = _deal;

- (void)setUseDarkBackground:(BOOL)flag
{
    if (flag != _useDarkBackground || !self.backgroundView)
    {
        _useDarkBackground = flag;
        
        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:_useDarkBackground ? @"DarkBackground" : @"LightBackground" ofType:@"png"];
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    dealDescription.backgroundColor = backgroundColor;
    dealTypeView.backgroundColor = backgroundColor;
}

-(void) setDeal:(Deal *)deal
{
    _deal = deal;
    
    dealDescription.text = deal.description;
    dealTime.text = deal.time;
    
    specials.text = deal.specials;
    
    int dealType = [deal.type intValue];
    
    
    switch (dealType) {
        case 0:
            dealTypeView.image= [UIImage imageNamed:@"food.png"];
            break;
            
        case 1:
            dealTypeView.image= [UIImage imageNamed:@"drink.png"];
            break;
    }
    
}

- (void)dealloc
{
    [_deal release];
    [dealTypeView release];
    [dealTime release];
    [dealDescription release];
       
    
    [super dealloc];
}

@end
