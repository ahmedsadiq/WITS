//
//  GetTopicsVC.m
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "GetTopicsVC.h"
#import "MKNetworkKit.h"
#import "CustomCell.h"
#import "Utils.h"
#import "SharedManager.h"
#import "RightBarVC.h"
#import "Topic.h"
#import "TopicModel.h"
#import "SubTopicsModel.h"
#import "CategoryModel.h"
#import "SubTopicVC.h"
#import "SocketIOPacket.h"
#import "NavigationHandler.h"
#import "HelperFunctions.h"
#import "CustomCell_SelectedCC.h"
#import "ChallengeFriendsVC.h"
#import "UIImageView+RoundImage.h"
#import "AlertMessage.h"
#import "HomeVC.h"

@interface GetTopicsVC ()

@end

@implementation GetTopicsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
          // Custom initialization
     }
     return self;
}

- (IBAction)HelpShiftViewCancelPressed:(id)sender {
     self.tabBarController.tabBar.hidden = false;
     
     _HelpShiftView.hidden = true;
     [_HelpShiftView removeFromSuperview];
     
}

- (IBAction)sendQuestion:(id)sender {
     
     if (answerTxt.text.length < 1) {
          NSString *message;
          if (languageCode == 0 ) {
               message = ENTER_ANSWER;
          }else if (languageCode == 1){
               message = ENTER_ANSWER_1;
          }else if (languageCode == 2){
               message = ENTER_ANSWER_2;
          }else if (languageCode == 3){
               message = ENTER_ANSWER_3;
          }else if (languageCode == 4){
               message = ENTER_ANSWER_4;
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
     }else if (questionTxt.text.length<1){
          NSString *message;
          if (languageCode == 0 ) {
               message = @"Enter Question!";
          }else if (languageCode == 1){
               message = @"ادخل السؤال";
          }else if (languageCode == 2){
               message = @"Entrez question";
          }else if (languageCode == 3){
               message = @"Introduzca pregunta";
          }else if (languageCode == 4){
               message = @"Digite Pergunta";
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
          
     }else{
          
          
          NSString *emailTitle = @"User Choice Question";
          // Email Content
          NSString *messageBody = [NSString stringWithFormat:@"Question: %@ \nAnswer: %@",questionTxt.text,answerTxt.text];
          // To address
          NSArray *toRecipents = [NSArray arrayWithObject:@"wits.addnewcontent@gmail.com"];
          
          MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
          mc.mailComposeDelegate = self;
          [mc setSubject:emailTitle];
          [mc setMessageBody:messageBody isHTML:NO];
          [mc setToRecipients:toRecipents];
          
          // Present mail view controller on screen
          [self presentViewController:mc animated:YES completion:NULL];
     }
     [questionTxt resignFirstResponder];
     [answerTxt resignFirstResponder];
}
-(IBAction)ShowRightMenu:(id)sender{
     
     [self.view endEditing:YES];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}
- (IBAction)homePressed:(id)sender {
     for (UIViewController *controller in self.navigationController.viewControllers) {
          
          if ([controller isKindOfClass:[HomeVC class]]) {
               [self.navigationController popToViewController:controller animated:YES];
               break;
          }
     }
}
- (IBAction)subTopicPressed:(id)sender {
     if(!topicsArray){
          topicsArray = [[SharedManager getInstance] categoriesArray];
     }
     //CategoryModel *tempTopic  =[topicsArray objectAtIndex:0];
     SubTopicVC *tempVC = [[SubTopicVC alloc] initWithAllTopics];
     [self.navigationController pushViewController:tempVC animated:NO];
     [addQuestion removeFromSuperview];
}
- (IBAction)newContentPressed:(id)sender {
     [self.view addSubview:addQuestion];
     addQuestion.hidden = NO;
}
- (IBAction)recommendPressed:(id)sender {
     [expandView reloadData];
     [self.view addSubview:tutorialView];
}

- (IBAction)addQuestionView:(id)sender {
     addQuestion.hidden = true;
}

- (IBAction)tutorialBackPressed:(id)sender {
     [tutorialView removeFromSuperview];
}

- (IBAction)mainBackPressed:(id)sender {
     [timer invalidate];
     timer = nil;
     
     [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)searchPressed:(id)sender {
}

- (IBAction)goToLogin:(id)sender {
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.profileImage = nil;
     [[SharedManager getInstance] ResetModel];
     //Take user to sign up page
     [[NavigationHandler getInstance] NavigateToSignUpScreen];
     //[self ShowInView];
     [self removeImage:@"test"];
}

- (IBAction)PlaywitStars:(id)sender {
}

- (IBAction)PlaywithGems:(id)sender {
}

- (IBAction)CloseGemsDialog:(id)sender {
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     
     //          [[NSUserDefaults standardUserDefaults ]setObject:@"1" forKey:@"callagain"];
     NSString *strCheck = [[NSUserDefaults standardUserDefaults] objectForKey:@"callagain"];
     if([strCheck isEqualToString:@"1"])
     {
          [self fetchTopics];
          
     }
     [self setLanguageForScreen];
     self.tabBarController.tabBar.hidden = false;
     indexCounter = 0;
     
     if (![[SharedManager getInstance] categoryArray] || ![[SharedManager getInstance] categoryArray].count){
          customObject = [[CustomAnimationView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
          [customObject startAnimating];
          [self.view addSubview: customObject];
          
          self.tabBarController.tabBar.hidden = true;
          
          [self fetchTopics];
     }
     else {
          topicsArray = [[SharedManager getInstance] categoriesArray];
     }
     
     //     [self fetchTopics];
     
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     
    // self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     // Do any additional setup after loading the view from its nib.
     [topicTblView setDelegate:self];
     [self setUpTutorial];
     topicTblView.tableHeaderView = searchBar;
     
     [lblGemsPoints setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [lblStarsPoints setText:[[SharedManager getInstance] _userProfile].totalPoints];
     
     
     
     
     titleErrrorMsg.font = [UIFont fontWithName:FONT_NAME  size:17];
     msgErrrormsg.font = [UIFont fontWithName:FONT_NAME  size:16];
     loginbuttonErrorMsg.font = [UIFont fontWithName:FONT_NAME  size:14];
     backBtn2.font = [UIFont fontWithName:FONT_NAME  size:17];
     senderNameLbl.font = [UIFont fontWithName:FONT_NAME  size:14];
     vsLbl.font = [UIFont fontWithName:FONT_NAME  size:17];
     searchingTxt.font = [UIFont fontWithName:FONT_NAME  size:14];
     opponent.font = [UIFont fontWithName:FONT_NAME  size:14];

     
     BOOL isMusicOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
     if(isMusicOn) {
          AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
          [del musicSwitch:true];
     }
     UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(signUpSwipeDown:)];
     [left setDirection:UISwipeGestureRecognizerDirectionUp];
     [self.view addGestureRecognizer:left];
}
- (void)signUpSwipeDown:(UISwipeGestureRecognizer *)gesture
{
     

     [self.tabBarController.tabBar setHidden:false];

//     [UIView animateWithDuration:0.5
//                      animations:^{_HelpShiftView.alpha = 0.0;}
//                      completion:^(BOOL finished){ [_HelpShiftView removeFromSuperview]; }];
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:1.0];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                            forView:[self view]
                              cache:NO];
     [_HelpShiftView removeFromSuperview];

     
     
     [UIView commitAnimations];
}


-(void) setUpTutorial {
     
     [self setLanguageForScreen];
     
     if (!sectionTitleArray) {
          sectionTitleArray = [NSMutableArray arrayWithObjects:@"", nil];
     }
     if (!arrayForBool) {
          arrayForBool    = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO] , nil];
     }
     if (!sectionContentDict) {
          sectionContentDict  = [[NSMutableDictionary alloc] init];
          NSArray *array1     = [NSArray arrayWithObjects:howtoPlay1, howtoPlay2, howtoPlay3, nil];
          [sectionContentDict setValue:array1 forKey:[sectionTitleArray objectAtIndex:0]];
          //      NSArray *array2     = [NSArray arrayWithObjects:howtoEarnPointDesc, nil];
          //    [sectionContentDict setValue:array2 forKey:[sectionTitleArray objectAtIndex:1]];
          //  NSArray *array3     = [NSArray arrayWithObjects:howtouseStoreDesc, nil];
          //  [sectionContentDict setValue:array3 forKey:[sectionTitleArray objectAtIndex:2]];
          
          tutorialArray1 = [array1 copy];
          //    tutorialArray2 = [array2 copy];
          //  tutorialArray3 = [array3 copy];
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
-(void)fetchTopics{
     //[loadView showInView:self.view withTitle:loadingTitle];
     [_loadingView showInView:self.view withTitle:loadingTitle];
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
          [_loadingView hide];
          if ( [(NSHTTPURLResponse *)response statusCode] == 200 )
          {
               [customObject stopAnimating];
               [customObject removeFromSuperview];
               
               //self.tabBarController.tabBar.hidden = false;
               
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
                         NSString *loginEmail = emailOBj.LoginEmail;
                    }
                    //self.tabBarController.tabBar.hidden = false;
                    [customObject stopAnimating];
                    [customObject removeFromSuperview];
                    
                    [SharedManager getInstance]._userProfile.totalPoints = [mainDict objectForKey:@"points"];
                    [SharedManager getInstance]._userProfile.cashablePoints = [mainDict objectForKey:@"cash_able"];
                    //[SharedManager getInstance]._userProfile.cashablePoints = @"1000";
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
                    emailOBj.isAlreadyFetched = true;
                    
                    indexCounter = 0;
                    [topicTblView reloadData];
                    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                    // bool firstTime = FALSE;
                    
                    if ([standardUserDefaults objectForKey:@"FirstTime"] == nil){
                         [self.tabBarController.tabBar setHidden:false];
                    }
                    else {
                         if([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"] == YES){
                              CATransition *transition = [CATransition animation];
                              transition.duration = 0.6;
                              transition.type = kCATransitionPush; //choose your animation
                              transition.subtype = kCATransitionFromBottom;
                              [_HelpShiftView.layer addAnimation:transition forKey:nil];
                              _HelpShiftView.hidden = false;
                              [self.view addSubview:_HelpShiftView];
                              [self.tabBarController.tabBar setHidden:true];
                              [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"FirstTime"];
                              [standardUserDefaults setBool:NO forKey:@"FirstTime"];
                              [standardUserDefaults synchronize];
                         }
                         else{ [self.tabBarController.tabBar setHidden:false];}
                    }
               }
               else if([flag isEqualToNumber:[NSNumber numberWithInt:USER_ALREADY_FLAG]])
               {
                    
                    [customObject stopAnimating];
                    [customObject removeFromSuperview];
                    
                    [self.view addSubview:invalidUserBg];
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
               //self.tabBarController.tabBar.hidden = false;
               [customObject stopAnimating];
               [customObject removeFromSuperview];
               
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
     }];
}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(tableView.tag == 5) {
          if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
               if(IS_IPAD) {
                    return 70;
               }
               return 50;
          }
          return 1;
     }
     else {
          float returnValue;
          if ([[UIScreen mainScreen] bounds].size.height == iPad)
          {
               CategoryModel *tempToplic = (topicTblView==tableView)?[topicsArray objectAtIndex:indexPath.row] : [topicsArrayForSearch objectAtIndex:indexPath.row];
               if(tempToplic.isSelected)
                    returnValue = 260.0f;
               
               else
                    returnValue = 260.0f;
          }
          else
          {
               CategoryModel *tempToplic = (topicTblView==tableView)?[topicsArray objectAtIndex:indexPath.row] : [topicsArrayForSearch objectAtIndex:indexPath.row];
               if(tempToplic.isSelected)
                    returnValue = 140.0f;
               
               else
                    returnValue = 140.0f;
          }
          return returnValue;
     }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     if(tableView.tag == 5) {
          return [sectionTitleArray count];
     }
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     
     if(tableView.tag == 5) {
          if ([[arrayForBool objectAtIndex:section] boolValue]) {
               if(section == 0){
                    return tutorialArray1.count;
               }
               else if(section == 1){
                    return tutorialArray2.count;
               }
               //             else if(section == 2){
               //                  return tutorialArray3.count;
               //             }
          }
          return 1;
     }
     else {
          int indexToBeReturned = (topicsArray.count/5)*3;
          
          if(topicsArray.count % 5 != 0){
               if(topicsArray.count %5 >2){
                    indexToBeReturned = indexToBeReturned+2;
               }
               else{
                    indexToBeReturned++;
               }
          }
          
          return indexToBeReturned;
     }
     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.row % 3 == 2)  {
          indexCounter = (indexPath.row/3)+1;
     }
     else if (indexPath.row % 3 == 1 || indexPath.row % 3 == 0) {
          if(indexPath>2){
               indexCounter = indexPath.row/3;
          }
     }
     
     if(indexPath.row == 0 || indexPath.row%3 != 2)
     {
          static NSString *simpleTableIdentifier = @"CustomCell";
          CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
          if (cell == nil)
          {
               if ([[UIScreen mainScreen] bounds].size.height == iPad) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
               else{
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
          }
          int i = indexPath.row;
          int index= i+(i-indexCounter);
          
          cell.leftOverLay.tag = index;
          [HelperFunctions setBackgroundColor:cell.leftOverLay];
          
          CategoryModel *tempTopic = (CategoryModel*)[topicsArray objectAtIndex:index];
          cell.leftTitle.text = tempTopic.title;
          
          cell.leftTitle.font = [UIFont fontWithName:FONT_NAME size:15];
          cell.leftSubTitles.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempTopic.topicsArray.count];
          cell.leftSubTitles.font = [UIFont fontWithName:FONT_NAME size:38];
          if(IS_IPAD)
          {
               cell.leftTitle.font = [UIFont fontWithName:FONT_NAME size:25];
               cell.leftSubTitles.font = [UIFont fontWithName:FONT_NAME size:45];
          }
          [cell.leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
          cell.leftBtn.tag = index;
          if(i==0) {
               NSString *tempTopicId = tempTopic.category_id;
               // here changed
               [self settingNameofImage:tempTopicId];
               cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:catMaintempImgName]];
               cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:catthumbnailtempName]];
               
          }
          else {
               
               NSString *tempTopicId = tempTopic.category_id;
               // here
               [self settingNameofImage:tempTopicId];
               cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:catMaintempImgName]];
               
               cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:catthumbnailtempName]];
               
          }
          
          
          if(index+1 < topicsArray.count){
               
               CategoryModel *tempTopic = (CategoryModel*)[topicsArray objectAtIndex:index+1];
               cell.rightTitle.text = tempTopic.title;
               // Here logic Changed images
               NSString *tempTopicId = tempTopic.category_id;
               // here
               [self settingNameofImage:tempTopicId];
               cell.rightImg.image = [UIImage imageNamed:[NSString stringWithFormat:catMaintempImgName]];
               
               cell.rightImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:catthumbnailtempName]];
               cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:15];
               cell.rightSubTitles.font = [UIFont fontWithName:FONT_NAME size:38];
               if(IS_IPAD){
                    cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:25];
                    cell.rightSubTitles.font = [UIFont fontWithName:FONT_NAME size:45];
               }
               cell.rightSubTitles.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempTopic.topicsArray.count];
               [cell.rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
               cell.rightBtn.tag = index+1;
               cell.rightOverLay.tag = index+1;
               [HelperFunctions setBackgroundColor:cell.rightOverLay];
               
          }
          else {
               cell.rightBtn.enabled = false;
               cell.rightImg.hidden = true;
               cell.rightImgThumbnail.hidden = true;
               cell.rightSubTitles.hidden = true;
               cell.rightTitle.hidden = true;
               cell.rightOverLay.hidden = true;
          }
          [cell setBackgroundColor:[UIColor clearColor]];
          [cell.contentView setBackgroundColor:[UIColor clearColor]];
          cell.selectionStyle = NAN;
          
          return cell;
     }
     else
     {
          static NSString *simpleTableIdentifier = @"CustomCell_SelectedCC";
          CustomCell_SelectedCC *cell = (CustomCell_SelectedCC *)[tableView dequeueReusableCellWithIdentifier:nil];
          if (cell == nil)
          {
               if ([[UIScreen mainScreen] bounds].size.height == iPad) {
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelected_iPad" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
               else{
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_SelectedCC" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
          }
          int i = indexPath.row;
          int index= (i+(i-indexCounter))+1;
          
          cell.OverlayMain.tag = index;
          [HelperFunctions setBackgroundColor:cell.OverlayMain];
          cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:13];
          
          CategoryModel *tempTopic = (CategoryModel*)[topicsArray objectAtIndex:index];
          cell.mainTitle.text = tempTopic.title;
          cell.mainTitle.font = [UIFont fontWithName:FONT_NAME size:15];
          cell.mainSubTitle.font = [UIFont fontWithName:FONT_NAME size:38];
          if(IS_IPAD)
          {
               cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:25];
               cell.mainTitle.font = [UIFont fontWithName:FONT_NAME size:25];
               cell.mainSubTitle.font = [UIFont fontWithName:FONT_NAME size:45];
          }
          cell.mainSubTitle.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempTopic.topicsArray.count];
          
          NSString *tempTopicId = tempTopic.category_id;
          [self settingNameofImage:tempTopicId];
          cell.mainImg.image = [UIImage imageNamed:[NSString stringWithFormat:catMaintempImgName]];
          
          cell.mainImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:catthumbnailtempName]];
          
          [cell.mainBtn addTarget:self action:@selector(mainBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
          cell.mainBtn.tag = index;
          [cell setBackgroundColor:[UIColor clearColor]];
          [cell.contentView setBackgroundColor:[UIColor clearColor]];
          cell.selectionStyle = NAN;
          return cell;
          
     }
     return nil;
}



- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
     switch (result)
     {
          case MFMailComposeResultCancelled:
               NSLog(@"Mail cancelled");
               break;
          case MFMailComposeResultSaved:
               NSLog(@"Mail saved");
               break;
          case MFMailComposeResultSent:
               NSLog(@"Mail sent");
               break;
          case MFMailComposeResultFailed:
               NSLog(@"Mail sent failure: %@", [error localizedDescription]);
               break;
          default:
               break;
     }
     // Close the Mail Interface
     [self dismissViewControllerAnimated:YES completion:NULL];
     
     addQuestion.hidden = YES;
}

#pragma mark - TableView Delegates

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     
     return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.row < topicsArray.count) {
          
          CategoryModel *tempTopic  = (topicTblView==tableView)?[topicsArray objectAtIndex:indexPath.row] : [topicsArrayForSearch objectAtIndex:indexPath.row];
          
          if(tempTopic.topicsArray.count > 0) {
               SubTopicVC *tempVC = [[SubTopicVC alloc] initWithParentTopicModel:tempTopic];
               [self.navigationController pushViewController:tempVC animated:YES];
          }
          else {
               if ([SharedManager getInstance].isFriendListSelected) {
                    
                    CategoryModel *subTopic = (topicTblView==tableView)?[topicsArray objectAtIndex:indexPath.row] : [topicsArrayForSearch objectAtIndex:indexPath.row];
                    
                    ChallengeFriendsVC *challenge = [[ChallengeFriendsVC alloc] initWithTopic_ID:@"1" andSubTopic:subTopic.category_id];
                    
                    [self.navigationController pushViewController:challenge animated:YES];
               }
               else{
                    if(tempTopic.isSelected)
                         tempTopic.isSelected = false;
                    else
                         tempTopic.isSelected = true;
                    
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
               }
          }
     }
     else {
          topicsArray = [[SharedManager getInstance] categoriesArray];
          CategoryModel *tempTopic  = (topicTblView==tableView)?[topicsArray objectAtIndex:indexPath.row] : [topicsArrayForSearch objectAtIndex:indexPath.row];
          
          if(tempTopic.topicsArray.count > 0) {
               SubTopicVC *tempVC = [[SubTopicVC alloc] initWithParentTopicModel:tempTopic];
               [self.navigationController pushViewController:tempVC animated:YES];
          }
          else {
               if ([SharedManager getInstance].isFriendListSelected) {
                    
                    CategoryModel *subTopic = (topicTblView==tableView)?[topicsArray objectAtIndex:indexPath.row] : [topicsArrayForSearch objectAtIndex:indexPath.row];
                    
                    ChallengeFriendsVC *challenge = [[ChallengeFriendsVC alloc] initWithTopic_ID:@"1" andSubTopic:subTopic.category_id];
                    
                    [self.navigationController pushViewController:challenge animated:YES];
               }
               else{
                    if(tempTopic.isSelected)
                         tempTopic.isSelected = false;
                    else
                         tempTopic.isSelected = true;
                    
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
               }
          }
     }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     
     return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 0;
}

