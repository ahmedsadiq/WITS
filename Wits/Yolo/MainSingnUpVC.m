//
//  MainSingnUpVC.m
//  Yolo
//
//  Created by Salman Khalid on 12/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "MainSingnUpVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "LoginVC.h"
#import "SignUpVC.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "NavigationHandler.h"
#import "Utils.h"
#import "AlertMessage.h"
#import <Twitter/Twitter.h>
#import "RewardsListVC.h"
#import "FriendsVC.h"
#import "StoreVC.h"
#import "EarnFreePointsViewController.h"
#import "SettingVC.h"
#import "RightBarVC.h"

@interface MainSingnUpVC ()

@end

@implementation MainSingnUpVC

#define kOAuthConsumerKey        @"XL0qdKEsuBscc8zUQDHo0VXQa"         //REPLACE With Twitter App OAuth Key
#define kOAuthConsumerSecret    @"SUlS1QVX5I9XxhVXZJmcUzsUhvnMCbEut8LERJZBYFI1BRCmtL"


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
-(id)init
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          self = [super initWithNibName:@"MainSignUpVC_iPad" bundle:Nil];
          
     }
     
     else{
          self = [super initWithNibName:@"MainSingnUpVC" bundle:Nil];
     }
     return self;
}
- (void)viewDidLoad
{
     [super viewDidLoad];
     user_name_id = @"";
    language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     [self.navigationController setNavigationBarHidden:YES];
     [[_RegisterButton layer] setBorderWidth:0.5f];
     [[_RegisterButton layer] setBorderColor:[UIColor whiteColor].CGColor];
     [[forgotpasswordSigninButtonn layer] setBorderWidth:0.5f];
     [[forgotpasswordSigninButtonn layer] setBorderColor:[UIColor whiteColor].CGColor];
    
     //
  if(IS_IPAD)
       skipbtn.titleLabel.font = [UIFont systemFontOfSize:30];
     UIColor *color = [UIColor whiteColor];
     DontSwipe = false;
     emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
     pswdTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
     [self setLanguage];
     [self setUpTutorial];
     
     tutorialLbl.text = tutoStr1;
   
     CGRect myRect = CGRectMake(0, 0, 0, 0);
     NSString *imageName = @"";
     if ([[UIScreen mainScreen] bounds].size.height == iPad){
          myRect = CGRectMake(415, 700, 300, 100);
          imageName = @"facebookbg.png";
          signuplabelTextbelow.font = [UIFont fontWithName:FONT_NAME size:19];
          forgotPasswordLabel.font = [UIFont fontWithName:FONT_NAME size:25];
          orLabel.font = [UIFont fontWithName:FONT_NAME size:20];
          emailTxt.font = [UIFont fontWithName:FONT_NAME size:30];
          pswdTxt.font = [UIFont fontWithName:FONT_NAME size:30];
          _resetPswdEmail.font = [UIFont fontWithName:FONT_NAME size:30];
          OrlabellForgotpasswrod.font = [UIFont fontWithName:FONT_NAME size:25];
          LoginBtnOutlet.font = [UIFont fontWithName:FONT_NAME size:25];
          _resetButtonOutlet.font = [UIFont fontWithName:FONT_NAME size:25];
          twitterBtn.font = [UIFont fontWithName:FONT_NAME size:25];
          [[_RegisterButton layer] setBorderWidth:2.0f];
          [[_RegisterButton layer] setBorderColor:[UIColor whiteColor].CGColor];
          [[forgotpasswordSigninButtonn layer] setBorderWidth:2.0f];
          [[forgotpasswordSigninButtonn layer] setBorderColor:[UIColor whiteColor].CGColor];
     }
     else{
          myRect = CGRectMake(174,421,132,42);
          imageName = @"facebookbg.png";
          twitterBtn.font = [UIFont fontWithName:FONT_NAME size:17];
          signuplabelTextbelow.font = [UIFont fontWithName:FONT_NAME size:12];
          forgotPasswordLabel.font = [UIFont fontWithName:FONT_NAME size:18];
          orLabel.font = [UIFont fontWithName:FONT_NAME size:14];
          emailTxt.font = [UIFont fontWithName:FONT_NAME size:17];
          pswdTxt.font = [UIFont fontWithName:FONT_NAME size:17];
          _resetPswdEmail.font = [UIFont fontWithName:FONT_NAME size:14];
          OrlabellForgotpasswrod.font = [UIFont fontWithName:FONT_NAME size:15];
          LoginBtnOutlet.font = [UIFont fontWithName:FONT_NAME size:17];
          _resetButtonOutlet.font = [UIFont fontWithName:FONT_NAME size:17];
     }
     BOOL isLanguageSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLanguageSelected"];
     if(!isLanguageSelected) {
          [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"languageCode"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          languageArray = [[NSArray alloc] initWithObjects:@"English (US)", @"Arabic (Ar)", @"French (Fr)",@"Spanish (Es)",@"Portuguese (Pt)", nil];
          [self.view addSubview:langSelectionPopUp];
          
          UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(languageSwipeDown:)];
          [left setDirection:UISwipeGestureRecognizerDirectionDown];
          [langSelectionPopUp addGestureRecognizer:left];
          
     }
     else {
          [self addFacebookSignInButton:myRect andImageName:imageName];
     }
     _loadingView = [[LoadingView alloc] init];
     
     
     //emailTxt.font = [UIFont fontWithName:FONT_NAME size:17];
     //pswdTxt.font = [UIFont fontWithName:FONT_NAME size:17];
     //LoginBtnOutlet.font = [UIFont fontWithName:FONT_NAME size:17];
     //  forgotPasswordLabel.font = [UIFont fontWithName:FONT_NAME size:18];
     //orLabel.font = [UIFont fontWithName:FONT_NAME size:14];
     // twitterBtn.font = [UIFont fontWithName:FONT_NAME size:17];
     // signuplabelTextbelow.font = [UIFont fontWithName:FONT_NAME size:13];
     chooseLangLbl.font = [UIFont fontWithName:FONT_NAME size:17];
     languageTitle.font = [UIFont fontWithName:FONT_NAME size:17];
     languageBtn.font = [UIFont fontWithName:FONT_NAME size:18];
     
     dialogTitle.font = [UIFont fontWithName:FONT_NAME size:16];
     DialogMsg.font = [UIFont fontWithName:FONT_NAME size:15];
     Dialogyes.font = [UIFont fontWithName:FONT_NAME size:14];
     Dialogno.font = [UIFont fontWithName:FONT_NAME size:14];
     // _resetButtonOutlet.font = [UIFont fontWithName:FONT_NAME size:17];
     //_resetPswdEmail.font = [UIFont fontWithName:FONT_NAME size:14];
     //OrlabellForgotpasswrod.font = [UIFont fontWithName:FONT_NAME size:15];
     forgotpasswordSigninButtonn.font = [UIFont fontWithName:FONT_NAME size:13];
     
     if(IS_IPAD)
          forgotpasswordSigninButtonn.font = [UIFont fontWithName:FONT_NAME size:19];
     
//     UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(signUpSwipeDown:)];
//     [left setDirection:UISwipeGestureRecognizerDirectionDown];
//     [self.view addGestureRecognizer:left];
     
}

//- (void)signUpSwipeDown:(UISwipeGestureRecognizer *)gesture
//{
//     SignUpVC *signUpVC;
//     if(!DontSwipe){
//     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
//          
//          signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC_iPad" bundle:nil];
//     }
//     else{
//          signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
//     }
//     //     CATransition* transition = [CATransition animation];
//     //     transition.duration = 0.4f;
//     //     transition.type = kCATransitionMoveIn;
//     //     transition.subtype = kCATransitionFromBottom;
//     //
//     //     [self.navigationController.view.layer addAnimation:transition
//     //                                                 forKey:kCATransition];
//     //     [self.navigationController pushViewController:signUpVC animated:NO];
//     
//     UIViewController *destVC = signUpVC;
//     UIViewController *sourceVC = self;
//     [destVC viewWillAppear:YES];
//     
//     destVC.view.frame = sourceVC.view.frame;
//     
//     [UIView transitionFromView:sourceVC.view
//                         toView:destVC.view
//                       duration:0.7
//                        options:UIViewAnimationOptionTransitionCrossDissolve
//                     completion:^(BOOL finished)
//      {
//           [destVC viewDidAppear:YES];
//           
//           UINavigationController *nav = sourceVC.navigationController;
//           [nav popViewControllerAnimated:NO];
//           [nav pushViewController:destVC animated:NO];
//      }
//      ];
//     }
//}
//
- (void)languageSwipeDown:(UISwipeGestureRecognizer *)gesture
{
     [self languageSaved:nil];
}

