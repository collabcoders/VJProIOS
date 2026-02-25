//
//  GenreModel.m
//  vjpro
//
//  Created by John Arguelles on 12/21/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "GenreModel.h"

@implementation GenreModel

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_genreId forKey:@"id"];
    [encoder encodeObject:_genre forKey:@"title"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        _genreId = [decoder decodeObjectForKey:@"id"];
        _genre = [decoder decodeObjectForKey:@"title"];
    }
    return self;
}

@end
