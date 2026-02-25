//
//  OverlayViewController.m
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "OverlayViewController.h"

@implementation OverlayViewController

- (id)init{
    int height = 480;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height > 480)
        {
            height = 568;
        }
    }
	return [self initWithFrame:CGRectMake(0, 0, 320, height)];
}

- (id)initWithFrame:(CGRect)aRect{
	self = [super initWithFrame: aRect];
	if ( self == nil )
		return ( nil );
	self.backgroundColor= [UIColor blackColor];
	self.alpha = .4;
	self.hidden = YES;
    self.userInteractionEnabled = YES;
    
	return self;
}

-(void)showOverlay {
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    
    //self.windowLevel = UIWindowLevelStatusBar + 1;
    //[self makeKeyAndVisible];
}

-(void)hideOverlay {
    self.hidden = YES;
    //[self removeFromSuperview];
}

@end
