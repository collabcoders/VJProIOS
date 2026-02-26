//
//  ViewController.m
//  vjpro
//
//  Created by John Arguelles on 11/20/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "ViewController.h"
#import "TWSReleaseNotesView.h"
#import "UtilityModel.h"
#import "SpinnerController.h"
#import "OverlayViewController.h"
#import "UserModel.h"
#import "SKSlideViewController.h"
#import "VideosController.h"

@interface ViewController () {
    CGRect myFrame;
    CGFloat myFrameY;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
//@property (nonatomic, retain) UtilityModel *um;
@property (nonatomic, retain) SpinnerController *spinner;
@property (nonatomic, retain) OverlayViewController *ovcontroller;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *viewAbout;
@property (weak, nonatomic) IBOutlet UIWebView *webHome;
@property (nonatomic, strong) UIButton *btnInfo;
@property (nonatomic, strong) UIButton *btnContact;
- (IBAction)btnWebClose:(id)sender;
- (IBAction)btnLogin:(id)sender;
- (void)btnInfoTapped:(id)sender;
- (void)btnContactTapped:(id)sender;

#define kOFFSET_FOR_KEYBOARD 80.0
//#define CGRectSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height )

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Extend layout to full screen (including under status bar and home indicator)
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    _viewAbout.hidden = YES;
    [_txtEmail setReturnKeyType:UIReturnKeyGo];
    [_txtPassword setReturnKeyType:UIReturnKeyGo];
    
