//
//  AnimeUndergroundAppDelegate.m
//  AnimeUnderground
//
//  Created by Nacho L on 06/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "AnimeUndergroundAppDelegate.h"
#import "DDMenuController.h"
#import "RootViewController.h"
#import "MenuViewController.h"

@implementation AnimeUndergroundAppDelegate


@synthesize window=_window;
@synthesize menuController = menuController_;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    
    // navbar custom en iOS5
    
    if ([[UINavigationBar class]respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    NSString *cargado = [[NSUserDefaults standardUserDefaults] stringForKey:@"usuarioLogin_preference"];
    if (cargado == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin_preference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // tengo que mostrar aqui el nuevo view controller
    
    RootViewController *rc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
    menuController_ = [[DDMenuController alloc]initWithRootViewController:rc];
    
    [rc release];
    
    [self.window setBackgroundColor:[UIColor blackColor]];
    self.window.rootViewController = menuController_; //self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
