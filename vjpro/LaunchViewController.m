//
//  LaunchViewController.m
//  vjpro
//
//  Custom launch screen with content mode control
//

#import "LaunchViewController.h"

@interface LaunchViewController ()
@property (nonatomic, strong) UIImageView *launchImageView;
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set background color to black (matches your app design)
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create image view with the launch image
    // Use "Default-568h@2x" or whatever your launch image is named
    UIImage *launchImage = [self launchImage];
    
    _launchImageView = [[UIImageView alloc] initWithImage:launchImage];
    _launchImageView.contentMode = UIViewContentModeScaleAspectFill;
    _launchImageView.clipsToBounds = YES;
    _launchImageView.frame = self.view.bounds;
    _launchImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_launchImageView];
    
    // Debug logging
    NSLog(@"=== LAUNCH SCREEN DEBUG ===");
    NSLog(@"Screen bounds: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"Launch image size: %@", NSStringFromCGSize(launchImage.size));
    NSLog(@"Content mode: ScaleAspectFill");
    NSLog(@"===========================");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Transition to the main app after a brief delay
    // Adjust the delay as needed (0.5-2.0 seconds is typical)
    [self performSelector:@selector(transitionToMainApp) withObject:nil afterDelay:1.0];
}

- (void)transitionToMainApp {
    // Simply fade out the launch screen overlay
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (UIImage *)launchImage {
    // Determine the correct launch image based on device screen size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    NSString *imageName = nil;
    
    // Get device dimensions (accounting for portrait/landscape)
    CGFloat height = MAX(screenSize.width, screenSize.height);
    CGFloat width = MIN(screenSize.width, screenSize.height);
    
    if (scale == 2.0) {
        if (height == 568.0) {
            // iPhone SE (1st gen), 5, 5s, 5c - 4 inch screen
            imageName = @"Default-568h@2x";
        } else if (height == 667.0) {
            // iPhone 6, 6s, 7, 8, SE (2nd/3rd gen) - 4.7 inch
            imageName = @"Default-667h@2x";
        } else if (height == 736.0) {
            // iPhone 6+, 6s+, 7+, 8+ - 5.5 inch
            imageName = @"Default-736h@3x";
        } else if (height == 812.0) {
            // iPhone X, XS, 11 Pro, 12 mini, 13 mini
            imageName = @"Default-812h@3x";
        }
    } else if (scale == 3.0) {
        if (height == 812.0) {
            // iPhone X, XS, 11 Pro, 12 mini, 13 mini
            imageName = @"Default-812h@3x";
        } else if (height == 896.0) {
            // iPhone XR, XS Max, 11, 11 Pro Max
            imageName = @"Default-896h@3x";
        } else if (height == 844.0) {
            // iPhone 12, 12 Pro, 13, 13 Pro, 14
            imageName = @"Default-844h@3x";
        } else if (height == 926.0) {
            // iPhone 12 Pro Max, 13 Pro Max, 14 Plus
            imageName = @"Default-926h@3x";
        }
    }
    
    // Try to load the device-specific image
    UIImage *image = nil;
    if (imageName) {
        image = [UIImage imageNamed:imageName];
    }
    
    // Fallback to generic launch images or background
    if (!image) {
        image = [UIImage imageNamed:@"Default@2x"];
    }
    if (!image) {
        image = [UIImage imageNamed:@"Default"];
    }
    if (!image) {
        // Last resort: use the background_login image
        image = [UIImage imageNamed:@"background_login"];
    }
    
    return image;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
