//
//  HomeTableViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MWPhotoBrowser.h"

@interface HomeTableViewController : UITableViewController <MWPhotoBrowserDelegate> {
    UISegmentedControl *_segmentedControl;
    NSMutableArray *_selections;
}

@property(nonatomic, strong) PFRelation* eventsRelation;
@property(nonatomic, strong) PFUser* currentUser;
@property(nonatomic, strong) PFObject* eventSelected;
@property(nonatomic, strong) NSMutableArray* eventsJoined;
@property(strong, nonatomic) NSMutableArray* photos;
@property(strong, nonatomic) NSMutableArray* thumbnails;
@property(strong, nonatomic) NSMutableArray* serverData;

- (IBAction)logOutButton:(id)sender;
-(void) addEvent:(id)sender;

@end