-(void)PlayNowSlected:(id)sender{
     
     if([SharedManager getInstance]._userProfile.isVerifiedBool) {
          int totalPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
          
          if(totalPoints < 10)
          {
               
               
               NSString *message;
               
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    message = @"You don't have sufficient Gems in your account. Please purchase more Gems to proceed";
                    title = @"Error..";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    message = @"ليس لديك رصيد كافٍ من الجواهر";
                    title = @"لقد حصل خطأ ما";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    message = @"Vous n'avez pas assez de Gems";
                    title = @"Erreur: Quelque chose s\'est mal passé!";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    message = @"No tienes suficientes gemas";
                    title = @"Algo salió mal!";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    message = @"VNão tem Gemas suficientes";
                    title = @"Alguma coisa deu errado!";
                    cancel = CANCEL_4;
               }
               
               [AlertMessage showAlertWithMessage:message andTitle:@"Error.." SingleBtn:YES cancelButton:cancel OtherButton:nil];
          }
          else {
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               int languageCode = [language intValue];
               
               if (languageCode == 0) {
                    opponent.text = @"Searching opponent...";
               }else if(languageCode == 1){
                    opponent.text = @"االبحث عن الخصم...";
               }else if (languageCode == 2 ){
                    opponent.text = @"Recherche d\'un adversaire...";
               }else if (languageCode == 3){
                    opponent.text = @"La búsqueda de un oponente...";
               }else if (languageCode == 4){
                    opponent.text = @"Procurando um adversário...";
               }
               
               [senderProfileImageView roundImageCorner];
               UIButton *playBtn = (UIButton *)sender;
               currentSelectedIndex = playBtn.tag;
               timeSinceTimer = 0;
               
               [self connectToSocket];
          }
     }
     else {
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Please verify your account to play game";
               title = @"Verification Required";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message = @"يرجى التحقق من حسابك للعب";
               title = @"مطلوب التحقق";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message = @"Se il vous plaît vérifier votre compte pour jouer";
               title = @"Vérification demandée";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message = @"Por favor, verifique su cuenta para jugar";
               title = @"Comprobación solicitada";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message = @"Por favor, verifique sua conta para jogar";
               title = @"Verificação requerida";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
     }
}
-(void)challengeSelected:(id)sender{
     
     if([[SharedManager getInstance]._userProfile.cashablePoints intValue] < 10)
     {
          
          NSString *message;
          
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"You don't have sufficient Gems in your account. Please purchase more Gems to proceed";
               title = @"Error..";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message = @"ليس لديك رصيد كافٍ من الجواهر";
               title = @"لقد حصل خطأ ما";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message = @"Vous n'avez pas assez de Gems";
               title = @"Erreur: Quelque chose s\'est mal passé!";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message = @"No tienes suficientes gemas";
               title = @"Algo salió mal!";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message = @"VNão tem Gemas suficientes";
               title = @"Alguma coisa deu errado!";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }
     
     UIButton *topicBtn = (UIButton *)sender;
     CategoryModel *subTopic = [topicsArray objectAtIndex:topicBtn.tag];
     
     ChallengeFriendsVC *challenge = [[ChallengeFriendsVC alloc] initWithTopic_ID:@"1" andSubTopic:subTopic.category_id];
     [self.navigationController pushViewController:challenge animated:YES];
}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
     if (indexPath.row == 0 ) {
          BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
          collapsed       = !collapsed;
          [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
          
          //reload specific section animated
          NSRange range   = NSMakeRange(indexPath.section, 1);
          NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
          [expandView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
     }
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     [questionTxt resignFirstResponder];
     [answerTxt resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [questionTxt resignFirstResponder];
     [answerTxt resignFirstResponder];
     return YES;
}

- (void)increaseTimerCount
{
}

-(void)TimeUp{
     
     CategoryModel *tempSubTopic = [topicsArray objectAtIndex:currentSelectedIndex];
     //[[SocketManager getInstance] StartPlayingWithOponent:@"1" ndParentTopicId:tempSubTopic.category_id];
}

-(void)displayNameAndImage{
     
     if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
          senderNameLbl.text = [SharedManager getInstance]._userProfile.display_name;
          
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [senderProfileImageView setImage:[completedOperation responseImage]];
               [senderProfileImageView roundImageCorner];
               
          } onError:^(NSError* error) {
               
          }];
          
          [engine enqueueOperation:op];
     }
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
     CABasicAnimation* rotationAnimation;
     rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
     rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
     rotationAnimation.duration = duration;
     rotationAnimation.cumulative = YES;
     rotationAnimation.repeatCount = repeat;
     
     [opponentProfileImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
     [self filterContentForSearchText:searchString];
     
     // Return YES to cause the search result table view to be reloaded.
     return YES;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView  {
     
     tableView.frame = topicTblView.frame;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     self.navigationController.navigationBar.hidden = YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     self.navigationController.navigationBar.hidden = YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
     
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
     [searchBar resignFirstResponder];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)filterContentForSearchText:(NSString*)str{
     // for inCaseSensitive search
     str = [str uppercaseString];
     
     NSMutableArray *ar=[NSMutableArray array];
     for (CategoryModel *d in topicsArray) {
          NSString *strOriginal = d.title;
          //          // for inCaseSensitive search
          strOriginal = [strOriginal uppercaseString];
          
          if([strOriginal hasPrefix:str]) {
               [ar addObject:d];
               
          }
          
     }
     
     topicsArrayForSearch = ar;
}

#pragma mark Socket Communication Methods
- (void) connectToSocket {
     sharedManager = [SocketManager getInstance];
     sharedManager.socketdelegate = nil;
     sharedManager.socketdelegate = self;
     [sharedManager openSockets];
}

#pragma mark Challenge
- (void) tick:(NSTimer *) timer {
     [[NavigationHandler getInstance] MoveToChallenge:_challenge];
}
#pragma mark Socket Manager Delegate Methods
-(void)DataRevieved:(SocketIOPacket *)packet {
     CategoryModel *subTopic = [topicsArray objectAtIndex:currentSelectedIndex];
     if([packet.name isEqualToString:@"connected"])
     {
          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
          [sharedManager sendEvent:@"register" andParameters:registerDictionary];
     }
     
     else if([packet.name isEqualToString:@"register"])
     {
          NSArray* args = packet.args;
          NSDictionary* arg = args[0];
          
          NSString *isVerified = [arg objectForKey:@"msg"];
          if([isVerified isEqualToString:@"verified"] ){
               
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               int languageCode = [language intValue];
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"1",@"type",subTopic.category_id,@"type_id",language,@"language",@"false",@"is_cancel", nil];
               [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionary];
               
          }
     }
     else if([packet.name isEqualToString:@"findPlayerOpponent"])
     {
          NSArray* args = packet.args;
          NSData *data = [args[0] dataUsingEncoding:NSUTF8StringEncoding];
          NSDictionary *json = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          int flag = [[json objectForKey:@"flag"] intValue];
          if(flag == 3) {
               //Oponent is still searching
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               int languageCode = [language intValue];
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"1",@"type",subTopic.category_id,@"type_id",language,@"language",@"false",@"is_cancel", nil];
               [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionary];
          }
          else if(flag == 1){
               [timer invalidate];
               timer = nil;
               isGameStarted = true;
               
               //Changed by Fiza
               NSString *oppName = [json objectForKey:@"displayName"];
               opponent.text = oppName;
               
               //////__________/////
               
               
               ///////Changes By Fiza/////
               [opponentProfileImageView.layer removeAllAnimations];
               
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               
               MKNetworkOperation *op = [engine operationWithURLString:_challenge.opponent_profileImage params:Nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [opponentProfileImageView setImage:[completedOperation responseImage]];
                    [opponentProfileImageView roundImageCorner];
                    opponentProfileImageView.layer.borderColor = [[UIColor blueColor]CGColor];
                    opponentProfileImageView.layer.borderWidth = 1.0f;
                    
               } onError:^(NSError* error) {
                    
                    opponentProfileImageView.image = [UIImage imageNamed:@"Icon_152.png"];
                    [opponentProfileImageView roundImageCorner];
                    opponentProfileImageView.layer.borderColor = [[UIColor blueColor]CGColor];
                    opponentProfileImageView.layer.borderWidth = 1.0f;
                    
               }];
               
               [engine enqueueOperation:op];
               
               ////////__________/////////
               
               _challenge = [[Challenge alloc] initWithDictionary:json];
               _challenge.type = @"1";
               _challenge.type_ID = subTopic.category_id;
               
               [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(tick:) userInfo:nil repeats:NO];
          }
          
     }
}
-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     if (languageCode == 0) {
          opponent.text = @"Something went wrong..";
     }else if(languageCode == 1){
          opponent.text = @"لقد حصل خطأ ما";
     }else if (languageCode == 2 ){
          opponent.text = @"Erreur: Quelque chose s\'est mal passé";
     }else if (languageCode == 3){
          opponent.text = @"Algo salió mal";
     }else if (languageCode == 4){
          opponent.text = @"Alguma coisa deu errado";
     }
     [timer invalidate];
     timer = nil;
     
     [searchingView removeFromSuperview];
     [SocketManager getInstance].socketdelegate = nil;
     
     NSString *message;
     
     NSString *title;
     NSString *cancel;
     if (languageCode == 0 ) {
          message = @"Sorry, your request cannot be completed.";
          title = @"Something went wrong.";
          cancel = CANCEL;
     } else if(languageCode == 1) {
          message = @"عذرا، لا يمكن إكمال طلبك.";
          title = @"لقد حصل خطأ ما";
          cancel = CANCEL_1;
     }else if (languageCode == 2){
          message = @"Désolée, votre demande ne peut être traitée.";
          title = @"Erreur: Quelque chose s\'est mal passé!";
          cancel = CANCEL_2;
     }else if (languageCode == 3){
          message = @"Lo sentimos, no podremos procesar su solicitud.";
          title = @"Algo salió mal!";
          cancel = CANCEL_3;
     }else if (languageCode == 4){
          message = @"Desculpe, sua solicitação não pode ser atendida.";
          title = @"Alguma coisa deu errado!";
          cancel = CANCEL_4;
     }
     
     
     [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
}

