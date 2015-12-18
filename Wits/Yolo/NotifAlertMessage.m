//
//  Notif-AlertMessage.m
//  iSpye
//
//  Created by Kiryl Lishynski on 10/29/12.
//  Copyright (c) 2012 Exairo. All rights reserved.
//

#import "NotifAlertMessage.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "MessageThreads.h"
#import "NavigationHandler.h"
#import "MKNetworkEngine.h"
#import "UIImageView+RoundImage.h"
#import "SharedManager.h"
#import "SocketManager.h"
#import "AlertMessage.h"
#import "Challenge.h"
#import "PushNotificationCenter.h"
#import "Challenge.h"

@implementation NotifAlertMessage


@synthesize textView = _textView;
@synthesize messageView = _messageView;
//@synthesize TitleView = _titleLbl;
@synthesize action;
@synthesize sharedManager;

static BOOL showing;


+ (void)showNotifAlertWithMessage:(NSString*)message andTitle: (NSString*)Title cancelButton: (NSString*)CancelBtn OtherButton:(NSString*)Otherbuttons ActionNameForSecondBtn: (NSString*)ActionName ImageLink: (NSString*)imageLink initwithDict: (NSDictionary*)Dictionary;
{
     
     if(showing) {
          return;
     }
     
     NotifAlertMessage *alertMessage = [[[NSBundle mainBundle] loadNibNamed:@"NotifAlertMessage" owner:nil options:nil] objectAtIndex:0];
     
     [[NSUserDefaults standardUserDefaults] setObject:ActionName forKey:@"ActionName"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     alertMessage.textView.text = message;
     alertMessage.titleLbl.text = Title;
     [alertMessage.outletCancel setTitle:CancelBtn forState:UIControlStateNormal];
     [alertMessage.OutletOk setTitle:Otherbuttons forState:UIControlStateNormal];
     
     [[NSUserDefaults standardUserDefaults] setObject:Dictionary forKey:@"AlertDict"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     if([imageLink isEqualToString:@""]){
          alertMessage.ProfileImage.hidden = YES;
           
     }
     else
          alertMessage.ProfileImage.hidden = NO;
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     MKNetworkOperation *op = [engine operationWithURLString:imageLink params:Nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [alertMessage.ProfileImage setImage:[completedOperation responseImage]];
     } onError:^(NSError* error) {
          alertMessage.ProfileImage.image = [UIImage imageNamed:@"personal.png"];
     }];
     
     [engine enqueueOperation:op];
     
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     
     NSString *emailMsg;
     NSString *okTitle;
     NSString *cancelTitle;
     if (languageCode == 0 ) {
          
          okTitle = OK_BTN;
          cancelTitle = CANCEL;
     } else if(languageCode == 1) {
          
          okTitle = OK_BTN_1;
          cancelTitle = CANCEL_1;
     }else if (languageCode == 2){
          
          okTitle = OK_BTN_2;
          cancelTitle = CANCEL_2;
     }else if (languageCode == 3){
          
          okTitle = OK_BTN_3;
          cancelTitle = CANCEL_3;
     }else if (languageCode == 4){
          
          okTitle = OK_BTN_4;
          cancelTitle = CANCEL_4;
     }
     
     [alertMessage.outletCancel setTitle:cancelTitle forState:UIControlStateNormal];
     
     [alertMessage show];
     
     
}

- (IBAction)Okbtn:(id)sender {
     
     PushNotificationCenter *pushObj = [[PushNotificationCenter alloc]init];
     NSString *actionstr = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ActionName"];
     NSDictionary *Dict = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:@"AlertDict"];
     [self.delegate Okbtn:actionstr withDictionary:Dict];
     
     if ([actionstr isEqualToString:@"Msg"]) {
          [pushObj Okbtn:@"Msg" withDictionary:Dict];
          
     }else if([actionstr isEqualToString:@"FriendReq"]){
          [pushObj Okbtn:@"Friend Request" withDictionary:Dict];
          
          
     }else if([actionstr isEqualToString:@"Challenge"]){
          
          [pushObj Okbtn:@"Challenge" withDictionary:Dict];
     }
     else if([actionstr isEqualToString:@"BuyGems"]){
          
          [pushObj Okbtn:@"Buy Gems" withDictionary:Dict];
     }
     showing = NO;
     [self removeFromSuperview];
}

