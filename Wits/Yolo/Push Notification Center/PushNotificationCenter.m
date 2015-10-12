//
//  PushNotificationCenter.m
//  Yolo
//
//  Created by Nisar Ahmad on 05/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "PushNotificationCenter.h"

#import "ChallengeVC.h"
#import "NavigationHandler.h"
#import "MessageThreads.h"
#import "AppDelegate.h"
#import "UIImageView+RoundImage.h"
#import "SharedManager.h"
#import "MKNetworkOperation.h"
#import "MKNetworkEngine.h"
#import "SocketIOPacket.h"
#import "Utils.h"
#import "AlertMessage.h"
#import "NotifAlertMessage.h"
#import "ChallengeSearchObject.h"
#import "ConversationVC.h"
#import "FriendsVC.h"
//#import "conver"

@implementation PushNotificationCenter
@synthesize sharedManager;

static PushNotificationCenter *centerInstance;

+(PushNotificationCenter *)getInstance{
     
     if(centerInstance == NULL)
     {
          centerInstance = [[PushNotificationCenter alloc] init];
     }
     
     return centerInstance;
}

-(void)AnalyzeNotification:(NSDictionary *)notification{
     
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     notif = [[NotifAlertMessage alloc]init];
     notif.delegate = self;
     
     if(notification)
     {
          NSLog(@"%@",notification);
          NSDictionary *aps = [notification objectForKey:@"aps"];
          NSDictionary *body = [aps objectForKey:@"alert"];
          int type_no = [[notification objectForKey:@"notificationType"] intValue];
          
          if(type_no == CHALLENGE_NOTIFICATION_TYPE || type_no == 5) {
               BOOL isChallengeNotificationOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"challenge"];
               if(isChallengeNotificationOn) {
                    [self Respond_To_ChallengeRequest:notification];
               }
          }
          else if(type_no == CHAT_MESSAGE_TYPE)
          {
               BOOL isChatNotificationOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"chat"];
               if(isChatNotificationOn) {
                    [self RespondToMessageType:notification];
               }
          }
          else if(type_no == FRIEND_REQUEST_TYPE)
          {
               [self RespondToFriendRequestType:notification];
               
          }
          else if(type_no == POINTS_RECIEVED_TYPE)
          {
               //[self RespondToPointsRecievedType:body];
               
          }
          else
          {
               
               language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"Unidentified notification type";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"إشعار مجهول";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"Type de notification inconnu";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"Tipo de notificación desconocido";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Tipo de notificação não identificado";
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:emailMsg  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
               
               /*    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                message:@"Unidentified notification type"
                delegate:nil
                cancelButtonTitle:@"ok"
                otherButtonTitles:nil];
                
                [alertView show];*/
          }
     }
     
     
}


-(void)Respond_To_ChallengeRequest:(NSDictionary *)_dict{
     
     challengeDIctionary = _dict;
     
     
     type = [challengeDIctionary objectForKey:@"type"];
     type_id = [challengeDIctionary objectForKey:@"typeId"];
     
     opposenderName = (NSString*)[challengeDIctionary objectForKey:@"userName"];
     NSString *msgbody = (NSString*)[challengeDIctionary objectForKey:@"message"];
     NSString *gameTitle = (NSString*)[challengeDIctionary objectForKey:@"gameTitle"];
     NSString *requestType = (NSString*)[challengeDIctionary objectForKey:@"requestType"];
     opponentsenderImage = (NSString*)[challengeDIctionary objectForKey:@"profileImage"];
     
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *title;
     NSString *cancel;
     NSString *View;
     NSString *message;
     
     if (languageCode == 0) {
          message = @" has Challenged you for";
          title = @"has Challenged you!";
          cancel = CANCEL;
          View = @"Accept";
          
     }else if (languageCode == 1){
          message = @" قد طلب تحديكم في ";
          title = @"قد طلب تحديكم!";
          cancel = CANCEL_1;
          View = @"تقبل";
          
     }else if (languageCode == 2){
          message = @"vous a défié pour";
          title = @"vous a défié!";
          cancel = CANCEL_2;
          View = @"accepter";
     }else if (languageCode == 3){
          message = @" mandó una solicitud de reto para ";
          title = @"mandó una solicitud de reto!";
          cancel = CANCEL_3;
          View = @"accepter";
     }else if (languageCode == 4){
          message = @" Desafiou você para ";
          title = @"Desafiou você!";
          cancel = CANCEL_4;
          View = @"accepter";
     }
     
     NSString *finalString = [[NSString alloc]initWithFormat:@"%@ %@ against %@.",opposenderName,message,requestType ];
     
     
     NSString *finalTitle = [NSString stringWithFormat:@"%@ %@",opposenderName,title];
     
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:finalTitle
                                                         message:msgbody
                                                        delegate:self
                                               cancelButtonTitle:cancel
                                               otherButtonTitles:View,nil];
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     appDelegate.isGameInProcess = true;
     
     alertView.tag = CHALLENGE_NOTIFICATION_TYPE;
     [alertView show];
     Tag = CHALLENGE_NOTIFICATION_TYPE;
}