-(IBAction)SignUpUsingEmail:(id)sender{
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          SignUpVC *signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC_iPad" bundle:nil];
          [self.navigationController pushViewController:signUpVC animated:YES];
     }
     else{
          SignUpVC *signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
          [self.navigationController pushViewController:signUpVC animated:YES];
     }
     
}

-(IBAction)loginAction:(id)sender{
     
//     if(![self validateEmail:emailTxt.text])
//     {
//          NSString *emailMsg;
//          NSString *title;
//          if (languageCode == 0 ) {
//               emailMsg = @"Please enter some valid email address.";
//               title = @"Error";
//          } else if(languageCode == 1) {
//               emailMsg = @"الرجاء تقديم عنوان بريدك الإلكتروني الصحيح!";
//               title = @"خطأ";
//          }else if (languageCode == 2){
//               emailMsg = @"Veuillez fournir une adresse e-mail correcte!";
//               title = @"Erreur";
//          }else if (languageCode == 3){
//               emailMsg = @"Por favor ingrese un correo electrónico correcto!";
//               title = @"Error";
//          }else if (languageCode == 4){
//               emailMsg = @"Por favor, forneça um endereço de e-mail correto!";
//               title = @"Erro";
//          }
//          
//          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
//          
//          /*   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter some valid email address." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//           
//           [alertView show];
//           return;*/
//     }
//     //NSLog(@"%@",emailTxt.text);
//     else
     if(![pswdTxt hasText]){
          NSString *emailMsg;
          NSString *title;
          if (languageCode == 0 ) {
               emailMsg = @"Enter Password.";
               title = @"Error";
          } else if(languageCode == 1) {
               emailMsg = @"أدخل كلمة المرور";
               title = @"خطأ";
          }else if (languageCode == 2){
               emailMsg = @"Escribe contraseña.";
               title = @"Erreur";
          }else if (languageCode == 3){
               emailMsg = @"Entrer votre mot de passe";
               title = @"Error";
          }else if (languageCode == 4){
               emailMsg = @"Senha";
               title = @"Erro";
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
          // [self textFieldDidEndEditing:nil];

     }
     else{
          
          [pswdTxt resignFirstResponder];
          [self sendLoginCall:false];
          
     }
     
     [emailTxt resignFirstResponder];
     [pswdTxt resignFirstResponder];
}

- (IBAction)RegiterBtnPressed:(id)sender {
      SignUpVC *signUpVC;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC_iPad" bundle:nil];
     }
     else{
          signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
     }
     UIViewController *destVC = signUpVC;
     UIViewController *sourceVC = self;
     [destVC viewWillAppear:YES];
     
     destVC.view.frame = sourceVC.view.frame;
     
     [UIView transitionFromView:sourceVC.view
                         toView:destVC.view
                       duration:0.4
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     completion:^(BOOL finished)
      {
           [destVC viewDidAppear:YES];
           
           UINavigationController *nav = sourceVC.navigationController;
           [nav popViewControllerAnimated:NO];
           [nav pushViewController:destVC animated:NO];
      }
      ];
}
#pragma mark Twitter Sign In
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
     NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
     
     [defaults setObject: data forKey: @"authData"];
     [defaults synchronize];
     
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
     return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (IBAction)twiiterSignIn:(id)sender {
     
     [_loadingView showInView:self.view withTitle:LoadingTitle];
     
     ACAccountStore *accountStore = [[ACAccountStore alloc] init];
     ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
     
     [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
          if (granted) {
               
               NSArray *accounts = [accountStore accountsWithAccountType:accountType];
               
               // Check if the users has setup at least one Twitter account
               
               if (accounts.count > 0)
               {
                    
                    ACAccount *twitterAccount = [accounts objectAtIndex:0];
                    // Creating a request to get the info about a user on Twitter
                    NSString *screenName = twitterAccount.username;
                    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:screenName forKey:@"screen_name"]];
                    [twitterInfoRequest setAccount:twitterAccount];
                    
                    // Making the request
                    
                    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                              
                              // Check if we reached the reate limit
                              
                              if ([urlResponse statusCode] == 429) {
                                   NSLog(@"Rate limit reached");
                                   return;
                              }
                              
                              // Check if there was an error
                              
                              if (error) {
                                   NSLog(@"Error: %@", error.localizedDescription);
                                   return;
                              }
                              
                              // Check if there is some response data
                              
                              if (responseData) {
                                   
                                   
                                   NSError *error = nil;
                                   NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                   // Filter the preferred data
                                   
                                   
                                   NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                                   NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                                   
                                   NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                                   NSString *bannerImageStringURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                                   
                                   email = screen_name;
                                   displayName = name;
                                   user_name_id = name;
                                   gender = @"";
                                   birthday = @"";
                                   profileImageUrl = profileImageStringURL;
                                   
                                   // Get the profile image in the original resolution
                                   
                                   profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                   lastRequestType = @"twitter";
                                   [self sendRegistrationCall:false andRequestType:@"twitter"];
                                   
                              }
                              
                         });
                    }];
                    
               }
               else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         
                         NSString *message;
                         NSString *title;
                         NSString *cancel;
                         if (languageCode == 0 ) {
                              message = @"Go to Device Settings and set up Twitter Account";
                              title = @"Account Configuration Error";
                              cancel = CANCEL;
                         } else if(languageCode == 1) {
                              message = @"اذهب إلى إعدادات الجهاز وقم بإنشاء حساب تويتر";
                              title = @"خطأ في تكوين الحساب";
                              cancel = CANCEL_1;
                         }else if (languageCode == 2){
                              message = @"Allez à paramètres et configurez votre compte Twitter";
                              title = @"Erreur de configuration du compte";
                              cancel = CANCEL_2;
                         }else if (languageCode == 3){
                              message = @"Ir a configuraciones y configurar su cuenta Twitter";
                              title = @"Error en la configuración de la cuenta";
                              cancel = CANCEL_3;
                         }else if (languageCode == 4){
                              message = @"Vá para Configurações e adicione a conta do Twitter";
                              title = @"Erro de Configuração de Conta";
                              cancel = CANCEL_4;
                         }
                         [_loadingView hide];
                         
                         [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                         
                    });
                    [_loadingView hide];
                    /*  UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Account Configuration Error" message:@"Go to Device Settings and set up Twitter Account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [warningAlert show];*/
               }
          } else {
               NSLog(@"No access granted");
               dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *message;
                    NSString *title;
                    NSString *cancel;
                    if (languageCode == 0 ) {
                         message = @"Access Denied by user";
                         title = @"Access Denied";
                         cancel = CANCEL;
                    } else if(languageCode == 1) {
                         message = @"تم رفض الدخول من قبل المستخدم";
                         title = @"تم رفض الدخول";
                         cancel = CANCEL_1;
                    }else if (languageCode == 2){
                         message = @"Accès refusé par l'utilisateur";
                         title = @"Accès refusé";
                         cancel = CANCEL_2;
                    }else if (languageCode == 3){
                         message = @"Acceso denegado por el usuario";
                         title = @"Acceso denegado";
                         cancel = CANCEL_3;
                    }else if (languageCode == 4){
                         message = @"Acesso negado pelo usuário";
                         title = @"Acesso negado";
                         cancel = CANCEL_4;
                    }
                    
                    [AlertMessage showAlertWithMessage:@"Access Denied by User" andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                    [_loadingView hide];
               });
          }
     }];
     
}

#pragma mark -
#pragma mark FaceBook methods


