//
//  CameraViewController.m
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@implementation CameraViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    //Create events relation
    self.eventsRelation = [self.currentUser objectForKey:@"eventsRelation"];
    self.currentUser = [PFUser currentUser];
    
    //Query Backend for events joined
    PFQuery *query = [self.eventsRelation query];
    [query orderByAscending:@"eventName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.eventsJoined = [NSMutableArray arrayWithArray:events];
            self.eventPickerView.dataSource = self;
            self.eventPickerView.delegate = self;
        }
    }];
    
    self.activityView.hidden = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabBarController hidesBottomBarWhenPushed];
    
    if(self.image == nil && [self.videoFilePath length] == 0){
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }else{
        //Everything already loaded.
        
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
                self.eventPickerView.dataSource = self;
                self.eventPickerView.delegate = self;
                [self.eventPickerView reloadAllComponents];
            }
        }];
    }
    
    
}

#pragma mark - Image Picker

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *) kUTTypeImage]){
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        self.previewImageView.image = [self resizeImage:self.image toWidth:200.0 andHeight:200.0];
    }else{
        //Video was taken or selected
        self.videoFilePath = (__bridge NSString *)([[info  objectForKey:UIImagePickerControllerMediaURL] path]);
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            //save the video
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Events

- (IBAction)cancelButton:(id)sender {
    self.image = nil;
    self.videoFilePath = nil;
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)sendButton:(id)sender {
    if(self.image == nil && [self.videoFilePath length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Por favor captura o selecciona una foto." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [self presentViewController: self.imagePicker animated:YES completion:nil];
    }else{
        [self uploadMessage];
        //[self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Image Upload

-(void) uploadMessage{
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    self.activityView.hidden = NO;
    
    if(self.image != nil){
        if(self.image.size.width > 1000){
            UIImage *newImage = [self resizeImage:self.image percent:0.2f];
            fileData = UIImagePNGRepresentation(newImage);
        }else{
            fileData = UIImagePNGRepresentation(self.image);
        }
        fileName = @"image.png";
        fileType = @"image";
    }else{
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
    [photo setObject:file forKey:@"file"];
    [photo setObject:fileType forKey:@"fileType"];
    [photo setObject:self.eventSelected.objectId forKey:@"eventId"];
    [photo setObject:self.currentUser.objectId forKey:@"userId"];
    
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }else{
            if(succeeded){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Gracias" message:@"Se ha enviado tu foto." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [self reset];
                self.activityView.hidden = YES;
                [self.tabBarController setSelectedIndex:0];
                
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                self.activityView.hidden = YES;
                [alertView show];
            }
            
        }
    }];
}



#pragma mark - Picker Methods

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.eventsJoined.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PFObject* event = [self.eventsJoined objectAtIndex:row];
    return event[@"eventName"];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    self.eventSelected = [self.eventsJoined objectAtIndex:row];
}

#pragma mark - Helper Methods

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

-(UIImage *)resizeImage:(UIImage *)image percent:(float)percent{
    float width = image.size.width;
    float height = image.size.height;
    CGSize newSize = CGSizeMake(width*percent, height*percent);
    CGRect newRectangle = CGRectMake(0, 0, width*percent, height*percent);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

-(void) reset{
    self.image = nil;
    self.videoFilePath = nil;
    self.previewImageView.image = nil;
}

@end
