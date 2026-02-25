//
//  PreviewController.m
//  vjpro
//
//  Created by John Arguelles on 12/8/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "PreviewController.h"
#import "UserModel.h"
#import "VideoModel.h"
#import "UtilityModel.h"
#import "OverlayViewController.h"
#import "SpinnerController.h"
#import "QueueModel.h"
#import "YRDropdownView.h"
#import "VideosController.h"


@interface PreviewController ()

@property (nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic) BOOL isInitial;
@property (nonatomic, retain) IBOutlet UIView *shadowSlider;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) IBOutlet UISlider *seekbar;
@property (weak, nonatomic) IBOutlet UIButton *btnQueue;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondsTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondsLeft;
@property (weak, nonatomic) IBOutlet UIView *viewVideoDetails;
@property (weak, nonatomic) IBOutlet UIView *viewVideoHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoArtist;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoGenre;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoDate;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoYear;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoBpm;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoLength;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoHd;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoEditor;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoEditorLabel;

@property (nonatomic, retain) NSTimer *vidTimer;
//@property (nonatomic, retain) NSTimer *bufferTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditsHd;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditsNonHd;

@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (weak, nonatomic) IBOutlet UILabel *lblBuffering;

- (IBAction)toggleQueue:(id)sender;
- (IBAction)togglePlay:(id)sender;
@end

@implementation PreviewController {
    int secondsToRemoveSpinner;
}

@synthesize seconds, video, cellSelected, activityIndicator;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Extend view under status bar
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    
    // Set main view background to black to match design
    self.view.backgroundColor = [UIColor blackColor];
    
    _isInitial = TRUE;
    _seekbar.hidden = YES;
    _viewVideoHeader.hidden = YES;
    _viewVideoDetails.hidden = YES;
    [_viewLoading setAlpha:0.0];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.center = CGPointMake(92, 17);
    activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicatorView;
    [_viewLoading addSubview:activityIndicatorView];
    
    [self.activityIndicator startAnimating];
    _lblBuffering.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showLoading {
    [_viewLoading setAlpha:0.0];
//    [self.activityIndicator startAnimating];
//    _lblBuffering.hidden = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [_viewLoading setAlpha:1.0];
    [UIView commitAnimations];
}

-(void) hideLoading {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [_viewLoading setAlpha:0];
    [UIView commitAnimations];
    
    //[self.activityIndicator stopAnimating];
    //_lblBuffering.hidden = YES;
}

