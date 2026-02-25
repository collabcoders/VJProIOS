//
//  UserModel.m
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
    
+ (NSInteger)getUserID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"UserID"];
	return myInt;
}
    
+ (void)setUserID:(NSInteger)userID{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:userID forKey: @"UserID"];
}
    
+ (NSInteger)getCredits{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"Credits"];
	return myInt;
}
    
+ (void)setCredits:(NSInteger)credits{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:credits forKey: @"Credits"];
}
    
+ (NSInteger)getQueueCount{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"QueueCount"];
	return myInt;
}
    
+ (void)setQueueCount:(NSInteger)queuecount{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:queuecount forKey: @"QueueCount"];
}
    
+ (NSString *)getCountry{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *country = [prefs stringForKey: @"CountryCode"];
	return country;
}
    
+ (void)setCountry:(NSString *)country{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:country forKey: @"CountryCode"];
}
    
+ (BOOL)getDownloaderOnline{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL downloaderonline = [prefs boolForKey: @"DownloaderOnline"];
	return downloaderonline;
}
    
+ (void)setDownloaderOnline:(BOOL)downloaderonline{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:downloaderonline forKey: @"DownloaderOnline"];
}

+ (NSString *)getStatus{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *status = [prefs stringForKey: @"AccountStatus"];
	return status;
}

+ (void)setStatus:(NSString *)status{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:status forKey: @"AccountStatus"];
}

+ (NSInteger)getPageSize{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"PageSize"];
	return myInt;
}

+ (void)setPageSize:(NSInteger)pagesize{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:pagesize forKey: @"PageSize"];
}

+ (NSInteger)getPreviewSeconds{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"PreviewSeconds"];
	return myInt;
}

+ (void)setPreviewSeconds:(NSInteger)seconds{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:seconds forKey: @"PreviewSeconds"];
}

+ (NSInteger)getUserHD{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myInt = [prefs integerForKey: @"UserHD"];
	return myInt;
}

+ (void)setUserHD:(NSInteger)userHd{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:userHd forKey: @"UserHD"];
}

+ (BOOL)getAlertShowing{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL alertShowing = [prefs boolForKey: @"AlertShowing"];
	return alertShowing;
}

+ (void)setAlertShowing:(BOOL)showing{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:showing forKey: @"AlertShowing"];
}

@end
