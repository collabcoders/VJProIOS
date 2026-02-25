//
//  VideoModel.h
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
    
    @property (nonatomic) NSInteger videoId;
    @property (nonatomic) BOOL queued;
    @property (nonatomic,retain) NSString *queueId;
    @property (nonatomic,retain) NSString *Artist;
    @property (nonatomic,retain) NSString *Title;
    @property (nonatomic,retain) NSString *genreId;
    @property (nonatomic,retain) NSString *duration;
    @property (nonatomic,retain) NSString *BPM;
    @property (nonatomic,retain) NSDate *Date;
    @property (nonatomic,retain) NSString *imageurl;
    @property (nonatomic,retain) NSString *vidurl;
    @property (nonatomic,retain) NSString *program;
    @property (nonatomic,retain) NSString *genre;
    @property (nonatomic) BOOL isfree;
    @property (nonatomic) BOOL downloading;
    @property (nonatomic) BOOL downloaded;
    @property (nonatomic) BOOL downloadable;
    @property (nonatomic) NSInteger Rank;
    @property (nonatomic,retain) NSString *downloadcount;
    @property (nonatomic,retain) NSString *groupId;
    @property (nonatomic,retain) NSString *version;
    @property (nonatomic) BOOL isclean;
    @property (nonatomic,retain) NSString *editor;
    @property (nonatomic,retain) NSString *releaseyear;
    @property (nonatomic) NSInteger quality;
    @property (nonatomic) NSInteger credits;

@end