-(void)addFacebookSignInButton:(CGRect)_rect andImageName:(NSString *)_imageName{
     
     FBLoginView *_loginView = [[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"public_profile", @"email", @"user_birthday",nil]];
     _loginView.frame = _rect;
     
     for (id loginObject in _loginView.subviews)
     {
          if ([loginObject isKindOfClass:[UIButton class]])
          {
               UIButton * loginButton =  loginObject;
               loginButton.frame = CGRectMake(0, 0, _rect.size.width, _rect.size.height);
               UIImage *loginImage = [UIImage imageNamed:_imageName];
               UIImage *pressedState = [UIImage imageNamed:@"facebookbgpressed.png"];
               loginButton.alpha = 1.0;
               [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
               [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
               [loginButton setBackgroundImage:pressedState forState:UIControlStateHighlighted];
               
               UILabel * loginLabel =  [[UILabel alloc] init];
               loginLabel.textColor = [UIColor whiteColor];
               loginLabel.frame = CGRectMake(0, 0, _rect.size.width, _rect.size.height);
               loginLabel.textAlignment = NSTextAlignmentCenter;
               [loginButton addSubview:loginLabel];
               
               language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               NSString *suffix = @"";
               if(languageCode == 0 ) {
                    loginLabel.text = @"FACEBOOK";
               }
               else if(languageCode == 1) {
                    loginLabel.text = @"أدخل عبر الفيسبوك ";
               }
               else if(languageCode == 2) {
                    loginLabel.text = @"Se connecter via Facebook";
               }
               else if(languageCode == 3) {
                    loginLabel.text = @"Iniciar Sesión con Facebook";
               }
               else if(languageCode == 4) {
                    loginLabel.text = @"Conectar com Facebook";
               }
               if ([[UIScreen mainScreen] bounds].size.height == iPad){
                    loginLabel.font = [UIFont fontWithName:FONT_NAME size:25.0f];
               }
               
          }
          if ([loginObject isKindOfClass:[UILabel class]])
          {
               UILabel * loginLabel =  loginObject;
               loginLabel.text = @"";
               loginLabel.frame = CGRectMake(0, 0,0,0);
               loginLabel.textAlignment = NSTextAlignmentJustified;
               
          }
     }
     [_loginView setDelegate:self];
     [self.view addSubview:_loginView];
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
     
     
     
     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
          if (error) {
               // Handle error
               userImageURLFB = @"";
          }
          
          else {
              // NSString *userName = [FBuser name];
               NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
               userImageURLFB = userImageURL;
               
          }
          email = [user objectForKey:@"email"];
          displayName = user.name;
          gender = [user objectForKey:@"gender"];
          NSString *dateObj = [user objectForKey:@"birthday"];
          if(dateObj.length > 1)
          {
               birthday = [self changeDateFormat:dateObj ndFormat:@"MM/dd/YYYY" ndDesiredFormat:@"dd-MM-yyyy"];
          }
          else {
               birthday = @"";
          }
          
          profileImageUrl = userImageURLFB;
          
          // Log out from face book
          
          FBSession* session = [FBSession activeSession];
          [session closeAndClearTokenInformation];
          [session close];
          [FBSession setActiveSession:nil];
          if(DontSwipe)
          [self textFieldDidBeginEditing:nil];
          NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
          NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
          for (NSHTTPCookie* cookie in facebookCookies) {
               [cookies deleteCookie:cookie];
          }
          lastRequestType = @"facebook";
          [self sendRegistrationCall:false andRequestType:@"facebook"];
     }];
     
     
}




//Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
     NSString *alertMessage, *alertTitle;
     
     // If the user should perform an action outside of you app to recover,
     // the SDK will provide a message for the user, you just need to surface it.
     // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
     if ([FBErrorUtility shouldNotifyUserForError:error]) {
          alertTitle = @"Facebook error";
          alertMessage = [FBErrorUtility userMessageForError:error];
          
          // This code will handle session closures that happen outside of the app
          // You can take a look at our error handling guide to know more about it
          // https://developers.facebook.com/docs/ios/errors
     } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
          alertTitle = @"Session Error";
          alertMessage = @"Your current session is no longer valid. Please log in again.";
          
          // If the user has cancelled a login, we will do nothing.
          // You can also choose to show the user a message if cancelling login will result in
          // the user not being able to complete a task they had initiated in your app
          // (like accessing FB-stored information or posting to Facebook)
     } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
          NSLog(@"user cancelled login");
          
          // For simplicity, this sample handles other errors with a generic message
          // You can checkout our error handling guide for more detailed information
          // https://developers.facebook.com/docs/ios/errors
     } else {
          alertTitle  = @"Something went wrong";
          alertMessage = @"Please try again later.";
          NSLog(@"Unexpected error:%@", error);
     }
     
     if (alertMessage) {
          [AlertMessage showAlertWithMessage:alertMessage andTitle:alertTitle SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
          
          
          /*   [[[UIAlertView alloc] initWithTitle:alertTitle
           message:alertMessage
           delegate:nil
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil] show];*/
     }
}
-(void) setUpTutorial {
     
     [self setLanguage];
     
     
}
#pragma mark -
#pragma mark Google methods

- (IBAction)tutorialBackPressed:(id)sender {
     [tutorialView removeFromSuperview];
}

- (IBAction)languageSelectonPressed:(id)sender {
     
     
     NSArray * arr = [[NSArray alloc] init];
     arr = languageArray;
     NSArray * arrImage = [[NSArray alloc] init];
     arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@""], [UIImage imageNamed:@""], nil];
     if(dropDown == nil) {
          CGFloat f = languageArray.count*40;
          dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down":true];
          dropDown.delegate = self;
     }
     else {
          [dropDown hideDropDown:sender];
          [self rel];
     }
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
     [langSelectionPopUp removeFromSuperview];
}
- (void)animateViewHeight:(UIView*)animateView withAnimationType:(NSString*)animType {
     CATransition *animation = [CATransition animation];
     [animation setType:kCATransitionPush];
     [animation setSubtype:animType];
     animation.delegate = self;
     
     [animation setDuration:0.5];
     [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
     [[animateView layer] addAnimation:animation forKey:kCATransition];
     animateView.hidden = !animateView.hidden;
}

- (IBAction)languageSaved:(id)sender {
     [self animateViewHeight:langSelectionPopUp withAnimationType:kCATransitionFromBottom];
     
     [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isLanguageSelected"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSString *langCheck = (NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:@"LangTitle"];
     if (langCheck == nil) {
          [[NSUserDefaults standardUserDefaults ]setObject:@"English(US)" forKey:@"LangTitle"];
     }
     
     tutorialLbl.text = tutoStr1;
     
     arrPoints = [[NSMutableArray alloc]init];
     
     alphaValue = 1;
     alphaValue1 = 1;
     alphaValue2 = 1;
     alphaValue3 = 1;
     alphaValue4 = 1;
     
     if (IS_IPHONE_5){
          tutorialScrollView.frame = CGRectMake(0, 0, 320, 568);
          tutorialScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
          //
          tutorialScroll.contentSize = CGSizeMake(320 * 7, 568);
          
     }else if(IS_IPHONE_4){
          tutorialScrollView.frame = CGRectMake(0, 0, 320, 480);
          
          tutorialScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
          tutorialScroll.contentSize = CGSizeMake(320 * 7, tutorialScroll.frame.size.height);
          _skipOutlet.frame = CGRectMake(tutorialScrollView.frame.size.width - _skipOutlet.frame.size.width, 480-_skipOutlet.frame.size.height, _skipOutlet.frame.size.width, _skipOutlet.frame.size.height);
          _lblTutorial.frame = CGRectMake(20, _skipOutlet.frame.origin.y - _lblTutorial.frame.size.height, _lblTutorial.frame.size.width, _skipOutlet.frame.size.height);
     }else if(IS_IPHONE_6){
          
          tutorialScrollView.frame = CGRectMake(0, -667, 320, 667);
          
          _skipOutlet.autoresizingMask = UIViewAutoresizingNone;
          tutorialScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 667)];
          tutorialScroll.contentSize = CGSizeMake(375 * 7, tutorialScroll.frame.size.height);
          _skipOutlet.frame = CGRectMake(tutorialScrollView.frame.size.width - _skipOutlet.frame.size.width, 667-_skipOutlet.frame.size.height, _skipOutlet.frame.size.width, _skipOutlet.frame.size.height+20);
          _skipOutlet.titleLabel.font = [UIFont fontWithName:@"Tw Cen MT" size:20.0];
          
          _lblTutorial.frame = CGRectMake(20, _skipOutlet.frame.origin.y - _lblTutorial.frame.size.height, _lblTutorial.frame.size.width, _skipOutlet.frame.size.height);
          
     }else if(IS_IPAD){
          
          _skipOutlet.autoresizingMask = UIViewAutoresizingNone;
          tutorialScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024 )];
          tutorialScroll.contentSize = CGSizeMake(768 * 7, tutorialScroll.frame.size.height);
          
          _skipOutlet.frame = CGRectMake(tutorialScrollView.frame.size.width - _skipOutlet.frame.size.width, 1024-_skipOutlet.frame.size.height, _skipOutlet.frame.size.width, _skipOutlet.frame.size.height+30);
          _skipOutlet.titleLabel.font = [UIFont fontWithName:@"Tw Cen MT" size:24.0];
          _lblTutorial.frame = CGRectMake(20, _skipOutlet.frame.origin.y - _lblTutorial.frame.size.height, _lblTutorial.frame.size.width, _skipOutlet.frame.size.height);
     }
     
