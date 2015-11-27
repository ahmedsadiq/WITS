//
//  MessagesVC.m
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "MessagesVC.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "RightBarVC.h"
#import "MessageThreads.h"
#import "ThreadCC.h"
#import "ConversationVC.h"
#import "UIImageView+RoundImage.h"
#import "AppDelegate.h"
#import "NavigationHandler.h"
#import "FriendsVC.h"

@interface MessagesVC ()

@end

@implementation MessagesVC

- (id)init
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          self = [super initWithNibName:@"MessagesVC_iPad" bundle:Nil];
     }
     
     else{
          self = [super initWithNibName:@"MessagesVC" bundle:Nil];
     }
     
     return self;
     
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     // Do any additional setup after loading the view from its nib.
     //[self setLanguageForScreen];
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     NSUInteger index = [threadList count];
     if (index == 0) {
          noMsgfoundLbl.hidden = false;
     } else if(index > 0){
          noMsgfoundLbl.hidden = true;
     }
     
     _loadView = [[LoadingView alloc] init];
     threadList = [[NSMutableArray alloc] init];
     AppDelegate *Inbox = (AppDelegate *)[UIApplication sharedApplication].delegate;
     noMsgfoundLbl.font = [UIFont fontWithName:FONT_NAME size:16];
     sendNewMsg.font = [UIFont fontWithName:FONT_NAME size:17];
     Inbox.isInbox = true;
     
     [self FetchThreads];
}



- (IBAction)SendNewMsg:(id)sender {
     [SharedManager getInstance].isFriendListSelected = NO;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          FriendsVC *_friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC_iPad" bundle:nil];
          [self.navigationController pushViewController:_friendsVC animated:YES];
     }
     else{
          
          FriendsVC *_friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC" bundle:nil];
          [self.navigationController pushViewController:_friendsVC animated:YES];
     }
}

- (IBAction)mainBack:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)ShowRightMenu:(id)sender{
     
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

-(void)FetchThreads{
     
     [_loadView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"getChatThreads" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOperation){
          
          [_loadView hide];
          NSDictionary *tempDict = [completedOperation responseJSON];
          
          NSNumber *flag = [tempDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
               
               NSArray *mainArray = [tempDict objectForKey:@"data"];
               
               if ([mainArray count]>0) {
                    
                    [threadList removeAllObjects];
                    for (int x=0; x<[mainArray count]; x++) {
                         
                         MessageThreads *thread = [[MessageThreads alloc] init];
                         [thread SetValuesFromDictionary:[mainArray objectAtIndex:x]];
                         
                         NSString *currentTime  = [[mainArray objectAtIndex:x] objectForKey:@"current_time"];
                         
                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                         // this is imporant - we set our input date format to match our input string
                         // if format doesn't match you'll get nil from your string, so be careful
                         NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                         [dateFormatter setTimeZone:timeZone];
                         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                         NSDate *messageDate = [[NSDate alloc] init];
                         // voila!
                         currentServerTime = [dateFormatter dateFromString:currentTime];
                         [threadList addObject:thread];
                    }
                    if(threadList && threadList.count > 0) {
                         [threadTbl reloadData];
                    }
                    else {
                         noMsgfoundLbl.hidden = false;
                    }
               }
          }
          
     }onError:^(NSError *error){
          
          [_loadView hide];
          noMsgfoundLbl.hidden = false;
          
          
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
     
     [engine enqueueOperation:operation];
}


#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     float returnValue;
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
     {
          //
          return 100.0f;
     }
     else
     {
          returnValue = 80.0f;
     }
     
     return returnValue;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     
     return [threadList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     ThreadCC *cell ;
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThreadCC_iPad" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     else{
          
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThreadCC" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     MessageThreads *_thread = [threadList objectAtIndex:indexPath.row];
     
     NSUInteger index = [threadList count];
     if (index == 0) {
          noMsgfoundLbl.hidden = false;
     } else if(index > 0){
          noMsgfoundLbl.hidden = true;
     }
     // here
     cell.nameLbl.text = _thread.displayName;
     cell.messageLbl.text = _thread.lastMessage;
     cell.messageLbl.font = [UIFont fontWithName:FONT_NAME size:13];
     cell.nameLbl.font = [UIFont fontWithName:FONT_NAME size:16];

     NSString *currentTime = _thread.timeAgo;
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     // this is imporant - we set our input date format to match our input string
     // if format doesn't match you'll get nil from your string, so be careful
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
     [dateFormatter setTimeZone:timeZone];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSDate *messageDate = [[NSDate alloc] init];
     // voila!
     messageDate = [dateFormatter dateFromString:currentTime];
     
     NSString *timeLeft;
     NSInteger seconds = [messageDate timeIntervalSinceDate:currentServerTime];
     
     NSInteger days = (int) (floor(seconds / (3600 * 24)));
     if(days) seconds -= days * 3600 * 24;
     
     NSInteger hours = (int) (floor(seconds / 3600));
     if(hours) seconds -= hours * 3600;
     
     NSInteger minutes = (int) (floor(seconds / 60));
     if(minutes) seconds -= minutes * 60;
     
     if(days) {
          if((long)days*-1 > 1) {
               timeLeft = [NSString stringWithFormat:@"%ld %@", (long)days*-1,days_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat:@"%ld %@", (long)days*-1,days_ago];
          }
     }
     else if(hours) {
          if((long)hours*-1 > 1) {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)hours*-1,hours_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)hours*-1,hours_ago];
          }
          
     }
     else if(minutes) {
          if((long)minutes*-1 > 1) {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)minutes*-1,minutes_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)minutes*-1,minutes_ago];
          }
          
     }
     else if(seconds) {
          if((long)seconds*-1 > 1) {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)seconds*-1,seconds_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)seconds*-1,seconds_ago];
          }
     }
     NSString *messageStr = [NSString stringWithFormat:@"%@ ",timeLeft];
     NSString *stringWithoutminus = [messageStr
                                      stringByReplacingOccurrencesOfString:@"-" withString:@""];
     
     cell.timeLbl.text = stringWithoutminus;
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSString *link = _thread.profileImage;
     
     MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [cell.profileImageView setImage:[completedOperation responseImage]];
          
     } onError:^(NSError* error) {
     }];
     
     [engine enqueueOperation:op];
     
     // add gesture to delete conversation
     
     cell.tag = indexPath.row;
     UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(DeleteConversation:)];
     
     longGesture.minimumPressDuration = 1.0;
     [cell addGestureRecognizer:longGesture];
     