-(void)updateQueueButton {
    BOOL boolQueued = YES;
    if ([QueueModel getSelectedQueueID] == 0) {
        boolQueued = NO;
    }
        UIImage *image = (boolQueued) ? [UIImage imageNamed:@"icon_queue_remove"] : [UIImage imageNamed:@"icon_queue_add"];
        [_btnQueue setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)loadVideoData {
    [self showLoading];
    [moviePlayerController stop];
    [moviePlayerController.view removeFromSuperview];
    
    _isInitial = TRUE;
    _lblBuffering.hidden = NO;
    
    // Reset slider to beginning for new video
    _seekbar.value = 0;
    _seekbar.maximumValue = 1;  // Temporary value until video loads
    
    secondsToRemoveSpinner =  (int)(self.seconds - 1);
    [_lblSecondsTotalLabel setText:[NSString stringWithFormat:@"%ld Second Preview", (long)self.seconds]];
    _seekbar.hidden = NO;
    _viewVideoHeader.hidden = NO;
    _viewVideoDetails.hidden = NO;
    
    //labels
    [_lblVideoTitle setText:self.video.Title];
    [_lblVideoArtist setText:self.video.Artist];
    [_lblVideoGenre setText:self.video.genre];
    NSString * cleanDirty = @"";
    if ([self.video.program isEqual:@"VJ Tools"]) {
        cleanDirty = @" / Clean";
        if(!self.video.isclean) {
            cleanDirty = @" / Dirty";
        }
    }
    NSString * strVideoVersion = [NSString stringWithFormat:@"%@ / %@%@", self.video.program, self.video.version, cleanDirty];
    [_lblVideoVersion setText:strVideoVersion];
    NSDateFormatter *anotherDateFormatter = [[NSDateFormatter alloc] init];
    [anotherDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [anotherDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *finalDate = [anotherDateFormatter stringFromDate:self.video.Date];
    [_lblVideoDate setText:finalDate];
    NSString* strReleaseYear = [NSString stringWithFormat:@"%@", self.video.releaseyear];
    [_lblVideoYear setText:strReleaseYear];
    NSString* strBpm = [NSString stringWithFormat:@"%@", self.video.BPM];
    [_lblVideoBpm setText:strBpm];
    [_lblVideoLength setText:self.video.duration];
    if ([UtilityModel isEmptyString:self.video.editor]) {
        _lblVideoEditorLabel.hidden = YES;
        [_lblVideoEditor setText:@""];
    } else {
        _lblVideoEditorLabel.hidden = NO;
        [_lblVideoEditor setText:self.video.editor];
    }
    
    //credits
    NSString *lblCredit = @"1 Credit";
    if (self.video.credits != 1) {
        lblCredit =  [NSString stringWithFormat:@"%ld Credits", (long)self.video.credits];
    }
    
    //hd icon
    NSString *imgHd = @"blank";
    int hd = (int)self.video.quality;
    if (hd == 1 || hd == 2 || hd == 3) {
        if (hd == 2) {
            imgHd = @"icon_1080p_big";
            _lblCreditsNonHd.hidden = YES;
            _lblCreditsHd.hidden = NO;
            [_lblCreditsHd setText:lblCredit];
        }
        if (hd == 1) {
            imgHd = @"icon_hd_big";
            _lblCreditsNonHd.hidden = YES;
            _lblCreditsHd.hidden = NO;
            [_lblCreditsHd setText:lblCredit];
        }
        if (hd == 3) {
            imgHd = @"icon_qhd_big";
            _lblCreditsNonHd.hidden = YES;
            _lblCreditsHd.hidden = NO;
            [_lblCreditsHd setText:lblCredit];
        }
    } else {
        _lblCreditsHd.hidden = YES;
        _lblCreditsNonHd.hidden = NO;
        [_lblCreditsNonHd setText:lblCredit];
    }
    [_imgVideoHd setImage:[UIImage imageNamed:imgHd]];
    
    //queue button
    BOOL checked = self.video.queued;
	UIImage *image = (checked) ? [UIImage imageNamed:@"icon_queue_remove"] : [UIImage imageNamed:@"icon_queue_add"];
    if (self.video.downloaded) {
        image = [UIImage imageNamed:@"icon_queued_downloaded"];
        if (checked) {
            image = [UIImage imageNamed:@"icon_queue_remove"];
        }
    }
    if (self.video.downloading) {
        image = [UIImage imageNamed:@"icon_queue_downloading"];
    }
    [_btnQueue setBackgroundImage:image forState:UIControlStateNormal];
    
    //video
    [_vidTimer invalidate];
    _vidTimer = nil;
    
    // URL encode the filename parameter
    NSString *encodedFilename = [self.video.vidurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // Build URL with possible authentication if needed
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)[UserModel getUserID]];
    NSString * strVideoUrl = [NSString stringWithFormat:@"https://members.vj-pro.net/Handlers/PreviewCloud.ashx?file=%@&userId=%@", encodedFilename, userId];
    
    NSLog(@"========================================");
    NSLog(@"Preview Video URL: %@", strVideoUrl);
    NSLog(@"Original filename: %@", self.video.vidurl);
    NSLog(@"User ID: %@", userId);
    NSLog(@"========================================");
    
    // Test URL accessibility
    [self testURLAccessibility:strVideoUrl];
    
    _vidTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updatePlaybackProgressFromTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_vidTimer forMode:NSRunLoopCommonModes];
    
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlaybackProgressFromTimer:) userInfo:nil repeats:YES];
    NSURL *movieURL = [NSURL URLWithString:strVideoUrl];
    
    if (!movieURL) {
        NSLog(@"ERROR: Invalid URL - could not create NSURL from string: %@", strVideoUrl);
        [UtilityModel showAlert:@"Video Error" msg:@"Invalid video URL. Please try again."];
        [self hideLoading];
        return;
    }
    
    NSLog(@"Creating movie player with URL: %@", movieURL);
    
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if (!moviePlayerController) {
        NSLog(@"ERROR: Failed to create MPMoviePlayerController");
        [UtilityModel showAlert:@"Video Error" msg:@"Failed to initialize video player."];
        [self hideLoading];
        return;
    }
    
    [moviePlayerController prepareToPlay];
    moviePlayerController.movieSourceType = MPMovieSourceTypeStreaming;
    
    NSLog(@"Movie player created successfully. Source type: Streaming");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    
    moviePlayerController.view.backgroundColor = [UIColor clearColor];
    [moviePlayerController.view setFrame:CGRectMake(_btnPreview.frame.origin.x,
                                                    _btnPreview.frame.origin.y,
                                                    _btnPreview.frame.size.width,
                                                    _btnPreview.frame.size.height)];
    moviePlayerController.controlStyle = MPMovieControlStyleNone;
    
    // Disable VisionKit interactions that may trigger background removal warnings
    if (@available(iOS 16.0, *)) {
        for (UIGestureRecognizer *recognizer in moviePlayerController.view.gestureRecognizers) {
            if ([NSStringFromClass([recognizer class]) containsString:@"ImageAnalysis"]) {
                recognizer.enabled = NO;
            }
        }
    }
    
    [self.view addSubview:moviePlayerController.view];
    moviePlayerController.initialPlaybackTime = 1;
    
    // Don't call pause immediately - let it load first
    // The player will be in a paused state initially anyway
    NSLog(@"Movie player view added to hierarchy");
    
    //seek bar
    _shadowSlider = [[UIView alloc] init];
    _shadowSlider.frame = CGRectMake(_seekbar.frame.origin.x , _seekbar.frame.origin.y , _seekbar.frame.size.width , _seekbar.frame.size.height);
    _shadowSlider.layer.masksToBounds = YES;
    [_seekbar addSubview:_shadowSlider];
    [_seekbar sendSubviewToBack:_shadowSlider];
    [self.view bringSubviewToFront:_seekbar];
    UIButton* btnPlayPause = (UIButton *)[self.view viewWithTag:80001];
    [self.view bringSubviewToFront:btnPlayPause];
    [_seekbar addTarget:self action:@selector(sliderValueChanged:)
       forControlEvents:UIControlEventTouchUpInside];
}


