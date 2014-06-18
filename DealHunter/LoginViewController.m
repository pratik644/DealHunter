//
//  LoginViewController.m
//  DealHunter
//
//  Created by Pratik on 18-11-13.
//  Copyright (c) 2014 Appacitive. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <Appacitive/AppacitiveSDK.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

-(IBAction)login {
    if(_username.text != nil && _password.text != nil)
    {
        [APUser authenticateUserWithUsername:_username.text password:_password.text sessionExpiresAfter:nil limitAPICallsTo:nil successHandler:^(APUser *user){
            [self dismissViewControllerAnimated:YES completion:nil];
        } failureHandler:^(APError *error) {
            NSLog(@"ERROR:%@",[error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error occurred" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

-(IBAction)fbLogin {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

@end
