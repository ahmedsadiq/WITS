//
//  LoginVC.h
//  Yolo
//
//  Created by Salman Khalid on 12/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "AppDelegate.h"
#import "GetTopicsVC.h"

@interface LoginVC : UIViewController{
     
     UIView *forgotPasswordView;
     UIView *LoginView;
     
     NSString *language;
     int languageCode;
     NSString * LoadingTitle;
     NSString *Ok;
     IBOutlet UITextField *emailField;
     IBOutlet UITextField *passwordField;
     IBOutlet UITextField *forgotEmailField;
     LoadingView *loadingView;
     AppDelegate *emailOBJ;
     
     IBOutlet UIView *VerificationView;
     IBOutlet UIButton *backBtn1;
     IBOutlet UIButton *resetBtn;
     IBOutlet UIButton *backBtn;
     IBOutlet UIButton *forgetPassOutlet;
     
     IBOutlet UILabel *forgetPasswordTitle;
     IBOutlet UILabel *forgetpassLbl;
     IBOutlet UILabel *loginLbl;
     IBOutlet UIButton *loginBtn;
     
     NSString *security_War;
     NSString *Already_loggedin_msg;
     NSString *Nobtn;
     NSString *yesbtn;
     
     IBOutlet UIView *DialogView;
     IBOutlet UILabel *dialogTitle;
     IBOutlet UILabel *DialogMsg;
     
     IBOutlet UIButton *Dialogno;
     IBOutlet UIButton *Dialogyes;
     //NSString *avaribale;
}
- (IBAction)DialogYes:(id)sender;
- (IBAction)DialogNo:(id)sender;


@property (strong, nonatomic) IBOutlet UITextView *verifyTxt;
@property (strong, nonatomic) IBOutlet UILabel *verifyTitle;

@property (nonatomic, retain) IBOutlet UIView *forgotPasswordView;
@property (nonatomic, retain) IBOutlet UIView *LoginView;
@property (strong, nonatomic) IBOutlet UIButton *verifyOkPressed;
@property (strong, nonatomic) IBOutlet UILabel *verifyEmailLbl;

@property ( strong , nonatomic ) UITabBarController *tabBarController;
@property (strong, nonatomic) GetTopicsVC *viewController;
@property ( strong , nonatomic ) UINavigationController *navController;

- (IBAction)verifyOkPressed:(id)sender;

-(IBAction)forgotPassword:(id)sender;
-(IBAction)LoginInuser:(id)sender;
-(IBAction)SendResetPasswordRequest:(id)sender;
-(IBAction)switchToLoginView:(id)sender;
-(IBAction)back:(id)sender;

@end
