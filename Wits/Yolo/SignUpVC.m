//
//  SignUpVC.m
//  Yolo
//
//  Created by Salman Khalid on 13/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "SignUpVC.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "NavigationHandler.h"
#import "AlertMessage.h"
#import "RewardsListVC.h"
#import "FriendsVC.h"
#import "StoreVC.h"
#import "EarnFreePointsViewController.h"
#import "SettingVC.h"
#import "RightBarVC.h"


@interface SignUpVC ()

@end

@implementation SignUpVC

@synthesize _scrollView, secondView, firstView;

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
     [self setLanguage];
     _loadingView = [[LoadingView alloc] init];
     
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     //[self loadProfileImage];
     _profileImageType = FromAvatar;
     AvatarSelectedIndex = 0;
     DontSwipe = false;
     profileScrollView.contentSize = CGSizeMake(320, 510);
     
     UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
     leftView.backgroundColor = [UIColor clearColor];
     
     emailField.leftViewMode = UITextFieldViewModeAlways;
     emailField.leftView = leftView;
     
     UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
     leftView1.backgroundColor = [UIColor clearColor];
     displayNameField.leftViewMode = UITextFieldViewModeAlways;
     displayNameField.leftView = leftView1;
     
     UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
     leftView2.backgroundColor = [UIColor clearColor];
     usernameLbl.leftViewMode = UITextFieldViewModeAlways;
     usernameLbl.leftView = leftView2;
     
     UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
     leftView3.backgroundColor = [UIColor clearColor];
     passwordField.leftViewMode = UITextFieldViewModeAlways;
     passwordField.leftView = leftView3;
     isEditPressed = NO;
     
     if(IS_IPAD)
     {
          displayNameField.font = [UIFont fontWithName:FONT_NAME size:25];
          emailField.font = [UIFont fontWithName:FONT_NAME  size:25];
          usernameLbl.font = [UIFont fontWithName:FONT_NAME size:25];
          passwordField.font = [UIFont fontWithName:FONT_NAME  size:25];
          registerBtn.font = [UIFont fontWithName:FONT_NAME size:27];
          signinLabel.font = [UIFont fontWithName:FONT_NAME size:25];
     }else
     {
          displayNameField.font = [UIFont fontWithName:FONT_NAME size:15];
          emailField.font = [UIFont fontWithName:FONT_NAME  size:15];
          usernameLbl.font = [UIFont fontWithName:FONT_NAME size:15];
          passwordField.font = [UIFont fontWithName:FONT_NAME  size:15];
          registerBtn.font = [UIFont fontWithName:FONT_NAME size:17];
          signinLabel.font = [UIFont fontWithName:FONT_NAME size:15];
     }
  
     UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(signUpSwipeDown:)];
     [left setDirection:UISwipeGestureRecognizerDirectionDown];
     [self.view addGestureRecognizer:left];
     
}

- (void)signUpSwipeDown:(UISwipeGestureRecognizer *)gesture
{
     if(!DontSwipe){
     int numViewControllers = self.navigationController.viewControllers.count;
     UIView *nextView = [[self.navigationController.viewControllers objectAtIndex:numViewControllers - 2] view];
     
     [UIView transitionFromView:self.navigationController.topViewController.view toView:nextView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
          [self.navigationController popViewControllerAnimated:NO];
     }];
     }
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:true];
     
     
     //     for (NSString* family in [UIFont familyNames])
     //     {
     //          NSLog(@"%@", family);
     //
     //          for (NSString* name in [UIFont fontNamesForFamilyName: family])
     //          {
     //               NSLog(@"  %@", name);
     //          }
     //     }
     
}


