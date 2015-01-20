//
//  LoginViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/19/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usuarioTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)logInButton:(id)sender;

@end
