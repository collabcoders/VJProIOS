//
//  SpinnerController.m
//  EdjoinApp
//
//  Created by Mike Thomasson on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpinnerController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpinnerController
@synthesize activity;

- (id)init{
	return [self initWithFrame:CGRectMake(0, 0, 60, 60)];
}

- (id)initWithFrame:(CGRect)aRect{
	self = [super initWithFrame: aRect];
	if ( self == nil )
		return ( nil );
	
	self.layer.cornerRadius = 10.0;
    
	self.backgroundColor = [UIColor darkGrayColor];
    
	self.alpha = .8;
    
	self.hidden = YES;

	activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    /*activity.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self addSubview:activity];*/
	activity.center = self.center;
	[self addSubview:activity];
	
	
	return self;
}



- (void)startAnimating{    
	[activity startAnimating];
	self.hidden = NO;
}

- (void) stopAnimating{
	[activity stopAnimating];
	self.hidden = YES;
}

@end