    //overlay and spinner
    _ovcontroller = [[OverlayViewController alloc] init];
    [_ovcontroller setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [_ovcontroller setUserInteractionEnabled:NO];
    [self.view addSubview:_ovcontroller];
    //[self.view insertSubview:_ovcontroller aboveSubview:self.parentViewController.view];
    _spinner = [[SpinnerController alloc] init];
    _spinner.center = self.view.center;
    [self.view addSubview:_spinner];
    
    //text box placeholder color
    UIColor *color = [UIColor colorWithWhite:0.7 alpha:1.0]; // Light gray color for visibility on white background
    _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail Address" attributes:@{NSForegroundColorAttributeName: color}];
    _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    //text box left padding
    _txtEmail.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    _txtEmail.leftViewMode = UITextFieldViewModeAlways;
    _txtEmail.backgroundColor = [UIColor whiteColor];
    _txtPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    _txtPassword.leftViewMode = UITextFieldViewModeAlways;
    _txtPassword.backgroundColor = [UIColor whiteColor];
    
    myFrame = _viewLogin.frame;
    int bgmargin = 0;
    
    //move child view based on phone size
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height < 500)
        {
            myFrame.origin.y -= 88;
            bgmargin = -40;
            CGRect frameAbout = _viewAbout.frame;
            frameAbout.size.height = 429;
            _viewAbout.frame = frameAbout;
        }
    }
    
    //myFrameY = myFrame.origin.y;
    _viewLogin.frame = myFrame;
    //_viewLogin.frame = CGRectSetPos( myFrame, 160, myFrameY );
    //self.viewLogin.frame = CGRectOffset(myFrame, 0, -80);
    
    //[_background removeFromSuperview];
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_login"]];
    _background.contentMode = UIViewContentModeScaleAspectFill;
    _background.clipsToBounds = YES;
    _background.frame = self.view.bounds; // Will be updated in viewDidLayoutSubviews
    [self.view addSubview:_background];
    [self.view sendSubviewToBack:_background];
    
    if ([UserModel getUserID] > 0) {
        //[_viewLogin setHidden:YES];
        [_viewLogin setAlpha:0.0];
        [self performSegueWithIdentifier:@"segue1" sender:nil];
    } else {
        [UserModel setUserHD:-1];
        
        // Create Info and Contact buttons BEFORE showing the modal (so they appear behind it)
        CGFloat screenWidth = self.view.bounds.size.width;
        CGFloat screenHeight = self.view.bounds.size.height;
        CGFloat buttonWidth = 50.0;
        CGFloat buttonHeight = 50.0;
        CGFloat spacing = 50.0;
        CGFloat bottomMargin = 40.0;
        CGFloat centerX = screenWidth / 2.0;
        CGFloat buttonY = screenHeight - bottomMargin - buttonHeight;
        
        // Info button
        _btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnInfo.frame = CGRectMake(centerX - buttonWidth - spacing/2, buttonY, buttonWidth, buttonHeight);
        
        UIImage *infoImage = [UIImage imageNamed:@"icon_info"];
        if (infoImage) {
            [_btnInfo setImage:infoImage forState:UIControlStateNormal];
        } else {
            // Fallback: use a circle with "i"
            _btnInfo.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
            _btnInfo.layer.cornerRadius = buttonWidth / 2.0;
            [_btnInfo setTitle:@"i" forState:UIControlStateNormal];
            [_btnInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnInfo.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        }
        
        [_btnInfo addTarget:self action:@selector(btnInfoTapped:) forControlEvents:UIControlEventTouchUpInside];
        _btnInfo.accessibilityLabel = @"Info";
        [self.view addSubview:_btnInfo];
        
        // Contact button
        _btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnContact.frame = CGRectMake(centerX + spacing/2, buttonY, buttonWidth, buttonHeight);
        
        UIImage *contactImage = [UIImage imageNamed:@"icon_contact"];
        if (contactImage) {
            [_btnContact setImage:contactImage forState:UIControlStateNormal];
        } else {
            // Fallback: use a circle with envelope
            _btnContact.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
            _btnContact.layer.cornerRadius = buttonWidth / 2.0;
            [_btnContact setTitle:@"✉" forState:UIControlStateNormal];
            [_btnContact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnContact.titleLabel.font = [UIFont systemFontOfSize:24];
        }
        
        [_btnContact addTarget:self action:@selector(btnContactTapped:) forControlEvents:UIControlEventTouchUpInside];
        _btnContact.accessibilityLabel = @"Contact";
        [self.view addSubview:_btnContact];
        
        NSLog(@"Buttons created in viewDidLoad at y: %.0f", buttonY);
        
        // NOW show the release notes modal (will appear on top of buttons)
        TWSReleaseNotesView *releaseNotesView = [TWSReleaseNotesView viewWithReleaseNotesTitle:@"ADVISORY" text:@"VJ-Pro is a music video resource for non-broadcast DJ/VJ's and other music driven video content professionals for use in closed-circuit, public performance displays ONLY. The services and resources on the VJ-Pro web site and app are made available under current and specific licenses and permissions granted by the original copyright holders and/or their consigns under usage and display definitions in accordance with United States Copyright Code, Title 17; §106(4,5) and §114(b) respectively, and for use in ASCAP, BMI and SESAC compliant venues within the United States and its territories alone.\n\nThe VJ-Pro mobile app and web site are NOT consumer resources for musical and/or video works and the assets described herein are NOT made available to the general public under any circumstance or condition.  By pressing the \"I AGREE\" button below and proceeding, you warrant and represent without condition or reservation, that you are a media professional as per the definitions above and seek access to this mobile app strictly within such capacity.\n\nIf you DO NOT meet these requirements or you DO NOT AGREE, please exit and delete this app." closeButtonTitle:@"I AGREE"];
        // Show the release notes view
        [releaseNotesView showInView:self.view];
    }
    
    // Hide the tab bar (removes Facebook and Twitter)
    _tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([UserModel getUserID] == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [_viewLogin setAlpha:1.0];
        [UIView commitAnimations];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Update background frame to match the actual view size (works for all device sizes)
    if (_background) {
        _background.frame = self.view.bounds;
        NSLog(@"Background resized to: %@", NSStringFromCGRect(_background.frame));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.txtEmail] || [sender isEqual:self.txtPassword])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    if (movedUp)
    {
        [self moveBgLogoDown];
        //[self performSelector:@selector(moveBgLogoDown) withObject:self afterDelay:0.5];
    }
    else
    {
        [self moveBgLogoUp];
        //[self performSelector:@selector(moveBgLogoUp) withObject:self afterDelay:0.1];
    }
    
    [UIView commitAnimations];
}

-(void)moveBgLogoDown {
    CGRect myBgFrame = _background.frame;
    int newY = myBgFrame.origin.y;
    NSLog(@"Down %d", newY);
    if (newY < 1) {
        myBgFrame.origin.y += 65;
        _background.frame = myBgFrame;
    }
}

-(void)moveBgLogoUp {
    CGRect myBgFrame = _background.frame;
    myBgFrame.origin.y -= 65;
    _background.frame = myBgFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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

- (IBAction)btnLogin:(id)sender {
    [_ovcontroller showOverlay];
    [_spinner startAnimating];
    [self checkLogin];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == _txtPassword) {
        [_ovcontroller showOverlay];
        [_spinner startAnimating];
        [self checkLogin];
        [_txtPassword resignFirstResponder];
    }
    if (theTextField == _txtEmail) {
        [_ovcontroller showOverlay];
        [_spinner startAnimating];
        [self checkLogin];
        [_txtEmail resignFirstResponder];
    }
    return YES;
}

-(void)checkLogin {
    if([_txtEmail.text length] < 6 && [_txtPassword.text length] < 7) {
        [UtilityModel showAlert:@"Login Error" msg:@"Invalid login e-mail and/or password."];
        [_ovcontroller hideOverlay];
        [_spinner stopAnimating];
    } else {
        NSString * urlpath = @"https://www.vj-pro.net/Mobile/Login";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_txtEmail.text forKey:@"em"];
        [params setObject:_txtPassword.text forKey:@"pw"];
        
        NSDictionary *loginData = [UtilityModel getJsonData:urlpath params:params];
        NSLog(@"Dictionary: %@",loginData);
        
        [UserModel setUserID:[[loginData valueForKey:@"userId"] integerValue]];
        [UserModel setStatus:[loginData valueForKey:@"status"]];
        [UserModel setCountry:[loginData valueForKey:@"countrycode"]];
        [UserModel setPageSize:[[loginData valueForKey:@"pagesize"] integerValue]];
        [UserModel setPreviewSeconds:[[loginData valueForKey:@"seconds"] integerValue]];
        
        if ([UserModel getUserID] > 0) {
            NSString *status = [loginData valueForKey:@"status"];
            if ([status isEqualToString:@"current"] || [status isEqualToString:@"trial"] || [status isEqualToString:@"free"]) {

                //[_viewLogin setHidden:YES];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                [_viewLogin setAlpha:0.0];
                [UIView commitAnimations];
                
                [self performSegueWithIdentifier:@"segue1" sender:nil];
                
                [_txtEmail setText:@""];
                [_txtPassword setText:@""];
                
                [_ovcontroller hideOverlay];
                [_spinner stopAnimating];
            } else {
                [_ovcontroller hideOverlay];
                [_spinner stopAnimating];
                [UtilityModel showAlert:@"Account not current" msg:@"Your VJ-Pro subscription is not current.  Please visit www.vj-pro.net to update your subscription."];
            }
        } else {
            [_ovcontroller hideOverlay];
            [_spinner stopAnimating];
            [UtilityModel showAlert:@"Login Error" msg:@"Invalid login e-mail and/or password."];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segue1"]){
        NSLog(@"In Perform segue");
        SKSlideViewController *controller=(SKSlideViewController *)[segue destinationViewController];
        
        // Force full screen presentation (removes the gap and rounded corners)
        if (@available(iOS 13.0, *)) {
            controller.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        
        [controller setSegueIDForMainController:SK_DEFAULT_SEGUE_IDENTIFIER_MAIN leftController:SK_DEFAULT_SEGUE_IDENTIFIER_LEFT rightController:SK_DEFAULT_SEGUE_IDENTIFIER_RIGHT];
        [controller setLoadViewControllersOnDemand:YES];
        [controller setSlideControllerStyleMask:SKSlideControllerStyleRevealLeft|SKSlideControllerStyleRevealRight];
        [controller setHasShadow:YES];
        [controller reloadControllers];
    }
}

- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    [_webHome stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];

    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    NSURL * myUrl;
    _viewAbout.hidden = NO;
    [_ovcontroller showOverlay];
    [_spinner startAnimating];
    [_viewAbout setAlpha:0];
    if (indexOfTab == 0) {
        myUrl = [NSURL URLWithString:@"https://www.vj-pro.net/Mobile/Info"];
    }
    if (indexOfTab == 1) {
        myUrl = [NSURL URLWithString:@"https://www.facebook.com/ScreenplayVJPro"];
    }
    if (indexOfTab == 2) {
        myUrl = [NSURL URLWithString:@"https://twitter.com/VJPro"];
    }
    if (indexOfTab == 3) {
        myUrl = [NSURL URLWithString:@"https://www.vj-pro.net/Mobile/Contact"];
    }
    NSURLRequest * myRequest = [NSURLRequest requestWithURL:myUrl];
    [_webHome loadRequest:myRequest];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [_viewAbout setAlpha:1.0];
    [UIView commitAnimations];
    NSLog(@"Tab index = %lu", (unsigned long)indexOfTab);
}

- (IBAction)btnWebClose:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [_viewAbout setAlpha:0];
    [UIView commitAnimations];
    _viewAbout.hidden = YES;
    //NSLog(@"close");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        [_ovcontroller hideOverlay];
        [_spinner stopAnimating];
    //}
}

- (void)btnInfoTapped:(id)sender {
    [_webHome stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    
    NSURL *myUrl = [NSURL URLWithString:@"https://www.vj-pro.net/Mobile/Info"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    _viewAbout.hidden = NO;
    [_ovcontroller showOverlay];
    [_spinner startAnimating];
    [_viewAbout setAlpha:0];
    
    [_webHome loadRequest:myRequest];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [_viewAbout setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)btnContactTapped:(id)sender {
    [_webHome stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    
    NSURL *myUrl = [NSURL URLWithString:@"https://www.vj-pro.net/Mobile/Contact"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    _viewAbout.hidden = NO;
    [_ovcontroller showOverlay];
    [_spinner startAnimating];
    [_viewAbout setAlpha:0];
    
    [_webHome loadRequest:myRequest];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [_viewAbout setAlpha:1.0];
    [UIView commitAnimations];
}

@end
