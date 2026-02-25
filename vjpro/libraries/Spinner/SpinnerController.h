//
//  SpinnerController.h
//  EdjoinApp
//
//  Created by Mike Thomasson on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpinnerController : UIView 

@property (nonatomic,retain) UIActivityIndicatorView *activity;

- (void)startAnimating;

- (void)stopAnimating;


@end
