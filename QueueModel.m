//
//  QueueModel.m
//  vjpro
//
//  Created by John Arguelles on 12/24/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "QueueModel.h"
#import "UtilityModel.h"

@implementation QueueModel

+(NSDictionary *)updateQueue:(NSInteger)userId queueId:(NSString *)queueId videoId:(NSInteger)videoId groupId:(NSString *)groupId credits:(NSInteger)credits {
    NSString *strUserId = [NSString stringWithFormat:@"%ld%@",(long)userId, @""];
    NSString *strVideoId = [NSString stringWithFormat:@"%ld%@",(long)videoId, @""];
    NSString *strCredits = [NSString stringWithFormat:@"%ld%@",(long)credits, @""];
    NSString *strQueueId = [NSString stringWithFormat:@"%@%@",queueId, @""];
    
    NSString * urlpath = @"https://www.vj-pro.net/Mobile/EditQueue";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:strUserId forKey:@"uid"];
    [params setObject:strVideoId forKey:@"vid"];
    [params setObject:strQueueId forKey:@"qid"];
    [params setObject:groupId forKey:@"gid"];
    [params setObject:strCredits forKey:@"credits"];
    
    NSLog(@"Params: %@",params);
    
    NSDictionary *queueData = [UtilityModel getJsonData:urlpath params:params];
    NSLog(@"Dictionary: %@", queueData);
    return queueData;
}

+ (BOOL)getHasRefreshed{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL hasrefreshed = [prefs boolForKey: @"HasRefreshed"];
	return hasrefreshed;
}

+ (void)setHasRefreshed:(BOOL)hasrefreshed{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:hasrefreshed forKey: @"HasRefreshed"];
}

+ (NSInteger)getSelectedVideoID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"SelectedVideoID"];
	return myInt;
}

+ (void)setSelectedVideoID:(NSInteger)videoId{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:videoId forKey: @"SelectedVideoID"];
}

+ (NSInteger)getSelectedQueueID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"SelectedQueueID"];
	return myInt;
}

+ (void)setSelectedQueueID:(NSInteger)queueId{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:queueId forKey: @"SelectedQueueID"];
}

+ (NSInteger)getSelectedCreditVal{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"SelectedCreditVal"];
	return myInt;
}

+ (void)setSelectedCreditVal:(NSInteger)credits{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:credits forKey: @"SelectedCreditVal"];
}

+ (NSString *)getSelectedGroupID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myGroupID = [prefs stringForKey: @"SelectedGroupID"];
	return myGroupID;
}

+ (void)setSelectedGroupID:(NSString *)groupId{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:groupId forKey: @"SelectedGroupID"];
}

@end