//     CGRect btnframe = _skipOutlet.frame;
//     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//     
//     UIImage *buttonImageNormal = [UIImage imageNamed:@"arrowRight.png"];
//     [button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
//     button.frame = CGRectMake(btnframe.origin.x + 20, btnframe.origin.y, 20, 30);
//     [tutorialScrollView addSubview:button];
     
     [tutorialScrollView addSubview:tutorialScroll];
     tutorialScroll.pagingEnabled = YES;
     tutorialScroll.delegate = self;
     
     [tutorialScrollView addSubview:_lblTutorial];
     _lblTutorial.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     _lblTutorial.autoresizingMask = UIViewAutoresizingFlexibleWidth;
     
     [tutorialScrollView addSubview:_skipOutlet];
     _skipOutlet.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     _skipOutlet.autoresizingMask = UIViewAutoresizingFlexibleWidth;
     
     for (i = 1; i <= 8; i++){
          UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568 )];
          
          NSString *imagename = [[NSString alloc ]initWithFormat:@"tutorial%d.png",i];
          imgView.image = [UIImage imageNamed:imagename];
          
          [tutorialScroll addSubview:imgView];
          
          if (IS_IPHONE_5){
               imgView.frame = CGRectMake((i -1) * 320, 0, 320, 568);
          }else if(IS_IPHONE_4){
               imgView.frame = CGRectMake((i -1) * 320, 0, 320, 480);
          }else if (IS_IPHONE_6){
               imgView.frame = CGRectMake((i -1) * 375, 0, 375, 667);
          }else if (IS_IPAD){
               imgView.frame = CGRectMake((i -1) * 768, 0, 768, 1024);
          }
     }
     if (IS_IPHONE_5){
          tutorialScrollView.frame = CGRectMake(0, -568, 320, 568);
     }else if(IS_IPHONE_4){
          tutorialScrollView.frame = CGRectMake(0, -480, 320, 480);
     }else if (IS_IPHONE_6){
          tutorialScrollView.frame = CGRectMake(0, -667, 320, 667);
     }else if (IS_IPAD){
          tutorialScrollView.frame = CGRectMake(0, -1024, 768, 1024 );
     }
     
     [self.view addSubview:tutorialScrollView];
     _lblTutorial.text = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
     
     [self moveViewPosition:0.0f forView:tutorialScrollView];
     
     [self setLanguage];
     
     
}
- (void)moveViewPosition:(CGFloat)xPosition forView:(UIView *)view
{
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.4];
     [UIView setAnimationCurve:UIViewAnimationCurveLinear];
     [view setFrame:CGRectMake(view.frame.origin.x,xPosition ,view.frame.size.width, view.frame.size.height)];
     [UIView commitAnimations];
}

- (IBAction)btnSkip:(id)sender {
     
     CGRect myRect = CGRectMake(0, 0, 0, 0);
     NSString *imageName = @"";
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad){
          myRect = CGRectMake(415, 700, 300, 100);
          imageName = @"facebookbg.png";
     }
     else{
          myRect = CGRectMake(174,421,132,42);
          imageName = @"facebookbg.png";
     }
     
     [self addFacebookSignInButton:myRect andImageName:imageName];
     tutorialScrollView.hidden = YES;
}

-(BOOL) animateView :(float) progress{
     if(progress >=0) {
          i = 0;
          
          return true;
     }
     else {
          [UIView animateWithDuration:0.9 animations:^{
               //            [UIView beginAnimations:nil context:nil];
               //            [UIView setAnimationDuration:37489327];
               
               CGRect img0Frame = self.imgTutorials.frame;
               img0Frame.origin.x = i;
               NSLog(@"i : %d",i);
               self.imgTutorials.frame = img0Frame;
               
               self.imgTutorials.frame = CGRectMake(i, 0, 340, 480);
               
               CGRect img1Frame = self.imgTutorial1.frame;
               img1Frame.origin.x = i;
               self.imgTutorial1.frame = img1Frame;
               
               CGRect img2Frame = self.imgTutorial2.frame;
               img2Frame.origin.x = i;
               self.imgTutorial2.frame = img2Frame;
               
               CGRect img3Frame = self.imgTutorial3.frame;
               img3Frame.origin.x = i;
               self.imgTutorial3.frame = img3Frame;
               
               CGRect img4Frame = self.imgTutorial4.frame;
               img4Frame.origin.x = i;
               self.imgTutorial4.frame = img4Frame;
               
               
               [UIView setAnimationCurve:UIViewAnimationCurveLinear];
               [UIView commitAnimations];
          } completion:^(BOOL finished) {
               //fade out
               i=i+1;
               //            if(i<1) {
               [self animateView:i];
               //            }
          }];
     }
     return false;
}


-(BOOL)animateBack :(float) progress{
     
     if(progress >=-20) {
          i = -20;
          [self animateView:i];
          
          return true;
     }
     else {
          [UIView animateWithDuration:34759834 animations:^{
               [UIView beginAnimations:nil context:nil];
               [UIView setAnimationDuration:37489327];
               CGRect img0Frame = self.imgTutorials.frame;
               img0Frame.origin.x = i;
               [UIView setAnimationCurve:UIViewAnimationCurveLinear];
               [UIView commitAnimations];
          } completion:^(BOOL finished) {
               //fade out
               i=i-1;
               //            if(i<1) {
               [self animateBack:i];
               //            }
          }];
     }
     return false;
     
     
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
     
     
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     
     NSLog(@"Will Begining called");
     
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     
     int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
     NSString *textToBeShown = @"";
     switch (indexOfPage) {
          case 0:
               
               //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
               if(languageCode == 0 ) {
                    textToBeShown = screenOne;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenOne1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenOne2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenOne3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenOne4;
               }
               
               break;
          case 1:
               //   textToBeShown = @"Sign In your preferred method in order to start playing and winning!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenTwo;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenTwo1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenTwo2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenTwo3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenTwo4;
               }
               break;
          case 2:
               // textToBeShown = @"Choose a topic out of different categories provided. Choose your favorite one to gain advantage over others!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenThree;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenThree1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenThree2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenThree3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenThree4;
               }
               break;
          case 3:
               //               textToBeShown = @"Choose how you want to play! Against a friend or a random opponent from around the globe! The choice is yours!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenfour;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenfour1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenfour2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenfour3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenfour4;
               }
               break;
          case 4:
               //textToBeShown = @"Choose what you want to play for Gems - to earn actual Real Rewards OR Points - to improve your ranking in the leaderboards!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenfive;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenfive1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenfive2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenfive3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenfive4;
               }
               break;
          case 5:
               // textToBeShown = @"Don't Panic! Just read the question and choose the right answer before your opponent does!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screensix;
               }
               else if(languageCode == 1) {
                    textToBeShown = screensix1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screensix2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screensix3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screensix4;
               }
               break;
          case 6:
               //textToBeShown = @"Addons are there to help you! Use them to make the competition easier for you!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screeneight;
               }
               else if(languageCode == 1) {
                    textToBeShown = screeneight1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screeneight2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screeneight3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screeneight4;
               }
               break;
          case 7:
               //               textToBeShown = @"Play more, Earn More Claim your unlocked rewards";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screeneight;
               }
               else if(languageCode == 1) {
                    textToBeShown = screeneight1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screeneight2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screeneight3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screeneight4;
               }
               break;
               
               
          default:
               break;
     }     _lblTutorial.text = textToBeShown;
}




- (IBAction)tutorialPressed:(id)sender {
     
     [self.view addSubview:tutorialView];
}

