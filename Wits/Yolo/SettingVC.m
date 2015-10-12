//
//  SettingVC.m
//  Yolo
//
//  Created by Jawad Mahmood  on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "SettingVC.h"
#import "RightBarVC.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "iRate.h"
#import "AlertMessage.h"
@interface SettingVC ()

@end

@implementation SettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
          // Custom initialization
     }
     return self;
}

- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self setLanguage];

}


- (void)viewDidLoad
{
     [super viewDidLoad];
     [self setLanguage];
     // Do any additional setup after loading the view from its nib.
     [self setRadioButtons];
     referralCodeTxt.delegate = self;
     mainscrollView.contentSize = CGSizeMake(320, 780);
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     langBtnTitle = (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"LangTitle"];
     [languageBtn setTitle:langBtnTitle forState:UIControlStateNormal];
     
     languageArray = [[NSArray alloc] initWithObjects:@"English (US)", @"Arabic (Ar)", @"French (Fr)",@"Spanish (Es)",@"Portuguese (Pt)", nil];
     
     
    
     musiclbl.font = [UIFont fontWithName:FONT_NAME size:16];
     soundEffectLbl.font = [UIFont fontWithName:FONT_NAME size:16];
     vibrationLbl.font = [UIFont fontWithName:FONT_NAME size:16];
     pushNotificationLbl.font = [UIFont fontWithName:FONT_NAME size:20];
     challengeNotificationLbl.font = [UIFont fontWithName:FONT_NAME size:16];
     chatNotification.font = [UIFont fontWithName:FONT_NAME size:16];
     selectlanguageHeading.font = [UIFont fontWithName:FONT_NAME size:20];
     languageButtonOutlet.font = [UIFont fontWithName:FONT_NAME size:16];
     
     
     
     // Initialize the dbManager object.
     self.witsdb = [[WitsDB alloc] initWithDatabaseFilename:@"Wits.sql"];
     
     if (self.recordIDToEdit != -1) {
          // Load the record with the specific ID from the database.
          [self loadData];
     }
     [self loadData];
     
}
-(void)loadData{
     
     NSString *AlldataSql = @"SELECT * From Wits";
     
     NSArray *AllData;
     // Get the results.
     if (AllData != nil) {
          AllData = nil;
     }
     AllData = [[NSArray alloc] initWithArray:[self.witsdb loadDataFromDB:AlldataSql]];
     NSLog(@"%@",AllData);
     
     
     NSString *UserId  = [[NSString alloc]initWithFormat:@"%@",[SharedManager getInstance].userID];
     // Form the query.
     sent = YES;
     NSString *query = [[NSString alloc]initWithFormat:@"select USer from Wits WHERE USer = '%@' AND RefferalSent = '%@'",UserId , sent ? @"YES":@"NO" ];
     NSArray *Info;
     // Get the results.
     if (Info != nil) {
          Info = nil;
     }
     Info = [[NSArray alloc] initWithArray:[self.witsdb loadDataFromDB:query]];
     NSLog(@"%@",Info);
     
     if (Info.count > 0) {
          NSLog(@"Query was executed successfully. Affected rows = %lu %@", (unsigned long)Info.count, query);
          
          referralCodeTxt.hidden = YES;
          sendBtn.hidden = YES;
          referalCode.hidden= YES;
          
     }
     else{
          NSLog(@"Database is Empty or No Record Matching Query.");
          
     }
     
}

