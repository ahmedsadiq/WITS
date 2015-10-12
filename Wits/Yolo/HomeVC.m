//
//  HomeVC.m
//  Yolo
//
//  Created by Salman Khalid on 16/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "HomeVC.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "SharedManager.h"
#import "RightBarVC.h"
#import "GetTopicsVC.h"
#import "MyPointsVC.h"
#import "NavigationHandler.h"
#import "SRWebSocket.h"
#import "AppDelegate.h"
#import "HistoryViewController.h"
#import "Utils.h"
#import "CategoryModel.h"
#import "TopicModel.h"
#import "SubTopicsModel.h"
#import "AlertMessage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SVPullToRefresh.h"


@implementation HomeVC

- (IBAction)dialogbtnPressed:(id)sender {
     [[NavigationHandler getInstance]NavigateToSignUpScreen];
}

- (id)init
{
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          self = [super initWithNibName:@"HomeVC_iPad" bundle:Nil];
     }
     
     else{
          self = [super initWithNibName:@"HomeVC" bundle:Nil];
     }
     
     CFStringRef state;
     
     UInt32 propertySize = sizeof(CFStringRef);
     
     AudioSessionInitialize(NULL, NULL, NULL, NULL);
     AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
     if(CFStringGetLength(state) > 0)
     {
          //SI
          NSLog(@"silent");
          MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
          
          musicPlayer.volume = 0;
     }
     else if(CFStringGetLength(state) == 0)
     {
          //NOT SILENT
          NSLog(@"not silent");
          MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
          
          musicPlayer.volume = 0;
     }
     return self;
}
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     [self setLanguageForScreen];
     [RightBarVC getInstance]._currentState = 0;
     if(delegate.isAlreadyFetched == false) {
          [self fetchTopics];
     }
     
     BOOL Login = [[NSUserDefaults standardUserDefaults] boolForKey:@"NewLogin"];
     if (Login == YES) {
     
     emailOBj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     
     NSString *verified = [SharedManager getInstance]._userProfile.isVerfied;
     emailVerfiyLbl.text = emailOBj.LoginEmail;
     NSString *loginEmail = emailOBj.LoginEmail;
     
     emailVerfiyLbl.text = loginEmail;
     if ([verified isEqualToString:@"Not Verified"]){
          //   [_loadingView showInView:parentView withTitle:loadingTitle];
          [self.view addSubview:verificationView];
          [_loadingView hide];
          
          
     }else{
          NSLog(@"User is verified");
     }
        }
     
     //initData
     delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     if(delegate.isLanguageChanged) {
          [self fetchTopics];
          
     }
     CFStringRef state;
     
     UInt32 propertySize = sizeof(CFStringRef);
     
     AudioSessionInitialize(NULL, NULL, NULL, NULL);
     AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
     
     [self silenced];
     }

-(void)silenced {

     
     if (!gAudioSessionInited)
     {
          AudioSessionInterruptionListener    inInterruptionListener = NULL;
          OSStatus    error;
          if ((error = AudioSessionInitialize (NULL, NULL, inInterruptionListener, NULL)))
          {
               NSLog(@"*** Error *** error in AudioSessionInitialize: %d.", error);
          }
          else
          {
               gAudioSessionInited = YES;
          }
     }
     
     SInt32  ambient = kAudioSessionCategory_AmbientSound;
     if (AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (ambient), &ambient))
     {
          NSLog(@"*** Error *** could not set Session property to ambient.");
     }
     
}
- (void)viewDidLoad
{
     [super viewDidLoad];
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     // Do any additional setup after loading the view from its nib.
     //   [_loadingView showInView:parentView withTitle:loadingTitle];
     emailOBj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     
     UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
     [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
     [homeScrollView addSubview:refreshControl];
     
     //[self fetchTopics];
     //  verified = [SharedManager getInstance]._userProfile.isVerfied;
     
     BOOL Login = [[NSUserDefaults standardUserDefaults] boolForKey:@"NewLogin"];
     if (Login == YES) {
          NSLog(@"verified? '%@' ",verified);
          
          
          emailVerfiyLbl.text = emailOBj.LoginEmail;
          NSString *loginEmail = emailOBj.LoginEmail;
          
          emailVerfiyLbl.text = loginEmail;
          if ([verified isEqualToString:@"Not Verified"]){
               [self.view addSubview:verificationView];
               [_loadingView hide];
               
               
          }else{
               
               NSLog(@"User is verified");
               
          }
     }
     
        [self sendOnlineStatusCall];
     [homeScrollView setContentSize:CGSizeMake(homeScrollView.frame.size.width, homeScrollView.frame.size.height+80)];
     
     
     [self.navigationController setNavigationBarHidden:YES];
     _loadingView = [[LoadingView alloc] init];
     if(delegate.isAlreadyFetched == false) {
          [self fetchTopics];
     }
     
     BOOL isMusicOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
     if(isMusicOn) {
          delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          [delegate musicSwitch:true];
     }
}

- (void)testRefresh:(UIRefreshControl *)refreshControl
{
  //   refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          
          [NSThread sleepForTimeInterval:3];
          
          dispatch_async(dispatch_get_main_queue(), ^{
               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
               [formatter setDateFormat:@"MMM d, h:mm a"];
               [self fetchTopics];
            //   NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
          //  refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
               
               [refreshControl endRefreshing];
               
               NSLog(@"refresh end");
          });
     });
}