-(IBAction)SignInUsingGoogle:(id)sender{
     
     [_loadingView showInView:self.view withTitle:@"Sign in through Google ..."];
     
     [GPPSignIn sharedInstance].clientID = kClientId;
     NSArray *scopesArray = [NSArray arrayWithObjects:@"profile",nil];
     [GPPSignIn sharedInstance].scopes = scopesArray;
     [GPPSignIn sharedInstance].shouldFetchGooglePlusUser=YES;
     [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail=YES;
     [GPPSignIn sharedInstance].delegate=self;
     
     [[GPPSignIn sharedInstance] authenticate];
     
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
     
     
     NSLog(@"Received error %@ and auth object %@",error, auth);
     NSLog(@"Email: %@", [GPPSignIn sharedInstance].userEmail);
     if(error == NULL)
          [self fetch_ProfileInformation_From_Google];
     else
     {
          [_loadingView hide];
          
          [AlertMessage showAlertWithMessage:@"Recieved Error While Fetching information form Google. Try Again."  andTitle:@"Error" SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
          
          
          /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Recieved Error While Fetching information form Google. Try Again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
           [alertView show];*/
     }
}


-(void)fetch_ProfileInformation_From_Google{
     
     [_loadingView hide];
     
     GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
     plusService.retryEnabled = YES;
     [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
     GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
     
     [plusService executeQuery:query
             completionHandler:^(GTLServiceTicket *ticket,
                                 GTLPlusPerson *person,
                                 NSError *error) {
                  if (error) {
                       GTMLoggerError(@"Error: %@", error);
                       
                       [AlertMessage showAlertWithMessage:@"Recieved Error While Fetching information form Google. Try Again."  andTitle:@"Error" SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
                       
                       
                       /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Recieved Error While Fetching information form Google. Try Again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                        [alertView show];*/
                       
                  } else {
                       /*
                        // Retrieve the display name and "about me" text
                        //[person retain];
                        NSString *description = [NSString stringWithFormat:
                        @"%@\n%@\n%@", person.displayName,
                        person.gender, person.aboutMe];
                        NSLog(@"Persons Description: %@",description);
                        NSLog(@"Persons Description: %@",description);
                        */
                       email = [GPPSignIn sharedInstance].userEmail;
                       displayName = person.displayName;
                       gender = person.gender;
                       
                       if(person.birthday)
                            birthday = [self changeDateFormat:person.birthday ndFormat:@"YYYY-MM-dd" ndDesiredFormat:@"dd-MM-yyyy"];
                       else
                            birthday = @"";
                       lastRequestType = @"google";
                       [self sendRegistrationCall:false andRequestType:@"google"];
                  }
             }];
}



- (void)presentSignInViewController:(UIViewController *)viewController {
     
     [[self navigationController] pushViewController:viewController animated:YES];
}


-(void)sendRegistrationCall:(BOOL)hasSession andRequestType :(NSString*)request{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"userSocialLogin" forKey:@"method"];
     [postParams setObject:request forKey:@"request_type"];
     [postParams setObject:displayName forKey:@"display_name"];
     [postParams setObject:email forKey:@"email"];
     [postParams setObject:birthday forKey:@"birthday"];
     [postParams setObject:profileImageUrl forKey:@"profile_image"];
     [postParams setObject:user_name_id forKey:@"user_name_id"];
     [postParams setObject:language forKey:@"language"];
     if (hasSession)
          [postParams setObject:@"true" forKey:@"has_session"];
     else
          [postParams setObject:@"false" forKey:@"has_session"];
     [postParams setObject:gender forKey:@"gender"];
     
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [_loadingView hide];
          
          NSLog(@"Response: %@",[completedOperation responseString]);
          NSDictionary *responseDict = [completedOperation responseJSON];
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               [SharedManager getInstance].userID = [responseDict objectForKey:@"user_id"];
               [SharedManager getInstance].sessionID = [responseDict objectForKey:@"session_id"];
               if ([request isEqualToString:@"facebook"] || [request isEqualToString:@"twitter"])
               {
                    [SharedManager getInstance]._userProfile.isVerfied = @"Verified";
               }
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewLogin"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstTime"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               [self createTabBarAndControl];
          }
          else if([flag isEqualToNumber:[NSNumber numberWithInt:USER_ALREADY_FLAG]])
          {
              // [self DialogYes:self];
               /*    [AlertMessage showAlertWithMessage:@"You have already signed in from another device. Would you like to sign out from all other devices and sign in here?"  andTitle:@"Error"];
                */
               NSString *Title;
               NSString *message;
               NSString *cancel;
               NSString *otherButton;
               if(languageCode == 0 ) {
                    
                    
                    Title = @"Security Warning!";
                    message = @"You have already signed in from another device. Would you like to sign out from all other devices and sign in here?";
                    cancel= @"No" ;
                    otherButton = @"Yes";
                    
               }else if (languageCode == 1){
                    
                    Title = @"لقد حصل خطأ ما";
                    message =@" هذا المستخدم التوقيع بالفعل في الجهاز الآخر. لا تريد التوقيع في على هذا الجهاز؟";
                    cancel= @"لا";
                    otherButton = @"نعم";
                    
               }else if (languageCode == 2){
                    
                    Title = @"Erreur: Quelque chose s\'est mal passé!";
                    message = @"Cet utilisateur grace déjà un autre appareil. \ N Voulez-vous vous connecter sur cet appareil?";
                    cancel = @"No";
                    otherButton = @"Oui";
                    
                    
               }else if (languageCode == 3){
                    
                    Title = @"Algo salió mal!";
                    message = @"Usted ya ha firmado desde otro dispositivo.\n Te gustaría firmar su salida de todos los demás dispositivos y firme aquí?";
                    cancel = @"No";
                    otherButton=@"Sí";
                    
                    
               }else if(languageCode == 4){
                    
                    Title = @"Alguma coisa deu errado!";
                    message = @"Você já assinaram a partir de outro dispositivo.\n Gostaria de sair de todos os outros dispositivos e login aqui?";
                    cancel = @"Não";
                    otherButton = @"Sim";
                    
                    
               }
               //   [AlertMessage showAlertWithMessage:message andTitle:Title SingleBtn:NO cancelButton:cancel OtherButton:otherButton];
               
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:otherButton,nil];
               [alertView show];
          }
          else {
               /* [AlertMessage showAlertWithMessage:@"Please try again"  andTitle:@"Network Erro"];
                */
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"Check your internet connection setting.";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                    title = @"v";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
                    title = @"Error";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"Revise su configuración de conexión a Internet.";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Verifique sua configuração de conexão à Internet";
                    title = @"Error";
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:CANCEL SingleBtn:YES cancelButton:cancel OtherButton:nil];
               /*
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                [alertView show];*/
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
          
          [AlertMessage showAlertWithMessage:emailMsg  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          /* UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to Sign Up" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alert show];*/
          
          
     }];
     [_loadingView showInView:self.view withTitle:LoadingTitle];
     [engine enqueueOperation:op];
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
                                                      imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] ];
     
     [self.navController.tabBarItem setImage:[[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
      ];
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
     
    // UIViewController *historyViewController;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     
     //    0 - NO
     //     1 - YES
     
     if(buttonIndex == 1)
     {
          [self sendRegistrationCall:true andRequestType:lastRequestType];
     }
     
}
-(NSString *)changeDateFormat:(NSString *)_inputString ndFormat:(NSString *)_inputFormat ndDesiredFormat:(NSString *)_outputFormat{
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:_inputFormat];
     
     NSDate *dateInOldFormat = [dateFormatter dateFromString:_inputString];
     
     /// IGNORING TIME COMPONENT
     
     unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
     NSCalendar* calendar = [NSCalendar currentCalendar];
     NSDateComponents* components = [calendar components:flags fromDate:dateInOldFormat];
     NSDate* dateOnly = [calendar dateFromComponents:components];
     
     /// CHANGING FORMAT
     
     //[dateFormatter setDateFormat:@"YYYY-M-d"];
     [dateFormatter setDateFormat:_outputFormat];
     
     NSString *dateInNewFormat = [dateFormatter stringFromDate:dateOnly];
     
     return dateInNewFormat;
     
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if ([[arrayForBool objectAtIndex:section] boolValue]) {
          if(section == 0){
               return tutorialArray1.count;
          }
          else if(section == 1){
               return tutorialArray2.count;
          }
     }
     return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     
     UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
     UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
     headerView.tag                  = section;
     headerView.backgroundColor      = [UIColor whiteColor];
     UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
     
     if(IS_IPAD) {
          headerView.frame = CGRectMake(0, 0, 597, 90);
          backgroundImage.frame = CGRectMake(0, 0, 597, 90);
          headerString.frame = CGRectMake(0, 0, 597, 90);
          
          
     }
     BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
     
     if(section == 0){
          if (!manyCells) {
               headerString.text = HowtoPlay;
               
          }else{
               headerString.text = HowtoPlay;
          }
          backgroundImage.image = [UIImage imageNamed:@"blueBar.png"];
     }
     else if (section == 1){
          
          if (!manyCells) {
               headerString.text = HowtoEarnPoints;
          }else{
               headerString.text = HowtoEarnPoints;
          }
          backgroundImage.image = [UIImage imageNamed:@"pinkBar.png"];
          
          
     }
     //              else if (section == 2){
     //              if (!manyCells) {
     //                   headerString.text = HowWitsStore;
     //              }else{
     //                   headerString.text = HowWitsStore;
     //              }
     //              backgroundImage.image = [UIImage imageNamed:@"greenBar.png"];
     //         }
     
     
     [headerView addSubview:backgroundImage];
     headerString.textAlignment      = NSTextAlignmentCenter;
     headerString.textColor          = [UIColor whiteColor];
     if(IS_IPAD) {
          headerString.font = [UIFont fontWithName:FONT_NAME size:20];
     }
     [headerView addSubview:headerString];
     
     UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
     [headerView addGestureRecognizer:headerTapped];
     
     //up or down arrow depending on the bool
     //    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"down_arow.png"]];
     //    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
     //    upDownArrow.frame               = CGRectMake(55, 21, 10, 10);
     //     if(IS_IPAD) {
     //          upDownArrow.frame               = CGRectMake(15, 30, 15, 15);
     //     }
     //    [headerView addSubview:upDownArrow];
     //
     return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
     return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if(IS_IPAD) {
          return 89;
     }
     return 49;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
          if(IS_IPAD) {
               return 90;
          }
          return 50;
     }
     return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *CellIdentifier = @"Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
               cell.accessoryType = UITableViewCellAccessoryNone;
          }
     }
     BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
     if (!manyCells) {
          cell.textLabel.text = @"click to enlarge";
     }
     else{
          
          int row = indexPath.section;
          if(row == 0){
               cell.textLabel.text = [tutorialArray1 objectAtIndex:indexPath.row];
          }
          else if(row == 1){
               cell.textLabel.text = [tutorialArray2 objectAtIndex:indexPath.row];
          }
          //          else if(row == 2){
          //               cell.textLabel.text = [tutorialArray3 objectAtIndex:indexPath.row];
          //          }
          cell.textLabel.numberOfLines = 3;
          cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:13];
          cell.textLabel.textAlignment = NSTextAlignmentLeft;
          
          if (languageCode == 1) {
               cell.textLabel.textAlignment = NSTextAlignmentRight;
          }
          
          if(IS_IPAD) {
               cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:20];
          }
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
     if (indexPath.row == 0) {
          BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
          collapsed       = !collapsed;
          [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
          
          //reload specific section animated
          NSRange range   = NSMakeRange(indexPath.section, 1);
          NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
          [expandView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
     }
}
-(void)rel{
     //    [dropDown release];
     dropDown = nil;
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
     if(sender.selectedIndex == 0) {
          [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"languageCode"];
          [[NSUserDefaults standardUserDefaults ]setObject:@"English(US)" forKey:@"LangTitle"];
          
     }
     else if (sender.selectedIndex == 1) {
          [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"languageCode"];
          [[NSUserDefaults standardUserDefaults ]setObject:@"Arabic(Ar)" forKey:@"LangTitle"];
     }
     else if (sender.selectedIndex == 2) {
          [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"languageCode"];
          [[NSUserDefaults standardUserDefaults ]setObject:@"French(Fr)" forKey:@"LangTitle"];
     }
     else if (sender.selectedIndex == 3) {
          [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"languageCode"];
          [[NSUserDefaults standardUserDefaults ]setObject:@"Spanish(Es)" forKey:@"LangTitle"];
     }
     else if (sender.selectedIndex == 4) {
          [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"languageCode"];
          [[NSUserDefaults standardUserDefaults ]setObject:@"Portuguese(Pt)" forKey:@"LangTitle"];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];
     [self rel];
}

-(void)setLanguage {
     /*
      IBOutlet UIButton *twitterBtn;
      IBOutlet UIButton *signUpBtn;
      IBOutlet UILabel *alreadyLbl;
      IBOutlet UILabel *logInBtn;
      IBOutlet UIButton *tutorialBtn;
      IBOutlet UILabel *languageSelectionLbl;
      IBOutlet UILabel *chooseLangLbl;
      IBOutlet UILabel *tutorialLbl;
      IBOutlet UILabel *knowledgelbl;
      IBOutlet UILabel *tutorialDescLbl;
      IBOutlet UILabel *tutorialDescLbl2;
      */
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          LoadingTitle = Loading;
          alreadyLbl.text = ALREADY_LBL;
          languageSelectionLbl.text = LANGUAGE_SELECTION_LBL;
          chooseLangLbl.text = CHOOSE_LANG_LBL;
          orLabel.text = OR_TEXT;
          howtoPlay1 = @"Embark on a 1-1 challenge against anyone in the world.";
          howtoPlay2 = @"The faster you answer the more Gems you\'ll collect.";
          howtoPlay3 = @"Claim your rewards.";
          UIColor *color = [UIColor whiteColor];
          [forgotpasswordSigninButtonn setTitle:[@"Back To Sign in" uppercaseString]
                                       forState:UIControlStateNormal];
          emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Email or Username" attributes:@{NSForegroundColorAttributeName: color}];
          pswdTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD attributes:@{NSForegroundColorAttributeName: color}];
          //           [forgotPasswordLabel setTitle:SIGNUP_FORGOT_PASS forState:UIControlStateNormal];
          forgot_password_button_text_label.text =SIGNUP_FORGOT_PASS;
          tutoStr1 = TUTORIAL_STR_1;
          tutoStr2 = TUTORIAL_STR_2;
          tutoStr3 = TUTORIAL_STR_3;
          tutoStr4 = TUTORIAL_STR_4;
          signuplabelTextbelow.text = SIGNUP_REGISTER;
          HowtoPlay = @"How to Play";
          HowWitsStore = @"How to Use WITS Store";
          HowtoEarnPoints = @"How to Earn Free Points";
          //UIColor *colors = [UIColor whiteColor];
          _resetPswdEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Email ID" attributes:@{NSForegroundColorAttributeName: color}];
          howtouseStoreDesc = @"Sign up now and get your hands on 100 free Gems.";
          howtoEarnPointDesc = @"You can always earn free Points simply by inviting your friends and sharing the app on Facebook or Twitter.";
          [_resetButtonOutlet setTitle:@"Reset Password" forState:UIControlStateNormal];
          logInBtn.text = LOGIN_BTN;
          [skipbtn setTitle:@"SKIP" forState:UIControlStateNormal];
          [LoginBtnOutlet setTitle:@"LOG IN" forState:UIControlStateNormal];
          [twitterBtn setTitle:TWITTER_BTN forState:UIControlStateNormal];
          [signUpBtn setTitle:SIGNUP_BTN forState:UIControlStateNormal];
          [tutorialBtn setTitle:TUTORIAL_BTN forState:UIControlStateNormal];
          [backLbl setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          
          forgot_password_button_text_label.text =SIGNUP_FORGOT_PASS_1;
          LoadingTitle = Loading_1;
          orLabel.text = OR_TEXT_1;
          //emailTxt.placeholder = SIGNUP_EMAIL_1;
          alreadyLbl.text = ALREADY_LBL_1;
          languageSelectionLbl.text = LANGUAGE_SELECTION_LBL_1;
          chooseLangLbl.text = CHOOSE_LANG_LBL_1;
          //pswdTxt.placeholder = SIGNUP_PASSWORD_1;
          UIColor *color = [UIColor whiteColor];
          [forgotpasswordSigninButtonn setTitle:@"العودة إلى تسجيل الدخول" forState:UIControlStateNormal];
          emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"أدخل البريد الإلكتروني أو اسم المستخدم" attributes:@{NSForegroundColorAttributeName: color}];
          pswdTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_1 attributes:@{NSForegroundColorAttributeName: color}];
          tutorialLbl.text = TUTORIAL_LBL_1;
          knowledgelbl.text = KNOWLEDGE_LBL_1;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_1;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_1;
          tutorialDescLbl.textAlignment = NSTextAlignmentRight;
          tutorialDescLbl2.textAlignment = NSTextAlignmentRight;
          signuplabelTextbelow.text = SIGNUP_REGISTER_1;
          tutoStr1 = TUTORIAL_STR_1_1;
          tutoStr2 = TUTORIAL_STR_2_1;
          tutoStr3 = TUTORIAL_STR_3_1;
          tutoStr4 = TUTORIAL_STR_4_1;
          [_resetButtonOutlet setTitle:@"إعادة تعيين كلمة المرور" forState:UIControlStateNormal];
          howtoPlay1 = @"أسرع في دخول تحدي ضد أي شخص في العالم ";
          howtoPlay2 = @"اسرع في الاجابة للحصول على نقاط اكثر";
          howtoPlay3 = @"قم باستبدال جواهرك بنقود حقيقية.";
          //UIColor *color = [UIColor whiteColor];
          _resetPswdEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"الرجاء إدخال عنوان البريد الإلكتروني" attributes:@{NSForegroundColorAttributeName: color}];
          howtouseStoreDesc = @"اشترك الآن و احصل على 1000 نقطة مجانا.";
          howtoEarnPointDesc = @"يمكنك أن تحصل دائماً على النقاط مجانية بمجرد دعوة اصدقائك للعب و بمشاركة تطبيق اللعبة على الفيس بوك أو تويتر";
          HowtoPlay = @"كيفية اللعب";
          HowWitsStore = @"كيفية استخدام مخزن ويتس";
          HowtoEarnPoints = @"كيف تحصل على النقاط مجاناً؟";
          
          
          
          logInBtn.text = LOGIN_BTN_1;
          
          
          [skipbtn setTitle:@"تخطي" forState:UIControlStateNormal];
          [LoginBtnOutlet setTitle:@"تسجيل الدخول" forState:UIControlStateNormal];
          [twitterBtn setTitle:TWITTER_BTN_1 forState:UIControlStateNormal];
          [signUpBtn setTitle:SIGNUP_BTN_1 forState:UIControlStateNormal];
          [tutorialBtn setTitle:TUTORIAL_BTN_1 forState:UIControlStateNormal];
          [backLbl setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          LoadingTitle = Loading_2;
          alreadyLbl.text = ALREADY_LBL_2;
          languageSelectionLbl.text = LANGUAGE_SELECTION_LBL_2;
          chooseLangLbl.text = CHOOSE_LANG_LBL_2;
          forgot_password_button_text_label.text =SIGNUP_FORGOT_PASS_2;
          tutorialLbl.text = TUTORIAL_LBL_2;
          orLabel.text = OR_TEXT_2;
          knowledgelbl.text = KNOWLEDGE_LBL_2;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_2;
          //pswdTxt.placeholder = SIGNUP_PASSWORD_2;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_2;
          signuplabelTextbelow.text = SIGNUP_REGISTER_2;
          tutoStr1 = TUTORIAL_STR_1_2;
          tutoStr2 = TUTORIAL_STR_2_2;
          //emailTxt.placeholder = SIGNUP_EMAIL_2;
          UIColor *color = [UIColor whiteColor];
          [forgotpasswordSigninButtonn setTitle:[@"retour a connexion" uppercaseString]
                                       forState:UIControlStateNormal];
          emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Saisissez votre email ou nom d\'utilisateur" attributes:@{NSForegroundColorAttributeName: color}];
          pswdTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_2 attributes:@{NSForegroundColorAttributeName: color}];
          tutoStr3 = TUTORIAL_STR_3_2;
          tutoStr4 = TUTORIAL_STR_4_2;
          [_resetButtonOutlet setTitle:@"Restablecer contraseña" forState:UIControlStateNormal];
          HowtoPlay = @"Comment jouer";
          HowWitsStore = @"Comment utiliser ESPRITS magasin";
          HowtoEarnPoints = @"Comment gagner des Points";
          howtoPlay1 = @"Défiez à 1-1 n\'importe qui dans le monde.";
          howtoPlay2 = @"Plus vite vous répondez, plus vous cumulez de Gems.";
          howtoPlay3 = @"Echangez vos Gems contre de l'argent.";
          //UIColor *color = [UIColor whiteColor];
          _resetPswdEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Introducir ID email" attributes:@{NSForegroundColorAttributeName: color}];
          
          howtouseStoreDesc = @"Inscrivez-vous maintenant et gagnez 1000 Gems gratuits.";
          howtoEarnPointDesc = @"Vous pouvez toujours gagner des Points en invitant vos amis et en partageant notre application sur Facebook et Twitter.";
          
          logInBtn.text = LOGIN_BTN_2;
          [skipbtn setTitle:@"sauter" forState:UIControlStateNormal];
          [LoginBtnOutlet setTitle:@"INICIAR" forState:UIControlStateNormal];
          [twitterBtn setTitle:TWITTER_BTN_2 forState:UIControlStateNormal];
          [signUpBtn setTitle:SIGNUP_BTN_2 forState:UIControlStateNormal];
          [tutorialBtn setTitle:TUTORIAL_BTN_2 forState:UIControlStateNormal];
          [backLbl setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          
     }
     
     
     else if(languageCode == 3) {
          
          LoadingTitle = Loading_3;
          signuplabelTextbelow.text = SIGNUP_REGISTER_3;
          alreadyLbl.text = ALREADY_LBL_3;
          languageSelectionLbl.text = LANGUAGE_SELECTION_LBL_3;
          chooseLangLbl.text = CHOOSE_LANG_LBL_3;
          orLabel.text = OR_TEXT_3;
          tutorialLbl.text = TUTORIAL_LBL_3;
          forgot_password_button_text_label.text =SIGNUP_FORGOT_PASS_3;          knowledgelbl.text = KNOWLEDGE_LBL_3;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_3;
          //pswdTxt.placeholder = SIGNUP_PASSWORD_3;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_3;
          //emailTxt.placeholder = SIGNUP_EMAIL_3;
          UIColor *color = [UIColor whiteColor];
          [forgotpasswordSigninButtonn setTitle:[@": Volver al inicio de sesión" uppercaseString]
                                       forState:UIControlStateNormal];
          emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Introducir email o nombre de usuario" attributes:@{NSForegroundColorAttributeName: color}];
          pswdTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_3 attributes:@{NSForegroundColorAttributeName: color}];
            [_resetButtonOutlet setTitle:@"réinitialiser le mot de" forState:UIControlStateNormal];
          tutoStr1 = TUTORIAL_STR_1_3;
          tutoStr2 = TUTORIAL_STR_2_3;
          tutoStr3 = TUTORIAL_STR_3_3;
          tutoStr4 = TUTORIAL_STR_4_3;
         // UIColor *color = [UIColor whiteColor];
          _resetPswdEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Entrez Email ID" attributes:@{NSForegroundColorAttributeName: color}];
          HowtoPlay = @"Cómo jugar";
          HowWitsStore = @"Cómo utilizar WITS tienda";
          HowtoEarnPoints = @"Cómo ganar pontus.";
          
          howtoPlay1 = @" Inicie un reto 1-1 contra a cualquiera en el mundo.";
          howtoPlay2 = @"En cuanto más rápido responde más puntos podrá recoger.";
          howtoPlay3 = @"Cambia tus gemas por dinero real.";
          
          howtouseStoreDesc = @"Registrase ahora y gane 1000 puntos gratis";
          howtoEarnPointDesc = @"Puedes ganar pontus gratis invitando a tus amigos y compartiendo la aplicación en Facebook or Twitter.";
          
          logInBtn.text = LOGIN_BTN_3;
          [LoginBtnOutlet setTitle:@"Identifiant" forState:UIControlStateNormal];
          [twitterBtn setTitle:TWITTER_BTN_3 forState:UIControlStateNormal];
          [signUpBtn setTitle:SIGNUP_BTN_3 forState:UIControlStateNormal];
          [tutorialBtn setTitle:TUTORIAL_BTN_3 forState:UIControlStateNormal];
          [backLbl setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [skipbtn setTitle:@"Skip" forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          LoadingTitle = Loading_4;
         // emailTxt.placeholder = SIGNUP_EMAIL_4;
          forgot_password_button_text_label.text =SIGNUP_FORGOT_PASS_4;
          tutoStr1 = TUTORIAL_STR_1_4;
          tutoStr2 = TUTORIAL_STR_2_4;
          tutoStr3 = TUTORIAL_STR_3_4;
          orLabel.text = OR_TEXT_4;
         // pswdTxt.placeholder = SIGNUP_PASSWORD_4;
          tutoStr4 = TUTORIAL_STR_4_4;
          signuplabelTextbelow.text = SIGNUP_REGISTER_4;
          //UIColor *color = [UIColor whiteColor];
          
          UIColor *color = [UIColor whiteColor];
          [forgotpasswordSigninButtonn setTitle:[@" Voltar para acessar" uppercaseString]
                                       forState:UIControlStateNormal];
          emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Digite o E-mail ou Usuário" attributes:@{NSForegroundColorAttributeName: color}];
          pswdTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SIGNUP_PASSWORD_4 attributes:@{NSForegroundColorAttributeName: color}];
          _resetPswdEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Digite o E-mail" attributes:@{NSForegroundColorAttributeName: color}];
          howtoPlay1 = @"Inicie um desafio de 1-1 contra qualquer pessoa no mundo.";
          
          howtoPlay2 = @"Quanto mais rápido você responder, mais pontos você vai acumular.";
          howtoPlay3 = @"Troque as suas Gemas por dinheiro verdadeiro.";
          
          howtouseStoreDesc = @"Inscreva-se gratuitamente e ganhe 1000 pontos";
          howtoEarnPointDesc = @"Poderá receber pontus Grátis a todo momento ao convidar os seus amigos ou ao partilhar a App no Facebook ou Twitter.";
          HowtoPlay = @"Como Jogar";
          HowWitsStore = @"Como usar WITS loja";
          HowtoEarnPoints = @"Como ganhar pontus grátis";
          
            [_resetButtonOutlet setTitle:@"Redefinir senha" forState:UIControlStateNormal];
          alreadyLbl.text = ALREADY_LBL_4;
          languageSelectionLbl.text = LANGUAGE_SELECTION_LBL_4;
          chooseLangLbl.text = CHOOSE_LANG_LBL_4;
          tutorialLbl.text = TUTORIAL_LBL_4;
          knowledgelbl.text = KNOWLEDGE_LBL_4;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_4;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_4;
          logInBtn.text = LOGIN_BTN_4;
          [LoginBtnOutlet setTitle:@"Usuário" forState:UIControlStateNormal];
          [twitterBtn setTitle:TWITTER_BTN_4 forState:UIControlStateNormal];
          [signUpBtn setTitle:SIGNUP_BTN_4 forState:UIControlStateNormal];
          [tutorialBtn setTitle:TUTORIAL_BTN_4 forState:UIControlStateNormal];
          [backLbl setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [skipbtn setTitle:@"Pular" forState:UIControlStateNormal];
     }
     
     if(languageCode == 0 ) {
          
          
          security_War = @"Security Warning!";
          Already_loggedin_msg = @"You have already signed in from another device. Would you like to sign out from all other devices and sign in here?";
          Nobtn= @"No" ;
          yesbtn = @"Yes";
          
     }else if (languageCode == 1){
          
          security_War = @"لقد حصل خطأ ما";
          Already_loggedin_msg =@" هذا المستخدم التوقيع بالفعل في الجهاز الآخر. لا تريد التوقيع في على هذا الجهاز؟";
          Nobtn= @"لا";
          yesbtn = @"نعم";
          
     }else if (languageCode == 2){
          
          security_War = @"Erreur: Quelque chose s\'est mal passé!";
          Already_loggedin_msg = @"Cet utilisateur grace déjà un autre appareil. \ N Voulez-vous vous connecter sur cet appareil?";
          Nobtn = @"No";
          yesbtn = @"Oui";
          
          
     }else if (languageCode == 3){
          
          security_War = @"Algo salió mal!";
          Already_loggedin_msg = @"Usted ya ha firmado desde otro dispositivo.\n Te gustaría firmar su salida de todos los demás dispositivos y firme aquí?";
          Nobtn = @"No";
          yesbtn=@"Sí";
          
          
     }else if(languageCode == 4){
          
          security_War = @"Alguma coisa deu errado!";
          Already_loggedin_msg = @"Você já assinaram a partir de outro dispositivo.\n Gostaria de sair de todos os outros dispositivos e login aqui?";
          Nobtn = @"Não";
          yesbtn = @"Sim";
          
          
     }
}

