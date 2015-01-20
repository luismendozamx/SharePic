//
//  HomeViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/19/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>

@implementation HomeViewController

-(void) viewDidLoad{
    
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        NSLog(@"Current User Name: %@", currentUser.username);
        NSLog(@"Current User Email: %@", currentUser.email);
    }else{
        [self performSegueWithIdentifier:@"ShowLogIn" sender:self];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowLogIn"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        //[segue.destinationViewController setHidesBackButton:YES];
    }
}

@end
