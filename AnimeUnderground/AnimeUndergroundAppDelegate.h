//
//  AnimeUndergroundAppDelegate.h
//  AnimeUnderground
//
//  Created by Nacho L on 06/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

@interface AnimeUndergroundAppDelegate : NSObject <UIApplicationDelegate> {
    DDMenuController *menuController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (retain, nonatomic) DDMenuController *menuController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
