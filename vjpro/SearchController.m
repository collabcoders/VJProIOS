//
//  SearchController.m
//  vjpro
//
//  Created by John Arguelles on 12/6/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "SearchController.h"
#import "VideosController.h"
#import "SearchModel.h"
#import "UtilityModel.h"
#import "GenreModel.h"
#import "GenreCellModel.h"
#import "SpinnerController.h"
#import "OverlayViewController.h"
#import "UserModel.h"
#import "AKSegmentedControl.h"

@interface SearchController ()

@property (nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic, retain) SpinnerController *spinner;
@property (nonatomic, retain) OverlayViewController *ovcontroller;
@property (weak, nonatomic) IBOutlet UITableView *tblGenres;
@property (weak, nonatomic) IBOutlet UITextField *txtKeywords;
//@property (nonatomic, retain) VideosController * videosConroller;
@property (weak, nonatomic) IBOutlet UIView *viewHdOption;
@property (nonatomic, retain) AKSegmentedControl *segmentedControl1;
- (IBAction)btnSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@end

@implementation SearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showspinner {
    [_ovcontroller showOverlay];
    [_spinner startAnimating];
}

-(void)hidespinner {
    [_ovcontroller hideOverlay];
    [_spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Force the view to extend to the very top and avoid extra white space
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [_txtKeywords setReturnKeyType:UIReturnKeySearch];
    
    // Set text field background to white
    _txtKeywords.backgroundColor = [UIColor whiteColor];
    
    // Ensure search text is always readable: black text and dark placeholder
    _txtKeywords.textColor = [UIColor blackColor];
    if (_txtKeywords.placeholder.length > 0) {
        _txtKeywords.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txtKeywords.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    }
    // Force light keyboard appearance to match white field
    _txtKeywords.keyboardAppearance = UIKeyboardAppearanceLight;
    
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main_iPhone"
//                                                  bundle:nil];
//    self.videosConroller = [sb instantiateViewControllerWithIdentifier:@"SKStoryBoardIdentifierMain"];
    
    // Replace "Search" text with search icon
    [_btnSearch setTitle:@"" forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) {
        // Use SF Symbols for iOS 13+
        UIImage *searchIcon = [UIImage systemImageNamed:@"magnifyingglass"];
        [_btnSearch setImage:searchIcon forState:UIControlStateNormal];
        [_btnSearch setTintColor:[UIColor whiteColor]];
    } else {
        // Fallback for older iOS versions - use Unicode search symbol
        [_btnSearch setTitle:@"🔍" forState:UIControlStateNormal];
        [_btnSearch.titleLabel setFont:[UIFont systemFontOfSize:20]];
    }
    
    [[_btnSearch layer] setBorderWidth:1.0f];
    [[_btnSearch layer] setBorderColor:[UIColor blackColor].CGColor];
    
    // Set HD option view background to black to eliminate white bar
    _viewHdOption.backgroundColor = [UIColor blackColor];
    
    // Hide the HD filter buttons
    _viewHdOption.hidden = YES;
    
    static BOOL didInitialize = NO;
    _segmentedControl1 = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(-1, -1, 272.0, 43.0)];
    [_segmentedControl1 addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl1 setSegmentedControlMode:AKSegmentedControlModeSticky];
    int selectedHd = ((int)[UserModel getUserHD] + 1);
    [_segmentedControl1 setSelectedIndex:selectedHd];
    
    [self setupSegmentedControl1];
    
    if (!didInitialize) {
        //if ([SearchModel getGenres].count < 10) {
            // Non-UI initialization goes here. It will only ever be called once.
            NSString * urlpath = @"https://www.vj-pro.net/api/videosapi/GetGenres";
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            NSDictionary *genresData = [UtilityModel getJsonData:urlpath params:params];
            NSLog(@"Dictionary: %@",genresData);
            
            NSMutableArray *genres = [[NSMutableArray alloc] init];
            [genres removeAllObjects];
            
            GenreModel * staticGenre1 = [[GenreModel alloc] init];
            staticGenre1.genreId = @"9999";
            staticGenre1.genre = @"Weekly Charts";
            [genres addObject:staticGenre1];
            GenreModel * staticGenre2 = [[GenreModel alloc] init];
            staticGenre2.genreId = @"9998";
            staticGenre2.genre = @"Monthly Charts";
            [genres addObject:staticGenre2];
            GenreModel * staticGenre3 = [[GenreModel alloc] init];
            staticGenre3.genreId = @"9997";
            staticGenre3.genre = @"Trending";
            [genres addObject:staticGenre3];
            if (genresData.count > 0) {
                for(NSDictionary *genre in genresData){
                    GenreModel * g = [[GenreModel alloc] init];
                    g.genreId = [genre objectForKey:@"id"];
                    g.genre = [genre objectForKey:@"title"];
                    [genres addObject:g];
                }
            }
            
            [SearchModel saveGenres:genres];
            genres = [SearchModel getGenres];
            [_tblGenres reloadData];
        //}
    }
    
    _ovcontroller = [[OverlayViewController alloc] init];
    [_ovcontroller setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [_ovcontroller setUserInteractionEnabled:NO];
    [self.view addSubview:_ovcontroller];
    _spinner = [[SpinnerController alloc] init];
    _spinner.center = self.view.center;
    [self.view addSubview:_spinner];
    
    _tblGenres.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    
    // Position the table view below the search controls
    // Calculate the bottom of the search button
    CGFloat searchControlsBottom = MAX(CGRectGetMaxY(_txtKeywords.frame), CGRectGetMaxY(_btnSearch.frame));
    
    // Add some padding
    CGFloat padding = 0;
    
    // Adjust the table view frame to start below the search controls
    CGRect tableFrame = _tblGenres.frame;
    tableFrame.origin.y = searchControlsBottom + padding;
    tableFrame.size.height = self.view.frame.size.height - tableFrame.origin.y;
    _tblGenres.frame = tableFrame;
    
    // Reset content insets
    _tblGenres.contentInset = UIEdgeInsetsZero;
    _tblGenres.scrollIndicatorInsets = UIEdgeInsetsZero;
    
//    if ([_tblGenres respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tblGenres setSeparatorInset:UIEdgeInsetsZero];
//    }
//    _tblGenres.separatorColor = [UIColor lightGrayColor];
    
    _txtKeywords.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    _txtKeywords.leftViewMode = UITextFieldViewModeAlways;
    // Keep white background
    _txtKeywords.borderStyle = UITextBorderStyleRoundedRect;
    
    // Reinforce colors in case of trait changes
    _txtKeywords.textColor = [UIColor blackColor];
    _txtKeywords.backgroundColor = [UIColor whiteColor];
    
    // Set text field superview background to black
    if (_txtKeywords.superview) {
        _txtKeywords.superview.backgroundColor = [UIColor blackColor];
    }
    
    // Find and fix any white background views (except the search text field)
    for (UIView *subview in self.view.subviews) {
        // Skip the text field - we want it to stay white
        if (subview == _txtKeywords || subview == _txtKeywords.superview) {
            continue;
        }
        // Change any white backgrounds to black
        if (subview.backgroundColor == nil || 
            CGColorEqualToColor(subview.backgroundColor.CGColor, [UIColor whiteColor].CGColor) ||
            CGColorEqualToColor(subview.backgroundColor.CGColor, [UIColor clearColor].CGColor)) {
            subview.backgroundColor = [UIColor blackColor];
        }
    }
    
    didInitialize = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Remove white space by extending view under status bar
    if ([self respondsToSelector:@selector(wantsFullScreenLayout)]) {
        [self setWantsFullScreenLayout:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Removed black overlay that was creating the black line
}

- (void)setupSegmentedControl1
{
    UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_segmentedControl1 setBackgroundImage:backgroundImage];
    [_segmentedControl1 setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [_segmentedControl1 setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [_segmentedControl1 setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"segmented-bg-pressed.png"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // Button 1
    UIButton *buttonSocial = [[UIButton alloc] init];
    [buttonSocial setTitle:@"All Def." forState:UIControlStateNormal];
    [buttonSocial setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonSocial.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *buttonStar = [[UIButton alloc] init];
    [buttonStar setTitle:@"SD Only" forState:UIControlStateNormal];
    [buttonStar setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonStar.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 3
    UIButton *buttonSettings = [[UIButton alloc] init];
    [buttonSettings setTitle:@"HD Only" forState:UIControlStateNormal];
    [buttonSettings setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonSettings.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [_segmentedControl1 setButtonsArray:@[buttonSocial, buttonStar, buttonSettings]];
    [_viewHdOption addSubview:_segmentedControl1];
}

- (void)segmentedViewController:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    BOOL changed = NO;
    if ([segmentedControl selectedIndexes].firstIndex == 0) {
        if ([UserModel getUserHD] != -1) {
            [UserModel setUserHD:-1];
            changed = YES;
        }
    }
    if ([segmentedControl selectedIndexes].firstIndex == 1) {
        if ([UserModel getUserHD] != 0) {
            [UserModel setUserHD:0];
            changed = YES;
        }
    }
    if ([segmentedControl selectedIndexes].firstIndex == 2) {
        if ([UserModel getUserHD] != 1) {
            [UserModel setUserHD:1];
            changed = YES;
        }
    }
    if (changed) {
        VideosController *mainController=(VideosController *)[self.slideController getMainViewController];
        [self showspinner];
        [mainController showspinner];
        mainController.pageSize = (int)[UserModel getPageSize];
        [mainController newsearch];
    }
    //NSLog(@"SegmentedControl #1 : Selected Index %@", [segmentedControl selectedIndexes]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SearchModel getGenres].count;
    NSLog(@"%lu", (unsigned long)[SearchModel getGenres].count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"genreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Add 1px dark grey border to the bottom of the cell
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    // Remove any existing bottom borders to avoid duplicates
    if (cell.contentView.layer.sublayers.count > 0) {
        NSArray *sublayers = [cell.contentView.layer.sublayers copy];
        for (CALayer *layer in sublayers) {
            if (layer.frame.size.height == 1) {
                [layer removeFromSuperlayer];
            }
        }
    }
    
    [cell.contentView.layer addSublayer:bottomBorder];
    
    GenreModel *keys = [self getSelectedGenre:indexPath];
    GenreCellModel *gCell=(GenreCellModel *)cell;
    [gCell.lblGenreTitle setText:@""];
    [gCell.lblGenreTitle setText:keys.genre];
    gCell.lblGenreTitle.textColor = [UIColor lightGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreCellModel* theCell = (GenreCellModel*)[tableView cellForRowAtIndexPath:indexPath];
    theCell.lblGenreTitle.textColor = [UIColor blackColor];
}

-(GenreModel *)getSelectedGenre:(NSIndexPath *)indexPath{
    GenreModel *genre = [[SearchModel getGenres] objectAtIndex:indexPath.row];
    return genre;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
	UITableViewCell *cell = [self tableView: tableView cellForRowAtIndexPath: indexPath];
	return cell.bounds.size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtKeywords resignFirstResponder];
    
    // Reset all cells to their default state
    NSArray *cells = [tableView visibleCells];
    for (GenreCellModel *cell in cells)
    {
        cell.lblGenreTitle.textColor = [UIColor lightGrayColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Set the selected cell to dark grey background with white text
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    GenreCellModel* theCell = (GenreCellModel*)[tableView cellForRowAtIndexPath:indexPath];
    theCell.lblGenreTitle.textColor = [UIColor whiteColor];
    UIImageView * customSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, (cell.frame.origin.y), 320, 1)];
    [customSeparator setImage:[UIImage imageNamed:@"seperator"]];
    [cell.contentView addSubview:customSeparator];
    
    [SearchModel resetParams];
    [_txtKeywords setText:@""];
    
    GenreModel *result = [self getSelectedGenre:indexPath];
    if ([result.genreId isEqual:@"9999"] || [result.genreId isEqual:@"9998"] || [result.genreId isEqual:@"9997"]) {
        [SearchModel setGenreID:0];
        if ([result.genreId isEqual:@"9999"]) {
            [SearchModel setProgram:@"weeklyCharts"];
        }
        if ([result.genreId isEqual:@"9998"]) {
            [SearchModel setProgram:@"monthlyCharts"];
        }
        if ([result.genreId isEqual:@"9997"]) {
            [SearchModel setProgram:@"trending"];
        }
    } else {
        [SearchModel setGenreID:result.genreId];
        [SearchModel setProgram:@""];
    }
    NSLog(@"Genre ID: %@", result.genreId);
    
    
    VideosController *mainController=(VideosController *)[self.slideController getMainViewController];
    [self showspinner];
    [mainController showspinner];
    [mainController.lblTitle setText:result.genre];
    mainController.pageSize = (int)[UserModel getPageSize];
    [mainController newsearch];
    
    [self.slideController showMainContainerViewAnimated:YES];
}

#pragma mark - SKSlideViewDelegate -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
    
    //Getting the datasource reference from the main view controller
    //VideosController *controller=(VideosController *)[self.slideController getMainViewController];
    //self.dataSource=[controller getDataSource];
    //[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[NSThread sleepForTimeInterval:0.50];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [_txtKeywords resignFirstResponder];
    [self keywordSearch];
    return YES;
}

- (IBAction)btnSearch:(id)sender {
    [_txtKeywords resignFirstResponder];
    [self keywordSearch];
}

-(void)keywordSearch {
    [SearchModel resetParams];
    NSString *trimmedKeywords = [_txtKeywords.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedKeywords.length > 2) {
        [SearchModel setKeywords:trimmedKeywords];
        
        VideosController *mainController=(VideosController *)[self.slideController getMainViewController];
        [self showspinner];
        [mainController showspinner];
        NSString * strTitle = [NSString stringWithFormat:@"Search: \"%@\"", trimmedKeywords];
        [mainController.lblTitle setText:strTitle];
        mainController.pageSize = (int)[UserModel getPageSize];
        [mainController newsearch];
        
        [self.slideController showMainContainerViewAnimated:YES];
    } else {
        [UtilityModel showAlert:@"Invalid Search" msg:@"Keyword(s) must be at least 3 characters in length."];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // Keep the search field readable across appearances
    _txtKeywords.textColor = [UIColor blackColor];
    _txtKeywords.backgroundColor = [UIColor whiteColor];
    if (_txtKeywords.placeholder.length > 0) {
        _txtKeywords.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txtKeywords.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    }
}

@end

