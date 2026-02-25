//
//  VideoCellModel.h
//  vjpro
//
//  Created by John Arguelles on 12/9/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCellModel : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnCellQueue;
@property (weak, nonatomic) IBOutlet UIImageView *imgCellHd;
@property (weak, nonatomic) IBOutlet UILabel *lblCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCellArtist;
@property (weak, nonatomic) IBOutlet UILabel *lblCellDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imgCellArrow;
@property (weak, nonatomic) IBOutlet UILabel *lblCellTitleNonHd;


@end
