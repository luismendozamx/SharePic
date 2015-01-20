//
//  SignUpViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/19/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@implementation SignUpViewController

-(void) viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)signUpButton:(id)sender {
    
    NSString *nombre = [self.nombreTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *usuario = [self.usuarioTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([usuario length] == 0 || [password length] == 0 || [email length] == 0 || [nombre length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Asegurate de llenar todos los campos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }else{
        PFUser *newUser = [PFUser user];
        newUser.username = usuario;
        newUser.password = password;
        newUser.email = email;
        newUser[@"nombre"] = nombre;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
    
}
@end
