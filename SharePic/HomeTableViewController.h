//
//  HomeTableViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeTableViewController : UITableViewController

@property(nonatomic, strong) PFRelation* eventsRelation;
@property(nonatomic, strong) NSMutableArray* eventsJoined;
@property(nonatomic, strong) PFUser* currentUser;
@property(nonatomic, strong) PFObject* eventSelected;

- (IBAction)logOutButton:(id)sender;
-(void) addEvent:(id)sender;

@end
