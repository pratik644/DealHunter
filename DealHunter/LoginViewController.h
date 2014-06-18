//
//  LoginViewController.h
//  DealHunter
//
//  Created by Pratik on 18-11-13.
//  Copyright (c) 2014 Appacitive. All rights reserved.
//

@interface LoginViewController : UIViewController

@property IBOutlet UITextField *username;
@property IBOutlet UITextField *password;

-(IBAction)login;
-(IBAction)fbLogin;

@end
