//
//  VideosController.h
//  vjpro
//
//  Created by John Arguelles on 12/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SKSlideViewController.h"
#import "VideoModel.h"
#import "VideoPaginatorModel.h"

@interface VideosController : UIViewController<SKSlideViewDelegate,NMPaginatorDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) VideoPaginatorModel *paginator;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) int pageSize;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) BOOL statusLoopStarted;
@property (nonatomic) BOOL connectionWasDropped;
@property (nonatomic, retain) NSTimer *statusTimer;
@property (weak, nonatomic) IBOutlet UITableView *tblVideos;

- (IBAction)didTappedRevealLeftButton:(id)sender;

- (IBAction)didTappedRevealRightButton:(id)sender;

- (IBAction)didTappedExitButton:(id)sender;

-(void)newsearch;

-(void)updateStatus;

-(void)showStatusChanges:(NSDictionary *)settingData;

-(void)showspinner;

-(void)hidespinner;

@end
