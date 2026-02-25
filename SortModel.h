//
//  SortModel.h
//  vjpro
//
//  Created by John Arguelles on 12/28/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAElegantSheet.h"
#import "VideosController.h"

@interface SortModel : NSObject

+ (IAElegantSheet *) loadSortList:(VideosController *)vc;

@end
