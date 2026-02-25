//
//  VideosController.m
//  vjpro
//
//  Created by John Arguelles on 12/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "VideosController.h"
#import "VideoModel.h"
#import "SpinnerController.h"
#import "OverlayViewController.h"
#import "SearchModel.h"
#import "ISO8601DateFormatter.h"
#import "UtilityModel.h"
#import "UserModel.h"
#import "VideoCellModel.h"
#import "PreviewController.h"
#import "ViewController.h"
#import "QueueModel.h"
#import "YRDropdownView.h"
#import "IAElegantSheet.h"
#import "SortModel.h"
#import "SearchController.h"
#import "ODRefreshControl.h"

@interface VideosController ()

@property (nonatomic, weak) SKSlideViewController *slideController;
@property (nonatomic, retain) SpinnerController *spinner;
@property (nonatomic, retain) OverlayViewController *ovcontroller;
- (IBAction)btnQueue:(id)sender;
@property (nonatomic, retain) NSDictionary *sortTags;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *viewStatusBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownloader;
@property (weak, nonatomic) IBOutlet UILabel *lblDownloader;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditStatus;
@property (weak, nonatomic) IBOutlet UIView *viewWebContainer;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)btnWebClose:(id)sender;

@end

@implementation VideosController 

@synthesize paginator=_paginator;
@synthesize footerLabel=_footerLabel;
@synthesize activityIndicator=_activityIndicator;
@synthesize pageSize=_pageSize;
@synthesize lblTitle=_lblTitle;
@synthesize statusLoopStarted=_statusLoopStarted;
@synthesize connectionWasDropped=_connectionWasDropped;
@synthesize statusTimer=_statusTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showspinner];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(hidespinner) withObject:self afterDelay:2.5];
}

-(void)showspinner {
    [_ovcontroller showOverlay];
    [_spinner startAnimating];
}

