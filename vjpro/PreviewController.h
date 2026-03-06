//
//  PreviewController.h
//  vjpro
//
//  Created by John Arguelles on 12/8/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoModel.h"
#import "VideoCellModel.h"

@interface PreviewController : UIViewController<SKSlideViewDelegate> {
    AVPlayer *avPlayer;
    AVPlayerLayer *avPlayerLayer;
}
@property (nonatomic) NSInteger seconds;
@property (nonatomic, assign) VideoCellModel * cellSelected;
@property (nonatomic, assign) VideoModel * video;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

-(void)updateQueueButton;
-(void)loadVideoData;
-(void)updatePlaybackProgressFromTimer:(NSTimer *)timer;

@end
