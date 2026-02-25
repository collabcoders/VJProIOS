//
//  VideoPaginatorModel.m
//  vjpro
//
//  Created by John Arguelles on 12/20/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "VideoPaginatorModel.h"
#import "UtilityModel.h"
#import "SearchModel.h"
#import "VideoModel.h"
#import "UserModel.h"

@implementation VideoPaginatorModel

- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize 
{
    //params
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)[UserModel getUserID]];
    NSString *countrycode = [UserModel getCountry];
    NSString *program = [SearchModel getProgram];
    NSString *mykeywords = [SearchModel getKeywords];
    NSString* escapedUrlKeywords = @"";
    NSString *keywordqs = @"";
    NSString *genreId = [SearchModel getGenreID];
    NSString *chartDays = @"8";
    NSString *sortBy = [SearchModel getSort];
    NSString *sortDir = [SearchModel getSortDir];
    NSString *hd = [NSString stringWithFormat:@"%ld", (long)[UserModel getUserHD]];
    
    if ([UtilityModel isEmptyString:sortBy]) {
        sortBy = @"Date";
    }
    if ([UtilityModel isEmptyString:sortDir]) {
        sortDir = @"desc";
    }
    if ([hd isEqual:@""] || hd == NULL || hd == nil) {
        hd = @"-1";
    }
    if ([genreId isEqual:@""] || genreId == NULL || genreId == nil) {
        genreId = @"0";
    }
    if (![UtilityModel isEmptyString:mykeywords]) {
        genreId = @"0";
        program = @"";
        keywordqs = @"&keywords=";
        escapedUrlKeywords = [mykeywords stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    if (![genreId isEqual:@"0"]) {
        program = @"";
        keywordqs = @"";
        escapedUrlKeywords = @"";
    }
    if ([program isEqual:@"monthlyCharts"]) {
        keywordqs = @"";
        escapedUrlKeywords = @"";
        chartDays = @"31";
        pageSize = 100;
    }
    if ([program isEqual:@"weeklyCharts"]) {
        keywordqs = @"";
        escapedUrlKeywords = @"";
        chartDays = @"8";
        pageSize = 100;
    }
    if ([program isEqual:@"trending"]) {
        keywordqs = @"";
        escapedUrlKeywords = @"";
        pageSize = 100;
    }

    //set url
    NSString * urlpath = [NSString stringWithFormat:@"https://www.vj-pro.net/Videos/GetVideos/%@?page=%@&rows=%@&ungroup=true&genreId=%@&cc=%@&sidx=%@&sord=%@&hd=%@%@%@", userId, [NSString stringWithFormat:@"%lu", (unsigned long)page], [NSString stringWithFormat:@"%lu", (unsigned long)pageSize], genreId, countrycode, sortBy, sortDir, hd, keywordqs, escapedUrlKeywords];
    if ([program isEqualToString:@"monthlyCharts"] || [program isEqualToString:@"weeklyCharts"] || [program isEqualToString:@"trending"]) {
        urlpath = [NSString stringWithFormat:@"https://www.vj-pro.net/Mobile/GetCharts/%@?top=%@&days=%@&cc=%@&sidx=%@&sord=%@&hd=%@&chart=%@", userId, [NSString stringWithFormat:@"%lu", (unsigned long)pageSize], chartDays, countrycode, sortBy, sortDir, hd, program];
    }
    if ([program isEqualToString:@"queued"]) {
        urlpath = [NSString stringWithFormat:@"https://www.vj-pro.net/Videos/GetQueue/%@?page=%@&rows=%@&sidx=%@&sord=%@", userId, [NSString stringWithFormat:@"%lu", (unsigned long)page], [NSString stringWithFormat:@"%lu", (unsigned long)pageSize], sortBy, sortDir];
    }
    if ([program isEqualToString:@"downloads"]) {
        urlpath = [NSString stringWithFormat:@"https://www.vj-pro.net/Videos/GetDownloads/%@?page=%@&rows=%@&sidx=%@&sord=%@", userId, [NSString stringWithFormat:@"%lu", (unsigned long)page], [NSString stringWithFormat:@"%lu", (unsigned long)pageSize], sortBy, sortDir];
    }
    NSLog(@"%@", urlpath);

    // do request on async thread
    dispatch_queue_t fetchQ = dispatch_queue_create("Videos fetcher", NULL);
    dispatch_async(fetchQ, ^{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSDictionary *jsonData = [UtilityModel getJsonData:urlpath params:params];
        
        if (jsonData != nil) {
            //NSLog(@"%@", jsonData);
            
            // go back to main thread before adding results
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSDictionary *videoData = [jsonData objectForKey:@"rows"];
                NSInteger total = [[jsonData objectForKey:@"records"] intValue];
                [SearchModel setTotalCount:total];
                [SearchModel setTotalPages:[[jsonData objectForKey:@"total"] intValue]];
                [SearchModel setCurrentPage:[[jsonData objectForKey:@"page"] intValue]];
                NSInteger videocount = videoData.count;
                NSLog(@"Rows: %ld", (long)videocount);
                
                NSMutableArray *searchResults = [[NSMutableArray alloc] init];
                [searchResults removeAllObjects];
                if (videocount > 0) {
                    for(NSDictionary *video in videoData){
                        VideoModel *result = [[VideoModel alloc] init];
                        result.Date = [UtilityModel dateFromJsonDate:[video objectForKey:@"Date"]];
                        result.videoId = [[video objectForKey:@"videoId"] integerValue];
                        result.queued = [[video objectForKey:@"queued"] boolValue];
                        result.queueId = [video objectForKey:@"queueId"];
                        result.Artist = [video objectForKey:@"Artist"];
                        result.Title = [video objectForKey:@"Title"];
                        result.genreId = [video objectForKey:@"genreId"];
                        result.duration = [video objectForKey:@"duration"];
                        result.BPM = [video objectForKey:@"BPM"];
                        result.program = [video objectForKey:@"Program"];
                        result.genre = [video objectForKey:@"Genre"];
                        result.imageurl = [video objectForKey:@"imageurl"];
                        result.vidurl = [video objectForKey:@"vidurl"];
                        result.isfree = [[video objectForKey:@"isfree"] boolValue];
                        result.downloading = [[video objectForKey:@"downloading"] boolValue];
                        result.downloaded = [[video objectForKey:@"downloaded"] boolValue];
                        result.downloadable = [[video objectForKey:@"downloadable"] boolValue];
                        result.Rank = [[video objectForKey:@"rank"] integerValue];
                        result.downloadcount = [video objectForKey:@"downloadcount"];
                        result.groupId = [video objectForKey:@"groupId"];
                        result.version = [video objectForKey:@"version"];
                        result.isclean = [[video objectForKey:@"is_clean"] boolValue];
                        result.editor = [video objectForKey:@"editor"];
                        result.releaseyear = [video objectForKey:@"releaseyear"];
                        result.quality = [[video objectForKey:@"quality"] integerValue];
                        result.credits = [[video objectForKey:@"credits"] integerValue];
                        [searchResults addObject:result];
                    }
                } else {
                    [UtilityModel showAlert:@"No Videos Found" msg:@"There are no videos that match your search criteria."];
                }
                NSArray *finalArray = searchResults;
                //NSLog(@"Array: %@",finalArray);
                [self receivedResults:finalArray total:total];
            });
        }
        
    });
}

@end
