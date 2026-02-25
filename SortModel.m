//
//  SortModel.m
//  vjpro
//
//  Created by John Arguelles on 12/28/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "SortModel.h"
#import "SearchModel.h"

@implementation SortModel

+ (IAElegantSheet *) loadSortList:(VideosController *)vc {
    
    IAElegantSheet *elegantSheet = [IAElegantSheet elegantSheetWithTitle:@"SORT VIDEOS BY:"];
    if ([[SearchModel getProgram] isEqual: @"weeklyCharts"] || [[SearchModel getProgram] isEqual: @"monthlyCharts"] || [[SearchModel getProgram] isEqual: @"trending"]) {
        [elegantSheet addButtonsWithTitle:@"Ranking - Default" block:^{
            [SearchModel setSort:@"Rank"];
            [SearchModel setSortDir:@"asc"];
            [vc showspinner];
            [vc newsearch];
        }];
        [elegantSheet addButtonsWithTitle:@"Date Posted (New to Old)" block:^{
            [SearchModel setSort:@"Date"];
            [SearchModel setSortDir:@"desc"];
            [vc showspinner];
            [vc newsearch];
        }];
        [elegantSheet addButtonsWithTitle:@"Date Posted (Old to New)" block:^{
            [SearchModel setSort:@"Date"];
            [SearchModel setSortDir:@"asc"];
            [vc showspinner];
            [vc newsearch];
        }];
    } else {
        if ([[SearchModel getProgram] isEqual: @"queued"]) {
            [elegantSheet addButtonsWithTitle:@"Date Queued (New to Old) - Default" block:^{
                [SearchModel setSort:@"Date"];
                [SearchModel setSortDir:@"desc"];
                [vc showspinner];
                [vc newsearch];
            }];
            [elegantSheet addButtonsWithTitle:@"Date Queued (Old to New)" block:^{
                [SearchModel setSort:@"Date"];
                [SearchModel setSortDir:@"asc"];
                [vc showspinner];
                [vc newsearch];
            }];
            [elegantSheet addButtonsWithTitle:@"Date Posted (New to Old)" block:^{
                [SearchModel setSort:@"Posted"];
                [SearchModel setSortDir:@"desc"];
                [vc showspinner];
                [vc newsearch];
            }];
            [elegantSheet addButtonsWithTitle:@"Date Posted (Old to New)" block:^{
                [SearchModel setSort:@"Posted"];
                [SearchModel setSortDir:@"asc"];
                [vc showspinner];
                [vc newsearch];
            }];
        } else {
            if ([[SearchModel getProgram] isEqual: @"downloads"]) {
                [elegantSheet addButtonsWithTitle:@"Date Downloaded (New to Old) - Default" block:^{
                    [SearchModel setSort:@"Date"];
                    [SearchModel setSortDir:@"desc"];
                    [vc showspinner];
                    [vc newsearch];
                }];
                [elegantSheet addButtonsWithTitle:@"Date Downloaded (Old to New)" block:^{
                    [SearchModel setSort:@"Date"];
                    [SearchModel setSortDir:@"asc"];
                    [vc showspinner];
                    [vc newsearch];
                }];
                [elegantSheet addButtonsWithTitle:@"Date Posted (New to Old)" block:^{
                    [SearchModel setSort:@"Posted"];
                    [SearchModel setSortDir:@"desc"];
                    [vc showspinner];
                    [vc newsearch];
                }];
                [elegantSheet addButtonsWithTitle:@"Date Posted (Old to New)" block:^{
                    [SearchModel setSort:@"Posted"];
                    [SearchModel setSortDir:@"asc"];
                    [vc showspinner];
                    [vc newsearch];
                }];
            }
            else
            {
                [elegantSheet addButtonsWithTitle:@"Date Posted (New to Old) - Default" block:^{
                    [SearchModel setSort:@"Date"];
                    [SearchModel setSortDir:@"desc"];
                    [vc showspinner];
                    [vc newsearch];
                }];
                [elegantSheet addButtonsWithTitle:@"Date Posted (Old to New)" block:^{
                    [SearchModel setSort:@"Date"];
                    [SearchModel setSortDir:@"asc"];
                    [vc showspinner];
                    [vc newsearch];
                }];
            }
        }
    }
    [elegantSheet addButtonsWithTitle:@"Title (A-Z)" block:^{
        [SearchModel setSort:@"Title"];
        [SearchModel setSortDir:@"asc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"Title (Z-A)" block:^{
        [SearchModel setSort:@"Title"];
        [SearchModel setSortDir:@"desc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"Artist (A-Z)" block:^{
        [SearchModel setSort:@"Artist"];
        [SearchModel setSortDir:@"asc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"Artist (Z-A)" block:^{
        [SearchModel setSort:@"Artist"];
        [SearchModel setSortDir:@"desc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"Release Year (New to Old)" block:^{
        [SearchModel setSort:@"releaseyear"];
        [SearchModel setSortDir:@"desc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"Release Year (Old to New)" block:^{
        [SearchModel setSort:@"releaseyear"];
        [SearchModel setSortDir:@"asc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"BPM (Slow to Fast)" block:^{
        [SearchModel setSort:@"BPM"];
        [SearchModel setSortDir:@"asc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet addButtonsWithTitle:@"BPM (Fast to Slow)" block:^{
        [SearchModel setSort:@"BPM"];
        [SearchModel setSortDir:@"desc"];
        [vc showspinner];
        [vc newsearch];
    }];
    [elegantSheet setDestructiveButtonWithTitle:@"CANCEL" block:^{
    }];
    //[elegantSheet showInView:vc.view];
    
    return elegantSheet;
}

@end
