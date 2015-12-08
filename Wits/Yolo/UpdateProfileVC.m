
//
//  UpdateProfileVC.m
//  Yolo
//
//  Created by Nisar Ahmad on 04/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "UpdateProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import "MKNetworkKit.h"
#import "Utils.h"
#import "SharedManager.h"
#import "UserProfile.h"
#import "UIImageView+RoundImage.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "RightBarVC.h"
#import "AsyncImageView.h"

@interface UpdateProfileVC ()

@end

@implementation UpdateProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
          // Custom initialization
     }
     return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     
     // Do any additional setup after loading the view from its nib.
     //[self setLanguage];
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     [profileScrollView setContentSize:CGSizeMake(profileScrollView.frame.size.width, profileScrollView.frame.size.height+60)];
     genderView.hidden = YES;
     isGender = NO;
     gender_ChildView.layer.cornerRadius = 8.0f;
     _loadView = [[LoadingView alloc] init];
     isFile = false;
     [self setLanguage];
     [self sendgetProfileCall];
     
}
-(void)setLanguage {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     if(languageCode == 0 ) {
          Done = @"Done";
          
          cancel1 = CANCEL;
          loadingTitle = Loading;
          profileLbl.text = @"Profile";
          _profileLbl.text = PROFILE;
          [_backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          privateInformation.text = @"PRIVATE INFORMATION";
          
          [cancelAvatar setTitle:CANCEL forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"Take Picture" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"Camera Roll" forState:UIControlStateNormal];
          [updateBtn setTitle:@"Update" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          Done = @"منجز";
          cancel1 = CANCEL_1;
          loadingTitle = Loading_1;
          _profileLbl.text = PROFILE_1;
          profileLbl.text = @"الملف الشخصي";
          privateInformation.text = @"معلومات خاصة";
          titleField.placeholder = @"اسم";
          cityField.placeholder = @"المدينة";
          about.placeholder = @"معلومات عنا ";
          
          [cancelAvatar setTitle:CANCEL_1 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_1 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"الصورة الرمزية" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"تأخذ صورة" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"الصورة الرمزية" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [updateBtn setTitle:@"تحديث" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          Done = @"Terminé";
          cancel1 = CANCEL_2;
          loadingTitle = Loading_2;
          _profileLbl.text = PROFILE_2;
          profileLbl.text = @"Profil";
          privateInformation.text = @"RENSEIGNEMENTS PERSONNELS";
          titleField.placeholder = @"nom";
          cityField.placeholder = @"Ville";
          about.placeholder = @"A propos";
          
          [cancelAvatar setTitle:CANCEL_2 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_2 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"prendre une photo" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"À partir du fichier" forState:UIControlStateNormal];
          
          [_backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [updateBtn setTitle:@"Mettre à jour" forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          Done = @"Done";
          
          cancel1 = CANCEL_3;
          loadingTitle = Loading_3;
          _profileLbl.text = PROFILE_3;
          profileLbl.text = @"Profilo";
          titleField.placeholder = @"nombre";
          privateInformation.text = @"PRIVATE INFORMO";
          cityField.placeholder = @"Ciudad";
          about.placeholder = @"Sobre ";
          
          [cancelAvatar setTitle:CANCEL_3 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_3 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"tomar foto" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"Desde archivo" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [updateBtn setTitle:@"Ĝisdatigu" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          
          Done = @"Terminé";
          cancel1 = CANCEL_4;
          loadingTitle = Loading_4;
          
          _profileLbl.text = PROFILE_4;
          profileLbl.text = @"Perfil";
          titleField.placeholder = @"nome";
          privateInformation.text = @"INFORMAÇÕES PESSOAIS";
          cityField.placeholder = @"Cidade";
          about.placeholder = @"Sobre";
          
          [cancelAvatar setTitle:CANCEL_4 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_4 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"Tirar foto" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"De Arquivo" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [updateBtn setTitle:@"Atualizar" forState:UIControlStateNormal];
          [_backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
//     if (IS_IPAD) {
//          if (languageCode == 1) {
//               UsernameIcon.frame = CGRectMake(500, 26, 40, 40);
//               nameIcon.frame = CGRectMake(500, 130, 40, 40);
//               AboutIcon.frame = CGRectMake(500, 226, 40, 40);
//               
//               countryicon.frame = CGRectMake(500, 132, 40, 40);
//               cityicon.frame = CGRectMake(500, 227, 40, 40);
//               birthdayIcon.frame = CGRectMake(500, 329, 40, 40);
//               genderIcon.frame = CGRectMake(500 , 24, 40, 40);
//               profileImgOutlet.frame = CGRectMake(10, 17, 100, 100);
//               userImage.frame = CGRectMake(10, 17, 100, 100);
//               greyLine.frame = CGRectMake(120, 100, 450, 1);
//               privateInformation.textAlignment = NSTextAlignmentRight;
//               
//               
//               nameField.textAlignment = NSTextAlignmentRight;
//               about.textAlignment = NSTextAlignmentRight ;
//               countryField.textAlignment = NSTextAlignmentRight;
//               cityField.textAlignment = NSTextAlignmentRight;
//               dobLbl.textAlignment = NSTextAlignmentRight;
//               titleField.textAlignment = NSTextAlignmentRight;
//               
//          }else{
//               UsernameIcon.frame = CGRectMake(10, 26, 40, 40);
//               nameIcon.frame = CGRectMake(10, 130, 40, 40);
//               AboutIcon.frame = CGRectMake(10, 226, 40, 40);
//               
//               countryicon.frame = CGRectMake(7, 125, 52, 53);
//               cityicon.frame = CGRectMake(7, 222, 52, 44);
//               birthdayIcon.frame = CGRectMake(10, 329, 40, 40);
//               
//               genderIcon.frame = CGRectMake(1 , 24, 64, 53);
//               greyLine.frame = CGRectMake(0,100, 450, 1);
//               
//               profileImgOutlet.frame = CGRectMake(490, 17, 100, 100);
//               
//               
//          }
//     }else{
//          if (languageCode == 1) {
//               UsernameIcon.frame = CGRectMake(260, 18, 18, 18);
//               nameIcon.frame = CGRectMake( 260 ,69, 18, 18);
//               AboutIcon.frame = CGRectMake(260, 118, 18, 18);
//               countryicon.frame = CGRectMake(260, 63, 28, 28);
//               cityicon.frame = CGRectMake(260, 115,28, 28);
//               birthdayIcon.frame = CGRectMake(270, 172, 18, 18);
//               genderIcon.frame = CGRectMake(260, 7, 28, 28);
//               profileImgOutlet.frame = CGRectMake(7, 4, 84, 84);
//               ringFrame.frame = CGRectMake(5, 3, 88, 88);
//               userImage.frame = CGRectMake(7, 4, 84, 84);
//               privateInformation.textAlignment = NSTextAlignmentRight;
//               greyLine.frame = CGRectMake(80, 52, 210, 2);
//               
//               dobLbl.text = @"عيد ميلاد";
//               dobLbl.textAlignment = NSTextAlignmentRight;
//               nameField.textAlignment = NSTextAlignmentRight;
//               about.textAlignment = NSTextAlignmentRight ;
//               countryField.textAlignment = NSTextAlignmentRight;
//               cityField.textAlignment = NSTextAlignmentRight;
//               titleField.textAlignment = NSTextAlignmentRight;
//               
//          }else{
//               UsernameIcon.frame = CGRectMake(10, 18, 18, 18);
//               nameIcon.frame = CGRectMake( 10, 69, 18, 18);
//               AboutIcon.frame = CGRectMake(10, 118, 18, 18);
//               
//               countryicon.frame = CGRectMake(3, 63, 35, 31);
//               cityicon.frame = CGRectMake(3, 115, 33, 30);
//               birthdayIcon.frame = CGRectMake(10, 172, 18, 18);
//               genderIcon.frame = CGRectMake(-1, 6, 42, 40);
//               greyLine.frame = CGRectMake(0, 52, 210, 2);
//               
//               profileImgOutlet.frame = CGRectMake(213, 4, 84, 84);
//               
//          }
//          
//     }
     UIColor *color = [UIColor whiteColor];
     nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Name" attributes:@{NSForegroundColorAttributeName: color}];
     countryField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Country" attributes:@{NSForegroundColorAttributeName: color}];
     
     about.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" About" attributes:@{NSForegroundColorAttributeName: color}];
     
     cityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" City" attributes:@{NSForegroundColorAttributeName: color}];
     
     UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, nameField.frame.size.height)];
     leftView.backgroundColor = nameField.backgroundColor;
     nameField.leftView = leftView;
     nameField.leftViewMode = UITextFieldViewModeAlways;
     
     
     UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, countryField.frame.size.height)];
     leftView1.backgroundColor = nameField.backgroundColor;
     countryField.leftView = leftView1;
     countryField.leftViewMode = UITextFieldViewModeAlways;
     
     UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, about.frame.size.height)];
     leftView2.backgroundColor = nameField.backgroundColor;
     about.leftView = leftView2;
     about.leftViewMode = UITextFieldViewModeAlways;
     
     UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, cityField.frame.size.height)];
     leftView3.backgroundColor = nameField.backgroundColor;
     cityField.leftView = leftView;
     cityField.leftViewMode = UITextFieldViewModeAlways;
     
     UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, titleField.frame.size.height)];
     leftView4.backgroundColor = nameField.backgroundColor;
     titleField.leftView = leftView4;
     titleField.leftViewMode = UITextFieldViewModeAlways;
     
}