-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
}

- (void)testURLAccessibility:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    [request setTimeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"❌ URL Test Failed: %@", [error localizedDescription]);
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"✅ URL Test Response: Status Code %ld", (long)httpResponse.statusCode);
            NSLog(@"   Content-Type: %@", httpResponse.allHeaderFields[@"Content-Type"]);
            NSLog(@"   Content-Length: %@", httpResponse.allHeaderFields[@"Content-Length"]);
            
            if (httpResponse.statusCode != 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UtilityModel showAlert:@"Video URL Error" msg:[NSString stringWithFormat:@"Server returned status code %ld", (long)httpResponse.statusCode]];
                });
            }
        }
    }];
    [task resume];
}

#pragma mark - SKSlideViewDelegate -

#pragma mark - MoviePlayer -

- (void)moviePlaybackComplete:(NSNotification *)notification {
    moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [moviePlayerController stop];
    // to prevent flickering on second play
    moviePlayerController.initialPlaybackTime = -1;
    [moviePlayerController.view removeFromSuperview];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    NSError *error = notification.userInfo[@"error"];
    NSString *reason = @"Unknown";
    switch (finishReason)
    {
        case MPMovieFinishReasonPlaybackEnded:
            reason = @"Playback Ended";
            break;
        case MPMovieFinishReasonPlaybackError:
            reason = @"Playback Error";
            if (error) {
                NSLog(@"Playback Error: %@", [error localizedDescription]);
                NSLog(@"Error details: %@", error);
            }
            break;
        case MPMovieFinishReasonUserExited:
            reason = @"User Exited";
            break;
    }
    NSLog(@"Finish Reason: %@%@", reason, error ? [@"\n" stringByAppendingString:[error description]] : @"");
}