-(void)hidespinner {
    [_ovcontroller hideOverlay];
    [_spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.'
    _viewWebContainer.hidden = YES;
    
    //set defaults
    [SearchModel resetParams];
    [QueueModel setSelectedVideoID:0];

    //initialize spinner
    _ovcontroller = [[OverlayViewController alloc] init];
    [_ovcontroller setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [_ovcontroller setUserInteractionEnabled:NO];
    [self.view addSubview:_ovcontroller];
    _spinner = [[SpinnerController alloc] init];
    _spinner.center = self.view.center;
    [self.view addSubview:_spinner];
    
     //set table bg
     self.tblVideos.backgroundColor = [UIColor darkGrayColor];
     if ([self.tblVideos respondsToSelector:@selector(setSeparatorInset:)]) {
         [self.tblVideos setSeparatorInset:UIEdgeInsetsZero];
     }
    
    CALayer *statusBorder = [CALayer layer];
    statusBorder.frame = CGRectMake(0.0f, 22.0f, _viewStatusBar.frame.size.width, 1.0f);
    statusBorder.backgroundColor = [UIColor blackColor].CGColor;
    [_viewStatusBar.layer addSublayer:statusBorder];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tblVideos];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    self.connectionWasDropped = NO;
    
    //load status bar
    [_viewStatusBar setAlpha:0.6];
    _imgDownloader.image = [UIImage imageNamed:@"dot_yellow"];
    [_lblDownloader setText:@"Checking Status..."];
    [self updateStatus];
    [self.statusTimer invalidate];
    self.statusTimer = nil;
    self.statusLoopStarted = YES;
    self.statusTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                         target:self
                                       selector:@selector(updateStatus)
                                       userInfo:nil
                                        repeats:YES];
    NSLog(@"loop started");
    
    //load data
    [UserModel setAlertShowing:NO];
    [self setupTableViewFooter];
    self.pageSize = [UserModel getPageSize];
    [self.lblTitle setText:@"Latest Releases"];
    [self newsearch];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    SearchController *leftController=(SearchController *)[self.slideController getLeftViewController];
    [self showspinner];
    [leftController showspinner];
    self.pageSize = [UserModel getPageSize];
    [self newsearch];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

-(void)newsearch {
    // set up the paginator
    [QueueModel setHasRefreshed:YES];
    self.paginator = [[VideoPaginatorModel alloc] initWithPageSize:self.pageSize delegate:self];
    [self.paginator fetchFirstPage];
}

-(void)updateStatus {
    if ([UserModel getUserID] > 0) {
        NSString *strUserId = [NSString stringWithFormat:@"%ld", (long)[UserModel getUserID]];
        NSString *strUrl = [NSString stringWithFormat:@"https://www.vj-pro.net/Mobile/GetUpdatedSettings/%@",strUserId];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSDictionary * settingData = [UtilityModel getJsonData:strUrl params:params];

        if (settingData != nil) {
            [self showStatusChanges:settingData];
            if (self.connectionWasDropped) {
                self.connectionWasDropped = NO;
                [self newsearch];
            }
        } else {
            self.connectionWasDropped = YES;
        }
        
        NSLog(@"looped");
    }
}

-(void)showStatusChanges:(NSDictionary *)settingData {
    [UserModel setCredits:[[settingData valueForKey:@"credits"] integerValue]];
    [UserModel setQueueCount:[[settingData valueForKey:@"queuecount"] integerValue]];
    [UserModel setDownloaderOnline:[[settingData valueForKey:@"downloaderonline"] boolValue]];
    [UserModel setStatus:[settingData valueForKey:@"status"]];
    NSString *status = [settingData valueForKey:@"status"];
    if ([status isEqualToString:@"current"] || [status isEqualToString:@"trial"] || [status isEqualToString:@"free"]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [_viewStatusBar setAlpha:1.0];
        [UIView commitAnimations];
        if ([UserModel getDownloaderOnline]) {
            _imgDownloader.image = [UIImage imageNamed:@"dot_green"];
            [_lblDownloader setText:@"Downloader Online"];
        } else {
            _imgDownloader.image = [UIImage imageNamed:@"dot_red"];
            [_lblDownloader setText:@"Downloader Offline"];
        }
        [_lblCreditStatus setText:[NSString stringWithFormat:@"Queued: %ld, Credits: %ld", (long)[UserModel getQueueCount],(long)[UserModel getCredits]]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [_viewStatusBar setAlpha:0.6];
        [UIView commitAnimations];
    } else {
        [_ovcontroller hideOverlay];
        [_spinner stopAnimating];
        [UserModel setUserID:0];
        [self.statusTimer invalidate];
        self.statusTimer = nil;
        [UtilityModel showAlert:@"Account not current" msg:@"Your VJ-Pro subscription is not current.  Please visit www.vj-pro.net to update your subscription."];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Slide Controller Delegate
#pragma mark -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
}

- (IBAction)didTappedRevealLeftButton:(id)sender {
    if(self.slideController.isActive){
        [self.slideController revealLeftContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}

- (IBAction)didTappedRevealRightButton:(id)sender {
    if(self.slideController.isActive){
        [self.slideController revealRightContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}

- (IBAction)didTappedExitButton:(id)sender {
    [self.slideController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Rows %lu", (unsigned long)[self.paginator.results count]);
    return [self.paginator.results count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UIActivityIndicatorViewStyleGray;

    VideoModel *result = [self.paginator.results objectAtIndex:indexPath.row];
    VideoCellModel *aCell=(VideoCellModel *)cell;
    
    //clear all fields
    [aCell.btnCellQueue setBackgroundImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];
    [aCell.imgCellHd setImage:[UIImage imageNamed:@"blank"]];
    [aCell.lblCellTitle setText:@""];
    [aCell.lblCellArtist setText:@""];
    [aCell.lblCellTitleNonHd setText:@""];
    [aCell.lblCellDetails setText:@""];
    
    //queue button
    BOOL checked = result.queued;
    UIImage *image = (checked) ? [UIImage imageNamed:@"icon_queue_remove"] : [UIImage imageNamed:@"icon_queue_add"];
    if (result.downloaded) {
        image = [UIImage imageNamed:@"icon_queued_downloaded"];
        if (checked) {
            image = [UIImage imageNamed:@"icon_queue_remove"];
        }
    }
    if (result.downloading) {
        image = [UIImage imageNamed:@"icon_queue_downloading"];
    }
    aCell.btnCellQueue.tag = indexPath.row;
    [aCell.btnCellQueue setBackgroundImage:image forState:UIControlStateNormal];
    [aCell.btnCellQueue addTarget:self action:@selector(btnQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    //hd icon
    NSString * strCredits = [NSString stringWithFormat:@"%ld CR", (long)result.credits];
    NSString *imgHd = @"blank";
    int hd = (int)result.quality;
    if (hd == 2) {
        imgHd = @"icon_1080";
        [aCell.imgCellHd setImage:[UIImage imageNamed:imgHd]];
        [aCell.lblCellTitleNonHd setText:@""];
        [aCell.lblCellTitle setText:[NSString stringWithFormat:@"%@ [%@]", result.Title,result.version]];
    }
    if (hd == 1) {
        imgHd = @"icon_hd";
        [aCell.imgCellHd setImage:[UIImage imageNamed:imgHd]];
        [aCell.lblCellTitleNonHd setText:@""];
        [aCell.lblCellTitle setText:[NSString stringWithFormat:@"%@ [%@]", result.Title,result.version]];
    }
    if (hd == 0) {
        [aCell.lblCellTitleNonHd setText:[NSString stringWithFormat:@"%@ [%@]", result.Title,result.version]];
    }
    
    [aCell.lblCellArtist setText:result.Artist];
    NSDateFormatter *anotherDateFormatter = [[NSDateFormatter alloc] init];
    [anotherDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [anotherDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *finalDate = [anotherDateFormatter stringFromDate:result.Date];
    NSString *cellDetails = [NSString stringWithFormat:@"%@, %@bpm, %@, ",finalDate,result.BPM, result.releaseyear];
    NSString *cellClean = @"Clean, ";
    if (!result.isclean) {
        cellClean = @"Dirty, ";
    }
    [aCell.lblCellDetails setText:[NSString stringWithFormat:@"%@%@%@, %@", cellDetails,cellClean,result.version, strCredits]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
	UITableViewCell *cell = [self tableView: tableView cellForRowAtIndexPath: indexPath];
	return cell.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCellModel *cell = (VideoCellModel *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor grayColor];
    
    [self.slideController revealRightContainerViewAnimated:YES];
    
    VideoModel *selectedVideo = [self.paginator.results objectAtIndex:indexPath.row];
    //VideoModel *selectedVideo = [self getSearchResult:indexPath];
    PreviewController *preview = (PreviewController *)[self.slideController getRightViewController];
    int selectedVideoID = (int)[QueueModel getSelectedVideoID];
    if (selectedVideo.videoId != selectedVideoID) {
        [QueueModel setHasRefreshed:NO];
        [QueueModel setSelectedVideoID:selectedVideo.videoId];
        [QueueModel setSelectedQueueID:[selectedVideo.queueId integerValue]];
        [QueueModel setSelectedGroupID:selectedVideo.groupId];
        [QueueModel setSelectedCreditVal:selectedVideo.credits];
        preview.seconds = [UserModel getPreviewSeconds];
        preview.video = selectedVideo;
        preview.cellSelected = cell;
        [preview loadVideoData];
    } else {
        [QueueModel setSelectedQueueID:[selectedVideo.queueId integerValue]];
        [preview updateQueueButton];
    }
    NSLog(@"Preview Video ID: %ld", (long)selectedVideo.videoId);
}

- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    _viewWebContainer.hidden = YES;
    SearchController *leftController=(SearchController *)[self.slideController getLeftViewController];
    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    if (indexOfTab == 0) {
        //[SortModel loadSortList];
        [[SortModel loadSortList:self] showInView:self.view];
    }
    if (indexOfTab == 1) {
        [self showspinner];
        [leftController showspinner];
        [SearchModel resetParams];
        //[SortModel loadSortList];
        self.pageSize = [UserModel getPageSize];
        [self.lblTitle setText:@"Latest Releases"];
        [self newsearch];
    }
    if (indexOfTab == 2) {
        [self showspinner];
        [leftController showspinner];
        [SearchModel resetParams];
        [SearchModel setProgram:@"queued"];
        //[SortModel loadSortList];
        self.pageSize = [UserModel getPageSize];
        [self.lblTitle setText:@"My Queue"];
        [self newsearch];
    }
    if (indexOfTab == 3) {
        [self showspinner];
        [leftController showspinner];
        [SearchModel resetParams];
        [SearchModel setProgram:@"downloads"];
        //[SortModel loadSortList];
        self.pageSize = [UserModel getPageSize];
        [self.lblTitle setText:@"My Downloads"];
        [self newsearch];
    }
    if (indexOfTab == 4) {
        [_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
        NSURL * myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.vj-pro.net/Mobile/SelectPackage/%ld", (long)[UserModel getUserID]]];
        NSMutableURLRequest * myRequest = [NSMutableURLRequest requestWithURL:myUrl];
        [_webView loadRequest:myRequest];
        [self showspinner];
        CGRect webFrame = _viewWebContainer.frame;
        webFrame.origin.y = 502;
        _viewWebContainer.frame = webFrame;
        _viewWebContainer.hidden = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        webFrame.origin.y = 0;
        _viewWebContainer.frame = webFrame;
        [UIView commitAnimations];
    }
    if (indexOfTab == 5) {
        [UserModel setUserID:0];
        [UserModel setUserHD:-1];
        [self.statusTimer invalidate];
        self.statusTimer = nil;
        [UserModel setUserID:0];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //NSLog(@"Tab index = %lu", (unsigned long)indexOfTab);
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height) {
        // ask next page only if we haven't reached last page
        if(![self.paginator reachedLastPage]) {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark - Queue

- (IBAction)btnQueue:(id)sender {
    int queuedRow = (int)[sender tag];
    VideoModel *queuedVideo = [self.paginator.results objectAtIndex:queuedRow];
    
    //NSLog(@"QueueModel userId: %d, queueId %@, videoId: %d, groupId: %@, credits: %d", [UserModel getUserID], queuedVideo.queueId,queuedVideo.videoId, queuedVideo.groupId, queuedVideo.credits);
    
    NSDictionary * queueData = [QueueModel updateQueue:[UserModel getUserID] queueId:queuedVideo.queueId videoId:queuedVideo.videoId groupId:queuedVideo.groupId credits:queuedVideo.credits];
    
    [self showStatusChanges:queueData];
    
    NSLog(@"%@", queueData);
    
    NSString *msg = [queueData valueForKey:@"msg"];
    NSString *newQueueId = [queueData valueForKey:@"queueId"];
    BOOL boolQueued;
    NSString *alerttitle = @"Queue Updated";
    if ([[queueData valueForKey:@"queued"] integerValue] == 0) {
        boolQueued = NO;
        alerttitle = @"Removed from Queue";
    } else {
        boolQueued = YES;
        alerttitle = @"Added to Queue";
    }
    int statusCode = [[queueData valueForKey:@"statuscode"] intValue];
    
    if (statusCode==-1) {
        [UtilityModel showAlert:@"Error Updating Queue" msg:msg];
    } else {
        if (queuedRow>-1) {
            NSLog(@"%@",msg);
            queuedVideo.queueId = newQueueId;
            queuedVideo.queued = boolQueued;

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:queuedRow inSection:0];
            UITableViewCell *cell = [self.tblVideos cellForRowAtIndexPath: indexPath];
            VideoCellModel *aCell=(VideoCellModel *)cell;
            
            UIImage *image = (boolQueued) ? [UIImage imageNamed:@"icon_queue_remove"] : [UIImage imageNamed:@"icon_queue_add"];
            if (queuedVideo.downloaded) {
                image = [UIImage imageNamed:@"icon_queued_downloaded"];
                if (boolQueued) {
                    image = [UIImage imageNamed:@"icon_queue_remove"];
                }
            }
            if (queuedVideo.downloading) {
                image = [UIImage imageNamed:@"icon_queue_downloading"];
            }
            [aCell.btnCellQueue setBackgroundImage:image forState:UIControlStateNormal];
            
            int selectedVideoID = (int)[QueueModel getSelectedVideoID];
            if (queuedVideo.videoId == selectedVideoID) {
                [QueueModel setSelectedQueueID:[newQueueId integerValue]];
                PreviewController *preview = (PreviewController *)[self.slideController getRightViewController];
                [preview updateQueueButton];
            }
        }
        
        [UserModel setCredits:[[queueData valueForKey:@"credits"] integerValue]];
        [UserModel setQueueCount:[[queueData valueForKey:@"queuecount"] integerValue]];
        [YRDropdownView showDropdownInView:self.view.window
                                     title:alerttitle
                                    detail:msg
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:1.0];
    }
}

#pragma mark - Paginator delegate methods

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results {
    // update tableview footer
    [self updateTableViewFooter];
    [self.activityIndicator stopAnimating];
    [self performSelector:@selector(hidespinner) withObject:self afterDelay:0.5];
    SearchController *leftController=(SearchController *)[self.slideController getLeftViewController];
    [leftController hidespinner];
    
    // update tableview content
    // easy way : call [tableView reloadData];
    // nicer way : use insertRowsAtIndexPaths:withAnimation:
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    NSInteger i = [self.paginator.results count] - [results count];
 
    int resultsCount = [results count];
    //for(NSDictionary *result in results)
    for (int c = 0; c < resultsCount; ++c)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        i++;
    }
    
    [self.tblVideos beginUpdates];
    [self.tblVideos insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tblVideos endUpdates];
}

- (void)paginatorDidReset:(id)paginator {
    [self.tblVideos reloadData];
    [self updateTableViewFooter];
}

- (void)paginatorDidFailToRespond:(id)paginator {
    // Todo
    
}

#pragma mark - Paginator Actions

- (void)fetchNextPage {
    [self.paginator fetchNextPage];
    [self.activityIndicator startAnimating];
    [self showspinner];
}

- (void)setupTableViewFooter {
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.footerLabel = label;
    [footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.center = CGPointMake(40, 22);
    activityIndicatorView.hidesWhenStopped = YES;
    
    self.activityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    
    self.tblVideos.tableFooterView = footerView;
}

- (void)updateTableViewFooter {
    if ([self.paginator.results count] != 0)
    {
        self.footerLabel.text = [NSString stringWithFormat:@"%lu results out of %ld", (unsigned long)[self.paginator.results count], (long)self.paginator.total];
    } else
    {
        self.footerLabel.text = @"";
    }
    [self.footerLabel setNeedsDisplay];
}

- (IBAction)btnWebClose:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Close" message:@"Are you sure you want to close the purchase window?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    [UtilityModel showAlertView:alert withCallback:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            CGRect webFrame = _viewWebContainer.frame;
            webFrame.origin.y = 502;
            _viewWebContainer.frame = webFrame;
            //_viewWebContainer.hidden = YES;
            [UIView commitAnimations];
            [self updateStatus];
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        [self hidespinner];
    }
}

@end