-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     if (languageCode == 0) {
          opponent.text = @"Something went wrong..";
     }else if(languageCode == 1){
          opponent.text = @"لقد حصل خطأ ما";
     }else if (languageCode == 2 ){
          opponent.text = @"Erreur: Quelque chose s\'est mal passé";
     }else if (languageCode == 3){
          opponent.text = @"Algo salió mal";
     }else if (languageCode == 4){
          opponent.text = @"Alguma coisa deu errado";
     }
     [timer invalidate];
     timer = nil;
     
     [searchingView removeFromSuperview];
     [SocketManager getInstance].socketdelegate = nil;
     
     
     
     NSString *message;
     
     NSString *title;
     NSString *cancel;
     if (languageCode == 0 ) {
          message = @"Sorry, your request cannot be completed.";
          title = @"Something went wrong.";
          cancel = CANCEL;
     } else if(languageCode == 1) {
          message = @"عذرا، لا يمكن إكمال طلبك.";
          title = @"لقد حصل خطأ ما";
          cancel = CANCEL_1;
     }else if (languageCode == 2){
          message = @"Désolée, votre demande ne peut être traitée.";
          title = @"Erreur: Quelque chose s\'est mal passé!";
          cancel = CANCEL_2;
     }else if (languageCode == 3){
          message = @"Lo sentimos, no podremos procesar su solicitud.";
          title = @"Algo salió mal!";
          cancel = CANCEL_3;
     }else if (languageCode == 4){
          message = @"Desculpe, sua solicitação não pode ser atendida.";
          title = @"Alguma coisa deu errado!";
          cancel = CANCEL_4;
     }
     
     
     
     [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     
}
- (IBAction)quitGame:(id)sender {
     [timer invalidate];
     timer = nil;
     
     [searchingView removeFromSuperview];
     [sharedManager closeWebSocket];
}
#pragma mark Set Language

