//
//  EventoCollectionViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventoCollectionViewController : UICollectionViewController

@property(nonatomic, strong) PFUser* currentUser;
@property(nonatomic, strong) PFObject* event;
@property(nonatomic, strong) NSMutableArray* photos;

@end
