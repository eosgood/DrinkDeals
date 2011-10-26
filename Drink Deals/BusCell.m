//
//  BusCell.m
//  Drink Deals
//
//  Created by Eric Osgood on 5/31/11.
//  Copyright 2011 Osgood Software. All rights reserved.
//

#import "BusCell.h"


@implementation BusCell

@synthesize theText = _theText;
@synthesize theImage = _theImage;

-(void) setTheText:(NSString *)theText{
    _theText = theText;
    busText.text = theText;
}

-(void) setTheImage:(UIImage *)theImage{
    _theImage = theImage;
    busImage.image = theImage;
}

- (void)dealloc
{
    [_theImage release];
    [_theText release];
    
    [busImage release];
    [busText release];
    
    [super dealloc];
}

@end