-(void)fetchTopics{
     
 //    [_loadingView showInView:self.view withTitle:loadingTitle];
     
     NSURL *url = [NSURL URLWithString:SERVER_URL];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"getTopics" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     NSString *languageCode = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     [postParams setObject:languageCode forKey:@"language"];
     
     if([SharedManager getInstance]._userProfile.lastFetched != NULL)
     {
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          
          NSString *_outputFormat = @"YYYY-MM-dd HH:mm:ss";
          [dateFormatter setDateFormat:_outputFormat];
          
          NSString *dateInNewFormat = [dateFormatter stringFromDate:[NSDate date]];
     }
     
     NSData *postData = [self encodeDictionary:postParams];
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:url];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:postData];
     
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response , NSData  *data, NSError *error) {
          if ( [(NSHTTPURLResponse *)response statusCode] == 200 )
          {
               [_loadingView hide];
               NSDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
               NSNumber *flag = [mainDict objectForKey:@"flag"];
               
               if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
               {
                    [SharedManager getInstance]._userProfile.display_name = [mainDict objectForKey:@"display_name"];
                    [SharedManager getInstance]._userProfile.consumedGems = [mainDict objectForKey:@"consumed_gems"];
                    [SharedManager getInstance]._userProfile.isVerfied = [mainDict objectForKey:@"is_verfier"];
                    verified =[mainDict objectForKey:@"is_verfier"];
                    if( [[SharedManager getInstance]._userProfile.isVerfied caseInsensitiveCompare:@"verified"] == NSOrderedSame ) {
                         [SharedManager getInstance]._userProfile.isVerifiedBool = true;
                    }
                    else {
                         [SharedManager getInstance]._userProfile.isVerifiedBool = false;
                    }
                    
                    BOOL Login = [[NSUserDefaults standardUserDefaults] boolForKey:@"NewLogin"];
                    if (Login == YES) {
                         
                    emailOBj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    NSString *verified = [SharedManager getInstance]._userProfile.isVerfied;
                    emailVerfiyLbl.text = emailOBj.LoginEmail;
                    NSString *loginEmail = emailOBj.LoginEmail;
                    emailVerfiyLbl.text = loginEmail;
                    if ([verified isEqualToString:@"Not Verified"]){
                         [self.view addSubview:verificationView];
                         [_loadingView hide];
                         
                    }
               }
                    
                    [_loadingView hide];
                    
                    [SharedManager getInstance]._userProfile.totalPoints = [mainDict objectForKey:@"points"];
                    [SharedManager getInstance]._userProfile.cashablePoints = [mainDict objectForKey:@"cash_able"];
                    [SharedManager getInstance]._userProfile.referral_code = [mainDict objectForKey:@"user_referral_code"];
                    [SharedManager getInstance]._userProfile.profile_image = [mainDict objectForKey:@"profile_image"];
                    [SharedManager getInstance]._userProfile.lastFetched = [NSDate date];
                    
                    [[SharedManager getInstance].topicsArray removeAllObjects];
                    
                    NSArray *categoryArray = [mainDict objectForKey:@"categories"];
                    [[SharedManager getInstance].categoryArray removeAllObjects];
                    [SharedManager getInstance].categoryArray = [[NSMutableArray alloc] init];
                    for(NSDictionary *tempDict in categoryArray)
                    {
                         Topic *_topic = [[Topic alloc] init];
                         _topic.title = [tempDict objectForKey:@"title"];
                         _topic.topic_id = [tempDict objectForKey:@"id"];
                         _topic._description = [tempDict objectForKey:@"description"];
                         _topic.is_recommended = [tempDict objectForKey:@"is_recommended"];
                         _topic.parentTopicID = [tempDict objectForKey:@"id"];
                         
                         [[SharedManager getInstance].categoryArray addObject:_topic];
                    }
                    NSArray *_topicsArray = [mainDict objectForKey:@"topics"];
                    [[SharedManager getInstance].topicsArray removeAllObjects];
                    for(NSDictionary *tempDict in _topicsArray)
                    {
                         Topic *_topic = [[Topic alloc] init];
                         _topic.title = [tempDict objectForKey:@"title"];
                         _topic.topic_id = [tempDict objectForKey:@"id"];
                         _topic.parentTopicID = [tempDict objectForKey:@"cid"];
                         _topic._description = [tempDict objectForKey:@"description"];
                         
                         [[SharedManager getInstance].topicsArray addObject:_topic];
                    }
                    [[SharedManager getInstance].subTopicsArray removeAllObjects];
                    NSArray *subTopicsArray = [mainDict objectForKey:@"sub_topics"];
                    for(NSDictionary *tempDict in subTopicsArray)
                    {
                         
                         Topic *_topic = [[Topic alloc] init];
                         _topic.title = [tempDict objectForKey:@"title"];
                         _topic.topic_id = [tempDict objectForKey:@"id"];
                         _topic._description = [tempDict objectForKey:@"description"];
                         _topic.is_recommended = [tempDict objectForKey:@"is_recommended"];
                         _topic.parentTopicID = [tempDict objectForKey:@"tid"];
                         
                         [[SharedManager getInstance].subTopicsArray addObject:_topic];
                    }
                    [[SharedManager getInstance].categoriesArray removeAllObjects];
                    [SharedManager getInstance].categoriesArray = [[NSMutableArray alloc] init];
                    
                    tempArray = [[SharedManager getInstance] categoryArray];
                    
                    for(int i =0; i<tempArray.count; i++) {
                         Topic *tempTopic = (Topic*) [[SharedManager getInstance].categoryArray objectAtIndex:i];
                         CategoryModel *cModel = [[CategoryModel alloc] init];
                         cModel.category_id = tempTopic.topic_id;
                         cModel._description = tempTopic._description;
                         cModel.title = tempTopic.title;
                         cModel.is_recommended = tempTopic.is_recommended;
                         cModel.isSelected = tempTopic.isSelected;
                         cModel.topicsArray = [[NSMutableArray alloc] init];
                         
                         for(int j=0; j<[SharedManager getInstance].topicsArray.count; j++) {
                              Topic *tTopic = (Topic*) [[SharedManager getInstance].topicsArray objectAtIndex:j];
                              if([tTopic.parentTopicID intValue] == [tempTopic.topic_id intValue])
                              {
                                   TopicModel *tModel = [[TopicModel alloc] init];
                                   tModel.topic_id = tTopic.topic_id;
                                   tModel._description = tTopic._description;
                                   tModel.title = tTopic.title;
                                   tModel.is_recommended = tTopic.is_recommended;
                                   tModel.isSelected = tTopic.isSelected;
                                   tModel.subTopicsArray = [[NSMutableArray alloc] init];
                                   
                                   for(int k=0; k<[SharedManager getInstance].subTopicsArray.count; k++) {
                                        Topic *sTopic = (Topic*) [[SharedManager getInstance].subTopicsArray objectAtIndex:k];
                                        if([sTopic.parentTopicID intValue] == [tTopic.topic_id intValue]) {
                                             SubTopicsModel *stModel = [[SubTopicsModel alloc] init];
                                             stModel.subTopic_id = sTopic.topic_id;
                                             stModel._description = sTopic._description;
                                             stModel.title = sTopic.title;
                                             stModel.is_recommended = sTopic.is_recommended;
                                             stModel.isSelected = sTopic.isSelected;
                                             
                                             [tModel.subTopicsArray addObject:stModel];
                                        }
                                   }
                                   [cModel.topicsArray addObject:tModel];
                              }
                         }
                         [[SharedManager getInstance].categoriesArray addObject:cModel];
                    }
                    NSString *model = [[UIDevice currentDevice] model];
                    if (![model isEqualToString:@"iPhone Simulator"]) {
                         [self RegisterDeviceForNotification];
                         
                    }
                    [[SharedManager getInstance] saveModel];
                    topicsArray = [[SharedManager getInstance] categoriesArray];
                    delegate.isAlreadyFetched = true;
               }
               else if([flag isEqualToNumber:[NSNumber numberWithInt:USER_ALREADY_FLAG]])
               {
                    
                    [self.view addSubview:dialogView];
               }
               else{
                    NSString *emailMsg;
                    NSString *title;
                    NSString *cancel;
                    
                    NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
                    int languageCode = [language intValue];
                    
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
               }
          }
          else{
               [_loadingView hide];
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               
               
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               int languageCode = [language intValue];
                              
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
          }
     }];
     
}