- (void) moviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    moviePlayerController = notification.object;
    NSString *playbackState = @"Unknown";
    switch (moviePlayerController.playbackState)
    {
        case MPMoviePlaybackStateStopped:
            playbackState = @"Stopped";
            [_btnPlay setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
            break;
        case MPMoviePlaybackStatePlaying:
            playbackState = @"Playing";
            [self hideLoading];
            break;
        case MPMoviePlaybackStatePaused:
            playbackState = @"Paused";
            [self hideLoading];
            break;
        case MPMoviePlaybackStateInterrupted:
            playbackState = @"Interrupted";
            [self showLoading];
            [_btnPlay setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
            break;
        case MPMoviePlaybackStateSeekingForward:
            playbackState = @"Seeking Forward";
            [self showLoading];
            break;
        case MPMoviePlaybackStateSeekingBackward:
            playbackState = @"Seeking Backward";
            [self showLoading];
            break;
    }
    NSLog(@"Playback State: %@", playbackState);
}

- (void) moviePlayerLoadStateDidChange:(NSNotification *)notification
{
    moviePlayerController = notification.object;
    NSMutableString *loadState = [NSMutableString new];
    MPMovieLoadState state = moviePlayerController.loadState;
    
    NSLog(@"Load State Raw Value: %lu", (unsigned long)state);
    
    if (state & MPMovieLoadStatePlayable) {
        [loadState appendString:@" | Playable"];
        
        // Once playable, we can start playing if this is initial load
        if (_isInitial && moviePlayerController.playbackState != MPMoviePlaybackStatePlaying) {
            NSLog(@"Video is playable - starting playback from second 1");
            moviePlayerController.currentPlaybackTime = 1.0;
            [moviePlayerController play];
            _isInitial = FALSE;  // Mark as no longer initial
        }
    }
    if (state & MPMovieLoadStatePlaythroughOK) {
        [loadState appendString:@" | Playthrough OK"];
        [self hideLoading];  // Hide loading when playthrough is ready
    }
    if (state & MPMovieLoadStateStalled) {
        [loadState appendString:@" | Stalled"];
        [self showLoading];
    }
    if (state == MPMovieLoadStateUnknown) {
        [loadState appendString:@" | Unknown"];
    }
    
    NSLog(@"Load State: %@", loadState.length > 0 ? [loadState substringFromIndex:3] : @"N/A");
    NSLog(@"Duration: %f, Current Time: %f", moviePlayerController.duration, moviePlayerController.currentPlaybackTime);
}

- (void)updatePlaybackProgressFromTimer:(NSTimer *)timer {
    NSTimeInterval duration = moviePlayerController.duration;
    NSTimeInterval currentTime = moviePlayerController.currentPlaybackTime;
    
    // Only update slider if we have valid duration and time values
    if (!isnan(duration) && duration > 0 && !isnan(currentTime)) {
        _seekbar.maximumValue = duration;
        _seekbar.value = currentTime;
        float smartWidth = 0.0;
        smartWidth = (210 * duration) / 100;
        _shadowSlider.frame = CGRectMake( _shadowSlider.frame.origin.x , _shadowSlider.frame.origin.y , smartWidth , _shadowSlider.frame.size.height);
    }
    
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateActive) && (moviePlayerController.playbackState == MPMoviePlaybackStatePlaying)) {
        
        UIImage *btnImage = [UIImage imageNamed:@"icon_pause"];
        [_btnPlay setImage:btnImage forState:UIControlStateNormal];
        
        self.seconds -= 1;
        
        _lblSecondsLeft.text = [NSString stringWithFormat:@"%ld",(long)self.seconds];
        
        if (self.seconds<1) {
            [moviePlayerController stop];
            // to prevent flickering on second play
            moviePlayerController.initialPlaybackTime = -1;
            [moviePlayerController.view removeFromSuperview];
            
            UIImage *btnImage = [UIImage imageNamed:@"icon_play"];
            [_btnPlay setImage:btnImage forState:UIControlStateNormal];
            _lblSecondsLeft.text = @"0";
        }
    }
}