-(void)RespondToMessageType:(NSDictionary *)_body{
     
     /* Getting this in body
      alert =         {
      "message_id" = 193;
      "thread_id" = 32;
      type = 2;
      "user_id" = 124;
      };
      */
     messageDictionary = _body;
     
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     NSString *senderName = (NSString*)[messageDictionary objectForKey:@"user_name"];
     NSString *senderImage = (NSString*)[messageDictionary objectForKey:@"profile_image"];
     NSString *MessageNotif;// = (NSString*)[messageDictionary objectForKey:@"message"];
     
     NSString *title;
     NSString *cancel;
     NSString *View;
     
     if (languageCode == 0) {
          MessageNotif = @"New Message from ";
          title = MESSAGE_BTN;
          cancel = CANCEL;
          View = VIEW;
          
     }else if (languageCode == 1){
          MessageNotif = @"رسالة جديدة من";
          title = MESSAGE_BTN_1;
          cancel = CANCEL_1;
          View = VIEW_1;
          
     }else if (languageCode == 2){
          MessageNotif = @"Nouveau message de ";
          title = MESSAGE_BTN_2;
          cancel = CANCEL_2;
          View = VIEW_2;
     }else if (languageCode == 3){
          MessageNotif =@"Nuevo mensaje de";
          title = MESSAGE_BTN_3;
          cancel = CANCEL_3;
          View = VIEW_3;
     }else if (languageCode == 4){
          MessageNotif = @"Nouveau message de";
          title = MESSAGE_BTN_4;
          cancel = CANCEL_4;
          View = VIEW_4;
     }
     
     //     AppDelegate *Inbox = (AppDelegate *)[UIApplication sharedApplication].delegate;
     //
     //     if(Inbox.isInbox == false){
     //
     //          /*  [AlertMessage showAlertWithMessage:MessageNotif andTitle:title SingleBtn:NO cancelButton:cancel OtherButton:View];
     //           */
     //
     //          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
     //                                                              message:MessageNotif
     //                                                             delegate:self
     //                                                    cancelButtonTitle:cancel
     //                                                    otherButtonTitles:View,nil];
     //
     //          alertView.tag = CHAT_MESSAGE_TYPE;
     //          [alertView show];
     //     }
     
     NSString *finalString = [NSString stringWithFormat:@"%@%@",MessageNotif,senderName];
     
     NSLog(@"finalStr %@",finalString);
     //     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
     //                                                         message:finalString
     //                                                        delegate:self
     //                                               cancelButtonTitle:cancel
     //                                               otherButtonTitles:View,nil];
     //
     //     alertView.tag = CHAT_MESSAGE_TYPE;
     //     [alertView show];
     
     [NotifAlertMessage showNotifAlertWithMessage:finalString andTitle:title cancelButton:cancel OtherButton:View ActionNameForSecondBtn:@"Msg" ImageLink:senderImage initwithDict:messageDictionary];
     Tag = CHAT_MESSAGE_TYPE;
}

