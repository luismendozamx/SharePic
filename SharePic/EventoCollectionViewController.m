//
//  EventoCollectionViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "EventoCollectionViewController.h"

@implementation EventoCollectionViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Evento"];
    [query whereKey:@"objectId" equalTo:self.event.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error");
        }else{
            self.photos = [NSMutableArray arrayWithArray:objects];
        }
    }];
}

@end
