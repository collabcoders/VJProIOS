//
//  SearchController.h
//  vjpro
//
//  Created by John Arguelles on 12/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface SearchController : UIViewController<SKSlideViewDelegate,UITableViewDelegate,UITableViewDataSource>

-(void)showspinner;

-(void)hidespinner;

@end
