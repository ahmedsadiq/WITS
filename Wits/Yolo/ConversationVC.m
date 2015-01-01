//
//  ConversationVC.m
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "ConversationVC.h"
#import "RightBarVC.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "Utils.h"
#import "UIImageView+RoundImage.h"
#import "AppDelegate.h"
#import "AlertMessage.h"

@interface ConversationVC ()

@end

@implementation ConversationVC

@synthesize headerTitle;

- (id)initWithThread:(MessageThreads *)_received
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          self = [super initWithNibName:@"ConversationVC_iPad" bundle:nil];
     else
          self = [super initWithNibName:@"ConversationVC" bundle:nil];
     
     
     if (self) {
          // Custom initialization
          
          _thread = _received;
          
     }
     return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     // Do any additional setup after loading the view from its nib.
     
     recievedMsgsY = 15;
     _loadView = [[LoadingView alloc] init];
     [self setLanguageForScreen];
     [self paddingLeft:chatField];
     tapper = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleSingleTap:)];
     
     tapper.cancelsTouchesInView = false;
     //     conversationWindow.userInteractionEnabled = YES;
     tapper.delegate = self;
     chatField.font = [UIFont fontWithName:FONT_NAME size:15];
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     AppDelegate *Inbox = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
     Inbox.isInbox = true;
     
     NSString *currentTime  = _thread.currentServerTime;
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     // this is imporant - we set our input date format to match our input string
     // if format doesn't match you'll get nil from your string, so be careful
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
     [dateFormatter setTimeZone:timeZone];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSDate *messageDate = [[NSDate alloc] init];
     // voila!
     currentServerTime = [dateFormatter dateFromString:currentTime];
     
     profileImg.layer.borderColor = [UIColor whiteColor].CGColor;
     profileImg.layer.borderWidth = 4;
     [profileImg roundImageCorner];
     
     if(_thread.displayName) {
          
          titleName.text = _thread.displayName;
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
          
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          NSString *link = _thread.profileImage;
          
          MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [profileImg setImage:[completedOperation responseImage]];
               [profileImg roundImageCorner];
               
          } onError:^(NSError* error) {
          }];
          
          [engine enqueueOperation:op];
          if(_thread.threadId) {
               [self FetchConversation];
          }
     }
     else {
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
          [postParams setObject:@"getProfile" forKey:@"method"];
          [postParams setObject:_thread.userId forKey:@"user_id"];
          [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
          
          MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [_loadView hide];
               
               NSDictionary *recievedDict = [completedOperation responseJSON];
               NSNumber *flag = [recievedDict objectForKey:@"flag"];
               if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
               {
                    UserProfile *profile = [[UserProfile alloc] init];
                    [profile SetValuesFromDictionary:recievedDict];
                    
                    _thread.displayName = profile.display_name;
                    _thread.profileImage = profile.profile_image;
                    
                    titleName.text = _thread.displayName;
                    
                    MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
                    NSString *link = _thread.profileImage;
                    
                    MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
                    
                    [op onCompletion:^(MKNetworkOperation *completedOperation) {
                         
                         [profileImg setImage:[completedOperation responseImage]];
                         [profileImg roundImageCorner];
                         
                    } onError:^(NSError* error) {
                    }];
                    
                    [engine enqueueOperation:op];
                    if(_thread.threadId) {
                         [self FetchConversation];
                    }
                    
                    
               }
          } onError:^(NSError* error) {
               
               [_loadView hide];
               
               
               if (languageCode == 0 ) {
                    emailMsg = @"Check your internet connection setting.";
                    title = @"Error";
               } else if(languageCode == 1) {
                    emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                    title = @"خطأ";
               }else if (languageCode == 2){
                    emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
                    title = @"Erreur";
               }else if (languageCode == 3){
                    emailMsg = @"Revise su configuración de conexión a Internet.";
                    title = @"Error";
               }else if (languageCode == 4){
                    emailMsg = @"Verifique sua configuração de conexão à Internet";
                    title = @"Erro";
               }
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               /*
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to Fetch profile" message:emailMsg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];*/
          }];
          [_loadView showInView:self.view withTitle:loadingTitle];
          [engine enqueueOperation:op];
     }
     
     
}




#pragma mark ------------
#pragma mark Fetch Conversation