-(void)RespondToFriendRequestType:(NSDictionary *)_body{
     
     /* Getting this in body
      alert =         {
      "message_id" = 193;
      "thread_id" = 32;
      type = 2;
      "user_id" = 124;
      };
      */
     
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     messageDictionary = _body;
     
     
     NSLog(@"Friend Req Notification %@",[messageDictionary objectForKey:@"message"]);
     NSString *senderImage = (NSString*)[messageDictionary objectForKey:@"profile_image"];
     
     NSString *ReqNotification = (NSString*)[messageDictionary objectForKey:@"message"];
     
     NSArray * arr = [ReqNotification componentsSeparatedByString:@" "];
     NSLog(@"Array values are : %@",arr);
     NSString *senderName = [arr objectAtIndex:0];
     NSLog(@"senderName %@",senderName);
     
     NSString *friendReq;
     NSString *title;
     NSString *cancel;
     NSString *View;
     
     if (languageCode == 0) {
          friendReq = @" has sent you a Friend Request";
          title = @"Friend Request!";
          cancel = OK_BTN;
          View = VIEW;
     }else if (languageCode == 1){
          friendReq = @"قد أرسل لك طلب صداقة ";
          title = @"طلب صداقة ";
          cancel = OK_BTN_1;
          View = VIEW_1;
     }else if (languageCode == 2){
          friendReq = @" vous a envoyé une demande d'ajout à la liste d'amis";
          title = @"Demande d'ajout d'amis!";
          cancel = OK_BTN_2;
          View = VIEW_2;
     }else if (languageCode == 3){
          friendReq = @" mandó una solicitud de amistad";
          title = @"¡Solicitud de amistad!";
          cancel = OK_BTN_3;
          View = VIEW_3;
     }else if (languageCode == 4){
          friendReq = @" enviou a você uma Solicitação de Amizade";
          title = @"Solicitação de Amizade!";
          cancel = OK_BTN_4;
          View = VIEW_4;
     }
     
     NSString *finalString = [[NSString alloc]initWithFormat:@"%@ %@",senderName,friendReq ];
     NSString *strTemp = [messageDictionary objectForKey:@"message"];
     NSString *accepted = @"accepted";
     
     
     NSRange textRange = [[strTemp lowercaseString] rangeOfString:[accepted lowercaseString]];
     
     if(textRange.location != NSNotFound)
     {
          finalString = [messageDictionary objectForKey:@"message"];
     }
     
     [NotifAlertMessage showNotifAlertWithMessage:finalString andTitle:title cancelButton:cancel OtherButton:View ActionNameForSecondBtn:@"FriendReq" ImageLink:senderImage initwithDict:nil];
     
     Tag = FRIEND_REQUEST_TYPE;
}
-(void)RespondToPointsRecievedType:(NSDictionary *)_body{
     
     /* Getting this in body
      alert =         {
      "message_id" = 193;
      "thread_id" = 32;
      type = 2;
      "user_id" = 124;
      };
      */
     messageDictionary = _body;
     NSLog(@"dictionary notifcation %@",_body);
     
     NSString *pointsMessage = (NSString*)[messageDictionary objectForKey:@"message"];
     NSString *currentPoints = (NSString*)[messageDictionary objectForKey:@"current_points"];
     
     NSArray * arr = [pointsMessage componentsSeparatedByString:@" "];
     NSLog(@"Array values are : %@",arr);
     NSString *senderName = [arr objectAtIndex:0];
     NSLog(@"senderName %@",senderName);
     NSString *Points = (NSString*)[messageDictionary objectForKey:@"points_added"];
     NSLog(@"Gems%@",Points);
     NSLog(@"Gems Notification %@",pointsMessage);
     
     [[SharedManager getInstance] _userProfile].cashablePoints = currentPoints;
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     NSString *title;
     NSString *cancel;
     NSString *View;
     NSString *message;
     NSString *alertTitle;
     
     if (languageCode == 0) {
          message = @" has sent you ";
          title = GEMS;
          cancel = CANCEL;
          View = OK_BTN;
          alertTitle = @"Congratulations!";
          
     }else if (languageCode == 1){
          message = @"قد أرسل لك ";
          title = GEMS_1;
          cancel = CANCEL_1;
          View = OK_BTN_1;
          alertTitle = @"مبروك!";
          
     }else if (languageCode == 2){
          message = @" vous a envoyé ";
          title = GEMS_2;
          cancel = CANCEL_2;
          View = OK_BTN_2;
          alertTitle = @"Félicitations!";
          
     }else if (languageCode == 3){
          message = @" mandó ";
          title = GEMS_3;
          cancel = CANCEL_3;
          View = OK_BTN_3;
          alertTitle = @"¡Felicidades!";
          
     }else if (languageCode == 4){
          message = @"enviou a você ";
          title = GEMS_4;
          cancel = CANCEL_4;
          View = OK_BTN_4;
          alertTitle = @"Parabéns!";
     }
     NSString *finalString = [[NSString alloc]initWithFormat:@"%@ %@ %@ %@",senderName,message,Points,title ];
     
     
     [AlertMessage showAlertWithMessage:finalString andTitle:alertTitle SingleBtn:YES cancelButton:View OtherButton:nil];
     /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
      message:pointsMessage
      delegate:self
      cancelButtonTitle:nil
      otherButtonTitles:View,nil];
      
      alertView.tag = POINTS_RECIEVED_TYPE;
      [alertView show];*/
}
-(void) closeAlert: (NSString*)alertType{
     if ([alertType isEqualToString:@"Challenge"]) {
          isChallengeAccepted = false;
          [self connectToSocket];
     }
     
}

