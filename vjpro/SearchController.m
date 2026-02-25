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
	// Do any additional setup after loading the view.
    [_txtKeywords setReturnKeyType:UIReturnKeySearch];
    
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main_iPhone"
//                                                  bundle:nil];
//    self.videosConroller = [sb instantiateViewControllerWithIdentifier:@"SKStoryBoardIdentifierMain"];
    [[_btnSearch layer] setBorderWidth:1.0f];
    [[_btnSearch layer] setBorderColor:[UIColor blackColor].CGColor];
    
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
//    if ([_tblGenres respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tblGenres setSeparatorInset:UIEdgeInsetsZero];
//    }
//    _tblGenres.separatorColor = [UIColor lightGrayColor];
    
    _txtKeywords.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    _txtKeywords.leftViewMode = UITextFieldViewModeAlways;
    _txtKeywords.background = [[UIImage imageNamed:@"image"] stretchableImageWithLeftCapWidth:7 topCapHeight:17];
    
    didInitialize = YES;
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
        mainController.pageSize = [UserModel getPageSize];
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
    
    UIImageView * customSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, (cell.frame.origin.y), 320, 1)];
    [customSeparator setImage:[UIImage imageNamed:@"seperator"]];
    [cell.contentView addSubview:customSeparator];
    
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
    NSArray *cells = [tableView visibleCells];
    for (GenreCellModel *cell in cells)
    {
        cell.lblGenreTitle.textColor = [UIColor lightGrayColor];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor darkTextColor];
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
    mainController.pageSize = [UserModel getPageSize];
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
        mainController.pageSize = [UserModel getPageSize];
        [mainController newsearch];
        
        [self.slideController showMainContainerViewAnimated:YES];
    } else {
        [UtilityModel showAlert:@"Invalid Search" msg:@"Keyword(s) must be at least 3 characters in length."];
    }
}

@end