-(void)FetchConversation{
     
     [_loadView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"fetchChat" forKey:@"method"];
     [postParams setObject:_thread.threadId forKey:@"thread_id"];
     
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOperation){
          
          [_loadView hide];
          recievedMsgsY = 15;
          NSDictionary *tempDict = [completedOperation responseJSON];
          NSNumber *flag = [tempDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
               conversationArray = [tempDict objectForKey:@"data"];
               [self ResetConversationWindow];
               chatLblPostition = CGPointMake(0.0, 0.0);
               if ([conversationArray count]>0) {
                    for (int y=0; y<[conversationArray count]; y++) {
                         messageCounter = y;
                         NSDictionary *tempDict = [conversationArray objectAtIndex:y];
                         if ([[SharedManager getInstance].userID isEqualToString:[tempDict objectForKey:@"user_id"]])
                              [self ShowSendMessages:tempDict];
                         else
                              [self ShowReceivedMessages:tempDict];
                    }
               }
          }
          
     }onError:^(NSError *error){
          
          [_loadView hide];
          
          
          
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Error";
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"خطأ";
          }else if (languageCode == 2){
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Erreur";
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"Error";
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Erro";
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          /*  UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
           
           [notifi show];
           */
     }];
     
     [engine enqueueOperation:operation];
     
}




#pragma mark -----------
#pragma mark Received Messages

-(void)ShowReceivedMessages:(NSDictionary *)_dict{
     
     
     UITextView *recievedMsgLbl = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 290, 65)];
     if(IS_IPAD)
          recievedMsgLbl =  [[UITextView alloc] initWithFrame:CGRectMake(40, 40, 650, 75)];
     recievedMsgLbl.scrollEnabled = false;
     recievedMsgLbl.backgroundColor = [UIColor clearColor];
     recievedMsgLbl.text = [_dict objectForKey:@"message"];
     recievedMsgLbl.textColor = [UIColor whiteColor];
     recievedMsgLbl.textAlignment = NSTextAlignmentJustified;
     recievedMsgLbl.editable = NO;
     
     NSString *str = [_dict objectForKey:@"message"];
     if(str.length >20){
          [recievedMsgLbl sizeToFit];
          UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:15];
          recievedMsgLbl.font = font;
          NSString * theText = [_dict objectForKey:@"message"];
          CGSize theStringSize = [theText sizeWithFont:font constrainedToSize:CGSizeMake(190, 1000000) lineBreakMode:UILineBreakModeWordWrap];
          CGRect frame = recievedMsgLbl.frame;
          frame.size.height = theStringSize.height;
          if(frame.size.height < 70){
               frame.size.height = 70;
          }
          
          recievedMsgLbl.frame = frame;
     }
     
     UIView *resizableOuterView = [[UIView alloc] initWithFrame:CGRectMake(15, recievedMsgsY, 290, recievedMsgLbl.frame.size.height+25)];
     if(IS_IPAD)
     {
          resizableOuterView = [[UIView alloc] initWithFrame:CGRectMake(15, recievedMsgsY, 700, recievedMsgLbl.frame.size.height+40)];
     }
     resizableOuterView.backgroundColor = [UIColor blackColor];
     
     UIImageView *profileImgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 70, 70)];
     if(IS_IPAD)
          profileImgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 100, 100)];

     UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(6, 10, 70, 70)];
     recievedMsgLbl.textContainer.exclusionPaths = @[imgRect];
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSString *link = _thread.profileImage;
     MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [profileImgTemp setImage:[completedOperation responseImage]];
          
     } onError:^(NSError* error) {
          [profileImgTemp setImage:[UIImage imageNamed:@"witsround.PNG"]];
     }];
     
     [engine enqueueOperation:op];
     
     [resizableOuterView addSubview:recievedMsgLbl];
     [resizableOuterView addSubview:profileImgTemp];
     
     
     UILabel *recievedTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 6, 210, 18)];
     recievedTitleLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
     recievedTitleLbl.textColor = [UIColor whiteColor];
     recievedTitleLbl.text = _thread.displayName;
     if(IS_IPAD){
          recievedTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 6, 210, 18)];
          
     }
     [resizableOuterView addSubview:recievedTitleLbl];
     
     [conversationWindow addSubview:resizableOuterView];
     
     recievedMsgsY = recievedMsgsY + resizableOuterView.frame.size.height+3;
     
     UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, recievedMsgsY, resizableOuterView.frame.size.width, 14)];
     timeLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0f];
     timeLbl.textColor = [UIColor whiteColor];
     timeLbl.text = [self getTimeDifference:[_dict objectForKey:@"time_ago"]];
     [conversationWindow addSubview:timeLbl];
     timeLbl.textAlignment = NSTextAlignmentRight;
     
     recievedMsgsY = recievedMsgsY +30;
     
     float sizeOfContent = 0;
     UIView *lLast = [conversationWindow.subviews lastObject];
     NSInteger wd = lLast.frame.origin.y;
     NSInteger ht = lLast.frame.size.height;
     
     sizeOfContent = wd+ht;
     
     conversationWindow.contentSize = CGSizeMake(conversationWindow.frame.size.width, sizeOfContent);
     
}


