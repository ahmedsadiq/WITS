//
//  SignUpVC.h
//  Yolo
//
//  Created by Salman Khalid on 13/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "Utils.h"
#import "GetTopicsVC.h"

@interface SignUpVC : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>{
     
     UIScrollView *_scrollView;
     UIDatePicker *_datePicker;
     UIView *datePickerContainer;
     UIView *firstView;
     UIView *secondView;
     NSString *language;
     int languageCode;
     NSString * LoadingTitle;
     NSString *cancel1;
     NSString *Done;
     NSString *errorMessageFromServer;
     IBOutlet UIButton *takePictureBtn;
     BOOL  isEditPressed;
     BOOL DontSwipe;
     __weak IBOutlet UILabel *signinLabel;
     IBOutlet UIButton *cancelAvatar;
     IBOutlet UIButton *cancelBtn;
     IBOutlet UIButton *AvatarBtn;
     IBOutlet UIButton *CameraRollBtn;
     
     UIButton *dismissBtn;
     IBOutlet UITextField *emailField;
     IBOutlet UITextField *displayNameField;
     IBOutlet UITextField *passwordField;
     IBOutlet UILabel *birthdaylbl;
     IBOutlet UITextField *usernameLbl;
     
     LoadingView *_loadingView;
     
     IBOutlet UIView *profileImageView;
     IBOutlet UIImageView *_profileImage;
     
     IBOutlet UIView *profileImageView1;
     IBOutlet UIImageView *_profileImage1;
     
     NSArray *_avatarsArray;
     IBOutlet UIScrollView *AvatarsScrollView;
     IBOutlet UIView *AvatarView;
     UIActionSheet *AvtarsActionSheet;
     UIImage *_AvatarImage;
     int AvatarSelectedIndex;
     IBOutlet UIView *containerView;
     
     ProfileImageType _profileImageType;
     
     IBOutlet UILabel *signUplbl;
     IBOutlet UIScrollView *profileScrollView;
     CGPoint scrollPoint;
     IBOutlet UILabel *signUpDescLbl;
     IBOutlet UIButton *registerBtn;
     
     IBOutlet UIButton *backBtn;
     IBOutlet UIButton *editBtn;
     IBOutlet UIView *overlayView;
     IBOutlet UIView *popUpView;
     
}

@property ( strong , nonatomic ) UITabBarController *tabBarController;
@property (strong, nonatomic) GetTopicsVC *viewController;
@property ( strong , nonatomic ) UINavigationController *navController;


@property(nonatomic, retain) IBOutlet UIScrollView *_scrollView;
@property(nonatomic, retain) IBOutlet UIView *firstView;
@property(nonatomic, retain) IBOutlet UIView *secondView;

-(IBAction)datePickerClicked:(id)sender;
-(IBAction)birthdayReasonAction:(id)sender;
-(IBAction)SwitchToSecondView:(id)sender;
-(IBAction)locationReasonAction:(id)sender;
-(IBAction)SendSignupCall:(id)sender;
-(IBAction)SwitchToFirstView:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)CancelAvatarSheet:(id)sender;

-(BOOL)validateEmail:(NSString *)candidate;
-(NSDate *)getCurrentDate;

-(IBAction)EditProfileImage:(id)sender;
-(void)setProfileImage:(UIImage *)_image;

- (IBAction)popUpCacnelPressed:(id)sender;
- (IBAction)popUpTakePicture:(id)sender;
- (IBAction)popUpFromFilePressed:(id)sender;
- (IBAction)popUpAvatarPressed:(id)sender;

@end