-(void)setLanguage {
     
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          loadingtitle = Loading;
          settingsLbl.text = SETTINGS;
          musiclbl.text = MUSIC_LBL;
          soundEffectLbl.text = SOUND_LBL;
          vibrationLbl.text = VIBRATION_LBL;
          generalLbl.text = GENERAL_LBL;
          pushNotificationLbl.text = PUSH_LBL;
          challengeNotificationLbl.text = CHALLENGE_LBL;
          chatNotification.text = CHAT_LBL;
          referalCode.text = REFERRAL_CODE;
          languageTitle.text = SELECT_LANGUAGE;
          referralCodeTxt.placeholder = REFERRAL_CODE;
          referralCodeTxt.textAlignment = NSTextAlignmentLeft;
          chooseLang.text = CHOOSE_LANGUAGE;
          chooseLang.textAlignment = NSTextAlignmentCenter;
          
          [rateUs setTitle:@"Rate Us" forState:UIControlStateNormal];
          [languageSaveBtn setTitle:SAVE_LANGUAGE_BTN forState:UIControlStateNormal];
          [sendBtn setTitle:SEND_BTN forState:UIControlStateNormal];
          [aboutBtn setTitle:ABOUT_BTN forState:UIControlStateNormal];
          [changeLangBtn setTitle:CHANGE_LANG_BTN forState:UIControlStateNormal];
          [mainbackBtn setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          
          loadingtitle = Loading_1;
          settingsLbl.text = SETTINGS_1;
          musiclbl.text = MUSIC_LBL_1;
          soundEffectLbl.text = SOUND_LBL_1;
          vibrationLbl.text = VIBRATION_LBL_1;
          generalLbl.text = GENERAL_LBL_1;
          pushNotificationLbl.text = PUSH_LBL_1;
          challengeNotificationLbl.text = CHALLENGE_LBL_1;
          chatNotification.text = CHAT_LBL_1;
          referalCode.text = REFERRAL_CODE_1;
          languageTitle.text = SELECT_LANGUAGE_1;
          referralCodeTxt.placeholder = REFERRAL_CODE_1;
          referralCodeTxt.textAlignment = NSTextAlignmentRight;
          chooseLang.text = CHOOSE_LANGUAGE_1;
          chooseLang.textAlignment = NSTextAlignmentCenter;
          
          
          [languageSaveBtn setTitle:SAVE_LANGUAGE_BTN_1 forState:UIControlStateNormal];
          [rateUs setTitle:@"قم بتقييمنا" forState:UIControlStateNormal];
          [sendBtn setTitle:SEND_BTN_1 forState:UIControlStateNormal];
          [aboutBtn setTitle:ABOUT_BTN_1 forState:UIControlStateNormal];
          [changeLangBtn setTitle:CHANGE_LANG_BTN_1 forState:UIControlStateNormal];
          [mainbackBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          loadingtitle = Loading_2;
          settingsLbl.text = SETTINGS_2;
          musiclbl.text = MUSIC_LBL_2;
          soundEffectLbl.text = SOUND_LBL_2;
          vibrationLbl.text = VIBRATION_LBL_2;
          generalLbl.text = GENERAL_LBL_2;
          pushNotificationLbl.text = PUSH_LBL_2;
          challengeNotificationLbl.text = CHALLENGE_LBL_2;
          chatNotification.text = CHAT_LBL_2;
          referalCode.text = REFERRAL_CODE_2;
          languageTitle.text = SELECT_LANGUAGE_2;
          referralCodeTxt.placeholder = REFERRAL_CODE_2;
          referralCodeTxt.textAlignment = NSTextAlignmentLeft;
          chooseLang.text = CHOOSE_LANGUAGE_2;
          chooseLang.textAlignment = NSTextAlignmentCenter;
          
          [languageSaveBtn setTitle:SAVE_LANGUAGE_BTN_2 forState:UIControlStateNormal];
          [rateUs setTitle:@"Evalúe-nos" forState:UIControlStateNormal];
          
          [sendBtn setTitle:SEND_BTN_2 forState:UIControlStateNormal];
          [aboutBtn setTitle:ABOUT_BTN_2 forState:UIControlStateNormal];
          [changeLangBtn setTitle:CHANGE_LANG_BTN_2 forState:UIControlStateNormal];
          [mainbackBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          
          loadingtitle = Loading_3;
          settingsLbl.text = SETTINGS_3;
          musiclbl.text = MUSIC_LBL_3;
          soundEffectLbl.text = SOUND_LBL_3;
          vibrationLbl.text = VIBRATION_LBL_3;
          generalLbl.text = GENERAL_LBL_3;
          pushNotificationLbl.text = PUSH_LBL_3;
          challengeNotificationLbl.text = CHALLENGE_LBL_3;
          chatNotification.text = CHAT_LBL_3;
          referalCode.text = REFERRAL_CODE_3;
          languageTitle.text = SELECT_LANGUAGE_3;
          referralCodeTxt.placeholder = REFERRAL_CODE_3;
          referralCodeTxt.textAlignment = NSTextAlignmentLeft;
          chooseLang.text = CHOOSE_LANGUAGE_3;
          chooseLang.textAlignment = NSTextAlignmentCenter;
          
          
          [languageSaveBtn setTitle:SAVE_LANGUAGE_BTN_3 forState:UIControlStateNormal];
          [rateUs setTitle:@"Notez nous" forState:UIControlStateNormal];
          [sendBtn setTitle:SEND_BTN_3 forState:UIControlStateNormal];
          [aboutBtn setTitle:ABOUT_BTN_3 forState:UIControlStateNormal];
          [changeLangBtn setTitle:CHANGE_LANG_BTN_3 forState:UIControlStateNormal];
          [mainbackBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          
          loadingtitle = Loading_4;
          settingsLbl.text = SETTINGS_4;
          musiclbl.text = MUSIC_LBL_4;
          soundEffectLbl.text = SOUND_LBL_4;
          vibrationLbl.text = VIBRATION_LBL_4;
          generalLbl.text = GENERAL_LBL_4;
          pushNotificationLbl.text = PUSH_LBL_4;
          challengeNotificationLbl.text = CHALLENGE_LBL_4;
          chatNotification.text = CHAT_LBL_4;
          referalCode.text = REFERRAL_CODE_4;
          languageTitle.text = SELECT_LANGUAGE_4;
          referralCodeTxt.placeholder = REFERRAL_CODE_4;
          referralCodeTxt.textAlignment = NSTextAlignmentLeft;
          chooseLang.text = CHOOSE_LANGUAGE_4;
          chooseLang.textAlignment = NSTextAlignmentCenter;
          
          
          [languageSaveBtn setTitle:SAVE_LANGUAGE_BTN_4 forState:UIControlStateNormal];
          [rateUs setTitle:@"Nos classifique " forState:UIControlStateNormal];
          [sendBtn setTitle:SEND_BTN_4 forState:UIControlStateNormal];
          [aboutBtn setTitle:ABOUT_BTN_4 forState:UIControlStateNormal];
          [changeLangBtn setTitle:CHANGE_LANG_BTN_4 forState:UIControlStateNormal];
          [mainbackBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
}
-(void) setRadioButtons {
     
     isMusicOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
     isSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
     isVibrationOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"vibration"];
     isChallengeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"challenge"];
     isChatOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"chat"];
     
     if(isMusicOn) {
          [musicBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [musicBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     
     if(isSoundOn) {
          [soundEffectBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [soundEffectBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     if(isVibrationOn) {
          [vibrationBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [vibrationBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     if(isChallengeOn) {
          [challengeNotificationBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [challengeNotificationBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     if(isChatOn) {
          [chatNotificationBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [chatNotificationBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
}
- (IBAction)aboutUsPressed:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.witsapplication.com/"]];
}

-(IBAction)ShowRightMenu:(id)sender{
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

- (IBAction)musicBtnPressed:(id)sender {
     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     if(isMusicOn) {
          [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"music"];
          isMusicOn = false;
          [musicBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
          [delegate musicSwitch:false];
     }
     else {
          [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"music"];
          isMusicOn = TRUE;
          [musicBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
          [delegate musicSwitch:true];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)soundEffectPressed:(id)sender {
     if(isSoundOn) {
          isSoundOn = false;
          [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"sound"];
          [soundEffectBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"sound"];
          isSoundOn = TRUE;
          [soundEffectBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)vibrationPressed:(id)sender {
     
     if(isVibrationOn) {
          [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"vibration"];
          isVibrationOn = false;
          [vibrationBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"vibration"];
          isVibrationOn = TRUE;
          [vibrationBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)challengeNotificationPressed:(id)sender {
     if(isChallengeOn) {
          [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"challenge"];
          isChallengeOn = false;
          [challengeNotificationBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"challenge"];
          isChallengeOn = TRUE;
          [challengeNotificationBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)chatNotificationPressed:(id)sender {
     if(isChatOn) {
          [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"chat"];
          isChatOn = false;
          [chatNotificationBtn setBackgroundImage:[UIImage imageNamed:@"off_btn.png"] forState:UIControlStateNormal];
     }
     else {
          [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"chat"];
          isChatOn = TRUE;
          [chatNotificationBtn setBackgroundImage:[UIImage imageNamed:@"on_btn.png"] forState:UIControlStateNormal];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeLanguagePressed:(id)sender {
     [self.view addSubview:langSelectionPopUp];
}

- (IBAction)rateUsPressed:(id)sender {
     /*[iRate sharedInstance].applicationBundleID = @"com.txlabs.wits";
      [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
      
      //enable preview mode
      [iRate sharedInstance].previewMode = YES;*/
     [[iRate sharedInstance] openRatingsPageInAppStore];
     
}


- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
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

- (IBAction)languageSaved:(id)sender {
     CGRect myRect = CGRectMake(0, 0, 0, 0);
     NSString *imageName = @"";
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad){
          myRect = CGRectMake(209, 440, 350, 50);
          imageName = @"conect_with_fb-ipad.png";
     }
     else{
          myRect = CGRectMake(40,221,240,34);
          imageName = @"conect_with_fb@2x.png";
     }
     [self setLanguage];
     [langSelectionPopUp removeFromSuperview];
     [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isLanguageSelected"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
}
-(void)rel{
     //    [dropDown release];
     dropDown = nil;
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     
     if(sender.selectedIndex == 0) {
          [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"languageCode"];
          [languageBtn setTitle:@"English(US)" forState:UIControlStateNormal];
          [[NSUserDefaults standardUserDefaults ]setObject:@"English(US)" forKey:@"LangTitle"];
          langBtnTitle = @"English(US)";
     }
     else if (sender.selectedIndex == 1) {
          [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"languageCode"];
          [languageBtn setTitle:@"Arabic(Ar)" forState:UIControlStateNormal];
          [[NSUserDefaults standardUserDefaults ]setObject:@"Arabic(Ar)" forKey:@"LangTitle"];
          langBtnTitle = @"Arabic(Ar)";
     }
     else if (sender.selectedIndex == 2) {
          [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"languageCode"];
          [languageBtn setTitle:@"French(Fr)" forState:UIControlStateNormal];
          [[NSUserDefaults standardUserDefaults ]setObject:@"French(Fr)" forKey:@"LangTitle"];
          langBtnTitle = @"French(Fr)";
     }
     else if (sender.selectedIndex == 3) {
          [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"languageCode"];
          [languageBtn setTitle:@"Spanish(Es)" forState:UIControlStateNormal];
          [[NSUserDefaults standardUserDefaults ]setObject:@"Spanish(Es)" forKey:@"LangTitle"];
          langBtnTitle = @"Spanish(Es)";
     }
     else if (sender.selectedIndex == 4) {
          [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"languageCode"];
          [languageBtn setTitle:@"Portuguese(Pt)" forState:UIControlStateNormal];
          [[NSUserDefaults standardUserDefaults ]setObject:@"Portuguese(Pt)" forKey:@"LangTitle"];
          
          
          langBtnTitle = @"Portuguese(Pt)";
     }
     
//     CGRect myRect = CGRectMake(0, 0, 0, 0);
//     NSString *imageName = @"";
//     
//     if ([[UIScreen mainScreen] bounds].size.height == iPad){
//          myRect = CGRectMake(209, 440, 350, 50);
//          imageName = @"conect_with_fb-ipad.png";
//     }
//     else{
//          myRect = CGRectMake(40,221,240,34);
//          imageName = @"conect_with_fb@2x.png";
//     }
     [self setLanguage];
     /// This check is for the call of topics etc on language changed with new language code
     [[NSUserDefaults standardUserDefaults ]setObject:@"1" forKey:@"callagain"];
//     [langSelectionPopUp removeFromSuperview];
     [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isLanguageSelected"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     delegate.isLanguageChanged = true;
     
     
     [[NSUserDefaults standardUserDefaults] synchronize];
     [self rel];
}
#pragma mark -------------
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
     [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
     [self animateTextField: textField up: NO];
     [referralCodeTxt resignFirstResponder];
     
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     
     [referralCodeTxt resignFirstResponder];
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
- (IBAction)sendPressed:(id)sender {
     if(referralCodeTxt.text.length > 0) {
          if( [referralCodeTxt.text caseInsensitiveCompare:[SharedManager getInstance]._userProfile.referral_code] == NSOrderedSame )
          {
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = ERR_REFERAL_CODE;
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = ERR_REFERAL_CODE_1;
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = ERR_REFERAL_CODE_2;
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = ERR_REFERAL_CODE_3;
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = ERR_REFERAL_CODE_4;
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
               /*    NSString *message = @"Not a valid referral code";
                
                UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                message:message
                delegate:nil
                cancelButtonTitle:nil
                otherButtonTitles:nil, nil];
                [toast show];
                
                int duration = 1; // duration in seconds
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
                });*/
          }
          else {
               loadView = [[LoadingView alloc] init];
               [loadView showInView:self.view withTitle:loadingtitle];
               MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
               
               NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
               [postParams setObject:@"accept_referral" forKey:@"method"];
               [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
               [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
               [postParams setObject:referralCodeTxt.text forKey:@"referral_code"];
               
               MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
               
               [operation onCompletion:^(MKNetworkOperation *completedOperation){
                    
                    [loadView hide];
                    NSDictionary *mainDict = [completedOperation responseJSON];
                    NSLog(@"main dict %@",mainDict);
                    
                    NSString *msgStr = [mainDict objectForKey:@"message"];
                    if ([msgStr isEqualToString:@"success"]) {
                         
                         if (languageCode == 0) {
                              
                              message = @"Referral code sent Succesfully";
                         }else if (languageCode == 1){
                              message = @"نشرت الإحالة كود بنجاح";
                         }else if (languageCode == 2){
                              message = @"Le code de référence publié avec succès";
                         }else if (languageCode == 3){
                              message = @"Código de referencia publicado con éxito";
                         }else if (languageCode == 4){
                              message = @"Código de Referência postado com sucesso";
                         }
                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:message
                                                                        delegate:nil
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
                         [toast show];
                         
                         int duration = 1; // duration in seconds
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                              [toast dismissWithClickedButtonIndex:0 animated:YES];
                         });
                         
                         NSString *UserId  = [[NSString alloc]initWithFormat:@"%@",[SharedManager getInstance].userID];
                         sent = YES;
                         
                         // Prepare the query string.
                         // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
                         NSString *query;
                         
                         //                NSString *existQuery = [NSString stringWithFormat:@"IF EXISTS(SELECT USerID FROM Wits WHERE USerID = '%@')BEGIN END ELSE BEGIN insert into Wits values(null, '%@', '%@')END ",UserId,UserId ,sent];
                         if (self.recordIDToEdit == -1) {
                              query = [NSString stringWithFormat:@"update Wits set USer='%@', RefferalSent ='%@' where USer='%@'",UserId , sent ? @"YES" : @"NO" , UserId];
                         }
                         else{
                              query = [NSString stringWithFormat:@"insert into Wits values(null, '%@', '%@')", UserId , sent ? @"YES" : @"NO"];
                              
                         }
                         
                         // Execute the query.
                         [self.witsdb executeQuery:query];
                         
                         // If the query was successfully executed then hide Textfield and button.
                         if (self.witsdb.affectedRows != 0) {
                              NSLog(@"Query was executed successfully. Affected rows = %d %@", self.witsdb.affectedRows, query);
                              
                              
                              referralCodeTxt.hidden = YES;
                              sendBtn.hidden = YES;
                              referalCode.hidden= YES;
                              
                         }
                         else{
                              NSLog(@"Could not execute the query.");
                              sent = NO;
                         }
                         [referralCodeTxt resignFirstResponder];
                         //                         referralCodeTxt.hidden = YES;
                         //                         sendBtn.hidden = YES;
                         //                         referalCode.hidden= YES;
                         
                    }else{
                         
                         NSString *UserId  = [[NSString alloc]initWithFormat:@"%@",[SharedManager getInstance].userID];
                         BOOL sent = NO;
                         
                         // Prepare the query string.
                         // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
                         NSString *query;
                         if (self.recordIDToEdit == -1) {
                              query = [NSString stringWithFormat:@"insert into Wits values(null, '%@', '%@')", UserId , sent ? @"YES" : @"NO"];
                         }
                         else{
                              query = [NSString stringWithFormat:@"update Wits set USer='%@', RefferalSent ='%@' where USer='%@'",UserId , sent ? @"YES" : @"NO" , UserId];
                         }
                         
                         // Execute the query.
                         [self.witsdb executeQuery:query];
                         
                         // If the query was successfully executed then hide Textfield and button.
                         if (self.witsdb.affectedRows != 0) {
                              NSLog(@"Query was executed successfully. Affected rows = %d %@", self.witsdb.affectedRows, query);
                              
                              referralCodeTxt.hidden = NO;
                              sendBtn.hidden = NO;
                              referalCode.hidden= NO;
                              
                         }
                         else{
                              NSLog(@"Could not execute the query.");
                              sent = NO;
                         }
                         
                         [referralCodeTxt resignFirstResponder];
                         NSString *emailMsg;
                         NSString *title;
                         NSString *cancel;
                         if (languageCode == 0 ) {
                              emailMsg = ERR_REFERAL_CODE;
                              title = @"Error";
                              cancel = CANCEL;
                         } else if(languageCode == 1) {
                              emailMsg = ERR_REFERAL_CODE_1;
                              title = @"خطأ";
                              cancel = CANCEL_1;
                         }else if (languageCode == 2){
                              emailMsg = ERR_REFERAL_CODE_2;
                              title = @"Erreur";
                              cancel = CANCEL_2;
                         }else if (languageCode == 3){
                              emailMsg = ERR_REFERAL_CODE_3;
                              title = @"Error";
                              cancel = CANCEL_3;
                         }else if (languageCode == 4){
                              emailMsg = ERR_REFERAL_CODE_4;
                              title = @"Erro";
                              cancel = CANCEL_4;
                         }
                         [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                    }
                    
               }
                               onError:^(NSError *error){
                                    
                                    [loadView hide];
                                    
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
               
               [engine enqueueOperation:operation];
          }
          
          
     }else{
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Enter Referral Code";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"الرجاء إدخال رمز الإحالة";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = REFERAL_CODE_LBL_2;
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = REFERAL_CODE_LBL_3;
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = REFERAL_CODE_LBL_4;
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          /*       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Enter a Referral Code First." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           
           [alert show]; */
          
     }
     
     
}

- (IBAction)mainBackPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}
@end
