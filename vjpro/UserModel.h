//
//  UserModel.h
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
    
+ (NSInteger)getUserID;
    
+ (void)setUserID:(NSInteger)userID;
    
+ (NSInteger)getCredits;
    
+ (void)setCredits:(NSInteger)credits;
    
+ (NSInteger)getQueueCount;
    
+ (void)setQueueCount:(NSInteger)queuecount;

+ (NSString *)getCountry;
    
+ (void)setCountry:(NSString *)country;
    
+ (BOOL)getDownloaderOnline;
    
+ (void)setDownloaderOnline:(BOOL)downloaderonline;

+ (NSString *)getStatus;

+ (void)setStatus:(NSString *)status;

+ (NSInteger)getPageSize;

+ (void)setPageSize:(NSInteger)pagesize;

+ (NSInteger)getPreviewSeconds;

+ (void)setPreviewSeconds:(NSInteger)seconds;

+ (NSInteger)getUserHD;

+ (void)setUserHD:(NSInteger)userHd;

+ (BOOL)getAlertShowing;

+ (void)setAlertShowing:(BOOL)showing;

@end
