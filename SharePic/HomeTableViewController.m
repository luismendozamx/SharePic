//
//  HomeTableViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "HomeTableViewController.h"
#import "EditEventosTableViewController.h"
#import "EventoCollectionViewController.h"
#import "PhotoBrowserViewController.h"
#import <Parse/Parse.h>

@implementation HomeTableViewController{
    MWPhotoBrowser* browser;
}

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
    [query orderByAscending:@"eventName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.eventsJoined = [NSMutableArray arrayWithArray:events];
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
    cell.textLabel.text = event[@"eventName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.eventSelected = [self.eventsJoined objectAtIndex:indexPath.row];
    
    //[self performSegueWithIdentifier:@"ShowEventCollection" sender:self];
    //[self performSegueWithIdentifier:@"ShowEventPhotos" sender:self];
    
    [self reloadBrowserData];
    [self.navigationController pushViewController:browser animated:YES];
    [self getPhotos];
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
    
    /*if ([segue.identifier isEqualToString:@"ShowEventCollection"]){
        EventoCollectionViewController* eventCVC = (EventoCollectionViewController *) segue.destinationViewController;
        eventCVC.event = self.eventSelected;
        eventCVC.currentUser = self.currentUser;
    }*/
    
    if ([segue.identifier isEqualToString:@"ShowEventPhotos"]){
        /*[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        PhotoBrowserViewController* photoBrowser = (PhotoBrowserViewController *) segue.destinationViewController;
        photoBrowser.event = self.eventSelected;
        photoBrowser.currentUser = self.currentUser;*/
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

-(void) reloadBrowserData{
    browser = nil;
    self.photos = nil;
    self.thumbnails = nil;
    self.serverData = nil;
    
    //init browser
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.displayActionButton = NO;
    [browser setCurrentPhotoIndex:0];
}


-(void) getPhotos{
    self.photos = [NSMutableArray array];
    self.thumbnails = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"eventId" equalTo:self.eventSelected.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error");
        }else{
            self.serverData = [NSMutableArray arrayWithArray:objects];
            [self extractData];
            [browser reloadData];
        }
    }];
}

-(void) extractData{
    if(self.serverData != nil){
        for (PFObject* event in self.serverData) {
            PFFile *imageFile = [event objectForKey:@"file"];
            MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageFile.url]];
            [self.photos addObject:photo];
        }
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
