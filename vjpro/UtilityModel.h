//
//  UtilityModel.h
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityModel : NSObject<UIAlertViewDelegate>

typedef void (^AlertViewCompletionBlock)(NSInteger buttonIndex);

@property (strong,nonatomic) AlertViewCompletionBlock callback;

+(NSDictionary *)getJsonData:(NSString *)urlpath params:(NSMutableDictionary *)params;

+(NSMutableDictionary *)getDataList:(NSString *)listName;

+(NSMutableArray *)getArrayList:(NSString *)listName;
    
+(BOOL) isEmptyString:(NSString *) string;
    
+(NSDate *)dateFromJsonDate:(NSString *)string;
    
+(NSData*)encodeDictionary:(NSDictionary*)dictionary;

+(void)showAlert:(NSString*)msgtitle msg:(NSString*)msg;

+(void)showAlertView:(UIAlertView *)alertView withCallback:(AlertViewCompletionBlock)callback;

@end
