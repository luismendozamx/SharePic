//
//  CameraViewController.h
//  SharePic
//
//  Created by Luis Mendoza on 1/20/15.
//  Copyright (c) 2015 LuisMendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) PFRelation* eventsRelation;
@property (nonatomic, strong) NSMutableArray* eventsJoined;
@property (nonatomic, strong) PFUser* currentUser;
@property (nonatomic, strong) PFObject* eventSelected;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@property (strong, nonatomic) IBOutlet UIPickerView *eventPickerView;


-(void) uploadMessage;
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

- (IBAction)sendButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
