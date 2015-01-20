//
//  HomeTableViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "HomeTableViewController.h"
#import "EditEventosTableViewController.h"
#import <Parse/Parse.h>

@implementation HomeTableViewController

-(void) viewDidLoad{
    
    //Check for current user
    self.currentUser = [PFUser currentUser];
    
    //If no current user send to login
    if(self.currentUser){
        NSLog(@"Current User Name: %@", self.currentUser.username);
        NSLog(@"Current User Email: %@", self.currentUser.email);
    }else{
        [self performSegueWithIdentifier:@"ShowLogIn" sender:self];
    }
    
    //Add button on nav bar pointing to edit events
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)]];
    
}

-(void) viewWillAppear:(BOOL)animated{
    //Create events relation
    self.eventsRelation = [self.currentUser objectForKey:@"eventsRelation"];
    
    //Query Backend for events joined
    PFQuery *query = [self.eventsRelation query];
    [query orderByAscending:@"Nombre"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.eventsJoined = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.eventsJoined.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *event = [self.eventsJoined objectAtIndex:indexPath.row];
    cell.textLabel.text = event[@"Nombre"];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowLogIn"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    
    if ([segue.identifier isEqualToString:@"ShowEditEventos"]){
        EditEventosTableViewController* editTVC = (EditEventosTableViewController *) segue.destinationViewController;
        editTVC.eventsJoined = self.eventsJoined;
        editTVC.currentUser = self.currentUser;
    }
}

- (IBAction)logOutButton:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        [PFUser logOut];
        [self performSegueWithIdentifier:@"ShowLogIn" sender:self];
    }
}

-(void) addEvent:(id)sender{
    [self performSegueWithIdentifier:@"ShowEditEventos" sender:self];
}
@end
