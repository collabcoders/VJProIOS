//
//  VideoCellModel.m
//  vjpro
//
//  Created by John Arguelles on 12/9/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "VideoCellModel.h"

@implementation VideoCellModel

@synthesize btnCellQueue, imgCellHd, lblCellTitle, lblCellArtist, lblCellDetails, imgCellArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
    [backgroundView setBackgroundColor:[UIColor grayColor]];
    [self setSelectedBackgroundView:backgroundView];
}

@end
