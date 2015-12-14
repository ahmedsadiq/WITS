//
//  UpdateProfileVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 04/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "UserProfile.h"
#import "NIDropDown.h"
#import "CountryPicker.h"

@interface UpdateProfileVC : UIViewController<UITextFieldDelegate,NIDropDownDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CountryPickerDelegate>{
     NSString *loadingTitle;
    
     NSString *displayName;
     
    IBOutlet UIImageView *cityicon;
    
      IBOutlet UILabel *FemaleLbl;
      IBOutlet UILabel *MaleLbl;
    IBOutlet UIButton *profileImgOutlet;
    IBOutlet UIImageView *genderIcon;
    IBOutlet UIImageView *countryicon;
    IBOutlet UIImageView *UsernameIcon;
    IBOutlet UIImageView *nameIcon;
    
    IBOutlet UIView *greyLine;
    IBOutlet UIImageView *birthdayIcon;
 
    IBOutlet UIImageView *AboutIcon;
    __weak IBOutlet UIScrollView *profileScrollView;
    
      IBOutlet UITextField *usernameField;
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *titleField;
    __weak IBOutlet UILabel *genderLbl;
     IBOutlet UILabel *dobLbl;
    __weak IBOutlet UITextField *aboutField;
    __weak IBOutlet UITextField *cityField;
     IBOutlet UITextField *countryField;
    IBOutlet UIImageView *userImage;
    IBOutlet UITextField *about;
    
    IBOutlet UIButton *maleBtn;
    IBOutlet UIButton *femaleBtn;
    
     NSString *Done;
     NSString *cancel1;
     IBOutlet UIButton *takePictureBtn;
     
     IBOutlet UIButton *cancelBtn;
     IBOutlet UIButton *AvatarBtn;
     IBOutlet UIButton *CameraRollBtn;
     
    IBOutlet UIButton *cancelAvatar;
     int languageCode;
    NIDropDown *dropDown;
    
    BOOL isFile;
    
#pragma mark -------
#pragma mark Gender View
    
    IBOutlet UIView *genderView;
    IBOutlet UIView *gender_ChildView;
    
#pragma mark ---------
#pragma mark Date Picker
    
    UIView *datePickerContainer;
    UIDatePicker *_datePicker;
    
    CGPoint scrollPoint;
    BOOL isGender;
    LoadingView *_loadView;
    
    UserProfile *profile;
    
    BOOL isMale;
    BOOL isFemale;
    
    IBOutlet UIView *dobView;
    IBOutlet UIDatePicker *dobPicker;
    IBOutlet UIButton *countryBtn;
    
    IBOutlet UIView *overlayView;
    IBOutlet UIView *popUpView;
    
    NSArray *_avatarsArray;
    IBOutlet UIScrollView *AvatarsScrollView;
    IBOutlet UIView *AvatarView;
    UIImage *_AvatarImage;
    int AvatarSelectedIndex;
    LoadingView *_loadingView;
    
    IBOutlet UILabel *profileLbl;
    IBOutlet UILabel *privateInformation;
    IBOutlet UIButton *updateBtn;
    
    IBOutlet UITableView *countriesTableView;
    IBOutlet UIView *countriesView;
    NSMutableArray *countries;
    IBOutlet CountryPicker *countryPicker;
    
    IBOutlet UIImageView *ringFrame;
        
}
- (IBAction)profileImagePressed:(id)sender;
- (IBAction)MaleSelected:(id)sender;
- (IBAction)FemaleSelected:(id)sender;
- (IBAction)SelectDateOfBirth:(id)sender;

-(IBAction)Updated:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)countryPressed:(id)sender;

- (IBAction)popUpCacnelPressed:(id)sender;
- (IBAction)popUpTakePicture:(id)sender;
- (IBAction)popUpFromFilePressed:(id)sender;
- (IBAction)popUpAvatarPressed:(id)sender;
- (IBAction)AvatarCanceled:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *profileLbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@end
