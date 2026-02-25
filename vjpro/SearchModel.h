//
//  GenreModel.h
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

//genres
+(void)saveGenres:(NSMutableArray *)array;
    
+(NSMutableArray *)getGenres;
    
+(NSString *)getGenreID;
    
+(void)setGenreID:(NSString *)genreID;

//programs
+(NSString *)getProgram;
    
+(void)setProgram:(NSString *)program;
    
//classics
+(void)saveClassics:(NSMutableDictionary *)dictionary;
    
+(NSMutableDictionary *)getClassics;
    
+(NSString *)getClassicID;
    
+(void)setClassicID:(NSString *)classicID;
    
+(NSString *)getKeywords;
    
+(void)setKeywords:(NSString *)keywords;

//sort
+(NSString *)getSort;

+(void)setSort:(NSString *)sort;

+(NSString *)getSortDir;

+(void)setSortDir:(NSString *)dir;

//counts
+(NSInteger)getTotalCount;

+(void)setTotalCount:(NSInteger)totalcount;

+(NSInteger)getCurrentPage;

+(void)setCurrentPage:(NSInteger)page;

+(NSInteger)getTotalPages;

+(void)setTotalPages:(NSInteger)totalpages;

+(void)resetParams;

@end