//     if (IS_IPAD) {
//          if (languageCode == 1) {
//               cell.profileImageView.frame = CGRectMake(665, 27, 40, 40);
//               cell.nameLbl.frame = CGRectMake(410, 18, 240, 30);
//               cell.nameLbl.textAlignment = NSTextAlignmentRight;
//               cell.messageLbl.textAlignment = NSTextAlignmentRight;
//               cell.timeLbl.frame = CGRectMake(50, 34, 300, 26);
//               cell.messageLbl.frame = CGRectMake(100, 48, 550, 25);
//               cell.imgFrme.frame = CGRectMake(660, 22, 50, 50);
//                cell.arrow.frame = CGRectMake(15, 36, 16, 24);
//               cell.arrow.image = [UIImage imageNamed:@"left_arow.png"];
//          }else{
//               cell.profileImageView.frame = CGRectMake(20, 27, 48, 48);
//               cell.nameLbl.frame = CGRectMake(85, 2, 240, 30);
//               cell.messageLbl.textAlignment = NSTextAlignmentLeft;
//               cell.timeLbl.frame = CGRectMake(85, 62, 300, 26);
//               cell.messageLbl.frame = CGRectMake(85, 34, 206, 25);
//               cell.imgFrme.frame = CGRectMake(15, 22, 50, 50);
//               cell.arrow.frame = CGRectMake(693, 36, 20, 20);
//               cell.arrow.image = [UIImage imageNamed:@"Right_arow.png"];
//          }
//     }else {
//          if (languageCode == 1) {
//               cell.profileImageView.frame = CGRectMake(250, 11, 38, 38);
//               cell.nameLbl.frame = CGRectMake(0, 2,240, 30);
//               cell.nameLbl.textAlignment = NSTextAlignmentRight;
//               cell.timeLbl.frame = CGRectMake(100, 20, 84, 44);
//               cell.messageLbl.frame = CGRectMake(200, 32, 211, 20);
//               cell.imgFrme.frame = CGRectMake(249, 10, 40, 40);
//               cell.arrow.frame = CGRectMake(10, 22, 16, 16);
//               cell.arrow.image = [UIImage imageNamed:@"left_arow.png"];
//          }else{
//               cell.profileImageView.frame = CGRectMake(5, 11, 38, 38);
//               cell.nameLbl.frame = CGRectMake(49, 8,123, 20);
//               //  cell.nameLbl.textAlignment = NSTextAlignmentLeft;
//               cell.timeLbl.frame = CGRectMake(174, 4, 84, 44);
//               cell.messageLbl.frame = CGRectMake(50, 32, 211, 20);
//               cell.imgFrme.frame = CGRectMake(4, 10, 40, 40);
//               cell.arrow.frame = CGRectMake(263, 22, 16, 16);
//               cell.arrow.image = [UIImage imageNamed:@"Right_arow.png"];
//          }
//     
//     }
     
     [cell setBackgroundColor:[UIColor clearColor]];
     [cell.contentView setBackgroundColor:[UIColor clearColor]];
     cell.selectionStyle = NAN;
     
     return cell;
}


#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
     MessageThreads *tempThread = [threadList objectAtIndex:indexPath.row];
     
     ConversationVC *conver = [[ConversationVC alloc] initWithThread:tempThread];
     conver.headerTitle = @"Messages";
     [self.navigationController pushViewController:conver animated:YES];
}



