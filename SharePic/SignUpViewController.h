//
//  SignUpViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/19/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nombreTextField;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usuarioTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signUpButton:(id)sender;
@end