- (void)show {
     showing = YES;
     
     CGRect messageViewFrame = _messageView.frame;
     messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height-30;
     _messageView.frame = messageViewFrame;
     
     if(IS_IPAD){
          _messageView.autoresizingMask = UIViewAutoresizingNone;
          
          CGSize sizeBtnWeb = [_textView sizeThatFits:CGSizeMake(400,FLT_MAX)];
          _textView.frame = CGRectMake(_titleLbl.frame.origin.x, 50, 160, sizeBtnWeb.height+30);
          _messageView.frame= CGRectMake(180, 350, 400, 350);
          if(alertMessage.ProfileImage.isHidden)
               NSLog(@"Asdasdasd");
               [_titleLbl setFont:[UIFont fontWithName:@"Helvetica" size:20]];
          [_textView setFont:[UIFont fontWithName:@"Helvetica" size:18]];
          //     [_messageView setCenter:CGPointMake(400 , 300)];
          
          CGRect btnFrame = _outletCancel.frame;
          btnFrame.origin.y = _textView.frame.origin.y + _textView.frame.size.height + 13;
          _outletCancel.frame = btnFrame;
          
          CGRect messageViewFrame = _messageView.frame;
          messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height-30;
          _messageView.frame = messageViewFrame;
          
          
     }else if(IS_IPHONE_4){
          
          CGSize sizeBtnWeb = [_textView sizeThatFits:CGSizeMake(280,FLT_MAX)];
          
          _textView.frame = CGRectMake(_titleLbl.frame.origin.x, 30, 150, sizeBtnWeb.height+40);
          
          CGRect btnFrame = _outletCancel.frame;
          btnFrame.origin.y = _textView.frame.origin.y + _textView.frame.size.height + 10;
          _outletCancel.frame = btnFrame;
          
          [_messageView setCenter:CGPointMake(160, 240)];
          
          [_messageView setAutoresizingMask:UIViewAutoresizingNone];
          
          CGRect messageViewFrame = _messageView.frame;
          messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height + 10;
          _messageView.frame = messageViewFrame;
          
          
     }else if (IS_IPHONE_6){
          
          //          CGSize sizeBtnWeb = [_textView sizeThatFits:CGSizeMake(320,FLT_MAX)];
          //
          //          _textView.frame = CGRectMake(1, 76, 300, sizeBtnWeb.height+10);
          //
          //          CGRect btnFrame = _outletCancel.frame;
          //          btnFrame.origin.y = _textView.frame.origin.y + _textView.frame.size.height + 10;
          //          _outletCancel.frame = btnFrame;
          //
          //          //   _messageView.frame= CGRectMake(100, 310, 300, 300);
          //
          //          [_messageView setCenter:CGPointMake(190, 300)];
          //
          //          [_messageView setAutoresizingMask:UIViewAutoresizingNone];
          //
          //          CGRect messageViewFrame = _messageView.frame;
          //          messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height + 10;
          //          _messageView.frame = messageViewFrame;
     }
     //  [_messageView layer].cornerRadius = 12;
     // _messageView.clipsToBounds = YES;
     
     UIWindow *window = [[UIApplication sharedApplication].delegate window];
     self.frame = window.frame;
     [window addSubview:self];
     self.center = window.center;
}

- (IBAction)closeAlert:(id)sender {
     PushNotificationCenter *pushObj = [[PushNotificationCenter alloc]init];
     NSString *actionstr = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ActionName"];
     
     [self.delegate closeAlert:actionstr];
     
     if ([actionstr isEqualToString:@"Msg"]) {
          [pushObj closeAlert:@"Msg"];
     }
     else if([actionstr isEqualToString:@"Challenge"]){
          [pushObj closeAlert:@"Challenge"];
     }
     
     showing = NO;
     [self removeFromSuperview];
}

- (void)dealloc {
     
     
}

-(void)backPressed :(id)sender {
     [challengeView removeFromSuperview];
}

- (void) tick:(NSTimer *) timer {
     [challengeView removeFromSuperview];
     Challenge *_challenge = [[Challenge alloc] initWithChallengeDictionary:challengeDIctionary];
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
          [challengeView removeFromSuperview];
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 1){
               Challenge *_challenge = [[Challenge alloc] initWithDictionary:userDictInner];
               _challenge.type = type;
               _challenge.type_ID = type_id;
               NSString *strOppName= [userDictInner objectForKey:@"displayName"];
               searchLbl.text = strOppName;
               _challenge.challengeID = [challengeDIctionary objectForKey:@"challengeId"];
               [[NavigationHandler getInstance] MoveToChallenge:_challenge];
          }
          else if(flag == 5) {
               [AlertMessage showAlertWithMessage:@"Sorry, your friend is not interested in the challenge request at the moment. Retry later." andTitle:@"Challenge Not Accepted" SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
          }
          else {
               [AlertMessage showAlertWithMessage:@"Unfortunately, your friend can't be reached at the moment. Please try later." andTitle:@"Friend Not Available" SingleBtn:YES cancelButton:OK_BTN OtherButton:nil];
          }
     }
     else if ([packet.name isEqualToString:@"cancelChallenge"]) {
          
     }
}
-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     NSLog(@"socketDisconnected:::::Accept Challenge");
     [challengeView removeFromSuperview];
     
     //Alert View that opponent has gone away
}
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     NSLog(@"socketError:::::Accept Challenge%@",error);
     [challengeView removeFromSuperview];
     
     //Alert View that opponent has gone away
}



@end