-(void)DeleteConversation:(UILongPressGestureRecognizer *)sender{
     
     UITableViewCell *tempCell = (UITableViewCell *)[sender view];
     indexToDelete = (int)tempCell.tag;
     
     
     
     if (sender.state == UIGestureRecognizerStateEnded) {
          
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          NSString *Yes;
          if (languageCode == 0 ) {
               emailMsg = @"You want to delete conversation?";
               title = @"Delete";
               cancel = NO_BTN;
               Yes = YES_BTN;
          } else if(languageCode == 1) {
               emailMsg = @"كنت ترغب في حذف المحادثة؟";
               title = @"حذف";
               cancel = NO_BTN_1;
               Yes = YES_BTN_1;
          }else if (languageCode == 2){
               emailMsg = @"Vous voulez supprimer conversation?";
               title = @"effacer";
               cancel = NO_BTN_2;
               Yes = YES_BTN_2;
          }else if (languageCode == 3){
               emailMsg = @"¿Quieres borrar la conversación?";
               title = @"eliminar";
               cancel = NO_BTN_3;
               Yes = YES_BTN_3;
          }else if (languageCode == 4){
               emailMsg = @"Você deseja excluir conversa?";
               title = @"eliminar";
               cancel = NO_BTN_4;
               Yes = YES_BTN_4;
          }
          
          UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:self cancelButtonTitle:cancel otherButtonTitles:Yes, nil];
          
          [notifi show];
     }
}



#pragma mark ------------
#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{     
     if (buttonIndex == 1) {
          
          [self YesDeleteConversation];
     }
}


-(void)YesDeleteConversation{
     
     MessageThreads *_thread = [threadList objectAtIndex:indexToDelete];
     
     [_loadView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"deleteConversation" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:_thread.threadId forKey:@"thread_id"];
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOperation){
          
          [_loadView hide];
          NSDictionary *tempDict = [completedOperation responseJSON];
          NSLog(@"%@",tempDict);
          
          NSNumber *flag = [tempDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
               
               [threadList removeObjectAtIndex:indexToDelete];
               [threadTbl reloadData];
               
               NSUInteger index = [threadList count];
               if (index == 0) {
                    noMsgfoundLbl.hidden = false;
               } else if(index > 0){
                    noMsgfoundLbl.hidden = true;
               }
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
          
          /* UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
           
           [notifi show];*/
          
     }];
     
     [engine enqueueOperation:operation];
}



- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

#pragma mark Set Language

-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          messagesLbl.text = MESSAGE_BTN;
          loadingTitle = Loading;
          days_ago = DAYS_AGO;
          hours_ago = @"hours ago";
          minutes_ago = @"minutes ago";
          seconds_ago = @"seconds ago";
          noMsgfoundLbl.text = @"You have no message.";
          [sendNewMsg setTitle:@"Send Message to Friend" forState:UIControlStateNormal];
          [mainBackbtn setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          
          messagesLbl.text = MESSAGE_BTN_1;
          loadingTitle = Loading_1;
          days_ago = DAYS_AGO_1;
          hours_ago = @"قبل ساعة";
          minutes_ago = @"قبل دقيقة";
          seconds_ago = @"قبل الثانية";
          noMsgfoundLbl.text = @"لا يوجد لديك رسالة.";
          [sendNewMsg setTitle:@"إرسال رسالة الى صديق" forState:UIControlStateNormal];
          [mainBackbtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          
          messagesLbl.text = MESSAGE_BTN_2;
          loadingTitle = Loading_2;
          days_ago = DAYS_AGO_2;
          hours_ago = @"Il ya heures";
          minutes_ago = @"il ya minutes";
          seconds_ago = @"il ya secondes";
          noMsgfoundLbl.text = @"Usted no tiene mensaje";
          
          [sendNewMsg setTitle:@"Envoyez un message à un ami" forState:UIControlStateNormal];
          [mainBackbtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          
          messagesLbl.text = MESSAGE_BTN_3;
          loadingTitle = Loading_3;
          days_ago = DAYS_AGO_3;
          hours_ago = @"hace horas";
          minutes_ago = @"hace minutos";
          seconds_ago = @"hace segundos";
          noMsgfoundLbl.text = @"Vous n\'avez pas de message.";
          
          [sendNewMsg setTitle:@"Envíe un mensaje a un amigo" forState:UIControlStateNormal];
          [mainBackbtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     
     else if(languageCode == 4) {
          
          messagesLbl.text = MESSAGE_BTN_4;
          loadingTitle = Loading_4;
          days_ago = DAYS_AGO_4;
          
          hours_ago = @"hora atrás";
          minutes_ago = @"minuto atrás";
          seconds_ago = @"segundo atrás";
          noMsgfoundLbl.text = @"Você não tem nenhuma mensagem.";
          [sendNewMsg setTitle:@"Enviar Mensagem a Amigo" forState:UIControlStateNormal];
          [mainBackbtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
     
}



@end