-(void) setLanguage {
     
     UIColor *color = [UIColor whiteColor];
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     if(languageCode == 0 ) {
          
          
          LoadingTitle = Loading;
          cancel1 = CANCEL;
         // emailField.placeholder = @"Email";
         // displayNameField.placeholder = @"Display Name";
          //passwordField.placeholder = @"Password";
          birthdaylbl.text = @" BIRTHDAY";
          //usernameLbl.placeholder = @"Username";
          signUpDescLbl.text = SIGNUP_DESC;
          signUplbl.text = @"Sign Up";
          Done = @"Done";
          signinLabel.text = SIGIN_TEXT;
          emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
          displayNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Display Name" attributes:@{NSForegroundColorAttributeName: color}];
          usernameLbl.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
          passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
          
          [cancelBtn setTitle:CANCEL forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"Take Picture" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"Camera Roll" forState:UIControlStateNormal];
          [cancelAvatar setTitle:CANCEL forState:UIControlStateNormal];
          [editBtn setTitle:EDIT forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          [registerBtn setTitle:SIGNUP_REGISTER forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          LoadingTitle = Loading_1;
          cancel1 = CANCEL_1;
          Done = @"منجز";
          passwordField.placeholder = SIGNUP_PASSWORD_1;
          birthdaylbl.text = SIGNUP_BIRTHDAY_1;
          signUplbl.text = @"اشترك";
          
          signinLabel.text = SIGIN_TEXT_1;
          emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_EMAIL_1 attributes:@{NSForegroundColorAttributeName: color}];
          displayNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_DISPLAY_NAME_1 attributes:@{NSForegroundColorAttributeName: color}];
          usernameLbl.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_USERNAME_1 attributes:@{NSForegroundColorAttributeName: color}];
          passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_1 attributes:@{NSForegroundColorAttributeName: color}];
          
          [cancelBtn setTitle:CANCEL_1 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"الصورة الرمزية" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"تأخذ صورة" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"الصورة الرمزية" forState:UIControlStateNormal];
          [cancelAvatar setTitle:CANCEL_1 forState:UIControlStateNormal];
          [editBtn setTitle:EDIT_1 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [registerBtn setTitle:SIGNUP_REGISTER_1 forState:UIControlStateNormal];
          
          emailField.textAlignment = NSTextAlignmentRight;
          displayNameField.textAlignment = NSTextAlignmentRight;
          passwordField.textAlignment = NSTextAlignmentRight;
          usernameLbl.textAlignment = NSTextAlignmentRight;
          signUpDescLbl.textAlignment = NSTextAlignmentRight;
          birthdaylbl.textAlignment = NSTextAlignmentRight;
          
     }
     else if(languageCode == 2) {
          LoadingTitle = Loading_2;
          cancel1 = CANCEL_2;
          signinLabel.text = SIGIN_TEXT_2;
          Done = @"Terminé";
          birthdaylbl.text = SIGNUP_BIRTHDAY_2;
          signUpDescLbl.text = SIGNUP_DESC_2;
          signUplbl.text = @"signer";
          
          emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_EMAIL_2 attributes:@{NSForegroundColorAttributeName: color}];
          displayNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_DISPLAY_NAME_2 attributes:@{NSForegroundColorAttributeName: color}];
          usernameLbl.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_USERNAME_2 attributes:@{NSForegroundColorAttributeName: color}];
          passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_2 attributes:@{NSForegroundColorAttributeName: color}];
          
          [cancelAvatar setTitle:CANCEL_2 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_2 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"prendre une photo" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"À partir du fichier" forState:UIControlStateNormal];
          [editBtn setTitle:EDIT_2 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [registerBtn setTitle:SIGNUP_REGISTER_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          cancel1 = CANCEL_3;
          Done = @"Done";
          signinLabel.text = SIGIN_TEXT_3;
          LoadingTitle = Loading_3;
          emailField.placeholder = SIGNUP_EMAIL_3;
          displayNameField.placeholder = SIGNUP_DISPLAY_NAME_3;
          passwordField.placeholder = SIGNUP_PASSWORD_3;
          birthdaylbl.text = SIGNUP_BIRTHDAY_3;
          usernameLbl.placeholder = SIGNUP_USERNAME_3;
          signUpDescLbl.text = SIGNUP_DESC_3;
          signUplbl.text = @"contratar";
          
          emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_EMAIL_3 attributes:@{NSForegroundColorAttributeName: color}];
          displayNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_DISPLAY_NAME_3 attributes:@{NSForegroundColorAttributeName: color}];
          usernameLbl.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_USERNAME_3 attributes:@{NSForegroundColorAttributeName: color}];
          passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_3 attributes:@{NSForegroundColorAttributeName: color}];
          
          [cancelAvatar setTitle:CANCEL_3 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_3 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"tomar foto" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"Desde archivo" forState:UIControlStateNormal];
          [editBtn setTitle:EDIT_3 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [registerBtn setTitle:SIGNUP_REGISTER_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          cancel1 = CANCEL_4;
          Done = @"Terminé";
          LoadingTitle = Loading_4;
          emailField.placeholder = SIGNUP_EMAIL_4;
          displayNameField.placeholder = SIGNUP_DISPLAY_NAME_4;
          signinLabel.text = SIGIN_TEXT_4;
          passwordField.placeholder = SIGNUP_PASSWORD_4;
          birthdaylbl.text = SIGNUP_BIRTHDAY_4;
          usernameLbl.placeholder = SIGNUP_USERNAME_4;
          signUpDescLbl.text = SIGNUP_DESC_4;
          signUplbl.text = @"inscrever-se";
          
          emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_EMAIL_4 attributes:@{NSForegroundColorAttributeName: color}];
          displayNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_DISPLAY_NAME_4 attributes:@{NSForegroundColorAttributeName: color}];
          usernameLbl.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_USERNAME_4 attributes:@{NSForegroundColorAttributeName: color}];
          passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_4 attributes:@{NSForegroundColorAttributeName: color}];
          
          [cancelAvatar setTitle:CANCEL_4 forState:UIControlStateNormal];
          [cancelBtn setTitle:CANCEL_4 forState:UIControlStateNormal];
          [AvatarBtn setTitle:@"Avatar" forState:UIControlStateNormal];
          [takePictureBtn setTitle:@"Tirar foto" forState:UIControlStateNormal];
          [CameraRollBtn setTitle:@"De Arquivo" forState:UIControlStateNormal];
          [editBtn setTitle:EDIT_4 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [registerBtn setTitle:SIGNUP_REGISTER_4 forState:UIControlStateNormal];
     }
}
-(void)loadProfileImage{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     MKNetworkOperation *op = [engine operationWithURLString:@"http://www.quizapplication.faditekdev.com/api/images/1.jpg" params:Nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          UIImage *profileImage = [UIImage imageWithData:[completedOperation responseData]];
          [self setProfileImage:profileImage];
          
     } onError:^(NSError* error) {
          
          /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to Sign Up" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alert show];*/
          
          
     }];
     [engine enqueueOperation:op];
}