-(NSString*) getTimeDifference : (NSString*) currentTime {
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
     
     timeLeft = [timeLeft stringByReplacingOccurrencesOfString:@"-"
                                                    withString:@""];
     
     if(timeLeft == nil){
          timeLeft = a_second_ago;
     }
     return timeLeft;
}


#pragma mark ---------------
#pragma mark Send Messages

-(void)ShowSendMessages:(NSDictionary *)_dict
{
     
     
     UITextView *recievedMsgLbl = [[UITextView alloc] initWithFrame:CGRectMake(4, 20, 285, 65)];
     if(IS_IPAD)
          recievedMsgLbl =  [[UITextView alloc] initWithFrame:CGRectMake(5, 40, 650, 75)];
     recievedMsgLbl.scrollEnabled = false;
     recievedMsgLbl.backgroundColor = [UIColor clearColor];
     recievedMsgLbl.text = [_dict objectForKey:@"message"];
     recievedMsgLbl.textColor = [UIColor whiteColor];
     recievedMsgLbl.textAlignment = NSTextAlignmentJustified;
     recievedMsgLbl.editable = NO;
     
     [recievedMsgLbl setUserInteractionEnabled:NO];
     NSString *str = [_dict objectForKey:@"message"];
     if(str.length >20){
          [recievedMsgLbl sizeToFit];
          UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:15];
          recievedMsgLbl.font = font;
          NSString * theText = [_dict objectForKey:@"message"];
          CGSize theStringSize = [theText sizeWithFont:font constrainedToSize:CGSizeMake(190, 1000000) lineBreakMode:UILineBreakModeWordWrap];
          CGRect frame = recievedMsgLbl.frame;
          frame.size.height = theStringSize.height;
          if(frame.size.height < 70){
               frame.size.height = 70;
          }
          
          recievedMsgLbl.frame = frame;
     }
     
     UIView *resizableOuterView = [[UIView alloc] initWithFrame:CGRectMake(15, recievedMsgsY, 290, recievedMsgLbl.frame.size.height+25)];
     if(IS_IPAD)
     {
          resizableOuterView = [[UIView alloc] initWithFrame:CGRectMake(15, recievedMsgsY, 700, recievedMsgLbl.frame.size.height+40)];
     }
     resizableOuterView.backgroundColor = [UIColor blackColor];
     
     UIImageView *profileImgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(215, 10, 70, 70)];
     if(IS_IPAD)
          profileImgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(590, 10, 100, 100)];
     UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(205, 10, 80, 70)];
     recievedMsgLbl.textContainer.exclusionPaths = @[imgRect];
     
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     UIImage *profileImg = [self loadImage];
     if(profileImg) {
          [profileImgTemp setImage:profileImg];
          delegate.profileImage = profileImg;
     }
     else {
          
          //logout user
          if(delegate.profileImage) {
               [profileImgTemp setImage:delegate.profileImage];
               [profileImgTemp roundImageCorner];
          }
          else {
               
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               NSString *link = [SharedManager getInstance]._userProfile.profile_image;
               
               MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [profileImgTemp setImage:[completedOperation responseImage]];
                    [self saveImage:[completedOperation responseImage]];
                    
               } onError:^(NSError* error) {
                    
                    [profileImgTemp setImage:[UIImage imageNamed:@"witsround.PNG"]];
               }];
               
               [engine enqueueOperation:op];
          }
     }
     [resizableOuterView addSubview:recievedMsgLbl];
     [resizableOuterView addSubview:profileImgTemp];
     
     
     UILabel *recievedTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 4, 210, 18)];
     recievedTitleLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
     if(IS_IPAD){
          recievedTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 4, 210, 18)];
          
     }
     recievedTitleLbl.textColor = [UIColor whiteColor];
     recievedTitleLbl.text = [SharedManager getInstance]._userProfile.display_name;
     
     [resizableOuterView addSubview:recievedTitleLbl];
     
     [conversationWindow addSubview:resizableOuterView];
     
     recievedMsgsY = recievedMsgsY + resizableOuterView.frame.size.height+3;
     
     UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, recievedMsgsY, resizableOuterView.frame.size.width, 14)];
     timeLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0f];
     timeLbl.textColor = [UIColor whiteColor];
     timeLbl.text = [self getTimeDifference:[_dict objectForKey:@"time_ago"]];
     [conversationWindow addSubview:timeLbl];
     timeLbl.textAlignment = NSTextAlignmentRight;
     
     recievedMsgsY = recievedMsgsY +30;
     
     float sizeOfContent = 0;
     UIView *lLast = [conversationWindow.subviews lastObject];
     NSInteger wd = lLast.frame.origin.y;
     NSInteger ht = lLast.frame.size.height;
     
     sizeOfContent = wd+ht;
     
     conversationWindow.contentSize = CGSizeMake(conversationWindow.frame.size.width, sizeOfContent);
     
}