-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     
     [[NSUserDefaults standardUserDefaults ]setObject:@"0" forKey:@"callagain"];
     NSString *suffix = @"";
     
     if(languageCode == 0 ) {
          
          searchBar.placeholder = SEARCH_CATEGORY;
          loadingTitle = Loading;
          _CategoriesLbl.text = TOPICS_BTN;
          knowledgeLbl.text = KNOWLEDGE_LBL;
          tutoDesc1.text = TUTORIAL_DESC_LBL;
          tutoDesc2.text = TUTORIAL_DESC_LBL2;
          howtoPlay1 = @"Embark on a 1-1 challenge against anyone in the world.";
          howtoPlay2 = @"The faster you answer the more Gems you'll collect.";
          howtoPlay3 = @"Claim your rewards.";
          
          howtouseStoreDesc = @"Sign up now and get your hands on 1000 free Gems.";
          howtoEarnPointDesc = @"You can always earn free Points simply by inviting your friends and sharing the app on Facebook or Twitter.";
          
          AddaQuestion.text = ADD_QUESTION;
          answerTxt.placeholder = ENTER_ANSWER;
          questionTxt.placeholder = @"Enter a Question";
          
          HowtoPlay = @"How to Play";
          HowWitsStore = @"How to Use WITS Store";
          HowtoEarnPoints = @"How to Earn Free Points";
          
          
          homeLbl.text = HOME_BTN;
          topicLbl.text = TOPICS_LBL;
          adContentLbl.text = ADD_CONTENT;
          guidelineLbl.text = GUIDELINES;
          
          //helpShiftView
          hplbl1.text =@"Go to The WITS Store";
          hpLbl2.text = @"Buy Gems";
          hpLbl3.text = @"Play and Win Prizes";
          hpleftDesc.text = @"Gold plated top rich Austrian style.";
          hpLefttitle.text = @"Roxi-Fashion Royal";
          hprightDesc.text = @"The new PowerShot N opens up a new dimension of photographic expression, helping you express your personal style and flair with powerful innovative Canon technologies.";
          hprightTitle.text = @"Canon N, Digital Camera";
          hpMidtitle.text = @"3 Easy Steps to Redeem your Prize";
          swipelbl.text = @"SWIPE";
          [sendQuestion setTitle:SEND forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          [backBtn3 setTitle:BACK_BTN forState:UIControlStateNormal];
          [backBtn2 setTitle:BACK_BTN forState:UIControlStateNormal];
          
     }
     
     else if(languageCode == 1 ) {
          howtoPlay1 = @"أسرع في دخول تحدي ضد أي شخص في العالم ";
          howtoPlay2 = @"اسرع في الاجابة للحصول على نقاط اكثر";
          howtoPlay3 = @"قم باستبدال جواهرك بنقود حقيقية.";
          
          howtouseStoreDesc = @"اشترك الآن و احصل على 1000 نقطة مجانا.";
          howtoEarnPointDesc = @"يمكنك أن تحصل دائماً على النقاط مجانية بمجرد دعوة اصدقائك للعب و بمشاركة تطبيق اللعبة على الفيس بوك أو تويتر";
          HowtoPlay = @"كيفية اللعب";
          HowWitsStore = @"كيفية استخدام مخزن ويتس";
          HowtoEarnPoints = @"كيف تحصل على النقاط مجاناً؟";
          
          //helpShiftView
          hplbl1.text =@"الذهاب إلى مخزن WITS";
          hpLbl2.text = @"شراء الأحجار الكريمة";
          hpLbl3.text = @"إلعب واربح جوائز";
          hpleftDesc.text = @"مطلية بالذهب من الطراز النمساوي الأكثر ثراء";
          hpLefttitle.text = @"أزياء روكسي الملكية";
          hprightDesc.text = @"بورشوت ن الجديدة تفتح بعد جديد من التعبير التصويري، وتساعدك على التعبير عن أسلوبك الشخصي وموهبتك مع تكنولوجيات كانون القوية والمبدعة";
          hprightTitle.text = @"كاميرا كانون ن الرقمية";
          hpMidtitle.text = @"3 خطوات سهلة لتخليص جائزتك و الحصول عليها ";
           swipelbl.text = @" اسحب باصبعك";
          loadingTitle = Loading_1;
          
          _CategoriesLbl.text = TOPICS_BTN_1;
          vsLbl.text = VS_1;
          searchBar.placeholder = SEARCH_CATEGORY_1;
          knowledgeLbl.text = KNOWLEDGE_LBL_1;
          tutoDesc1.text = TUTORIAL_DESC_LBL_1;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_1;
          tutoDesc1.textAlignment = NSTextAlignmentRight;
          tutoDesc2.textAlignment = NSTextAlignmentRight;
          
          AddaQuestion.text = ADD_QUESTION_1;
          answerTxt.placeholder = ENTER_ANSWER_1;
          questionTxt.placeholder = @"ادخل السؤال";
          
          questionTxt.textAlignment = NSTextAlignmentRight;
          answerTxt.textAlignment = NSTextAlignmentRight;
          
          homeLbl.text = HOME_BTN_1;
          topicLbl.text = TOPICS_LBL_1;
          adContentLbl.text = ADD_CONTENT_1;
          guidelineLbl.text = GUIDELINES_1;
          
          [backBtn3 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_1 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [backBtn2 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          
          loadingTitle = Loading_2;
          
          HowtoPlay = @"Comment jouer";
          HowWitsStore = @"Comment utiliser ESPRITS magasin";
          HowtoEarnPoints = @"Comment gagner des Gems";
          howtoPlay1 = @"Défiez à 1-1 n\'importe qui dans le monde.";
          howtoPlay2 = @"Plus vite vous répondez, plus vous cumulez de Gems.";
          howtoPlay3 = @"Echangez vos Gems contre de l'argent.";
          
          swipelbl.text =@"Frapper";
          howtouseStoreDesc = @"Inscrivez-vous maintenant et gagnez 100 Gems gratuits.";
          howtoEarnPointDesc = @"Vous pouvez toujours gagner des Points en invitant vos amis et en partageant notre application sur Facebook et Twitter.";
          
          searchBar.placeholder = SEARCH_CATEGORY_2;
          _CategoriesLbl.text = TOPICS_BTN_2;
          knowledgeLbl.text = KNOWLEDGE_LBL_2;
          tutoDesc1.text = TUTORIAL_DESC_LBL_2;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_2;
          
          AddaQuestion.text = ADD_QUESTION_2;
          
          //helpShiftView
          hplbl1.text =@"Aller à la boutique de WITS";
          hpLbl2.text = @"Acheter de Gems";
          hpLbl3.text = @"Jouer et gagner des prix";
          hpleftDesc.text = @"Haut plaqué or riche Austrian Style";
          hpLefttitle.text = @"Roxi-Fashion Royal";
          hprightDesc.text = @"Les nouveaux PowerShot N ouvre une nouvelle dimension d\'expression photographique, vous aidant à exprimer votre style personnel et flair avec de puissantes technologies Canon innovants";
          hprightTitle.text = @"Canon N, Appareil Photo Numérique";
          hpMidtitle.text = @"Trois étapes simples pour Recuperares votre prix";
          
          HowtoPlay = @"Comment jouer";
          HowWitsStore = @"Comment utiliser ESPRITS magasin";
          HowtoEarnPoints = @"Comment gagner des Points";
          
          homeLbl.text = HOME_BTN_2;
          topicLbl.text = TOPICS_LBL_2;
          adContentLbl.text = ADD_CONTENT_2;
          guidelineLbl.text = GUIDELINES_2;
          
          [backBtn3 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [backBtn2 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_2 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          
          HowtoPlay = @"Cómo jugar";
          HowWitsStore = @"Cómo utilizar WITS tienda";
          HowtoEarnPoints = @"Cómo ganar pontus.";
          
          howtoPlay1 = @" Inicie un reto 1-1 contra a cualquiera en el mundo.";
          howtoPlay2 = @"En cuanto más rápido responde más puntos podrá recoger.";
          howtoPlay3 = @"Cambia tus gemas por dinero real.";
          
          howtouseStoreDesc = @"Registrase ahora y gane 1000 puntos gratis";
          howtoEarnPointDesc = @"Puedes ganar pontus gratis invitando a tus amigos y compartiendo la aplicación en Facebook or Twitter.";
          swipelbl.text = @"DESLIZAR";
          searchBar.placeholder = SEARCH_CATEGORY_3;
          loadingTitle = Loading_3;
          _CategoriesLbl.text = TOPICS_BTN_3;
          knowledgeLbl.text = KNOWLEDGE_LBL_3;
          tutoDesc1.text = TUTORIAL_DESC_LBL_3;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_3;
          
          AddaQuestion.text = ADD_QUESTION_3;
          answerTxt.placeholder = ENTER_ANSWER_3;
          questionTxt.placeholder = @"Introduzca pregunta";
          //helpShiftView
          hplbl1.text =@"Ir a la Tienda de WITS";
          hpLbl2.text = @"Comprar Gemas";
          hpLbl3.text = @"Jugar y ganar premios";
          hpleftDesc.text = @"Top Oro Plateado Estilo Australiano.";
          hpLefttitle.text = @"Roxi-Fashion Royal";
          hprightDesc.text = @"El nuevo PowerShot N abre una nueva dimensión de la expresión fotográfica ayudándote a expresar tu estilo personal y tu potencial con las potentes e innovadoras tecnologías Canon.";
          hprightTitle.text = @"Canon N, Cámara Digital";
          hpMidtitle.text = @"3 pasos fáciles para liberar tu premio";
          
          homeLbl.text = HOME_BTN_3;
          topicLbl.text = TOPICS_LBL_3;
          adContentLbl.text = ADD_CONTENT_3;
          guidelineLbl.text = GUIDELINES_3;
          
          [backBtn3 setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [backBtn2 setTitle:BACK_BTN_3  forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_3 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          
          howtoPlay1 = @"Inicie um desafio de 1-1 contra qualquer pessoa no mundo.";
          howtoPlay2 = @"Quanto mais rápido você responder, mais pontos você vai acumular.";
          howtoPlay3 = @"Troque as suas Gemas por dinheiro verdadeiro.";
          
          howtouseStoreDesc = @"Inscreva-se gratuitamente e ganhe 1000 pontos";
          howtoEarnPointDesc = @"Poderá receber pontus Grátis a todo momento ao convidar os seus amigos ou ao partilhar a App no Facebook ou Twitter.";
          swipelbl.text = @"Deslizar";
          searchBar.placeholder = SEARCH_CATEGORY_4;
          loadingTitle = Loading_4;
          _CategoriesLbl.text = TOPICS_BTN_4;
          knowledgeLbl.text = KNOWLEDGE_LBL_4;
          tutoDesc1.text = TUTORIAL_DESC_LBL_4;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_4;
          //helpShiftView
          hplbl1.text =@"Ir para Loja WITS";
          hpLbl2.text = @"Comprar Gems";
          hpLbl3.text = @"Jogue e Ganhe Prêmios";
          hpleftDesc.text = @"Coroa banhada a ouro, rico estilo Austríaco";
          hpLefttitle.text = @"Roxi-Fashion Real";
          hprightDesc.text = @"A nova PowerShot N abre uma nova dimensão de expressão fotográfica, ajudando você expressar seu estilo e dom pessoal com poderosas tecnologias inovadoras Canon";
          hprightTitle.text = @"Câmera Digital Canon N";
          hpMidtitle.text = @"3 Passos Simples para Resgatar seu Prêmio";
          AddaQuestion.text = ADD_QUESTION_4;
          answerTxt.placeholder = ENTER_ANSWER_4;
          questionTxt.placeholder = @"Digite Pergunta";
          
          HowtoPlay = @"Como Jogar";
          HowWitsStore = @"Como usar WITS loja";
          HowtoEarnPoints = @"Como ganhar pontus grátis";
          
          homeLbl.text = HOME_BTN_4;
          topicLbl.text = TOPICS_LBL_4;
          adContentLbl.text = ADD_CONTENT_4;
          guidelineLbl.text = GUIDELINES_4;
          
          [backBtn3 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [backBtn2 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_4 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
     if (!languageCode == 0) {
          self.searchDisplayController.searchBar.userInteractionEnabled = NO;
          self.searchDisplayController.searchBar.alpha = .5;
     }else{
          
          self.searchDisplayController.searchBar.userInteractionEnabled = YES;
          self.searchDisplayController.searchBar.alpha = 1.0;
     }
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
               if ( [(NSHTTPURLResponse *)response statusCode] == 200 )
               {
                    [customObject stopAnimating];
                    [customObject removeFromSuperview];
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSNumber *flag = [result objectForKey:@"flag"];
                    
                    if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
                    {
                         [SharedManager getInstance].isNotificationRegister = YES;
                         [[SharedManager getInstance] saveModel];
                    }
               }
               else{
                    [customObject stopAnimating];
                    [customObject removeFromSuperview];
                    
               }
          }];
     }
}

#pragma cell button Pressed State
-(void)leftBtnPressed :(id) sender {
     
     UIButton *senderBtn = (UIButton*)sender;
     
     CategoryModel *tempTopic  = [topicsArray objectAtIndex:senderBtn.tag];
     
     if(tempTopic.topicsArray.count > 0) {
          SubTopicVC *tempVC = [[SubTopicVC alloc] initWithParentTopicModel:tempTopic];
          [self.navigationController pushViewController:tempVC animated:YES];
     }
     
     
}
-(void)rightBtnPressed :(id) sender {
     UIButton *senderBtn = (UIButton*)sender;
     
     CategoryModel *tempTopic  = [topicsArray objectAtIndex:senderBtn.tag];
     
     if(tempTopic.topicsArray.count > 0) {
          SubTopicVC *tempVC = [[SubTopicVC alloc] initWithParentTopicModel:tempTopic];
          [self.navigationController pushViewController:tempVC animated:YES];
     }
     
}
-(void)mainBtnPressed :(id) sender {
     UIButton *senderBtn = (UIButton*)sender;
     
     CategoryModel *tempTopic  = [topicsArray objectAtIndex:senderBtn.tag];
     
     if(tempTopic.topicsArray.count > 0) {
          SubTopicVC *tempVC = [[SubTopicVC alloc] initWithParentTopicModel:tempTopic];
          [self.navigationController pushViewController:tempVC animated:YES];
     }
     
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



-(void) settingNameofImage:(NSString *)idOfCat
{
     
     // here
     
     if([idOfCat isEqualToString:@"1"])
     {
          catMaintempImgName = @"General1.png";
          catthumbnailtempName = @"Generalsmallicon.png";
          
     }else  if([idOfCat isEqualToString:@"2"])
     {
          catMaintempImgName = @"Sports.png";
          catthumbnailtempName = @"Sportsicon.png";
          
          
     }else  if([idOfCat isEqualToString:@"3"])
     {
          catMaintempImgName = @"History.png";
          catthumbnailtempName = @"Historyicon.png";
          
          
     }else  if([idOfCat isEqualToString:@"4"])
     {
          catMaintempImgName = @"Geography.png";
          catthumbnailtempName = @"Geographyicon.png";
          
          
     }else  if([idOfCat isEqualToString:@"5"])
     {
          catMaintempImgName = @"Education.png";
          catthumbnailtempName = @"Educationicon.png";
          
          
     }else  if([idOfCat isEqualToString:@"6"])
     {
          catMaintempImgName = @"Games.png";
          catthumbnailtempName = @"Gamesicon.png";
          
          
     }else  if([idOfCat isEqualToString:@"7"])
     {
          
          catMaintempImgName = @"Science and Technology.png";
          catthumbnailtempName = @"Science and Technologyicon.png";
          
     }else  if([idOfCat isEqualToString:@"8"])
     {
          catMaintempImgName = @"Entertainment.png";
          catthumbnailtempName = @"Entertainmenticon.png";
          
          
     }else  if([idOfCat isEqualToString:@"9"])
     {
          catMaintempImgName = @"Religion.png";
          catthumbnailtempName = @"Religionicon.png";
          
          
     }
     
     
     
     
}





@end