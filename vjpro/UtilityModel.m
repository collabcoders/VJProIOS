//
//  UtilityModel.m
//  vjpro
//
//  Created by John Arguelles on 11/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.

#import "UtilityModel.h"
#import "UserModel.h"
#import "JSONKit.h"

@implementation UtilityModel

@synthesize callback;
    
+(NSDictionary *)getJsonData:(NSString *)urlpath params:(NSMutableDictionary *)params {
    NSDictionary *results;
    NSString *connectionErrorMsg = @"This app requires an internet connection and will attempt to re-establish a connection every 30 seconds.  Please make sure you have data or wifi enabled on your device.";
    
    @try {
        NSURL *url = [NSURL URLWithString:urlpath];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        
        NSData *postData;
        if (params.count > 0) {
            //NSMutableDictionary *nameElements = [NSMutableDictionary dictionary];
            //for(NSString * key in params) {
            //    [nameElements setObject:[params objectForKey: key] forKey:key];
            //}
            postData = [self encodeDictionary:params];
            NSString* postString = [params JSONString];
            NSLog(@"Post data: %@", postString);
        }
        
        [request setURL:url];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setTimeoutInterval:60];
        if (params.count > 0) {
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
        }
        
        NSError* error = nil;
        NSURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Error performing request: %@", urlpath);
            NSLog(@"Error message: %@", [error debugDescription]);
            results = nil;
            
            if ([UserModel getAlertShowing]) {
                //do nothing
            } else {
                [UserModel setAlertShowing:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:[NSString stringWithFormat:@"%@  %@", [error localizedDescription], connectionErrorMsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil, nil];
                [UtilityModel showAlertView:alert withCallback:^(NSInteger buttonIndex) {
                    [UserModel setAlertShowing:NO];
                }];
            }
            
            //[ovcontroller hideOverlay];
            //[spinner stopAnimating];
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            results = [jsonString objectFromJSONString];
        }
    }
    @catch (NSException *exception) {
        results = nil;
        NSLog(@"%@", exception.reason);
        
        if ([UserModel getAlertShowing]) {
            //do nothing
        } else {
            [UserModel setAlertShowing:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:[NSString stringWithFormat:@"%@  %@", exception.reason, connectionErrorMsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil, nil];
            [UtilityModel showAlertView:alert withCallback:^(NSInteger buttonIndex) {
                [UserModel setAlertShowing:NO];
            }];
        }
        
    }
    /*@finally {
        
    }*/
    
    return results;
}

+(void)getJsonDataAsync:(NSString *)urlpath params:(NSMutableDictionary *)params completion:(NetworkCompletionBlock)completion {
    NSString *connectionErrorMsg = @"This app requires an internet connection and will attempt to re-establish a connection every 30 seconds.  Please make sure you have data or wifi enabled on your device.";
    
    @try {
        NSURL *url = [NSURL URLWithString:urlpath];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        
        NSData *postData;
        if (params.count > 0) {
            postData = [self encodeDictionary:params];
            NSString* postString = [params JSONString];
            NSLog(@"Post data: %@", postString);
        }
        
        [request setURL:url];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setTimeoutInterval:60];
        if (params.count > 0) {
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
        }
        
        // Use NSURLSession for async networking
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error performing request: %@", urlpath);
                NSLog(@"Error message: %@", [error debugDescription]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([UserModel getAlertShowing]) {
                        // do nothing
                    } else {
                        [UserModel setAlertShowing:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
                                                                        message:[NSString stringWithFormat:@"%@  %@", [error localizedDescription], connectionErrorMsg] 
                                                                       delegate:self 
                                                              cancelButtonTitle:nil 
                                                              otherButtonTitles:@"OK", nil];
                        [UtilityModel showAlertView:alert withCallback:^(NSInteger buttonIndex) {
                            [UserModel setAlertShowing:NO];
                        }];
                    }
                    
                    if (completion) {
                        completion(nil, error);
                    }
                });
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *results = [jsonString objectFromJSONString];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(results, nil);
                    }
                });
            }
        }];
        
        [task resume];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UserModel getAlertShowing]) {
                // do nothing
            } else {
                [UserModel setAlertShowing:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
                                                                message:[NSString stringWithFormat:@"%@  %@", exception.reason, connectionErrorMsg] 
                                                               delegate:self 
                                                      cancelButtonTitle:nil 
                                                      otherButtonTitles:@"OK", nil];
                [UtilityModel showAlertView:alert withCallback:^(NSInteger buttonIndex) {
                    [UserModel setAlertShowing:NO];
                }];
            }
            
            if (completion) {
                NSError *error = [NSError errorWithDomain:@"UtilityModel" code:-1 userInfo:@{NSLocalizedDescriptionKey: exception.reason}];
                completion(nil, error);
            }
        });
    }
}
    
    
+(NSMutableDictionary *)getDataList:(NSString *)listName {
    NSMutableDictionary * myDictionary;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [prefs objectForKey:listName];
    myDictionary = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    if (myDictionary == nil) {
        myDictionary = [[NSMutableDictionary alloc] init];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:listName];
    }
    return myDictionary;
}

+(NSMutableArray *)getArrayList:(NSString *)listName {
    NSMutableArray * array;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [prefs objectForKey:listName];
    array = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:listName];
    }
    return array;
}

+(BOOL) isEmptyString:(NSString *) string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    } else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}
    
+(NSDate *)dateFromJsonDate:(NSString *)string {
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}
    
+(NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedValue  = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

+(void)showAlert:(NSString*)msgtitle msg:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msgtitle
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void)showAlertView:(UIAlertView *)alertView withCallback:(AlertViewCompletionBlock)callback {
    __block UtilityModel *delegate = [[UtilityModel alloc] init];
    alertView.delegate = delegate;
    delegate.callback = ^(NSInteger buttonIndex) {
        callback(buttonIndex);
        alertView.delegate = nil;
#pragma clang diagnostic push 
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        delegate = nil;
#pragma clang diagnostic pop
    };
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    callback(buttonIndex);
}

@end