-(IBAction)datePickerClicked:(id)sender{
     
     [self.view endEditing:YES];
     
     _datePicker = [[UIDatePicker alloc] init];
     if(![birthdaylbl.text isEqualToString:@"Birthday"])
     {
          [_datePicker setDate:[self getCurrentDate]];
          [_datePicker setMaximumDate:[self getCurrentDate]];
     }
     [_datePicker setDatePickerMode:UIDatePickerModeDate];
     // [_datePicker setCenter:CGPointMake(self.view.frame.size.width/2, _datePicker.frame.size.height/2)];
     [_datePicker setCenter:self.view.center];
     datePickerContainer = [[UIView alloc] initWithFrame:self.view.frame];
     [datePickerContainer setBackgroundColor:[UIColor clearColor]];
     
     UIView *tempview1 = [[UIView alloc] initWithFrame:datePickerContainer.frame];
     [tempview1 setBackgroundColor:[UIColor grayColor]];
     [tempview1 setAlpha:0.8];
     [datePickerContainer addSubview:tempview1];
     
     UIView *tempview = [[UIView alloc] initWithFrame:CGRectMake(_datePicker.frame.origin.x, _datePicker.frame.origin.y, _datePicker.frame.size.width, _datePicker.frame.size.height+70)];
     [tempview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dialogbg.png"]]];
     [tempview setAlpha:0.9];
     [datePickerContainer addSubview:tempview];
     
     [datePickerContainer addSubview:_datePicker];
     [self.view addSubview:datePickerContainer];
     
     UIButton *DateSelected = [UIButton buttonWithType:UIButtonTypeCustom];
     [DateSelected setFrame:CGRectMake(_datePicker.frame.origin.x+40, _datePicker.frame.origin.y+_datePicker.frame.size.height+10, 85, 30)];
     [DateSelected setBackgroundImage:[UIImage imageNamed:@"messagebg.png"] forState:UIControlStateNormal];
     [DateSelected setTitle:Done forState:UIControlStateNormal];
     //     DateSelected.titleLabel.font = [UIFont fontWithName:@"System" size:12];
     DateSelected.titleLabel.font = [UIFont fontWithName:FONT_NAME size:12];
     [DateSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [DateSelected addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
     [datePickerContainer addSubview:DateSelected];
     
     UIButton *CancelSelected = [UIButton buttonWithType:UIButtonTypeCustom];
     [CancelSelected setFrame:CGRectMake(DateSelected.frame.origin.x+DateSelected.frame.size.width+70, DateSelected.frame.origin.y, 85, 30)];
     [CancelSelected setBackgroundImage:[UIImage imageNamed:@"messagebg.png"] forState:UIControlStateNormal];
     [CancelSelected setTitle:cancel1 forState:UIControlStateNormal];
     [CancelSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [CancelSelected addTarget:self action:@selector(dateSelectionCancelled:) forControlEvents:UIControlEventTouchUpInside];
     [datePickerContainer addSubview:CancelSelected];
     
}

-(void)dateSelectionCancelled:(id)sender{
     
     [datePickerContainer removeFromSuperview];
     
}

-(void)dateSelected:(id)sender{
     
     [datePickerContainer removeFromSuperview];
     
     /// IGNORING TIME COMPONENT
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     
     NSDate *dateInOldFormat = [_datePicker date];
     
     unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
     NSCalendar* calendar = [NSCalendar currentCalendar];
     NSDateComponents* components = [calendar components:flags fromDate:dateInOldFormat];
     NSDate* dateOnly = [calendar dateFromComponents:components];
     
     /// CHANGING FORMAT
     
     NSString *_outputFormat = @"dd-MM-YYYY";
     //[dateFormatter setDateFormat:@"YYYY-M-d"];
     [dateFormatter setDateFormat:_outputFormat];
     
     NSString *dateInNewFormat = [dateFormatter stringFromDate:dateOnly];
     NSLog(@"Date: %@",dateInNewFormat);
     
     [birthdaylbl setText:dateInNewFormat];
     birthdaylbl.textColor = [UIColor whiteColor];
}


-(NSDate *)getCurrentDate{
     
     return [NSDate date];
}

-(IBAction)SwitchToFirstView:(id)sender{
     
     
     
}

-(IBAction)SwitchToSecondView:(id)sender{
     
     if(displayNameField.text.length < 1)
     {
          
          NSString *emptyfield;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0) {
               emptyfield = @"Please Provide Display Name!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 1){
               emptyfield = @"يرجى تقديم اسم العرض!";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emptyfield = @"Veuillez fournir votre Pseudo!";
               title = @"Erreur";
               cancel = CANCEL_1;
          }else if(languageCode == 3){
               emptyfield = @"Por favor, ingrese su alias!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 4){
               emptyfield = @"Por favor, forneça o nome de exibição!";
               title = @"Erro";
               cancel = CANCEL_1;
          }
          
          [AlertMessage showAlertWithMessage:emptyfield andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Display Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
           return;*/
     }
     else if([birthdaylbl.text isEqualToString:@"Birthday"])
     {
          NSString *emptyfield;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0) {
               emptyfield = @"Please Provide Birthday!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 1){
               emptyfield = @"يرجى تقديم تاريخ الميلاد!";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emptyfield = @"Veuillez fournir votre date de naissance";
               title = @"Erreur";
               cancel = CANCEL_1;
          }else if(languageCode == 3){
               emptyfield = @"Por favor, ingrese su fecha de nacimiento!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 4){
               emptyfield = @"Por favor, forneça data de aniversário!";
               title = @"Erro";
               cancel = CANCEL_1;
          }
          
          [AlertMessage showAlertWithMessage:emptyfield andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Select Birthday" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
           return;*/
     }
     
     self.view = secondView;
}

-(IBAction)back:(id)sender{
     
     [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)SendSignupCall:(id)sender{
     
     [self DismissTextField:sender];
     
     NSLog(@"Send sign up call here %@",displayNameField.text);
     
     if(emailField.text.length < 1)
     {
          NSString *emptyfield;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0) {
               emptyfield = @"Please Provide Email address!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 1){
               emptyfield = @"يرجى تقديم عنوان البريد الإلكتروني!";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emptyfield = @"Veuillez fournir votre adresse e-mail!";
               title = @"Erreur";
               cancel = CANCEL_1;
          }else if(languageCode == 3){
               emptyfield = @"Por favor, ingrese su correo electrónico!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 4){
               emptyfield = @"Por favor, forneça um endereço de e-mail!";
               title = @"Erro";
               cancel = CANCEL_1;
          }
          
          
          
          [AlertMessage showAlertWithMessage:emptyfield andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Email Address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
           return;*/
     }else if (usernameLbl.text.length <1 ){
          NSString *emptyfield;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0) {
               emptyfield = @"Please Provide User Name ID!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 1){
               emptyfield = @"يرجى تقديم اسم المستخدم!";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emptyfield = @"Veuillez fournir votre nom d'utilisateur!";
               title = @"Erreur";
               cancel = CANCEL_1;
          }else if(languageCode == 3){
               emptyfield = @"Por favor, ingrese su usuario!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 4){
               emptyfield = @"Por favor, forneça o nome de usuário!";
               title = @"Erro";
               cancel = CANCEL_1;
          }
          
          [AlertMessage showAlertWithMessage:emptyfield andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
     }
     else if(![self validateEmail:emailField.text])
     {
          
          NSString *emptyfield;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0) {
               emptyfield = @"Please Provide Email address!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 1){
               emptyfield = @"يرجى تقديم عنوان البريد الإلكتروني!";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emptyfield = @"Veuillez fournir votre adresse e-mail!";
               title = @"Erreur";
               cancel = CANCEL_1;
          }else if(languageCode == 3){
               emptyfield = @"Por favor, ingrese su correo electrónico!";
               title = @"Error";
               cancel = CANCEL_1;
          }else if (languageCode == 4){
               emptyfield = @"Por favor, forneça um endereço de e-mail!";
               title = @"Erro";
               cancel = CANCEL_1;
          }
          
          [AlertMessage showAlertWithMessage:emptyfield andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Some Valid Email Address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
           return;*/
     }
     else if(passwordField.text.length < 6)
     {
          NSString *passwrdLimit;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0) {
               passwrdLimit = @"Password must be at least six characters long!";
               title = @"Error";
               cancel = CANCEL;
          }else if (languageCode == 1){
               passwrdLimit = @"يجب أن يكون طول كلمة السر أكبر من 6";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               passwrdLimit = @"Le mot de passe doit être supérieur à 6.";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if(languageCode == 3){
               passwrdLimit = @"Longitud de la contraseña debe ser superior a 6.";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               passwrdLimit = @"A senha deve ser maior do que 6.";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          
          [AlertMessage showAlertWithMessage:passwrdLimit andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password must be atleast six characters long!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
           return;*/
     }else{
          [[NSUserDefaults standardUserDefaults] setObject:emailField.text forKey:@"LoginEmail"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          
          AppDelegate *emailOBj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
          emailOBj.LoginEmail = emailField.text;
          [self sendRegistrationCall];
     }
}

-(IBAction)EditProfileImage:(id)sender{
     isEditPressed = YES;
     [self DismissTextField:sender];
     overlayView.hidden = NO;
     popUpView.hidden = NO;
}



-(void)cameraPhoto{
     
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
          
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          
          [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
          [self presentViewController:picker animated:YES completion:nil];
          
     }
     else {
          
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Your device does not support this feature!";
               title = @"Error";
               cancel = OK_BTN;
          } else if(languageCode == 1) {
               message = @"!لا يدعم جهازك هذه الميزة";
               title = @"خطأ";
               cancel = OK_BTN_1;
          }else if (languageCode == 2){
               message = @"Su dispositivo no admite esta característica!";
               title = @"Erreur";
               cancel = OK_BTN_2;
          }else if (languageCode == 3){
               message = @"Votre appareil ne prend pas en charge cette fonctionnalité!";
               title = @"Error";
               cancel = OK_BTN_3;
          }else if (languageCode == 4){
               message = @"O dispositivo não suporta esta função!";
               title = @"Erro";
               cancel = OK_BTN_4;
          }
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing Camera" message:@"Device does not support Camera" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alert show];*/
     }
     
     
}

-(void)libraryPhoto{
     
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          [self presentViewController:picker animated:YES completion:nil];
     }
     else {
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Your device does not support this feature!";
               title = @"Error";
               cancel = OK_BTN;
          } else if(languageCode == 1) {
               message = @"!لا يدعم جهازك هذه الميزة";
               title = @"خطأ";
               cancel = OK_BTN_1;
          }else if (languageCode == 2){
               message = @"Su dispositivo no admite esta característica!";
               title = @"Erreur";
               cancel = OK_BTN_2;
          }else if (languageCode == 3){
               message = @"Votre appareil ne prend pas en charge cette fonctionnalité!";
               title = @"Error";
               cancel = OK_BTN_3;
          }else if (languageCode == 4){
               message = @"O dispositivo não suporta esta função!";
               title = @"Erro";
               cancel = OK_BTN_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing photo library" message:@"Device does not support a photo library" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alert show];*/
     }
     
     
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
          NSLog(@"Response: %@",[completedOperation responseString]);
          NSDictionary *recievedDict = [completedOperation responseJSON];
          NSNumber *flag = [recievedDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:1]])
               
          {
               _avatarsArray = [recievedDict objectForKey:@"avatars"];
               int randomNumber =  0 + rand() % (_avatarsArray.count - 0);
               NSLog(@"randomNumber : %d",randomNumber);
               NSString *i = [NSString stringWithFormat:@"%d",randomNumber];
               
               [self downloadAvatars];
               
               NSString *avatarURL = [_avatarsArray objectAtIndex:[i intValue]];
               NSURL *imageURL = [NSURL URLWithString:avatarURL];
               NSString *ImagePath = [docs stringByAppendingPathComponent:imageURL.lastPathComponent];
               
               NSLog(@"Complete Path: %@",ImagePath);
               
               _AvatarImage = [UIImage imageWithContentsOfFile:ImagePath];
               if (_AvatarImage == nil) {
                    _AvatarImage = [UIImage imageNamed:@"logo.png"];
               }
               
               [self setProfileImage:_AvatarImage];
          }
          
          
     } onError:^(NSError* error) {
          
          [_loadingView hide];
          
          
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
          
          
          /*   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to Show Avatars" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alert show];
           */
          
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
     
     
     [_loadingView hide];
     if (isEditPressed == YES) {
          if ([[UIScreen mainScreen] bounds].size.height == iPad)
               [self loadAvatarsToIpadView];
          else
               [self LoadAvatars];
          [self.view addSubview:AvatarView];
     }
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
          
          NSString *imagePath = [docs stringByAppendingPathComponent:fileName];
          
          NSLog(@"Image Path: %@",imagePath);
          
          UIImage *image = [completedOperation responseImage];
          NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
          [imageData writeToFile:imagePath atomically:NO];
          
          [self downloadAvatars];
          
     }onError:^(NSError* error) {
          
          [_loadingView hide];
          
          
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
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:@"Unable to Show Avatar" SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to Show Avatar" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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
          
          
          NSString *ImagePath = [docs stringByAppendingPathComponent:imageURL.lastPathComponent];
          
          NSLog(@"Complete Path: %@",ImagePath);
          
          
          UIImage *avatarImage = [UIImage imageWithContentsOfFile:ImagePath];
          
          UIButton *avatarSelectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          [avatarSelectionBtn setFrame:CGRectMake(x_Position, y_Position, Width, Height)];
          [avatarSelectionBtn setBackgroundImage:avatarImage forState:UIControlStateNormal];
          [avatarSelectionBtn addTarget:self action:@selector(AvatarSelected:) forControlEvents:UIControlEventTouchUpInside];
          [avatarSelectionBtn setTag:k];
          [AvatarsScrollView addSubview:avatarSelectionBtn];
     }
     [AvatarsScrollView setContentSize:CGSizeMake((Width*2)+18,y_Position+Height)];
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
     
     [AvatarsScrollView setContentSize:CGSizeMake(AvatarsScrollView.frame.size.width,yPosition+Height)];
     
}




-(void)AvatarSelected:(id)sender{
     
     UIButton *btn = (UIButton *)sender;
     NSLog(@"Btn Tag: %i",btn.tag);
     
     AvatarSelectedIndex = btn.tag;
     NSString *avatarURL = [_avatarsArray objectAtIndex:btn.tag];
     NSURL *imageURL = [NSURL URLWithString:avatarURL];
     NSString *ImagePath = [docs stringByAppendingPathComponent:imageURL.lastPathComponent];
     
     NSLog(@"Complete Path: %@",ImagePath);
     popUpView.hidden = true;
     overlayView.hidden = true;
     
     _AvatarImage = [UIImage imageWithContentsOfFile:ImagePath];
     
     [self setProfileImage:_AvatarImage];
     
     [AvatarView removeFromSuperview];
     
}

-(IBAction)CancelAvatarSheet:(id)sender{
     
     [AvatarView removeFromSuperview];
}


-(BOOL)checkThisFileIndocs:(NSString *)fileName{
     
     NSString *filePath = [docs stringByAppendingPathComponent:fileName];
     
     
     if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
          return true;
     
     return false;
}



-(void)sendRegistrationCall{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"userSignUP" forKey:@"method"];
     [postParams setObject:language forKey:@"language"];
     [postParams setObject:displayNameField.text forKey:@"display_name"];
     [postParams setObject:emailField.text forKey:@"email"];
     [postParams setObject:passwordField.text forKey:@"password"];
    // [postParams setObject:birthdaylbl.text forKey:@"birthday"];
     [postParams setObject:usernameLbl.text forKey:@"user_name_id"];
     
     [postParams setObject:@"Pakistan" forKey:@"country_name"];
     [postParams setObject:@"xxx" forKey:@"about"];
     [postParams setObject:@"male" forKey:@"gender"];
     if(_profileImageType == FromAvatar)
     {
          [postParams setObject:@"false" forKey:@"is_file"];
          if([_avatarsArray count] > 0)
               [postParams setObject:[_avatarsArray objectAtIndex:AvatarSelectedIndex] forKey:@"profile_image"];
          else
               [postParams setObject:@"http://www.quizapplication.faditekdev.com/api/images/1.jpg" forKey:@"profile_image"];
     }
     else
     {
          [postParams setObject:@"true" forKey:@"is_file"];
          [postParams setObject:UIImageJPEGRepresentation(_AvatarImage,1.0) forKey:@"profile_image"];
          
     }
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     if(_profileImageType != FromAvatar)
     {
          NSData *imageData = UIImageJPEGRepresentation(_AvatarImage,1.0);
          [op addData:imageData forKey:@"profile_image" mimeType:@"image/jpg" fileName:@"profile_image"];
     }
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [_loadingView hide];
          NSDictionary *responseDict = [completedOperation responseJSON];
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          errorMessageFromServer = [responseDict objectForKey:@"message"];
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               [self removeImage:@"test"];
               [self saveImage:_profileImage1.image];
               
               [SharedManager getInstance].userID = [responseDict objectForKey:@"user_id"];
               [SharedManager getInstance].sessionID = [responseDict objectForKey:@"session_id"];
               [[SharedManager getInstance] saveModel];
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewLogin"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               [self createTabBarAndControl];
          }
          else
          {
               NSString *title;
               NSString *cancel;
               NSString *message;
               
               if (languageCode == 0 ) {
                    message = @"Email Already Exist";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    message = @"البريد الإلكتروني موجودا مسبقا";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    message = @"Cette adresse e-mail existe déjà";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    message = @"Este correo electrónico ya existe";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    message =@"E-mail já existe";
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               
//               if ([[responseDict objectForKey:@"message"]isEqualToString:@"Email Already Exist"]){
//                    
//                    [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
//                    
//                    
//               }else if ([[responseDict objectForKey:@"message"]isEqualToString:@"Email Already Exist"]){
//                    
//                    
//                    NSString *emailMsg;
//                    NSString *title;
//                    
//                    if (languageCode == 0 ) {
//                         emailMsg = @"Username already exists";
//                         title = @"Error";
//                         cancel = CANCEL;
//                    } else if(languageCode == 1) {
//                         emailMsg = @"اسم المستخدم موجود مسبقا";
//                         title = @"خطأ";
//                         cancel = CANCEL_1;
//                    }else if (languageCode == 2){
//                         emailMsg = @"ECe nom d'utilisateur existe déjà";
//                         title = @"Erreur";
//                         cancel = CANCEL_2;
//                    }else if (languageCode == 3){
//                         emailMsg = @"¡Este usuario ya existe!";
//                         title = @"Error";
//                         cancel = CANCEL_3;
//                    }else if (languageCode == 4){
//                         emailMsg = @"O usuário já existe";
//                         title = @"Erro";
//                         cancel = CANCEL_4;
//                    }
//                    
//                    
//                    [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
//                    
//               }else{
//                    
//                    NSString *emailMsg;
//                    NSString *title;
//                    
//                    if (languageCode == 0 ) {
//                         emailMsg = @"Something went wrong.";
//                         title = @"Error";
//                         cancel = CANCEL;
//                    } else if(languageCode == 1) {
//                         emailMsg = @"لقد حصل خطأ ما";
//                         title = @"خطأ";
//                         cancel = CANCEL_1;
//                    }else if (languageCode == 2){
//                         emailMsg = @"Erreur: Quelque chose s\'est mal passé!";
//                         title = @"Erreur";
//                         cancel = CANCEL_2;
//                    }else if (languageCode == 3){
//                         emailMsg = @"Algo salió mal!";
//                         title = @"Error";
//                         cancel = CANCEL_3;
//                    }else if (languageCode == 4){
//                         emailMsg = @"Alguma coisa deu errado!";
//                         title = @"Erro";
//                         cancel = CANCEL_4;
//                    }
//                    
               
                    [AlertMessage showAlertWithMessage:errorMessageFromServer andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          }
          
          
     } onError:^(NSError* error) {
          
          [_loadingView hide];
          
          
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
     
     [_loadingView showInView:self.view withTitle:LoadingTitle];
     [engine enqueueOperation:op];
}


-(void)setProfileImage:(UIImage *)_image{
     
     _AvatarImage = _image;
     
     [profileImageView setHidden:NO];
     [profileImageView1 setHidden:NO];
     
     [_profileImage setImage:_image];
     [_profileImage1 setImage:_image];
}

#pragma mark ----------------------------------------------------
#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
     
     _profileImageType = FromCamera;
     popUpView.hidden = true;
     overlayView.hidden = true;
     UIImage *myIcon = [SignUpVC imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
     [self setProfileImage:myIcon];
     [picker dismissViewControllerAnimated:true completion:nil];
     
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
     //UIGraphicsBeginImageContext(newSize);
     // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
     // Pass 1.0 to force exact pixel size.
     UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
     
     [picker dismissViewControllerAnimated:true completion:nil];
     
}


#pragma mark ----------------------------------------------------
#pragma mark - Action Sheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
     
     NSLog(@"Clicked at index: %li",(long)buttonIndex);
     
     if(buttonIndex == CAMERA_INDEX)
          [self cameraPhoto];
     else if(buttonIndex == GALLERY_INDEX)
          [self libraryPhoto];
     else if(buttonIndex == AVATAR_INDEX)
          [self showAvatars];
}

#pragma mark ----------------------------------------------------
#pragma mark - TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     DontSwipe = true;
     if (textField == usernameLbl){
          [UIView beginAnimations:nil context:nil];
          [UIView setAnimationDuration:0.3];
          [UIView setAnimationCurve:UIViewAnimationCurveLinear];
          self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
          [UIView commitAnimations];
          
     }
     if (textField == passwordField){
          [UIView beginAnimations:nil context:nil];
          [UIView setAnimationDuration:0.3];
          [UIView setAnimationCurve:UIViewAnimationCurveLinear];
          self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
          [UIView commitAnimations];
          
     }
     [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     DontSwipe = false;
     [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     
     [textField resignFirstResponder];
     [dismissBtn removeFromSuperview];
     return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     const int movementDistance = 120;
     const float movementDuration = 0.3f;
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     containerView.frame = CGRectOffset(containerView.frame, 0, movement);
     [UIView commitAnimations];
}

-(void)addDissmissButton{
     
     dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [dismissBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     [dismissBtn addTarget:self action:@selector(DismissTextField:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:dismissBtn];
}

-(void)DismissTextField:(id)sender{
     [emailField resignFirstResponder];
     [passwordField resignFirstResponder];
     [displayNameField resignFirstResponder];
     [usernameLbl resignFirstResponder];
}

-(BOOL)validateEmail:(NSString *)candidate {
     
     NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     
     return [emailTest evaluateWithObject:candidate];
}

-(IBAction)locationReasonAction:(id)sender{
     
}
-(IBAction)birthdayReasonAction:(id)sender{
     
}
- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (IBAction)popUpCacnelPressed:(id)sender {
     overlayView.hidden = YES;
     popUpView.hidden = YES;
}
- (IBAction)popUpTakePicture:(id)sender {
     [self cameraPhoto];
}
- (IBAction)popUpFromFilePressed:(id)sender {
     [self libraryPhoto];
}
- (IBAction)popUpAvatarPressed:(id)sender {
     [self showAvatars];
     
     
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

-(void)createTabBarAndControl {
     if(IS_IPAD){
          self.viewController = [[GetTopicsVC alloc] initWithNibName:@"GetTopicsVC_iPad" bundle:nil];
     }
     else {
          self.viewController = [[GetTopicsVC alloc] initWithNibName:@"GetTopicsVC" bundle:nil];
     }
     
     
     self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
     [self.navController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"homeglow.png"]
                                                      imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
     
     [self.navController.tabBarItem setImage:[[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     
     
     self.navController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
     if(IS_IPAD)
     {
          [self.navController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"homeglowForIpad.png"]
                                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          
          [self.navController.tabBarItem setImage:[[UIImage imageNamed:@"homeForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          self.navController.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, -35, 15, 35);
          
     }
     [self.navController setNavigationBarHidden:YES animated:NO];
     
     UIViewController *friendsVC;
     
     if(IS_IPAD) {
          friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC_iPad" bundle:[NSBundle mainBundle]];
     }
     else {
          friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC" bundle:[NSBundle mainBundle]];
     }
     UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsVC];
     
     
     [friendsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"friendsglow1.png"]
                                             imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
     [friendsVC.tabBarItem setImage:[[UIImage imageNamed:@"friends.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     
     
     friendsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
     if(IS_IPAD)
          
     {
          [friendsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"friendsglowForIpad.png"]
                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [friendsVC.tabBarItem setImage:[[UIImage imageNamed:@"friendsForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          friendsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, -30, 15,30);
          
     }
     [friendsVC.navigationController setNavigationBarHidden:YES animated:NO];
     
     UIViewController *storeVC;
     if(IS_IPAD) {
          storeVC = [[StoreVC alloc] initWithNibName:@"StoreVC_iPad" bundle:[NSBundle mainBundle]];
     }
     else {
          storeVC = [[StoreVC alloc] initWithNibName:@"StoreVC" bundle:[NSBundle mainBundle]];
     }
     UINavigationController *storeNavController = [[UINavigationController alloc] initWithRootViewController:storeVC];
     
     [storeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shopglow.png"]
                                           imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
     [storeVC.tabBarItem setImage:[[UIImage imageNamed:@"shop.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     
     storeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
     if(IS_IPAD){
          [storeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shopglowForIpad.png"]
                                                imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [storeVC.tabBarItem setImage:[[UIImage imageNamed:@"shopForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          storeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, -20, 15, 20);
          
     }
     [storeVC.navigationController setNavigationBarHidden:YES animated:NO];
     
     UIViewController *rewardsVC;
     if(IS_IPAD) {
          rewardsVC = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC_iPad" bundle:[NSBundle mainBundle]];
     }
     else {
          rewardsVC = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC" bundle:[NSBundle mainBundle]];
     }
     UINavigationController *historyNavController = [[UINavigationController alloc] initWithRootViewController:rewardsVC];
     
     [rewardsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"rewardsglowp.png"]
                                             imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
     [rewardsVC.tabBarItem setImage:[[UIImage imageNamed:@"rewardsp.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     
     rewardsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
     if(IS_IPAD)
     {
          [rewardsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"referglowForIpad.png"]
                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [rewardsVC.tabBarItem setImage:[[UIImage imageNamed:@"referforIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          rewardsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0);
          
     }
     
     [rewardsVC.navigationController setNavigationBarHidden:YES animated:NO];
     
     
     UIViewController *settingVC;
     if(IS_IPAD) {
          settingVC = [[RightBarVC alloc] initWithNibName:@"RightBarVC_iPad" bundle:[NSBundle mainBundle]];
          
     }
     else {
          settingVC = [[RightBarVC alloc] initWithNibName:@"RightBarVC" bundle:[NSBundle mainBundle]];
          
     }
     
     UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingVC];
     
     [settingVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menuglow.png"]
                                             imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
     [settingVC.tabBarItem setImage:[[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     
     settingsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
     if(IS_IPAD){
          [settingVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menuglowForIpad.png"]
                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [settingVC.tabBarItem setImage:[[UIImage imageNamed:@"menuForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          settingsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 30, 15, -30);
          
     }
     [settingVC.navigationController setNavigationBarHidden:YES animated:NO];
     
     self.tabBarController = [[UITabBarController alloc] init] ;
     self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navController, friendsNavController,storeNavController,historyNavController,settingsNavController,nil];
     
     [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"menubg.png"]];
     if(IS_IPAD) {
          [self.tabBarController.tabBar setShadowImage:[[UIImage alloc] init]];
          [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"menubgForIpad.png"]];
     }
     
     //    [self setFieldsAndButtonsText:self.configResponse];
     self.viewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
     //self.viewController.navigationController.navigationBar
     [[[UIApplication sharedApplication]delegate] window].rootViewController = self.tabBarController;
}

@end
