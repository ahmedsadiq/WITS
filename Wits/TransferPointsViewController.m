//
//  TransferPointsViewController.m
//  Wits
//
//  Created by Mr on 19/11/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "TransferPointsViewController.h"
#import "RightBarVC.h"
#import "MKNetworkEngine.h"
#import "SharedManager.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "NavigationHandler.h"
#import "AlertMessage.h"

@interface TransferPointsViewController ()
@property (strong, nonatomic) UITextField *textField;

@end

@implementation TransferPointsViewController

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
    _loadView = [[LoadingView alloc] init];
     self.textField.delegate = self;
     [self setLanguageForScreen];
     
     
     
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     if(delegate.transferPointsEmail.length > 0) {
          _recieverEmail.text = delegate.transferPointsEmail;
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendBtn:(id)sender {
     
     [_recieverEmail resignFirstResponder];
     [_amount resignFirstResponder];
     
     int userPoints  = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
     int requestedPoints = [_amount.text intValue];
     if (_recieverEmail.text.length >0) {
          if (_amount.text.length >0) {
               
          
     if(requestedPoints <= (userPoints-100)) {
          [_loadView showInView:self.view withTitle:loadingTitle];
          MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
          
          NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
          [postParams setObject:@"share_points" forKey:@"method"];
          [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
          [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
          [postParams setObject:_recieverEmail.text forKey:@"friend_email"];
          NSLog(@"recieverEmail ::%@",_recieverEmail.text);
          [postParams setObject:_amount.text forKey:@"points"];
          
          MKNetworkOperation *oper = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
          
          [oper onCompletion:^(MKNetworkOperation *compOper){
               
               [_loadView hide];
               NSDictionary *mainDict = [compOper responseJSON];
               NSNumber *flag = [mainDict objectForKey:@"flag"];
               int remainingPoints  = userPoints-requestedPoints;
               [[SharedManager getInstance] _userProfile].cashablePoints = [NSString stringWithFormat:@"%d",remainingPoints];
               if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
               {
                    
                    NSString *emptyfield;
                    
                    if (languageCode == 0) {
                         emptyfield = SUCCESS_TRANF_POINTS;
                    }else if (languageCode == 1){
                         emptyfield = SUCCESS_TRANF_POINTS_1;
                    }else if (languageCode == 2){
                         emptyfield = SUCCESS_TRANF_POINTS_2;
                    }else if(languageCode == 3){
                         emptyfield = SUCCESS_TRANF_POINTS_3;
                    }else if (languageCode == 4){
                         emptyfield = SUCCESS_TRANF_POINTS_4;
                    }
                    
                    
                    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:emptyfield
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil, nil];
                    [toast show];
                    
                    int duration = 2; // duration in seconds
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                         [toast dismissWithClickedButtonIndex:0 animated:YES];
                    });

                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
               }
          
               else {
                    
                    
                    NSString *emailMsg;
                    NSString *title;
                    NSString *cancel;
                    if (languageCode == 0 ) {
                         emailMsg = @"Always leave 100 Points in your balance to be able to Transfer";
                         title = @"Error";
                         cancel = CANCEL;
                    } else if(languageCode == 1) {
                         emailMsg = @"حاول دائماً أن تترك في رصيدك 100 جوهرة لتستطيع التحويل";
                         title = @"خطأ";
                         cancel = CANCEL_1;
                    }else if (languageCode == 2){
                         emailMsg = @"Pour pouvoir encaisser, vous devez laisser au moins 100 Points sur votre compte. ";
                         title = @"Erreur";
                         cancel = CANCEL_2;
                    }else if (languageCode == 3){
                         emailMsg = @"Siempre deja 100 pontus en tu cuenta para poder transferir";
                         title = @"Error";
                         cancel = CANCEL_3;
                    }else if (languageCode == 4){
                         emailMsg = @"Deixe sempre 100 pontus na sua conta afim de poder efetuar transferências";
                         title = @"Erro";
                         cancel = CANCEL_4;
                    }

                    
                    [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                /*
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
                    
                    [alert show]; */
               }
               
          }onError:^(NSError *error){
               
               [_loadView hide];
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = ERR_TRANF_POINTS;
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = ERR_TRANF_POINTS_1;
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = ERR_TRANF_POINTS_2;
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = ERR_TRANF_POINTS_3;
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = ERR_TRANF_POINTS_4;
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
     else {
          
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Always leave 100 Gems in your balance to be able to Transfer";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"حاول دائماً أن تترك في رصيدك 100 جوهرة لتستطيع التحويل";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Pour pouvoir encaisser, vous devez laisser au moins 100 Gems sur votre compte. ";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Siempre deja 100 gemas en tu cuenta para poder transferir";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Deixe sempre 100 Gemas na sua conta afim de poder efetuar transferências";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          /*
          
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
          
          [alert show];*/
          }
          }else{
          
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               
               if (languageCode == 0 ) {
                    emailMsg = @"Enter Amount";
                    title = @"Error";
                    cancel = OK_BTN;
               } else if(languageCode == 1) {
                    emailMsg = @"أدخل المبلغ";
                    title = @"خطأ";
                    cancel = OK_BTN_1;
               }else if (languageCode == 2){
                    emailMsg = @"saisir le montant";
                    title = @"Erreur";
                    cancel = OK_BTN_2;
               }else if (languageCode == 3){
                    emailMsg = @"Ingrese monto";
                    title = @"Error";
                    cancel = OK_BTN_3;
               }else if (languageCode == 4){
                    emailMsg = @"Digite o valor:";
                    title = @"Erro";
                    cancel = OK_BTN_4;
               }
               
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
          }
     }else {
          
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          
          if (languageCode == 0 ) {
               emailMsg = ENTER_EMAIL_USERNAME;
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = ENTER_EMAIL_USERNAME_1;
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = ENTER_EMAIL_USERNAME_2;
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = ENTER_EMAIL_USERNAME_3;
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = ENTER_EMAIL_USERNAME_4;
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }
}

- (IBAction)sliderBar:(id)sender {
     [self.view endEditing:YES];
    [[RightBarVC getInstance] loadProfileImage];
    [[RightBarVC getInstance] AddInView:self.view];
    [[RightBarVC getInstance] ShowInView];
}

#pragma mark -------------
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
    [_recieverEmail resignFirstResponder];
     [_amount resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [_recieverEmail resignFirstResponder];
     [_amount resignFirstResponder];
    return YES;
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     const int movementDistance = 165; // tweak as needed
     const float movementDuration = 0.3f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
}
- (IBAction)backpressed:(id)sender {
     _recieverEmail.text = nil;
     
     [[NavigationHandler getInstance] NavigateToHomeScreen];
}

#pragma mark Set Language

-(void)setLanguageForScreen {
    NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          loadingTitle = Loading;
          _recieverEmail.placeholder = @"Reciever Email / Username";
          TransferPoints.text = TRANSFER_POINTS_BTN;
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          [SendPoint setTitle:SEND forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          loadingTitle = Loading_1;
          _recieverEmail.placeholder = @"المتلقي ID البريد الإلكتروني";
          _amount.placeholder = @"كمية";
          TransferPoints.text = TRANSFER_POINTS_BTN_1;
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [SendPoint setTitle:SEND_1 forState:UIControlStateNormal];

     }
     else if(languageCode == 2) {
          loadingTitle = Loading_2;
          _recieverEmail.placeholder = @"Récepteur Email Id";
          _amount.placeholder = @"montant";
          TransferPoints.text = TRANSFER_POINTS_BTN_2;
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [SendPoint setTitle:SEND_2 forState:UIControlStateNormal];

     }
     else if(languageCode == 3) {
          loadingTitle = Loading_3;
          _recieverEmail.placeholder = @"E-mail del ID";
          _amount.placeholder = @"importe";
          TransferPoints.text = TRANSFER_POINTS_BTN_3;
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [SendPoint setTitle:SEND_3 forState:UIControlStateNormal];

     }
     else if(languageCode == 4) {
          loadingTitle = Loading_4;
          _recieverEmail.placeholder = @"Receiver Email ID";
          _amount.placeholder = @"Valor";
          TransferPoints.text = TRANSFER_POINTS_BTN_4;
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [SendPoint setTitle:SEND_4 forState:UIControlStateNormal];

     }
     if (languageCode == 1){
     
          _recieverEmail.textAlignment = NSTextAlignmentRight;
          _amount.textAlignment = NSTextAlignmentRight;
     }else {
     
          _recieverEmail.textAlignment = NSTextAlignmentLeft;
          _amount.textAlignment = NSTextAlignmentLeft;
     }
}

@end
