//
//  EventoCollectionViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "EventoCollectionViewController.h"
#import <Parse/Parse.h>

@implementation EventoCollectionViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"eventId" equalTo:self.event.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error");
        }else{
            self.photos = [NSMutableArray arrayWithArray:objects];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"EventCollectionCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:100];
    PFObject *imageObject = [self.photos objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    photoImageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}

@end