-(void)ResetConversationWindow{
     
     NSArray *_subviews = [conversationWindow subviews];
     for (UIView *tempView in _subviews) {
          [tempView removeFromSuperview];
     }
}





#pragma mark --------------------
#pragma mark Delete Message

-(void)DeleteMessage:(UILongPressGestureRecognizer *)sender{
     
     UIView *tempView = [sender view];
     indexToDelete = tempView.tag;
     
     if (sender.state == UIGestureRecognizerStateEnded) {
          
          NSLog(@"index to be deleted %i",tempView.tag);
          UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          [deleteBtn setFrame:CGRectMake(0, 0, 20, 20)];
          [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_Btn.png"] forState:UIControlStateNormal];
          deleteBtn.tag = indexToDelete;
          [deleteBtn addTarget:self action:@selector(YesDeleteMessage:) forControlEvents:UIControlEventTouchUpInside];
          
          [tempView addSubview:deleteBtn];
     }
     
     
}




-(void)YesDeleteMessage:(id)sender{
     
     UIButton *btn = (UIButton *)sender;
     indexToDelete = btn.tag;
     
     NSDictionary *_dict = [conversationArray objectAtIndex:indexToDelete];
     
     [_loadView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"deleteChatMessage" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:_thread.threadId forKey:@"thread_id"];
     [postParams setObject:[_dict objectForKey:@"message_id"] forKey:@"message_ids"];
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOperation){
          
          [_loadView hide];
          NSDictionary *tempDict = [completedOperation responseJSON];
          NSNumber *flag = [tempDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
               
               [self RemoveMessageFromContainer];
          }
          
     }onError:^(NSError *error){
          
          [_loadView hide];
          
          
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
           UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:title  message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
           
           [notifi show];
           */
     }];
     
     [engine enqueueOperation:operation];
}

#pragma mark -
#pragma mark KeyBoard

- (void) keyboardDidShow:(NSNotification*)notification {
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
     {
          // Move Scroll View Content here
          [chatView setFrame:CGRectMake(chatView.frame.origin.x, chatView.frame.origin.y - iPad_KeyBoard_PORTRAIT_OFFSET, chatView.frame.size.width, chatView.frame.size.height)];
     }
     else
     {
          // Move Scroll View Content here
          [chatView setFrame:CGRectMake(chatView.frame.origin.x, chatView.frame.origin.y - iPhone_KeyBoard_PORTRAIT_OFFSET, chatView.frame.size.width, chatView.frame.size.height)];
     }
     
}



-(void)RemoveMessageFromContainer{
     
     UIView *tempView = [conversationWindow viewWithTag:indexToDelete];
     [tempView removeFromSuperview];
}





-(IBAction)ShowRightMenu:(id)sender{
     
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

-(IBAction)sendChatMessage:(id)sender{
     
     [chatField resignFirstResponder];
     
     [chatView setFrame:CGRectMake(chatView.frame.origin.x, self.view.frame.size.height-chatView.frame.size.height, chatView.frame.size.width, chatView.frame.size.height)];
     [self SendChatMessageToFriend];
     
}

- (IBAction)backBtnPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}