-(IBAction)sliderValueChanged:(UISlider *)sender
{
    moviePlayerController.currentPlaybackTime = sender.value;
    NSLog(@"time: %f", moviePlayerController.currentPlaybackTime);
    NSLog(@"seek: %f", sender.value);
    NSLog(@"max: %f", sender.maximumValue);
}

- (IBAction)toggleQueue:(id)sender {
    //NSLog(@"QueueModel userId: %d, queueId %@, videoId: %d, groupId: %@, credits: %ld", [UserModel getUserID], [NSString stringWithFormat:@"%ld", (long)[QueueModel getSelectedQueueID]],[QueueModel getSelectedVideoID], [QueueModel getSelectedGroupID], (long)[QueueModel getSelectedCreditVal]);
    
    NSDictionary * queueData = [QueueModel updateQueue:[UserModel getUserID] queueId:[NSString stringWithFormat:@"%ld", (long)[QueueModel getSelectedQueueID]] videoId:[QueueModel getSelectedVideoID] groupId:[QueueModel getSelectedGroupID] credits:[QueueModel getSelectedCreditVal]];
    
    VideosController *mainController=(VideosController *)[self.slideController getMainViewController];
    [mainController showStatusChanges:queueData];
    
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
        NSLog(@"%@",msg);
        [QueueModel setSelectedQueueID:[newQueueId integerValue]];
        UIImage *image = (boolQueued) ? [UIImage imageNamed:@"icon_queue_remove"] : [UIImage imageNamed:@"icon_queue_add"];
        
        @try {
            if (![QueueModel getHasRefreshed]) {
                self.video.queueId = newQueueId;
                self.video.queued = boolQueued;
                VideoCellModel *aCell=(VideoCellModel *)self.cellSelected;
                if (self.video.downloaded) {
                    image = [UIImage imageNamed:@"icon_queued_downloaded"];
                    if (boolQueued) {
                        image = [UIImage imageNamed:@"icon_queue_remove"];
                    }
                }
                if (self.video.downloading) {
                    image = [UIImage imageNamed:@"icon_queue_downloading"];
                }
                [aCell.btnCellQueue setBackgroundImage:image forState:UIControlStateNormal];
            }
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        
        [_btnQueue setBackgroundImage:image forState:UIControlStateNormal];
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

- (IBAction)togglePlay:(id)sender {
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateActive) && (moviePlayerController.playbackState == MPMoviePlaybackStatePlaying)) {
        UIImage *btnImage = [UIImage imageNamed:@"icon_play"];
        [sender setImage:btnImage forState:UIControlStateNormal];
        [moviePlayerController pause];
    } else {
        moviePlayerController.controlStyle = MPMovieControlStyleNone;
        if (_isInitial) {
            moviePlayerController.currentPlaybackTime = 1;
        }
        UIImage *btnImage = [UIImage imageNamed:@"icon_pause"];
        [sender setImage:btnImage forState:UIControlStateNormal];
        [moviePlayerController play];
    }
    _isInitial = FALSE;
}

@end