-(void)Okbtn :(NSString*)alertType withDictionary:(NSDictionary*)dict{
     notif.delegate = nil;
     notif.delegate = self;
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     
     if ([alertType isEqualToString:@"Challenge"]) {
          
     }else if ([alertType isEqualToString: @"Msg"]){
          
          messageDictionary = dict;
          
          NSString *threadID = [messageDictionary  objectForKey:@"thread_id"];
          MessageThreads *tempThread = [[MessageThreads alloc] init];
          tempThread.threadId = threadID;
          tempThread.userId = [messageDictionary  objectForKey:@"user_id"];
          tempThread.profileImage = [messageDictionary  objectForKey:@"profile_image"];
          tempThread.displayName = [messageDictionary  objectForKey:@"user_name"];
          tempThread.timeAgo = [messageDictionary objectForKey:@"time_ago"];
          tempThread.currentServerTime = [messageDictionary objectForKey:@"current_time"];
          
                    
          ConversationVC *conver = [[ConversationVC alloc] initWithThread:tempThread];
          conver.headerTitle = @"Messages";
          UITabBarController *tbc = (UITabBarController *)[appDelegate window].rootViewController;
          [(UINavigationController *)tbc.selectedViewController pushViewController:conver animated:YES];
          [tbc.tabBar setHidden:YES];
          
     }else if ([alertType isEqualToString: @"Friend Request"]){
          
          UITabBarController *tbc = (UITabBarController *)[appDelegate window].rootViewController;
          appDelegate.isFriendRequest = true;
          [tbc setSelectedIndex:1];
     }
     
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     
     
     if(alertView.tag == CHALLENGE_NOTIFICATION_TYPE)
     {
          
          if(buttonIndex == 0)
          {
               isChallengeAccepted = false;
               [alertView dismissWithClickedButtonIndex:0 animated:YES];
               [self connectToSocket];
          }
          else if(buttonIndex == 1)
          {
               timeSinceTimer = 0;
               isChallengeAccepted = true;
               currentSelectedIndex = buttonIndex;
               
               ChallengeSearchObject *searchObj= [[ChallengeSearchObject alloc] init];
               
               AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
               if(delegate.profileImage) {
                    searchObj.senderProfileImage = delegate.profileImage;
               }
               searchObj.senderName = [SharedManager getInstance]._userProfile.display_name;
               searchObj.recieverName = opposenderName;
               searchObj.senderProfileImgLink = [SharedManager getInstance]._userProfile.profile_image;
               searchObj.recieverProfileImgLink = opponentsenderImage;
               
               customSerachView = [[[NSBundle mainBundle] loadNibNamed:@"CustomLoading" owner:nil options:nil] objectAtIndex:0];
               [customSerachView showAlertMessage:searchObj];
               
               AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
               [[appDelegate window] addSubview:customSerachView];
               
               timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
               
               eventId = 0;
               [self connectToSocket];
               [alertView dismissWithClickedButtonIndex:0 animated:YES];
          }
          
     }
     else if(alertView.tag == CHAT_MESSAGE_TYPE)
     {
          if(buttonIndex == 0)
          {
               [alertView dismissWithClickedButtonIndex:0 animated:YES];
          }
          else if(buttonIndex == 1)
          {
               NSString *threadID = [messageDictionary  objectForKey:@"thread_id"];
               MessageThreads *tempThread = [[MessageThreads alloc] init];
               tempThread.threadId = threadID;
               tempThread.userId = [messageDictionary  objectForKey:@"user_id"];
               tempThread.profileImage = [messageDictionary  objectForKey:@"profile_image"];
               tempThread.displayName = [messageDictionary  objectForKey:@"user_name"];
               tempThread.timeAgo = [messageDictionary objectForKey:@"time_ago"];
               tempThread.currentServerTime = [messageDictionary objectForKey:@"current_time"];
               
               
               [[NavigationHandler getInstance] openConversation:tempThread];
          }
     }
     else if(alertView.tag == FRIEND_REQUEST_TYPE)
     {
          if(buttonIndex == 0)
          {
               [alertView dismissWithClickedButtonIndex:0 animated:YES];
          }
          else if(buttonIndex == 1)
          {
               [[NavigationHandler getInstance] MoveToFriends];
          }
     }
     else if(alertView.tag == POINTS_RECIEVED_TYPE)
     {
          /*if(buttonIndex == 0)
           {
           [alertView dismissWithClickedButtonIndex:0 animated:YES];
           }
           else if(buttonIndex == 1)
           {
           [[NavigationHandler getInstance] MoveToStore];
           }*/
     }
}
-(void)backPressed :(id)sender {
     [challengeView removeFromSuperview];
}