-(void)sendgetProfileCall{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"getProfile" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     NSLog(@"%@",[SharedManager getInstance].sessionID);
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [_loadView hide];
          [_loadView removeFromSuperview];
          NSDictionary *recievedDict = [completedOperation responseJSON];
          NSNumber *flag = [recievedDict objectForKey:@"flag"];
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               //[[SharedManager getInstance]._userProfile SetValuesFromDictionary:recievedDict];
               
               profile = [[UserProfile alloc] init];
               [profile SetValuesFromDictionary:recievedDict];
               profile.totalPoints = [SharedManager getInstance]._userProfile.totalPoints;
               [self SetProfileData];
          }
     } onError:^(NSError* error) {
          
          [_loadView hide];
          [_loadView removeFromSuperview];
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Profile update problem!";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"مشكلة في تحديث الملف!";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Un problème est survenu lors de la mise à jour de votre profil!";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Ha habido un problema en actualizar su perfil!";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Problema na atualização do perfil!";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          /*  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil];
           [alert show];*/
          
     }];
     
     [_loadView showInView:self.view withTitle:loadingTitle];
     [engine enqueueOperation:op];
}

-(void)SetProfileData{
     
     UserProfile *tempUser = profile;
     
     displayName = tempUser.display_name;
     titleField.text = tempUser.display_name;;
     about.text = tempUser.about;
     cityField.text = tempUser.cityName;
     dobLbl.text = tempUser.birthday;
     countryField.text = tempUser.cur_countryName;
     
     [self setUserProfileImage];
     
     if( [tempUser.gender caseInsensitiveCompare:@"male"] == NSOrderedSame ) {
          isMale = true;
          [ maleBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
          [ femaleBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
     }
     if( [tempUser.gender caseInsensitiveCompare:@"female"] == NSOrderedSame ) {
          isFemale = true;
          [ maleBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
          [ femaleBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
     }
     
}
-(void) setUserProfileImage {
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     if(delegate.profileImage) {
          [userImage setImage:delegate.profileImage];
          //[userImage roundImageCorner];
     }
     else {
          NSString *imageStr = [SharedManager getInstance]._userProfile.profile_image;
          if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    [_loadView removeFromSuperview];
                    [userImage setImage:[completedOperation responseImage]];
                    //[userImage roundImageCorner];
                    
               } onError:^(NSError* error) {
                    
                    
                    [_loadView removeFromSuperview];
                    NSString *emailMsg;
                    NSString *title;
                    NSString *cancel;
                    if (languageCode == 0 ) {
                         emailMsg = @"Some problem occurred in processing profile Image";
                         title = @"Error";
                         cancel = CANCEL;
                    } else if(languageCode == 1) {
                         emailMsg = @"حدثت مشكلة في معالجة صورة الملف الشخصي";
                         title = @"خطأ";
                         cancel = CANCEL_1;
                    }else if (languageCode == 2){
                         emailMsg = @"Un problème est survenu lors du traitement de votre image de profil.";
                         title = @"Erreur";
                         cancel = CANCEL_2;
                    }else if (languageCode == 3){
                         emailMsg = @"Ha habido un problema en ingresar la imagen del perfil ";
                         title = @"Error";
                         cancel = CANCEL_3;
                    }else if (languageCode == 4){
                         emailMsg = @"Alguns problemas ocorreram no processamento da imagem";
                         title = @"Erro";
                         cancel = CANCEL_4;
                    }
                    
                    [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                    
                    /*
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil];
                     [alert show];*/
                    
               }];
               
               [engine enqueueOperation:op];
          }
     }
}
#pragma mark -----------
#pragma mark Gender
- (IBAction)profileImagePressed:(id)sender {
     overlayView.hidden = NO;
     popUpView.hidden = NO;
}

- (IBAction)SelectGender:(id)sender {
     
     [self DissmissKeyBoard];
     
     if (isGender){
          genderView.hidden = YES;
          isGender = NO;
     }
     else{
          genderView.hidden = NO;
          isGender = YES;
     }
}
- (IBAction)MaleSelected:(id)sender {
     if(isMale) {
          isMale = false;
          isFemale = true;
          
          [maleBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
          [femaleBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
     }
     else {
          isMale = true;
          isFemale = false;
          
          [maleBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
          [femaleBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
     }
}
- (IBAction)FemaleSelected:(id)sender {
     if(isFemale) {
          isMale = true;
          isFemale = false;
          
          [maleBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
          [femaleBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
     }
     else {
          isMale = false;
          isFemale = true;
          
          [maleBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
          [femaleBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
     }
     
}
#pragma mark ---------------
#pragma mark Date Of Birth
- (IBAction)SelectDateOfBirth:(id)sender {
     [self.view endEditing:YES];
     dobPicker.hidden = NO;
     dobView.hidden = NO;
     overlayView.hidden = false;
     
     [dobPicker setMaximumDate:[self getCurrentDate]];
     UIButton *DateSelected = [UIButton buttonWithType:UIButtonTypeCustom];
     [DateSelected setFrame:CGRectMake(50, 350, 85, 30)];
     if(IS_IPAD) {
        //  [DateSelected setFrame:CGRectMake(dobVi\0ew.frame.origin.x-60, dobView.frame.size.height-50, 120, 35)];
          [DateSelected setFrame:CGRectMake(220, 620, 140, 50)];
     }
     [DateSelected setBackgroundImage:[UIImage imageNamed:@"messagebg.png"] forState:UIControlStateNormal];
     [DateSelected setTitle:Done forState:UIControlStateNormal];
     [DateSelected.titleLabel setFont:[UIFont systemFontOfSize:12]];
     [DateSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [DateSelected addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
     [dobView addSubview:DateSelected];
     
     UIButton *CancelSelected = [UIButton buttonWithType:UIButtonTypeCustom];
     [CancelSelected setFrame:CGRectMake(DateSelected.frame.origin.x+DateSelected.frame.size.width+55, DateSelected.frame.origin.y, 85, 30)];
     if(IS_IPAD) {
        //  [CancelSelected setFrame:CGRectMake(DateSelected.frame.origin.x+DateSelected.frame.size.width+30, DateSelected.frame.origin.y, 120, 35)];
         [CancelSelected setFrame:CGRectMake(420, 620, 140, 50)];

     }
     [CancelSelected setBackgroundImage:[UIImage imageNamed:@"messagebg.png"] forState:UIControlStateNormal];
     [CancelSelected setTitle:cancel1 forState:UIControlStateNormal];
     [CancelSelected.titleLabel setFont:[UIFont systemFontOfSize:12]];
     [CancelSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [CancelSelected addTarget:self action:@selector(dateSelectionCancelled:) forControlEvents:UIControlEventTouchUpInside];
     [dobView addSubview:CancelSelected];
}
-(void)dateSelectionCancelled:(id)sender{
     dobPicker.hidden = true;
     dobView.hidden = true;
     
     overlayView.hidden = true;
}
-(void)dateSelected:(id)sender{
     
     /// IGNORING TIME COMPONENT
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     NSDate *dateInOldFormat = [dobPicker date];
     unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
     NSCalendar* calendar = [NSCalendar currentCalendar];
     NSDateComponents* components = [calendar components:flags fromDate:dateInOldFormat];
     NSDate* dateOnly = [calendar dateFromComponents:components];
     
     /// CHANGING FORMAT
     
     NSString *_outputFormat = @"dd-MM-YYYY";
     //[dateFormatter setDateFormat:@"YYYY-M-d"];
     [dateFormatter setDateFormat:_outputFormat];
     
     NSString *dateInNewFormat = [dateFormatter stringFromDate:dateOnly];
     [dobLbl setText:dateInNewFormat];
     dobPicker.hidden = true;
     dobView.hidden = true;
     overlayView.hidden = true;
}
-(void)countrySelected:(id)sender{
     overlayView.hidden = true;
     countriesView.hidden = true;
     countryPicker.hidden = true;
     
     
}
-(void)countrySelectionCancelled:(id)sender{
     countriesView.hidden = true;
     countryPicker.hidden = true;
     
     overlayView.hidden = true;
}

-(NSDate *)getCurrentDate{
     
     /*   NSString *_outputFormat = @"dd-MM-YYYY";
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:_outputFormat];*/
     
     return [NSDate date];
     // return [dateFormatter dateFromString:dobLbl.text];;
}

#pragma mark -
-(IBAction)Updated:(id)sender{
     
     [self DissmissKeyBoard];
     [_loadView showInView:self.view withTitle:loadingTitle];
     
     int countryId = 0;
     for(int i=0; i<profile.countries.count; i++) {
          NSString *country = (NSString*)[profile.countries objectAtIndex:i];
          if( [country caseInsensitiveCompare:countryBtn.titleLabel.text] == NSOrderedSame ) {
               countryId = i+1;
               break;
          }
     }
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"updateProfile" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:countryField.text forKey:@"country"];
     [postParams setObject:cityField.text forKey:@"city"];
     
     [postParams setObject:displayName forKey:@"display_name"];
     [postParams setObject:dobLbl.text forKey:@"birthday"];
     [postParams setObject:profile.usernameID forKey:@"user_name_id"];
     [postParams setObject:about.text forKey:@"about"];
     
     NSString *gender = @"";
     if(isMale ) {
          gender = @"male";
     }
     if(isFemale) {
          gender = @"female";
     }
     
     NSString *isFileStr = @"";
     if(isFile ) {
          isFileStr = @"true";
     }
     else {
          isFileStr = @"false";
          [postParams setObject:[SharedManager getInstance]._userProfile.profile_image forKey:@"profile_image"];
     }
     
     [postParams setObject:gender forKey:@"gender"];
     [postParams setObject:isFileStr forKey:@"is_file"];
     
     NSData *imageData = UIImageJPEGRepresentation(userImage.image, 0.0);
     
     MKNetworkOperation *oper = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     if(isFile) {
          [oper addData:imageData forKey:@"profile_image" mimeType:@"image/png" fileName:@"upload1.png"];
     }
     [oper onCompletion:^(MKNetworkOperation *compOper){
          
          [_loadView hide];
          NSDictionary *mainDict = [compOper responseJSON];
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               [self sendgetProfileCall];
               
               NSString *imageUrl = profile.profile_image;
               
               //[SharedManager getInstance]._userProfile = profile;
               
               [SharedManager getInstance]._userProfile.profile_image = imageUrl;
               [SharedManager getInstance]._userProfile.display_name = displayName;
               [SharedManager getInstance]._userProfile.usernameID = profile.usernameID;
               [SharedManager getInstance]._userProfile.about = about.text;
               [SharedManager getInstance]._userProfile.cityName = cityField.text;
               [SharedManager getInstance]._userProfile.birthday = dobLbl.text;
               [SharedManager getInstance]._userProfile.cur_countryName = countryField.text;
               
               [self removeImage:@"test"];
               
               AppDelegate *delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
               
               delegate.profileImage = userImage.image;
               
               [self saveImage:delegate.profileImage];
               
               [RightBarVC getInstance].profileImageView.image = delegate.profileImage;
               
               [self.navigationController popToRootViewControllerAnimated:YES];
          }
          
     }onError:^(NSError *error){
          
          [_loadView hide];
          
          
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          /*
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
           
           [alert show];*/
          
     }];
     
     [engine enqueueOperation:oper];
}


- (IBAction)backPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}
-(void)rel{
     dropDown = nil;
}
- (IBAction)countryPressed:(id)sender {
     
     /*NSArray *countries = [profile.countries copy];
      
      NSArray * arr = [[NSArray alloc] init];
      arr = countries;
      NSArray * arrImage = [[NSArray alloc] init];
      arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@""], [UIImage imageNamed:@""], nil];
      if(dropDown == nil) {
      CGFloat f = profile.countries.count*40;
      dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down":true];
      dropDown.delegate = self;
      }
      else {
      [dropDown hideDropDown:sender];
      [self rel];
      }*/
     [self.view endEditing:YES];
     overlayView.hidden = false;
     countriesView.hidden = false;
     countryPicker.hidden = false;
     UIButton *DateSelected = [UIButton buttonWithType:UIButtonTypeCustom];
     [DateSelected setFrame:CGRectMake(_datePicker.frame.origin.x+40, countryPicker.frame.origin.y+countryPicker.frame.size.height, 85, 25)];
     if(IS_IPAD) {
          [DateSelected setFrame:CGRectMake(220, 620, 140, 50)];
     }
     [DateSelected setBackgroundImage:[UIImage imageNamed:@"messagebg.png"] forState:UIControlStateNormal];
     [DateSelected setTitle:Done forState:UIControlStateNormal];
     [DateSelected.titleLabel setFont:[UIFont systemFontOfSize:12]];
     [DateSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [DateSelected addTarget:self action:@selector(countrySelected:) forControlEvents:UIControlEventTouchUpInside];
     [countriesView addSubview:DateSelected];
     
     UIButton *CancelSelected = [UIButton buttonWithType:UIButtonTypeCustom];
     [CancelSelected setFrame:CGRectMake(DateSelected.frame.origin.x+DateSelected.frame.size.width+70, DateSelected.frame.origin.y, 86, 25)];
     if(IS_IPAD) {
         [CancelSelected setFrame:CGRectMake(420, 620, 140, 50)];
     }
     [CancelSelected setBackgroundImage:[UIImage imageNamed:@"messagebg.png"] forState:UIControlStateNormal];
     [CancelSelected setTitle:cancel1 forState:UIControlStateNormal];
     [CancelSelected.titleLabel setFont:[UIFont systemFontOfSize:12]];
     [CancelSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [CancelSelected addTarget:self action:@selector(countrySelectionCancelled:) forControlEvents:UIControlEventTouchUpInside];
     [countriesView addSubview:CancelSelected];
     
}
#pragma mark countries picker delegate
- (void)countryPicker:(__unused CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
     countryField.text = name;
}
- (IBAction)popUpCacnelPressed:(id)sender {
     overlayView.hidden = YES;
     popUpView.hidden = YES;
}

- (IBAction)popUpTakePicture:(id)sender {
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     
     [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)popUpFromFilePressed:(id)sender {
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     
     [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     
     UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     userImage.image = chosenImage;
     isFile = true;
     popUpView.hidden = true;
     overlayView.hidden = true;
     [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)popUpAvatarPressed:(id)sender {
     
     [_loadingView hide];
     [_loadView removeFromSuperview];
     //_loadingView = [[LoadingView alloc] init];
     //[_loadingView showInView:self.view withTitle:loadingTitle];
     [self showAvatars];
}

- (IBAction)AvatarCanceled:(id)sender {
     overlayView.hidden = YES;
     popUpView.hidden = YES;
     AvatarView.hidden = YES;
     
}

-(void)DissmissKeyBoard{
     
     [nameField resignFirstResponder];
     [titleField resignFirstResponder];
     [aboutField resignFirstResponder];
     [cityField resignFirstResponder];
     [countryField resignFirstResponder];
}

#pragma mark -------------
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
     
     scrollPoint = profileScrollView.contentOffset;
     CGPoint pt;
     CGRect rc = [textField bounds];
     rc = [textField convertRect:rc toView:profileScrollView];
     pt = rc.origin;
     pt.x = 0;
     pt.y -= 50;
     [profileScrollView setContentOffset:pt animated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
     
     [textField resignFirstResponder];
     [profileScrollView setContentOffset:scrollPoint animated:YES];
     
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     
     [textField resignFirstResponder];
     return YES;
}

- (void)didReceiveMemoryWarning
{
     
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
     [self rel];
}


-(void)showAvatars{
     
     
     if([_avatarsArray count] > 0)
     {
          [self downloadAvatars];
          return;
     }
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"userGetAvatars" forKey:@"method"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [_loadView hide];
          [_loadView removeFromSuperview];
          NSLog(@"Response: %@",[completedOperation responseString]);
          NSDictionary *recievedDict = [completedOperation responseJSON];
          NSNumber *flag = [recievedDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:1]])
          {
               _avatarsArray = [recievedDict objectForKey:@"avatars"];
               [self downloadAvatars];
          }
          
          
     } onError:^(NSError* error) {
          
          [_loadView hide];
          [_loadView removeFromSuperview];
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }];
     
     
     [engine enqueueOperation:op];
     
}
-(void)downloadAvatars{
     
     for (NSString *avatarURL in _avatarsArray) {
          
          NSURL *_avatarURL = [NSURL URLWithString:avatarURL];
          BOOL isPresent = [self checkThisFileIndocs:_avatarURL.lastPathComponent];
          
          if(!isPresent)
          {
               [self DownloadAvatarCall:avatarURL withFileName:_avatarURL.lastPathComponent];
               return;
          }
          
     }
     [_loadView hide];
     [_loadView removeFromSuperview];
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          [self loadAvatarsToIpadView];
     else
          [self LoadAvatars];
     
     
     [self.view addSubview:AvatarView];
}




-(void)DownloadAvatarCall:(NSString *)avatarURL withFileName:(NSString *)fileName{
     
     BOOL isDir;
     if(![[NSFileManager defaultManager] fileExistsAtPath:docs isDirectory:&isDir])
     {
          NSLog(@"NO file exists at path.");
          
          if(![[NSFileManager defaultManager] createDirectoryAtPath:docs withIntermediateDirectories:YES attributes:nil error:nil]){
               NSLog(@"Error while crate folder.");
          }
          else
               NSLog(@"Directory Created.");
          
     }
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     MKNetworkOperation *op = [engine operationWithURLString:avatarURL params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [_loadingView hide];
          [_loadingView removeFromSuperview];
          NSString *imagePath = [docs stringByAppendingPathComponent:fileName];
          
          NSLog(@"Image Path: %@",imagePath);
          
          UIImage *image = [completedOperation responseImage];
          NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
          [imageData writeToFile:imagePath atomically:NO];
          
          [self downloadAvatars];
          
     }onError:^(NSError* error) {
          
          [_loadingView hide];
          [_loadingView removeFromSuperview];
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Unable to fetch Avatars";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"غير قادر على جلب الصور الرمزية";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Impossible de trouver l'avatar";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"No se pudo encontrar avatars";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Incapaz de buscar avatares";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:@"Unable to Show Avatar" SingleBtn:YES cancelButton:cancel OtherButton:nil];
          /*
           
           UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to Show Avatar" message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil];
           [alert show];*/
          
          
     }];
     [engine enqueueOperation:op];
     
}


-(void)LoadAvatars{
     
     
     ////////////    Add cover image here  ///////////
     
     float interElementDistance_X = 6.0;
     float interElementDistance_Y = 6.0;
     
     float Width = 151.0;
     float Height = 151.0;
     
     float Initial_X = interElementDistance_X;
     
     float x_Position = Initial_X ;
     float y_Position = 6.0;
     
     int rowChange = 2;
     
     for (int k=0; k<[_avatarsArray count]; k++) {
          
          if((k % rowChange == 0) && k != 0)
          {
               x_Position = Initial_X;
               y_Position += Height + interElementDistance_Y;
          }
          else if(k != 0){
               
               x_Position = (interElementDistance_X * 2) + Width;
          }
          
          NSString *avatarURL = [_avatarsArray objectAtIndex:k];
          NSURL *imageURL = [NSURL URLWithString:avatarURL];
          
          AsyncImageView *asyncImg = [[AsyncImageView alloc] init];
          
          NSString *ImagePath = [docs stringByAppendingPathComponent:imageURL.lastPathComponent];
          
          NSLog(@"Complete Path: %@",ImagePath);
          
          asyncImg.imageURL = [NSURL URLWithString:[_avatarsArray objectAtIndex:k]];
          NSURL *url = [NSURL URLWithString:[_avatarsArray objectAtIndex:k]];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
          
          
          UIImage *avatarImage = [UIImage imageWithContentsOfFile:ImagePath];
          
          UIButton *avatarSelectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          [avatarSelectionBtn setFrame:CGRectMake(x_Position, y_Position, Width, Height)];
          [avatarSelectionBtn setImage:avatarImage forState:UIControlStateNormal];
          [avatarSelectionBtn addTarget:self action:@selector(AvatarSelected:) forControlEvents:UIControlEventTouchUpInside];
          [avatarSelectionBtn setTag:k];
          [AvatarsScrollView addSubview:avatarSelectionBtn];
     }
     [AvatarsScrollView setContentSize:CGSizeMake(AvatarsScrollView.frame.size.width, AvatarsScrollView.frame.size.height+60)];

}
-(void)loadAvatarsToIpadView{
     ////////////    Add cover image here  ///////////
     
     float xPosition = 20.0f;
     float yPosition = 20.0f;
     
     float Width = 222.0f;
     float Height = 227.0f;
     
     float verticalSpace = 31.0f;
     float horizentalSpace = 31.0f;
     
     
     int rowChange = 3;
     
     for (int k=0; k<[_avatarsArray count];) {
          
          NSString *avatarURL = [_avatarsArray objectAtIndex:k];
          NSURL *imageURL = [NSURL URLWithString:avatarURL];
          
          
          NSString *ImagePath = [docs stringByAppendingPathComponent:imageURL.lastPathComponent];
          
          NSLog(@"Complete Path: %@",ImagePath);
          
          
          UIImage *avatarImage = [UIImage imageWithContentsOfFile:ImagePath];
          
          UIButton *avatarSelectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          [avatarSelectionBtn setFrame:CGRectMake(xPosition, yPosition, Width, Height)];
          [avatarSelectionBtn setBackgroundImage:avatarImage forState:UIControlStateNormal];
          [avatarSelectionBtn addTarget:self action:@selector(AvatarSelected:) forControlEvents:UIControlEventTouchUpInside];
          [avatarSelectionBtn setTag:k];
          [AvatarsScrollView addSubview:avatarSelectionBtn];
          
          
          k++;
          if(k % rowChange == 0)
          {
               xPosition = 20.0f;
               yPosition = yPosition + Height + verticalSpace;
          }
          else{
               yPosition = yPosition;
               xPosition = xPosition + Width + horizentalSpace;
          }
     }
     
     [AvatarsScrollView setContentSize:CGSizeMake(AvatarsScrollView.frame.size.width, AvatarsScrollView.frame.size.height+60)];

     
}

-(void)AvatarSelected:(id)sender{
     
     
     [_loadView showInView:self.view  withTitle:loadingTitle];
     UIButton *btn = (UIButton *)sender;
     AvatarSelectedIndex = btn.tag;
     NSString *avatarURL = [_avatarsArray objectAtIndex:btn.tag];
     NSURL *imageURL = [NSURL URLWithString:avatarURL];
     NSString *ImagePath = [docs stringByAppendingPathComponent:imageURL.lastPathComponent];
     
     _AvatarImage = [UIImage imageWithContentsOfFile:ImagePath];
     
     userImage.image = _AvatarImage;
     isFile = true;
     popUpView.hidden = true;
     overlayView.hidden = true;
     
     [AvatarView removeFromSuperview];
     
}
-(BOOL)checkThisFileIndocs:(NSString *)fileName{
     
     NSString *filePath = [docs stringByAppendingPathComponent:fileName];
     
     
     if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
          return true;
     
     return false;
}

- (void)saveImage: (UIImage*)image
{
     if (image != nil)
     {
          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES);
          NSString *documentsDirectory = [paths objectAtIndex:0];
          NSString* path = [documentsDirectory stringByAppendingPathComponent:
                            @"test.png" ];
          NSData* data = UIImagePNGRepresentation(image);
          [data writeToFile:path atomically:YES];
     }
}

- (UIImage*)loadImage
{
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString* path = [documentsDirectory stringByAppendingPathComponent:
                       @"test.png" ];
     UIImage* image = [UIImage imageWithContentsOfFile:path];
     return image;
}

- (void)removeImage:(NSString*)fileName {
     
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"%@.png", fileName]];
     
     NSError *error = nil;
     if(![fileManager removeItemAtPath:fullPath error:&error]) {
          NSLog(@"Delete failed:%@", error);
     } else {
          NSLog(@"image removed: %@", fullPath);
     }
     
}



@end