#pragma text field delegates method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     DontSwipe = true;
     [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     DontSwipe = false;
     [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
      //[self animateTextField: textField up: NO];
     [textField resignFirstResponder];
     return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     const int movementDistance = 145; // tweak as needed
     const float movementDuration = 0.2f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
}

#pragma Login Call
-(void)sendLoginCall:(BOOL)isAlreadyLogin{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
      [postParams setObject:language forKey:@"language"];
     [postParams setObject:@"userLogin" forKey:@"method"];
     if(![self validateEmail:emailTxt.text])
     {
          [postParams setObject:emailTxt.text forKey:@"user_name_id"];
     }
     else
          [postParams setObject:emailTxt.text forKey:@"email"];
     [postParams setObject:pswdTxt.text forKey:@"password"];
     if(isAlreadyLogin == false)
          [postParams setObject:@"false" forKey:@"has_session"];
     else
          [postParams setObject:@"true" forKey:@"has_session"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [_loadingView hide];
          
          // extract user id and session id using json parser and save it in shared manager
          NSDictionary *responseDict = [completedOperation responseJSON];
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:USER_ALREADY_FLAG]])
          {
               
               
               dialogTitle.text = security_War;
               DialogMsg.text = Already_loggedin_msg;
               [Dialogyes setTitle:yesbtn forState:UIControlStateNormal];
               [Dialogno setTitle:Nobtn forState:UIControlStateNormal];
               [self DialogYes:nil];
               if(IS_IPHONE_4){
                    DialogView.frame = CGRectMake(0, 0, 320, 480);
               }else if (IS_IPHONE_5){
                    DialogView.frame = CGRectMake(0, 0, 320, 568);
               }else if (IS_IPHONE_6){
                    DialogView.frame = CGRectMake(0, 0, 375, 667);
               }
               
              // [self.view addSubview:DialogView];
               
          }
          else if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               
               [SharedManager getInstance].userID = [responseDict objectForKey:@"user_id"];
               [SharedManager getInstance].sessionID = [responseDict objectForKey:@"session_id"];
               
               [[SharedManager getInstance] saveModel];
               
               
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewLogin"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstTime"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               [self createTabBarAndControl];
          }
          else if([flag isEqualToNumber:[NSNumber numberWithInt:INVALID_CREDENTIALS]])
          {
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"Email or Password doesn't match.";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"البريد الإلكتروني أو كلمة المرور غير صحيحة!";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"E-mail ou mot de passe incorrecte!";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"Correo electrónico o contraseña incorrectos!";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"E-mail ou senha incorreto!";
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          }
     } onError:^(NSError* error) {
          
          [_loadingView hide];
          
          NSString *emailMsg;
          NSString *title;
          
          
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Unable to Sign in.";
               Ok = OK_BTN;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"غير قادر على تسجيل الدخول";
               Ok = OK_BTN_1;
          }else if (languageCode == 2){
               Ok = OK_BTN_2;
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Impossible de se connecter";
               
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"No se pudo conectar ";
               Ok = OK_BTN_3;
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Incapaz de fazer login";
               Ok = OK_BTN_4;
          }
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:Ok OtherButton:nil];
     }];
     [_loadingView showInView:self.view withTitle:LoadingTitle];
     [engine enqueueOperation:op];
     
}
- (IBAction)DialogYes:(id)sender {
     
     [self sendLoginCall:true];
     //[DialogView removeFromSuperview];
}