-(void)SendChatMessageToFriend{
     if(_thread.userId) {
          [_loadView showInView:self.view withTitle:loadingTitle];
          
          MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
          
          NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
          
          [postParams setObject:@"chatMessage" forKey:@"method"];
          [postParams setObject:_thread.userId forKey:@"friend_id"];
          
          [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
          [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
          [postParams setObject:chatField.text forKey:@"message"];
          MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
          
          [operation onCompletion:^(MKNetworkOperation *completedOperation){
               
               [_loadView hide];
               NSDictionary *mainDict = [completedOperation responseJSON];
               
               NSNumber *flag = [mainDict objectForKey:@"flag"];
               if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
                    chatField.text = @"";
                    if(_thread.threadId) {
                         [self FetchConversation];
                    }
               }
               else {
                    //unable to fetch
               }
          }onError:^(NSError *error){
               
               [_loadView hide];
               
               if (languageCode == 0 ) {
                    emailMsg = @"Check your internet connection setting.";
                    title = @"Error";
               } else if(languageCode == 1) {
                    emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                    title = @"خطأ";
               }else if (languageCode == 2){
                    emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
                    title = @"Erreur";
               }else if (languageCode == 3){
                    emailMsg = @"Revise su configuración de conexión a Internet.";
                    title = @"Error";
               }else if (languageCode == 4){
                    emailMsg = @"Verifique sua configuração de conexão à Internet";
                    title = @"Erro";
               }
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               /*
                UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
                
                [notifi show];*/
               
          }];
          
          [engine enqueueOperation:operation];
     }
     else {
          
          if (languageCode == 0 ) {
               emailMsg = @"Invalid Thread";
               title = @"Error";
               cancel = CANCEL;
               
          } else if(languageCode == 1) {
               emailMsg = @"الموضوع غير صالح";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Sujet non valide";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Tema válida";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Tópico inválido";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          /*  UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
           
           [notifi show]; */
     }
     
     
}
- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

#pragma mark -------------
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
     [self animateTextField: textField up: YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
     [self animateTextField: textField up: NO];
     [chatField resignFirstResponder];
     
     
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     
     [chatField resignFirstResponder];
     
     [chatView setFrame:CGRectMake(chatView.frame.origin.x, self.view.frame.size.height-chatView.frame.size.height, chatView.frame.size.width, chatView.frame.size.height)];
     [self SendChatMessageToFriend];
     
     return YES;
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     int movementDistance = 30; // tweak as needed
     if(IS_IPAD) {
          movementDistance = 325;
     }
     const float movementDuration = 0.3f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
}
#pragma mark Set Language

-(void)setLanguageForScreen {
     NSString* language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     if (languageCode == 0) {
          
          loadingTitle = Loading;
          days_ago = DAYS_AGO;
          hours_ago = @"hours ago";
          minutes_ago = @"minutes ago";
          seconds_ago = @"seconds ago";
          a_second_ago = @"A second ago";
          
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          
     }else if (languageCode == 1){
          days_ago = DAYS_AGO_1;
          hours_ago = @"قبل ساعة";
          minutes_ago = @"قبل دقيقة";
          seconds_ago = @"قبل الثانية";
          loadingTitle = Loading_1;
          a_second_ago = @"بضع ثوان قبل";
          
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }else if (languageCode == 2){
          
          days_ago = DAYS_AGO_2;
          hours_ago = @"Il ya heures";
          minutes_ago = @"il ya minutes";
          seconds_ago = @"il ya secondes";
          loadingTitle = Loading_2;
          a_second_ago = @"il ya quelques secondes";
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }else if (languageCode == 3){
          
          loadingTitle = Loading_3;
          days_ago = DAYS_AGO_3;
          hours_ago = @"hace horas";
          minutes_ago = @"hace minutos";
          seconds_ago = @"hace segundos";
          
          a_second_ago = @"hace unos segundos";
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          
     }else if (languageCode == 4){
          
          loadingTitle = Loading_4;
          days_ago = DAYS_AGO_4;
          
          hours_ago = @"hora atrás";
          minutes_ago = @"minuto atrás";
          seconds_ago = @"segundo atrás";
          
          a_second_ago = @"alguns segundos atrás";
          
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
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
- (void)viewWillDisappear:(BOOL)animated {
     [self.tabBarController.tabBar setHidden:false];
}

-(void)paddingLeft:(UITextField *) viewToPad
{
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
     viewToPad.leftView = paddingView;
     viewToPad.leftViewMode = UITextFieldViewModeAlways;
     viewToPad.leftViewMode = UITextFieldViewModeAlways;
     
     
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender

{
     
     [self.view endEditing:YES];
     
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
     return YES;
}


@end
