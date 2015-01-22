//
//  PhotoBrowserViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/22/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MWPhotoBrowser.h"

@interface PhotoBrowserViewController : UIViewController <MWPhotoBrowserDelegate> {
    UISegmentedControl *_segmentedControl;
    NSMutableArray *_selections;
}

@property(strong, nonatomic) PFObject* event;
@property(strong, nonatomic) PFUser* currentUser;
@property(strong, nonatomic) NSMutableArray* photos;
@property(strong, nonatomic) NSMutableArray* thumbnails;
@property(strong, nonatomic) NSMutableArray* serverData;

@end