- (void) tick:(NSTimer *) timer {
     [challengeView removeFromSuperview];
     Challenge *_challenge = [[Challenge alloc] initWithChallengeDictionary:dictChallenge];
     [[NavigationHandler getInstance] MoveToChallenge:_challenge andRecieved:true];
}


#pragma mark Socket Communication Methods
- (void) connectToSocket {
     sharedManager = [SocketManager getInstance];
     sharedManager.socketdelegate = nil;
     sharedManager.socketdelegate = self;
     
     [sharedManager openSockets];
}

#pragma mark iPhone - Server Communication
-(void) DataRevieved:(SocketIOPacket *)packet{
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     NSString *requestType = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"requestType"];
     challengeID = [challengeDIctionary objectForKey:@"challengeId"];
     
     if([packet.name isEqualToString:@"connected"])
     {
          eventId = 1;
          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
          [sharedManager sendEvent:@"register" andParameters:registerDictionary];
     }
     else if([packet.name isEqualToString:@"register"])
     {
          eventId = 2;
          NSArray* args = packet.args;
          NSDictionary* arg = args[0];
          
          NSString *isVerified = [arg objectForKey:@"msg"];
          if([isVerified isEqualToString:@"verified"] ){
               if(!isChallengeAccepted) {
                    
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",challengeID,@"challenge_id",requestType,@"challenge_type", nil];
                    [sharedManager sendEvent:@"cancelChallenge" andParameters:registerDictionary];
               }
               else {
                    NSString *challengeID = [challengeDIctionary objectForKey:@"challengeId"];
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",challengeID,@"challenge_id",language,@"language",requestType,@"challenge_type", nil];
                    [sharedManager sendEvent:@"acceptChallenge" andParameters:registerDictionary];
               }
          }
     }
     else if ([packet.name isEqualToString:@"acceptChallenge"]) {
          searchingicon.hidden = YES;
          NSArray* args = packet.args;
          NSDictionary *json = (NSDictionary*)args[0];
          NSDictionary *userDictInner = [json objectForKey:[SharedManager getInstance].userID];
          [customSerachView removeFromSuperview];
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 1){
               isOpponentFound = true;
               [timer invalidate];
               timer = nil;
          
               Challenge *_challenge = [[Challenge alloc] initWithDictionary:userDictInner];
               _challenge.type = type;
               _challenge.type_ID = type_id;
               NSString *strOppName= [userDictInner objectForKey:@"displayName"];
               searchLbl.text = strOppName;
               _challenge.challengeID = [challengeDIctionary objectForKey:@"challengeId"];
               
               ChallengeVC *challengeTemp = [[ChallengeVC alloc] initWithChallenge:_challenge];
               
               AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
               
               
               UITabBarController *tbc = (UITabBarController *)[appDelegate window].rootViewController;
               tbc.tabBar.hidden = true;
               [(UINavigationController *)tbc.selectedViewController pushViewController:challengeTemp animated:YES];
               
          }
          else if(flag == 5) {
               [AlertMessage showAlertWithMessage:@"Sorry, your friend is not interested in the challenge request at the moment. Retry later." andTitle:@"Challenge Not Accepted" SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
          }
          else {
               [AlertMessage showAlertWithMessage:@"Unfortunately, your friend can't be reached at the moment. Please try later." andTitle:@"Friend Not Available" SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
          }
     }
     else if ([packet.name isEqualToString:@"cancelChallenge"]) {
          AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          appDelegate.isGameInProcess = false;
          [customSerachView removeFromSuperview];
     }
}
-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     NSLog(@"socketDisconnected:::::Accept Challenge");
     [customSerachView removeFromSuperview];
     
     //Alert View that opponent has gone away
}
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     NSLog(@"socketError:::::Accept Challenge%@",error);
     [customSerachView removeFromSuperview];
     
     //Alert View that opponent has gone away
}

- (void)increaseTimerCount
{
     if (isOpponentFound){
          timeSinceTimer = 0;
     }
     else{
          if(timeSinceTimer == 45) {
               timeSinceTimer = 0;
               [timer invalidate];
               timer = nil;
               [customSerachView removeFromSuperview];
               
               [AlertMessage showAlertWithMessage:@"Unfortunately, your friend can't be reached at the moment. Please try later." andTitle:@"Friend Not Available" SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
          }
          else {
               timeSinceTimer = timeSinceTimer+2;
          }
     }
}

@end