-(void)sendOnlineStatusCall{
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     [engine useCache];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"onlineStatus" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:@"1" forKey:@"online_status"];
     
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     
     [operation onCompletion:^(MKNetworkOperation *completedOperation){
          
          NSDictionary *mainDict = [completedOperation responseJSON];
          NSLog(@"main dict %@",mainDict);
          
          
     }
                     onError:^(NSError *error){
                          
                     }];
     
     [engine enqueueOperation:operation];
}

#pragma mark --------------
#pragma mark Notification Registeration

-(void)RegisterDeviceForNotification{
     
     
     NSString *token = [AppDelegate getDeviceToken];
     
     if(token){
          NSURL *url = [NSURL URLWithString:SERVER_URL];
          
          NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
          [postParams setObject:@"notificationRegistration" forKey:@"method"];
          [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
          [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
          [postParams setObject:[AppDelegate getDeviceToken] forKey:@"notification_key"];
          [postParams setObject:@"1" forKey:@"which_os"];
          
          NSData *postData = [self encodeDictionary:postParams];
          
          NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
          [request setURL:url];
          [request setHTTPMethod:@"POST"];
          [request setHTTPBody:postData];
          
          [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response , NSData  *data, NSError *error) {
               NSLog(@"%ld",(long)[(NSHTTPURLResponse *)response statusCode]);
               if ( [(NSHTTPURLResponse *)response statusCode] == 200 )
               {
                    [_loadingView hide];
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSNumber *flag = [result objectForKey:@"flag"];
                    
                    if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
                    {
                         [SharedManager getInstance].isNotificationRegister = YES;
                         [[SharedManager getInstance] saveModel];
                    }
               }
               else{
                    [_loadingView hide];
//                    NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
//                    languageCode = [language intValue];
//                    AppDelegate *GameCheck = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//                    if( GameCheck.isGameInProcess == YES){
//                         
//                         NSLog(@"Game is Playing cant Register device");
//                    }else{
//                         
//                         NSString *emailMsg;
//                         NSString *title;
//                         NSString *cancel;
//                         if (languageCode == 0 ) {
//                              emailMsg = @"Check your internet connection setting.";
//                              title = @"Unable to register device";
//                              cancel = CANCEL;
//                         } else if(languageCode == 1) {
//                              emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
//                              title = @"غير قادر على تسجيل جهاز";
//                              cancel = CANCEL_1;
//                         }else if (languageCode == 2){
//                              emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
//                              title = @"Impossible d'enregistrer l'appareil";
//                              cancel = CANCEL_2;
//                         }else if (languageCode == 3){
//                              emailMsg = @"Revise su configuración de conexión a Internet.";
//                              title = @"No se puede registrar el dispositivo";
//                              cancel = CANCEL_3;
//                         }else if (languageCode == 4){
//                              emailMsg = @"Verifique sua configuração de conexão à Internet";
//                              title = @"Não é possível registrar dispositivo";
//                              cancel = CANCEL_4;
//                         }
//                         
//                         [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
//                    }
               }
          }];
     }
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
     NSMutableArray *parts = [[NSMutableArray alloc] init];
     for (NSString *key in dictionary) {
          NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
          [parts addObject:part];
     }
     NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
     return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

-(IBAction)ShowRightMenu:(id)sender{
     
     //[[RightBarVC getInstance] loadProfileImage];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

#pragma mark -------------------------------------
#pragma mark Topics Detail


-(IBAction)getTopics:(id)sender{
     
     [[NavigationHandler getInstance] MoveToTopics];
}

-(IBAction)ShowHistory:(id)sender{
     
     [[NavigationHandler getInstance] MoveToEarnFreePoint];
     //[[NavigationHandler getInstance] MoveToHistory];
}


#pragma mark ---------------------------
#pragma mark Points Detail


-(IBAction)getPoint:(id)sender{
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          MyPointsVC *point1 = [[MyPointsVC alloc] initWithNibName:@"MyPointsVC_iPad" bundle:nil];
          [self.navigationController pushViewController:point1 animated:YES];
     }
     
     else{
          
          MyPointsVC *point2 = [[MyPointsVC alloc] initWithNibName:@"MyPointsVC" bundle:nil];
          [self.navigationController pushViewController:point2 animated:YES];
     }
}


- (IBAction)okVerfiyPressed:(id)sender {
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.profileImage = nil;
     verificationView.hidden = YES;
     [[NavigationHandler getInstance] LogOutUserOnInvalidSession];
}

-(IBAction)showStore:(id)sender{
     
     [[NavigationHandler getInstance] MoveToStore];
}


-(IBAction)ShowSetting:(id)sender{
     
     [[NavigationHandler getInstance] MoveToSetting];
}

-(IBAction)showFriends:(id)sender{
     
     [[NavigationHandler getInstance] MoveToFriends];
}

-(IBAction)ShowMessages:(id)sender{
     
     [[NavigationHandler getInstance] MoveToMessages];
}

-(IBAction)ShowDiscussion:(id)sender{
     
     [[NavigationHandler getInstance] MoveToFriends];
}

- (IBAction)showRanking:(id)sender {
     [[NavigationHandler getInstance] MoveToRanking];
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}
-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     
     
     if(languageCode == 0 ) {
          loadingTitle = Loading;
          playNowLbl.text = PLAY_NOW;
          witsStoreLbl.text = WITS_STORE;
          earnFreePointsLbl.text = INVITE_FRIENDS;
          myMsgLbl.text = MY_MESSAGE;
          myFriendsLbl.text = MY_FRIENDS;
          rankingLbl.text = RANKING;
          settingLbl.text = SETTINGS;
          titleLbl.text = HOME_PAGE_TITLE;
          verifyTxt.text = @"To activate your account, Please click the verification link that has been sent to";
          verifyTitle.text = @"Verify your WITS account";
          Ok = @"Try Other Account";
          
     }
     else if(languageCode == 1 ) {
          loadingTitle = Loading_1;
          
          
          playNowLbl.text = PLAY_NOW_1;
          witsStoreLbl.text = WITS_STORE_1;
          earnFreePointsLbl.text = INVITE_FRIENDS_1;
          myMsgLbl.text = MY_MESSAGE_1;
          myFriendsLbl.text = MY_FRIENDS_1;
          rankingLbl.text = RANKING_1;
          settingLbl.text = SETTINGS_1;
          titleLbl.text = HOME_PAGE_TITLE_1;
          verifyTxt.text = @"لتفعيل حسابك، يرجى النقر على رابط التحقق الذي تم إرساله إلى";
          verifyTitle.text = @"الرجاء التحقق من حساب ويتس الخاص بك";
          
          Ok = @"محاولة حساب آخر";
     }
     else if(languageCode == 2) {
          loadingTitle = Loading_2;
          playNowLbl.text = PLAY_NOW_2;
          witsStoreLbl.text = WITS_STORE_2;
          earnFreePointsLbl.text = INVITE_FRIENDS_2;
          myMsgLbl.text = MY_MESSAGE_2;
          myFriendsLbl.text = MY_FRIENDS_2;
          rankingLbl.text = RANKING_2;
          settingLbl.text = SETTINGS_2;
          titleLbl.text = HOME_PAGE_TITLE_2;
          Ok = @"Essayez autre compte";
     }
     else if(languageCode == 3) {
          
          loadingTitle = Loading_3;
          
          playNowLbl.text = PLAY_NOW_3;
          witsStoreLbl.text = WITS_STORE_3;
          earnFreePointsLbl.text = INVITE_FRIENDS_3;
          myMsgLbl.text = MY_MESSAGE_3;
          myFriendsLbl.text = MY_FRIENDS_3;
          rankingLbl.text = RANKING_3;
          settingLbl.text = SETTINGS_3;
          titleLbl.text = HOME_PAGE_TITLE_3;
          Ok = @"Trate otra cuenta";
          verifyTxt.text = @"Pour activer votre compte, veuillez cliquer sur le lien envoyé à votre adresse";
          verifyTitle.text =@"Vérifier votre compte WITS";
     }
     else if(languageCode == 4) {
          
          loadingTitle = Loading_4;
          playNowLbl.text = PLAY_NOW_4;
          witsStoreLbl.text = WITS_STORE_4;
          earnFreePointsLbl.text = INVITE_FRIENDS_4;
          myMsgLbl.text = MY_MESSAGE_4;
          myFriendsLbl.text = MY_FRIENDS_4;
          rankingLbl.text = RANKING_4;
          settingLbl.text = SETTINGS_4;
          titleLbl.text = HOME_PAGE_TITLE_4;
          Ok = @"Tente outra conta";
          verifyTitle.text = @"Verifique sua conta WITS";
          verifyTxt.text = @"Para ativar sua conta, Por favor click no link the verificação que foi enviado para ";
     }
     
     [_okverifyView setTitle:Ok forState:UIControlStateNormal];
}


@end
