//
//  VideoCellModel.m
//  vjpro
//
//  Created by John Arguelles on 12/9/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "VideoCellModel.h"

@implementation VideoCellModel

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
}

@end
