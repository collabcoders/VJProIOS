//
//  GenreModel.m
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "SearchModel.h"
#import "UtilityModel.h"

@implementation SearchModel

//genres
+(void)saveGenres:(NSMutableArray *)array{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"GenresList"];
}
+(NSMutableArray *)getGenres{
    NSMutableArray * array = [UtilityModel getArrayList:@"GenresList"];
    return array;
}
+ (NSString *)getGenreID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myGenreID = [prefs stringForKey: @"GenreID"];
	return myGenreID;
}
+ (void)setGenreID:(NSString *)genreID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:genreID forKey: @"GenreID"];
}
    
//programs
+ (NSString *)getProgram{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myProgramID = [prefs stringForKey: @"Program"];
	return myProgramID;
}
+ (void)setProgram:(NSString *)program{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:program forKey: @"Program"];
}
    
//classics
+(void)saveClassics:(NSMutableDictionary *)dictionary{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ClassicsList"];
}
+(NSMutableDictionary *)getClassics{
    NSMutableDictionary * myDictionary = [UtilityModel getDataList:@"ClassicsList"];
    return myDictionary;
}
+ (NSString *)getClassicID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myClassicID = [prefs stringForKey: @"ClassicID"];
	return myClassicID;
}
    
+ (void)setClassicID:(NSString *)classicID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:classicID forKey: @"ClassicID"];
}

//keywords
+ (NSString *)getKeywords{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *keywords = [prefs stringForKey: @"Keywords"];
	return keywords;
}
    
+ (void)setKeywords:(NSString *)keywords{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:keywords forKey: @"Keywords"];
}

//sort
+ (NSString *)getSort{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sort = [prefs stringForKey: @"SortOrder"];
	return sort;
}

+ (void)setSort:(NSString *)sort{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:sort forKey: @"SortOrder"];
}

+ (NSString *)getSortDir{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *dir = [prefs stringForKey: @"SortDir"];
	return dir;
}

+ (void)setSortDir:(NSString *)dir{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:dir forKey: @"SortDir"];
}

//total count
+ (NSInteger)getTotalCount{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"TotalCount"];
	return myInt;
}

+ (void)setTotalCount:(NSInteger)totalcount{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:totalcount forKey: @"TotalCount"];
}

//current page
+(NSInteger)getCurrentPage{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"CurrentPage"];
	return myInt;
}

+(void)setCurrentPage:(NSInteger)page{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:page forKey: @"CurrentPage"];
}

//total pages
+(NSInteger)getTotalPages{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"TotalPages"];
	return myInt;
}

+(void)setTotalPages:(NSInteger)totalpages{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:totalpages forKey: @"TotalPages"];
}

//reset search params
+(void)resetParams {
    [SearchModel setProgram:@""];
    [SearchModel setGenreID:0];
    [SearchModel setKeywords:@""];
    [SearchModel setSort:@"Date"];
    [SearchModel setSortDir:@"desc"];
}


@end
