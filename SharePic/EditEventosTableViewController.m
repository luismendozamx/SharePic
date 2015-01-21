//
//  EditEventosTableViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "EditEventosTableViewController.h"

@implementation EditEventosTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Evento"];
    [query orderByAscending:@"eventName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.events = events;
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
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"EventoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject* event = [self.events objectAtIndex:indexPath.row];
    cell.textLabel.text = event[@"eventName"];
    
    if([self hasJoinedEvent:event]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFObject* event = [self.events objectAtIndex:indexPath.row];
    PFRelation *eventsRelation = [self.currentUser relationForKey:@"eventsRelation"];
    
    if([self hasJoinedEvent:event]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (PFObject *eventJoined in self.eventsJoined) {
            if ([event.objectId isEqualToString:eventJoined.objectId]){
                [self.eventsJoined removeObject:event];
                break;
            }
        }
        
        [eventsRelation removeObject:event];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.eventsJoined addObject:event];
        [eventsRelation addObject:event];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

-(BOOL) hasJoinedEvent:(PFObject *)event{
    for (PFObject* eventJoined in self.eventsJoined) {
        if ([eventJoined.objectId isEqual:event.objectId]){
            return YES;
        }
    }
    return NO;
}


@end
