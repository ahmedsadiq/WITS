//
//  LoginVC.m
//  Yolo
//
//  Created by Salman Khalid on 12/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "LoginVC.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "SharedManager.h"
#import "NavigationHandler.h"
#import "AlertMessage.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "FriendsVC.h"
#import "StoreVC.h"
#import "EarnFreePointsViewController.h"
#import "SettingVC.h"
#import "RightBarVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

@synthesize forgotPasswordView,LoginView;

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
     [self setLanguageForScreen];
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
          emailOBJ = (AppDelegate *) [[UIApplication sharedApplication]delegate];
     
     // Do any additional setup after loading the view from its nib.
     loadingView = [[LoadingView alloc] init];
}
-(void)setLanguageForScreen {
     
     /*
      IBOutlet UITextField *emailField;
      IBOutlet UITextField *passwordField;
      IBOutlet UITextField *forgotEmailField;
      */
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          LoadingTitle = Loading;
          Ok = OK_BTN;
          emailField.placeholder = LOGIN_EMAIL;
          passwordField.placeholder = LOGIN_PASSWORD;
          forgotEmailField.placeholder = LOGIN_FORGOT_PSWD;
          loginLbl.text = LOGIN_LOGIN_BTN;
          forgetpassLbl.text =@"Forgot Password?";
          forgetPasswordTitle.text =@"Forgot Password";
          _verifyTxt.text = @"To activate your account, Please click the verification link that has been sent to";
          _verifyTitle.text = @"Verify your WITS account";
          
          [forgetPassOutlet setTitle:@"Forgot Password?" forState:UIControlStateNormal];
          [loginBtn setTitle:LOGIN_LOGIN_BTN forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN forState:UIControlStateNormal];
          [resetBtn setTitle:@"RESET" forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          LoadingTitle = Loading_1;
          emailField.placeholder = LOGIN_EMAIL_1;
          passwordField.placeholder = LOGIN_PASSWORD_1;
          forgotEmailField.placeholder = LOGIN_FORGOT_PSWD_1;
          loginLbl.text = LOGIN_LOGIN_BTN_1;
          forgetpassLbl.text = @"نسيت كلمة السر؟ ";
          forgetPasswordTitle.text = @"نسيت كلمة السر";
          _verifyTxt.text = @"لتفعيل حسابك، يرجى النقر على رابط التحقق الذي تم إرساله إلى";
          _verifyTitle.text = @"الرجاء التحقق من حساب ويتس الخاص بك";
          
          Ok = OK_BTN_1;
          
          [forgetPassOutlet setTitle:@"نسيت كلمة السر " forState:UIControlStateNormal];
          [loginBtn setTitle:LOGIN_LOGIN_BTN_1 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [resetBtn setTitle:@"إعادة تعيين كلمة المرور" forState:UIControlStateNormal];
          
          loginLbl.textAlignment = NSTextAlignmentRight;
          emailField.textAlignment = NSTextAlignmentRight;
          passwordField.textAlignment = NSTextAlignmentRight;
          forgotEmailField.textAlignment = NSTextAlignmentRight;
     }
     else if(languageCode == 2) {
          
          LoadingTitle = Loading_2;
          emailField.placeholder = LOGIN_EMAIL_2;
          passwordField.placeholder = LOGIN_PASSWORD_2;
          forgotEmailField.placeholder = LOGIN_FORGOT_PSWD_2;
          loginLbl.text = LOGIN_LOGIN_BTN_2;
          forgetpassLbl.text = @"Oublié Mot de passe?";
          forgetPasswordTitle.text = @"Oublié Mot de passe?";
          Ok = OK_BTN_2;
          _verifyTxt.text = @"Pour activer votre compte, veuillez cliquer sur le lien envoyé à votre adresse";
          _verifyTitle.text =@"Vérifier votre compte WITS";
          
          [forgetPassOutlet setTitle:@"Oublié Mot de passe?" forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [resetBtn setTitle:@"réinitialiser le mot de" forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [loginBtn setTitle:LOGIN_LOGIN_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          LoadingTitle = Loading_3;
          emailField.placeholder = LOGIN_EMAIL_3;
          passwordField.placeholder = LOGIN_PASSWORD_3;
          forgotEmailField.placeholder = LOGIN_FORGOT_PSWD_3;
          loginLbl.text = LOGIN_LOGIN_BTN_3;
          forgetpassLbl.text = @"Olvidado Contraseña?";
            forgetPasswordTitle.text = @"Olvidado Contraseña";
          Ok = OK_BTN_3;
          _verifyTxt.text = @"Para activar su cuenta WITS, por favor haga click en el vínculo del mensaje de correo electrónico de comprobación.";
          _verifyTitle.text = @"Comprobar su cuenta WITS";
          
          [forgetPassOutlet setTitle:@"Olvidado Contraseña?" forState:UIControlStateNormal];
          [resetBtn setTitle:@"Restablecer contraseña" forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [loginBtn setTitle:LOGIN_LOGIN_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          LoadingTitle = Loading_4;
          emailField.placeholder = LOGIN_EMAIL_4;
          passwordField.placeholder = LOGIN_PASSWORD_4;
          forgotEmailField.placeholder = LOGIN_FORGOT_PSWD_4;
          loginLbl.text = LOGIN_LOGIN_BTN_4;
          forgetpassLbl.text = @"Esqueceu Senha?";
           forgetPasswordTitle.text = @"Esqueceu Senha?";
          Ok = OK_BTN_4;
          _verifyTitle.text = @"Verifique sua conta WITS";
          _verifyTxt.text = @"Para ativar sua conta, Por favor click no link the verificação que foi enviado para ";
          
          [forgetPassOutlet setTitle:@"Esqueceu Senha?" forState:UIControlStateNormal];
          [resetBtn setTitle:@"Redefinir senha" forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [loginBtn setTitle:LOGIN_LOGIN_BTN_4 forState:UIControlStateNormal];
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

     
     [_verifyOkPressed setTitle:Ok forState:UIControlStateNormal];
     if (languageCode == 1) {
          loginLbl.textAlignment = NSTextAlignmentRight;
          emailField.textAlignment = NSTextAlignmentRight;
          passwordField.textAlignment = NSTextAlignmentRight;
          forgotEmailField.textAlignment = NSTextAlignmentRight;
     } else {
          loginLbl.textAlignment = NSTextAlignmentLeft;
          emailField.textAlignment = NSTextAlignmentLeft;
          passwordField.textAlignment = NSTextAlignmentLeft;
          forgotEmailField.textAlignment = NSTextAlignmentLeft;
     }
}

- (IBAction)verifyOkPressed:(id)sender {
     
     [VerificationView removeFromSuperview];
   
     
}

-(IBAction)forgotPassword:(id)sender{
     
     NSLog(@"Forgot Password called");
     [self.view addSubview:forgotPasswordView];
}

-(IBAction)LoginInuser:(id)sender{
     
   
     emailOBJ.LoginEmail = emailField.text;
          NSLog(@"Login User");
     
     if(![self validateEmail:emailField.text])
     {
          NSString *emailMsg;
          NSString *title;
          if (languageCode == 0 ) {
               emailMsg = @"Please enter some valid email address.";
               title = @"Error";
          } else if(languageCode == 1) {
               emailMsg = @"الرجاء تقديم عنوان بريدك الإلكتروني الصحيح!";
               title = @"خطأ";
          }else if (languageCode == 2){
               emailMsg = @"Veuillez fournir une adresse e-mail correcte!";
               title = @"Erreur";
          }else if (languageCode == 3){
               emailMsg = @"Por favor ingrese un correo electrónico correcto!";
               title = @"Error";
          }else if (languageCode == 4){
               emailMsg = @"Por favor, forneça um endereço de e-mail correto!";
               title = @"Erro";
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
          
          /*   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter some valid email address." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           
           [alertView show];
           return;*/
     }else{
          
          [passwordField resignFirstResponder];
          [self sendLoginCall:false];
          
     }
     
     [emailField resignFirstResponder];
     [passwordField resignFirstResponder];
}

-(void)sendLoginCall:(BOOL)isAlreadyLogin{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"userLogin" forKey:@"method"];
     [postParams setObject:emailField.text forKey:@"email"];
     [postParams setObject:passwordField.text forKey:@"password"];
     if(isAlreadyLogin == false)
          [postParams setObject:@"false" forKey:@"has_session"];
     else
          [postParams setObject:@"true" forKey:@"has_session"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [loadingView hide];
          
          // extract user id and session id using json parser and save it in shared manager
          NSDictionary *responseDict = [completedOperation responseJSON];
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:USER_ALREADY_FLAG]])
          {
               
               
               dialogTitle.text = security_War;
               DialogMsg.text = Already_loggedin_msg;
               [Dialogyes setTitle:yesbtn forState:UIControlStateNormal];
               [Dialogno setTitle:Nobtn forState:UIControlStateNormal];
               
               if(IS_IPHONE_4){
                    DialogView.frame = CGRectMake(0, 0, 320, 480);
               }else if (IS_IPHONE_5){
                    DialogView.frame = CGRectMake(0, 0, 320, 568);
               }else if (IS_IPHONE_6){
                    DialogView.frame = CGRectMake(0, 0, 375, 667);
               }
               
               [self.view addSubview:DialogView];
               
          }
          else if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
            
               [SharedManager getInstance].userID = [responseDict objectForKey:@"user_id"];
               [SharedManager getInstance].sessionID = [responseDict objectForKey:@"session_id"];
               
               [[SharedManager getInstance] saveModel];
               
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewLogin"];
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
               
               
               /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log in Error" message:@"Email or password doesn't match. Please retry with the correct information." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alertView show]; */
          }
     } onError:^(NSError* error) {
          
          [loadingView hide];
          
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
     [loadingView showInView:self.view withTitle:LoadingTitle];
     [engine enqueueOperation:op];
     
}

- (IBAction)DialogYes:(id)sender {
     
     [self sendLoginCall:true];
     [DialogView removeFromSuperview];
}

- (IBAction)DialogNo:(id)sender {
     [DialogView removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     
     NSLog(@"Clicked at Index: %i",buttonIndex);
     //    0 - NO
     //     1 - YES
     
     if(buttonIndex == 1)
     {
          [self sendLoginCall:true];
     }
     
}



-(IBAction)SendResetPasswordRequest:(id)sender{
     
     if(![self validateEmail:forgotEmailField.text])
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


-(void)sendForgotPasswordRequest{
     [loadingView showInView:self.view withTitle:LoadingTitle];
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"userPasswordReset" forKey:@"method"];
     [postParams setObject:forgotEmailField.text forKey:@"email"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          NSLog(@"Response: %@",[completedOperation responseString]);
          
          // extract user id and session id using json parser and save it in shared manager
          
          NSDictionary *responseDict = [completedOperation responseJSON];
          //NSString *flag = [responseDict objectForKey:@"flag"];
          NSString *message = [responseDict objectForKey:@"message"];
     
          
          [loadingView hide];
          forgotEmailField.text = nil;
          if ([message isEqualToString:@"Password Reset Email has been sent successfully"]){
               [forgotEmailField resignFirstResponder];
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


-(IBAction)switchToLoginView:(id)sender{
     //[self.view addSubview:LoginView];
     [forgotPasswordView removeFromSuperview];
}

-(IBAction)back:(id)sender{
     
     [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)validateEmail:(NSString *)candidate {
     
     NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     
     return [emailTest evaluateWithObject:candidate];
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [textField resignFirstResponder];
     return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     const int movementDistance = 145; // tweak as needed
     const float movementDuration = 0.3f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
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
     [storeVC.navigationController setNavigationBarHidden:YES animated:NO];
     
     UIViewController *historyViewController;
     if(IS_IPAD) {
          historyViewController = [[EarnFreePointsViewController alloc] initWithNibName:@"EarnFreePointsViewController_iPad" bundle:[NSBundle mainBundle]];
     }
     else {
          historyViewController = [[EarnFreePointsViewController alloc] initWithNibName:@"EarnFreePointsViewController" bundle:[NSBundle mainBundle]];
     }
     UINavigationController *historyNavController = [[UINavigationController alloc] initWithRootViewController:historyViewController];
     
     [historyViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"referralglow.png"]
                                                         imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
     [historyViewController.tabBarItem setImage:[[UIImage imageNamed:@"referral.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     
     historyViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
     [historyViewController.navigationController setNavigationBarHidden:YES animated:NO];
     
     
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
     [settingVC.navigationController setNavigationBarHidden:YES animated:NO];
     
     self.tabBarController = [[UITabBarController alloc] init] ;
     self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navController, friendsNavController,storeNavController,historyNavController,settingsNavController,nil];
     
     [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"menubg.png"]];
     
     //    [self setFieldsAndButtonsText:self.configResponse];
     self.viewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
     //self.viewController.navigationController.navigationBar
     [[[UIApplication sharedApplication]delegate] window].rootViewController = self.tabBarController;
}


@end
