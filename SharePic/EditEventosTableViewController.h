//
//  EditEventosTableViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditEventosTableViewController : UITableViewController

@property(nonatomic, strong) NSArray* events;
@property(nonatomic, strong) PFUser* currentUser;
@property(nonatomic, strong) NSMutableArray* eventsJoined;


@end
