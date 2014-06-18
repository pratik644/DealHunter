//
//  AppDelegate.h
//  DealHunter
//
//  Created by Pratik on 18-11-13.
//  Copyright (c) 2014 Appacitive. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "TableViewController.h"
#import "LoginViewController.h"

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TableViewController *mainViewController;
@property (strong, nonatomic) UINavigationController *navController;

- (void)showLoginView;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;
- (void)openSession;

@end
