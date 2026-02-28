//
//  AppDelegate.m
//  vjpro
//
//  Created by John Arguelles on 11/20/13.
//  Copyright (c) 2013 Collab Coders. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Add custom launch screen overlay FIRST (before anything else)
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
    [self.window addSubview:launchVC.view];
    launchVC.view.frame = self.window.bounds;
    
    // Set global tab bar item title font (normal state)
    [[UITabBarItem appearance] setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:10.0]
    } forState:UIControlStateNormal];

    // Optionally match the selected state too
    [[UITabBarItem appearance] setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:10.0]
    } forState:UIControlStateSelected];
    
    // Override point for customization after application launch.
    self.window.tintColor = [UIColor whiteColor];
    
    // Make status bar content white on all view controllers
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // Set window background to black to eliminate white space
    self.window.backgroundColor = [UIColor blackColor];
    
    // Adjust window frame to remove any top spacing
    CGRect windowFrame = self.window.frame;
    windowFrame.origin.y = 0;
    self.window.frame = windowFrame;
    
    // Remove glass/blur effect from tab bar by using an opaque background
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        // Start from a plain, opaque background (no blur)
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor blackColor]; // match app design

        // Optional: set item title colors to ensure readability
        NSDictionary *normalAttrs = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
        NSDictionary *selectedAttrs = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs;
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttrs;
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttrs;
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttrs;
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttrs;

        // Apply globally
        UITabBar *tabBarAppearanceProxy = [UITabBar appearance];
        tabBarAppearanceProxy.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            tabBarAppearanceProxy.scrollEdgeAppearance = appearance;
        }

        // Also disable translucency to avoid glass effect
        tabBarAppearanceProxy.translucent = NO;
    } else {
        // Fallback for older iOS: disable translucency and set a solid bar tint
        [[UITabBar appearance] setTranslucent:NO];
        [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

