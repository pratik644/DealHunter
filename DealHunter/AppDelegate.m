//
//  AppDelegate.m
//  DealHunter
//
//  Created by Pratik on 18-11-13.
//  Copyright (c) 2014 Appacitive. All rights reserved.
//

#import "AppDelegate.h"
#import <Appacitive/AppacitiveSDK.h>

@implementation AppDelegate

@synthesize navController, mainViewController;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Appacitive registerAPIKey:@"YOUR_API_KEY_HERE" useLiveEnvironment:NO];
    self.mainViewController = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
    navController = (UINavigationController *)self.window.rootViewController;
    mainViewController = (TableViewController *)[navController topViewController];
    [self.window makeKeyAndVisible];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
    } else {
        [self showLoginView];
    }
    return YES;
}

- (void)showLoginView {
    
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController presentedViewController];
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        [topViewController performSegueWithIdentifier:@"showLoginView" sender:self];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                [APUser authenticateUserWithFacebook:session.accessTokenData.accessToken signUp:NO sessionExpiresAfter:nil limitAPICallsTo:nil successHandler:^(APUser *user){
                    NSLog(@"User's Facebook account added to Appacitive");
                } failureHandler:^(APError *error) {
                    NSLog(@"Error while adding user's Facebook account to Appacitive: %@",error.description);
                }];
            }];
            
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController presentedViewController]
                 isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)openSession {
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                             FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
    }
}

@end