- (IBAction)DialogNo:(id)sender {
     [DialogView removeFromSuperview];
}
-(BOOL)validateEmail:(NSString *)candidate {
     
     NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     
     return [emailTest evaluateWithObject:candidate];
}
- (IBAction)resetPasswordPressed:(id)sender {
     CATransition *transition = [CATransition animation];
     transition.duration = 0.3;
     transition.type = kCATransitionPush; //choose your animation
     transition.subtype = kCATransitionFromBottom;
     [_resetPswdView.layer addAnimation:transition forKey:nil];
     _resetPswdView.hidden = false;
     [self.view addSubview:_resetPswdView];
     
     UIColor *color = [UIColor whiteColor];
     //_resetPswdEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER EMAIL ID" attributes:@{NSForegroundColorAttributeName: color}];
     
}
- (IBAction)sendResetPswdCall:(id)sender {
     if(![self validateEmail:_resetPswdEmail.text])
     {
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          
          if (languageCode == 0 ) {
               emailMsg = @"Please enter some valid email address.";
               title = @"Error";
               cancel = CANCEL;
          }else if(languageCode == 1) {
               emailMsg = @"!تعيين تنسيق البريد الإلكتروني الصحيح";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Régler le format électronique approprié!";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Ajustar el formato de correo electrónico correcta!";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Definir o formato de e-mail correto!";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }
     /*
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter some valid email address." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
      
      [alertView show];
      return;*/
     
     else{
          
          [self sendForgotPasswordRequest];
     }
}

- (IBAction)signInView:(id)sender {
     [_resetPswdView removeFromSuperview];
}

-(void)sendForgotPasswordRequest{
     [_loadingView showInView:self.view withTitle:LoadingTitle];
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"userPasswordReset" forKey:@"method"];
     [postParams setObject:_resetPswdEmail.text forKey:@"email"];
     [postParams setObject:language forKey:@"language"];
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          NSLog(@"Response: %@",[completedOperation responseString]);
          
          // extract user id and session id using json parser and save it in shared manager
          
          NSDictionary *responseDict = [completedOperation responseJSON];
          //NSString *flag = [responseDict objectForKey:@"flag"];
          NSString *message = [responseDict objectForKey:@"message"];
          
          
          [_loadingView hide];
          _resetPswdEmail.text = nil;
          if ([message isEqualToString:@"Password Reset Email has been sent successfully"]){
               [_resetPswdEmail resignFirstResponder];
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"Password Reset Email has been sent successfully";
                    title = @"Password Reset";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"تم إرسال البريد الإلكتروني لإعادة تعيين كلمة المرور بنجاح";
                    title = @"إعادة تعيين كلمة المرور";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"El correo electrónico del cambio de la contraseña ha sido enviado satisfactoriamente";
                    title = @"réinitialiser le mot de";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"L'e-mail de réinitialisation de mot de passe vous a été envoyé avec succès.";
                    title = @"Restablecer contraseña";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Foi enviado um e-mail para restabelecer a senha";
                    title = @"Redefinir senha";
                    cancel = CANCEL_4;
               }
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:Ok OtherButton:nil];
               
               /*  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];*/
          }else if ([message isEqualToString:@"Provided Email not registered!"]){
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"Email id is incorrect!";
                    title = @"Reset Password";
                    cancel = OK_BTN;
               } else if(languageCode == 1) {
                    emailMsg = @"البريد الإلكتروني غير صحيح";
                    title = @"إعادة تعيين كلمة المرور";
                    cancel = OK_BTN_1;
               }else if (languageCode == 2){
                    emailMsg = @"Votre adresse email est incorrecte";
                    title = @"réinitialiser le mot de";
                    cancel = OK_BTN_2;
               }else if (languageCode == 3){
                    emailMsg = @"Su correo electrónico es incorrecto";
                    title = @"Restablecer contraseña";
                    cancel = OK_BTN_3;
               }else if (languageCode == 4){
                    emailMsg = @"O endereço de email está incorreto";
                    title = @"Redefinir senha";
                    cancel = OK_BTN_4;
               }
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:Ok OtherButton:nil];
               
               
          }
          
     } onError:^(NSError* error) {
          
          //[loading hide];
          
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
          
          /*    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error .." message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alert show];*/
          
          
          
     }];
     [engine enqueueOperation:op];
}
@end
