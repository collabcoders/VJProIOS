//
//  GenreCellModel.m
//  vjpro
//
//  Created by John Arguelles on 12/21/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "GenreCellModel.h"

@implementation GenreCellModel

@synthesize lblGenreTitle;

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
    
    [backgroundView setBackgroundColor:[UIColor darkTextColor]];
    [self setSelectedBackgroundView:backgroundView];
    
    UIImageView * customSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.origin.y), 320, 1)];
    [customSeparator setImage:[UIImage imageNamed:@"seperator"]];
    [self.contentView addSubview:customSeparator];
    
    //deprkcated - instead use the highlight color in storyboard ui
    //[self setSelectedTextColor:[UIColor whiteColor]];
}

@end
