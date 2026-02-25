//
//  VideoModel.m
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
    
-(void)encodeWithCoder:(NSCoder *)encoder
    {
        //Encode the properties of the object
        [encoder encodeInt:(int)_videoId forKey:@"videoId"];
        [encoder encodeBool:_queued forKey:@"queued"];
        [encoder encodeObject:_queueId forKey:@"queueId"];
        [encoder encodeObject:_Artist forKey:@"Artist"];
        [encoder encodeObject:_Title forKey:@"Title"];
        [encoder encodeObject:_genreId forKey:@"genreId"];
        [encoder encodeObject:_duration forKey:@"duration"];
        [encoder encodeObject:_BPM forKey:@"BPM"];
        [encoder encodeObject:_Date forKey:@"Date"];
        [encoder encodeObject:_imageurl forKey:@"imageurl"];
        [encoder encodeObject:_vidurl forKey:@"vidurl"];
        [encoder encodeObject:_program forKey:@"program"];
        [encoder encodeObject:_genre forKey:@"genre"];
        [encoder encodeBool:_isfree forKey:@"isfree"];
        [encoder encodeBool:_downloading forKey:@"downloading"];
        [encoder encodeBool:_downloaded forKey:@"downloaded"];
        [encoder encodeBool:_downloadable forKey:@"downloadable"];
        [encoder encodeInt:(int)_Rank forKey:@"Rank"];
        [encoder encodeObject:_downloadcount forKey:@"downloadcount"];
        [encoder encodeObject:_groupId forKey:@"groupId"];
        [encoder encodeObject:_version forKey:@"genre"];
        [encoder encodeBool:_isclean forKey:@"isfree"];
        [encoder encodeObject:_editor forKey:@"editor"];
        [encoder encodeObject:_releaseyear forKey:@"releaseyear"];
        [encoder encodeInt:(int)_quality forKey:@"quality"];
        [encoder encodeInt:(int)_credits forKey:@"credits"];
    }
    
-(id)initWithCoder:(NSCoder *)decoder
    {
        self = [super init];
        if ( self != nil )
        {
            //decode the properties
            _videoId = [decoder decodeIntForKey:@"videoId"];
            _queued = [decoder decodeBoolForKey:@"queued"];
            _queueId = [decoder decodeObjectForKey:@"queueId"];
            _Artist = [decoder decodeObjectForKey:@"Artist"];
            _Title = [decoder decodeObjectForKey:@"Title"];
            _genreId = [decoder decodeObjectForKey:@"genreId"];
            _duration = [decoder decodeObjectForKey:@"duration"];
            _BPM = [decoder decodeObjectForKey:@"BPM"];
            _Date = [decoder decodeObjectForKey:@"Date"];
            _imageurl = [decoder decodeObjectForKey:@"imageurl"];
            _vidurl = [decoder decodeObjectForKey:@"vidurl"];
            _program = [decoder decodeObjectForKey:@"program"];
            _genre = [decoder decodeObjectForKey:@"genre"];
            _isfree = [decoder decodeBoolForKey:@"isfree"];
            _downloading = [decoder decodeBoolForKey:@"downloading"];
            _downloaded = [decoder decodeBoolForKey:@"downloaded"];
            _downloadable = [decoder decodeBoolForKey:@"downloadable"];
            _Rank = [decoder decodeIntForKey:@"Rank"];
            _downloadcount = [decoder decodeObjectForKey:@"downloadcount"];
            _groupId = [decoder decodeObjectForKey:@"groupId"];
            _version = [decoder decodeObjectForKey:@"version"];
            _isclean = [decoder decodeBoolForKey:@"isclean"];
            _editor = [decoder decodeObjectForKey:@"editor"];
            _releaseyear = [decoder decodeObjectForKey:@"releaseyear"];
            _quality = [decoder decodeIntForKey:@"quality"];
            _credits = [decoder decodeIntForKey:@"credits"];
        }
        return self;
    }

@end
