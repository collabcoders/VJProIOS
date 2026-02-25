//
//  QueueModel.h
//  vjpro
//
//  Created by John Arguelles on 12/24/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueModel : NSObject

+(NSDictionary *)updateQueue:(NSInteger)userId queueId:(NSString *)queueId videoId:(NSInteger)videoId groupId:(NSString *)groupId credits:(NSInteger)credits;

+ (BOOL)getHasRefreshed;

+ (void)setHasRefreshed:(BOOL)hasrefreshed;

+ (NSInteger)getSelectedVideoID;

+ (void)setSelectedVideoID:(NSInteger)videoId;

+ (NSInteger)getSelectedQueueID;

+ (void)setSelectedQueueID:(NSInteger)queueId;

+ (NSInteger)getSelectedCreditVal;

+ (void)setSelectedCreditVal:(NSInteger)credits;

+ (NSString *)getSelectedGroupID;

+ (void)setSelectedGroupID:(NSString *)groupId;

@end
