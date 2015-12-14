//
//  ChallengeVC.m
//  Yolo
//
//  Created by Ahmad on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "ChallengeVC.h"
#import "Question.h"
#import "Option.h"
#import "SharedManager.h"
#import "NavigationHandler.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "Utils.h"
#import "UIImageView+RoundImage.h"
#import "ChallengeFriendsVC.h"
#include <stdlib.h>
#import "Reachability.h"
#import "SocketIOPacket.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "AlertMessage.h"
#import "RightBarVC.h"
#import "Utils.h"
#import "ArabicConverter.h"
#import "AppDelegate.h"
#import "RewardsListVC.h"

@interface ChallengeVC ()

@end

static ChallengeVC *ChallengeInstance;
enum{
     SOCKET_FAIL = 0,
     SOCKET_SUCCESS = 1,
     SOCKET_SESSION_OUT = 2,
     SOCKET_SEARCHING = 3,
     SOCKET_GAME_END = 4
};
typedef NSUInteger MAIN_FLAG_TYPE;

@implementation ChallengeVC
@synthesize sharedManager,requestType;
+(ChallengeVC *)getInstance{
     
     return ChallengeInstance;
}

- (id)initWithChallenge:(Challenge *)_Challenge
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          self = [super initWithNibName:@"ChallengeVC_iPad" bundle:Nil];
     }
     else{
          self = [super initWithNibName:@"ChallengeVC" bundle:Nil];
     }
     if(self)
     {
          _challenge = _Challenge;
     }
     return self;
}

- (id)initWithChallenge:(Challenge *)_Challenge andRecieved:(BOOL) isRecieved
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          self = [super initWithNibName:@"ChallengeVC_iPad" bundle:Nil];
     }
     else{
          self = [super initWithNibName:@"ChallengeVC" bundle:Nil];
     }
     if(self)
     {
          _challenge = _Challenge;
          isChallenge = true;
     }
     return self;
}
-(void) addScreenForChallengeRecieved {
     
}

-(IBAction)GotoHome:(id)sender{
     
     [[NavigationHandler getInstance] NavigateToRoot];
}
- (void) initData {
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.isGameInProcess = true;
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if(requestType == nil) {
          requestType = delegate.requestType;
     }
     
     loadView = [[LoadingView alloc] init];
     currentAddOns = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentAddOns"] intValue];
     currentIndex = 0;
     currentResponseIndex = 0;
     isGameEnd = false;
     ChallengeInstance = self;
     isFirstLoad = YES;
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
}

- (void)initViews {
     [selfProfileImg roundImageCorner];
     [opponentProfileImg roundImageCorner];
     
     if ([requestType isEqualToString:@"gems"]) {
          selfgameTypeimg.image = [UIImage imageNamed:@"ame1.png"];
          oppGametypeimg.image = [UIImage imageNamed:@"ame1.png"];
          resultGametypeimg.image = [UIImage imageNamed:@"gemstore.png"];
          _gemRight.image = [UIImage imageNamed:@"gemstore.png"];
          _gemLeft.image = [UIImage imageNamed:@"gemstore.png"];
          if([[SharedManager getInstance]._userProfile.cashablePoints intValue] < 70) {
               currentSelfPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
               currentOtherPoints = 70;
          }
          else {
               currentSelfPoints = 70;
               currentOtherPoints = 70;
          }
//          for(int i=1; i<8; i++) {
//               UIImageView *starImgLeftView = (UIImageView*)[upperViewLeft viewWithTag:i];
//               UIImageView *starImgRightView = (UIImageView*)[upperViewRight viewWithTag:i];
//               starImgLeftView.image = [UIImage imageNamed:@"gemwhite.png"];
//               starImgRightView.image = [UIImage imageNamed:@"gemwhite.png"];
//          }
     }else if ([requestType isEqualToString:@"points"]){
          selfgameTypeimg.image = [UIImage imageNamed:@"starg1.png"];
          oppGametypeimg.image = [UIImage imageNamed:@"starg1.png"];
          resultGametypeimg.image = [UIImage imageNamed:@"newStarPoints.png"];
          currentSelfPoints = 0;
          currentOtherPoints = 0;
          _gemRight.image = [UIImage imageNamed:@"newStarPoints.png"];
          _gemLeft.image = [UIImage imageNamed:@"newStarPoints.png"];
//          for(int i=1; i<8; i++) {
//               UIImageView *starImgLeftView = (UIImageView*)[upperViewLeft viewWithTag:i];
//               UIImageView *starImgRightView = (UIImageView*)[upperViewRight viewWithTag:i];
//               starImgLeftView.image = [UIImage imageNamed:@"starwhite.png"];
//               starImgRightView.image = [UIImage imageNamed:@"starwhite.png"];
//          }
     }
     if(IS_IPHONE_4){
          _roundView.frame = CGRectMake(0,_roundLbl.frame.size.height+400, 320, 330);
          
          _gamebg.frame = CGRectMake(0, 0, 320, 480);
          _roundView.frame = CGRectMake(0, 75, 320, 330);
          
          answerReaction.frame = CGRectMake(answerReaction.frame.origin.x, answerReaction.frame.origin.y+29, answerReaction.frame.size.width, answerReaction.frame.size.height);
          answerTxt.frame = CGRectMake(answerTxt.frame.origin.x, answerTxt.frame.origin.y+33, answerTxt.frame.size.width, answerTxt.frame.size.height);
          
          answerTxt.frame = CGRectMake(answerTxt.frame.origin.x, answerTxt.frame.origin.y+8, answerTxt.frame.size.width, answerTxt.frame.size.height);
          answerReaction.frame = CGRectMake(answerReaction.frame.origin.x, answerReaction.frame.origin.y+15, answerReaction.frame.size.width, answerReaction.frame.size.height);
     }
     else if(IS_IPHONE_5) {
          
          _gamebg.frame = CGRectMake(0, 0, 320, 568);
          
          answerReaction.frame = CGRectMake(40,460,240,25);
          answerTxt.frame = CGRectMake(30,448,260,21);
     }
     
     labelToBlink = option_1_Lbl;
     
     option_1_Btn.hidden = true;
     option_2_Btn.hidden = true;
     option_3_Btn.hidden = true;
     option_4_Btn.hidden = true;
     
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     //  Do any additional setup after loading the view from its nib.
     
     [self initData];
     [self initViews];
    
     NSArray * name_Player = [[SharedManager getInstance]._userProfile.display_name componentsSeparatedByString:@" "];
     NSArray * name_opponent = [_challenge.opponentDisplayName componentsSeparatedByString:@" "];
     //topBarOpponentName.text = _challenge.opponentDisplayName;
     //topBarPlayerName.text = [SharedManager getInstance]._userProfile.display_name;
     topBarPlayerName.text = [name_Player objectAtIndex:0];
     topBarOpponentName.text = [name_opponent objectAtIndex:0];
     [self viewSlideInFromLeftToRight:upperViewLeft];
     [self viewSlideInFromRightToLeft:upperViewRight];
      appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     [self showQuestion:currentIndex];
     
     [self setInitialPoints];
     
     [self connectToSocket];
     
     
     
}


-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self setLanguageForScreen];
}

-(void) setAfterChalleneg {
     [initialView removeFromSuperview];
     loadView = [[LoadingView alloc] init];
     currentIndex = 0;
     currentResponseIndex = 0;
     isGameEnd = false;
     
     [self showQuestion:currentIndex];
     ChallengeInstance = self;
     
     topBarOpponentName.text = _challenge.opponentDisplayName;
     topBarPlayerName.text = [SharedManager getInstance]._userProfile.display_name;
     //////////Changed by Fiza///////
     [self SendSelfImageView];
     [self SendOpponentImageView];
     
     [self viewSlideInFromLeftToRight:upperViewLeft];
     [self viewSlideInFromRightToLeft:upperViewRight];
     
     if(IS_IPHONE_4) {
          answerReaction.frame = CGRectMake(answerReaction.frame.origin.x, answerReaction.frame.origin.y+27, answerReaction.frame.size.width, answerReaction.frame.size.height);
          answerTxt.frame = CGRectMake(answerTxt.frame.origin.x, answerTxt.frame.origin.y+35, answerTxt.frame.size.width, answerTxt.frame.size.height);
     }
     else if(IS_IPHONE_5) {
          answerReaction.frame = CGRectMake(40,460,240,25);
          answerTxt.frame = CGRectMake(30,438,260,21);
     }
     if([[SharedManager getInstance]._userProfile.cashablePoints intValue] < 100) {
          
          currentSelfPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
          currentOtherPoints = 100;
     }
     else {
          currentSelfPoints = 100;
          currentOtherPoints = 100;
     }
     [self setInitialPoints];
     
}
-(void)viewSlideInFromRightToLeft:(UIView *)views
{
     CATransition *transition = nil;
     transition = [CATransition animation];
     transition.duration = 1.0;//kAnimationDuration
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     transition.type = kCATransitionPush;
     transition.subtype =kCATransitionFromRight;
     transition.delegate = self;
     [views.layer addAnimation:transition forKey:nil];
}
-(void)viewSlideInFromLeftToRight:(UIView *)views
{
     CATransition *transition = nil;
     transition = [CATransition animation];
     transition.duration = 1.0;//kAnimationDuration
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     transition.type = kCATransitionPush;
     transition.subtype =kCATransitionFromLeft;
     transition.delegate = self;
     [views.layer addAnimation:transition forKey:nil];
}

-(void)setInitialPoints{
     
     [self SendSelfImageView];
     [self SendOpponentImageView];
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if(requestType == nil) {
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          requestType = delegate.requestType;
     }
     
     if ([requestType isEqualToString:@"gems"]) {
          
          if([[SharedManager getInstance]._userProfile.cashablePoints intValue] < 70) {
               
               selfPointsLbl.text = [SharedManager getInstance]._userProfile.cashablePoints;
          }
          else {
               selfPointsLbl.text = @"70";
          }
          
          int opponentPoints = [_challenge.opponent_points intValue];
          
          if(opponentPoints >= 70) {
               
               opponentPointsLbl.text = @"70";
               currentOtherPoints = 70;
          }
          else {
               NSString *stringPoints = [NSString stringWithFormat:@"%@",_challenge.opponent_points];
               opponentPointsLbl.text = stringPoints;
               currentOtherPoints = opponentPoints;
          }
     }else if ([requestType isEqualToString:@"points"]){
          selfPointsLbl.text = @"0";
          opponentPointsLbl.text = @"0";
          currentOtherPoints = 0;
          
     }
}

-(void)SendSelfImageView{
     if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [selfProfileImg setImage:[completedOperation responseImage]];
               [selfProfileImg roundImageCorner];
               
          } onError:^(NSError* error) {
               //////Changed by Fiza //////
               selfProfileImg.image= [UIImage imageNamed:@"Icon_120.png"];
               [selfProfileImg roundImageCorner];
          }];
          
          [engine enqueueOperation:op];
     }
}

-(void)SendOpponentImageView{
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     MKNetworkOperation *op = [engine operationWithURLString:_challenge.opponent_profileImage params:Nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [opponentProfileImg setImage:[completedOperation responseImage]];
          [opponentProfileImg roundImageCorner];
          
          _optionImg1.image = opponentProfileImg.image;
          _optionImg2.image = opponentProfileImg.image;
          _optionImg3.image = opponentProfileImg.image;
          _optionImg4.image = opponentProfileImg.image;
          
          [_optionImg1 roundImageCorner];
          [_optionImg2 roundImageCorner];
          [_optionImg3 roundImageCorner];
          [_optionImg4 roundImageCorner];
          
          
     } onError:^(NSError* error) {
          /////////// Changed by Fiza ////////
          opponentProfileImg.image= [UIImage imageNamed:@"Icon_120.png"];
          [opponentProfileImg roundImageCorner];
     }];
     
     [engine enqueueOperation:op];
}

#pragma mark -
#pragma mark Show Questions

-(BOOL)checkFinished{
     
     currentIndex ++;
     if (currentIndex<[_challenge.questionsArray count]){
          return false;
     }
     return true;
}


-(void)showQuestion:(int)questionNumber{
     
     _optionImg1.hidden = true;
     _optionImg2.hidden = true;
     _optionImg3.hidden = true;
     _optionImg4.hidden = true;
     
     if(!isGameEnd && currentIndex <6) {
          [blinkTimer invalidate];
          blinkTimer = nil;
          
          [buttonToBlink setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
          buttonToBlink = nil;
          
          [option_1_Btn setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
          [option_2_Btn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
          [option_3_Btn setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
          [option_4_Btn setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
          
          [self disableOptions:false];
          _questionView.hidden = true;
          [_carrierView setHidden:true];
          
          CGRect screenRect = [[UIScreen mainScreen] bounds];
          CGFloat screenWidth = screenRect.size.width;
          
          _timerBar.frame = CGRectMake(0, 0, screenWidth, 7);
          _timerBar.backgroundColor = [UIColor greenColor];
          _roundView.hidden = false;
          
          if(IS_IPHONE_4) {
               _gamebg.frame = CGRectMake(0, 0, 320, 568);
               
               _roundView.frame = CGRectMake(0, 75, 320, 330);
               roundBg.frame = CGRectMake(0, 0, 320, 330);
               //changed  by fiza
               _roundLbl.frame = CGRectMake(54, 140, 212, 68);
          }
          
          _roundLbl.text = [NSString stringWithFormat:@"%@ %d",Round,currentIndex+1];
          roundTitleLbl.text = [NSString stringWithFormat:@"%@ %d",Round,currentIndex+1];
          
          if(languageCode == 0 ) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ %d",Round,currentIndex+1];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ %d",Round,currentIndex+1];
          }
          else if(languageCode == 1 ) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ %d",Round_1,currentIndex+1];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ %d",Round_1,currentIndex+1];
          }
          else if(languageCode == 2) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ %d",Round_2,currentIndex+1];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ %d",Round_2,currentIndex+1];
          }
          else if(languageCode == 3) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ %d",Round_3,currentIndex+1];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ %d",Round_3,currentIndex+1];
          }
          else if(languageCode == 4) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ %d",Round_4,currentIndex+1];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ %d",Round_4,currentIndex+1];
          }
          
     }else if(!isGameEnd && currentIndex >5){
          
          [blinkTimer invalidate];
          blinkTimer = nil;
          if(labelToBlink){
               labelToBlink.textColor = [UIColor whiteColor];
          }
          
          [option_1_Btn setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
          [option_2_Btn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
          [option_3_Btn setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
          [option_4_Btn setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
          
          [self disableOptions:false];
          _questionView.hidden = true;
          [_carrierView setHidden:true];
          
          CGRect screenRect = [[UIScreen mainScreen] bounds];
          CGFloat screenWidth = screenRect.size.width;
          
          _timerBar.frame = CGRectMake(0, 0, screenWidth, 7);
          _timerBar.backgroundColor = [UIColor greenColor];
          _roundView.hidden = false;
          if(languageCode == 0 ) {
               _roundLbl.text = LAST_ROUND;
               roundTitleLbl.text = LAST_ROUND;
          }
          else if(languageCode == 1 ) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_1];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_1];
          }
          else if(languageCode == 2) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_2];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_2];
          }
          else if(languageCode == 3) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_3];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_3];
          }
          else if(languageCode == 4) {
               _roundLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_4];
               roundTitleLbl.text = [NSString stringWithFormat:@"%@ ",LAST_ROUND_4];
          }
     }
     timerLbl.text = @"10";
     questionNoLbl.text = [NSString stringWithFormat:@"%d",currentIndex+1];
     [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                    selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
}

-(void) callAfterSixtySecond:(NSTimer*) t
{
     _roundView.hidden = true;
     if(isFirstLoad){
          [self addAnimationToQuestionsView];
     }
}
#pragma mark -
#pragma mark Timer

-(void)countDown:(NSTimer *) aTimer {
     
     timerLbl.text = [NSString stringWithFormat:@"%d",[timerLbl.text  intValue] - 1];
     int timeSpend = 10 - [timerLbl.text intValue];
     if ([_challenge.isSuperBot intValue]== 0 && [_challenge.isBot intValue]== 1) {
          if(timeSpend >= [timeSeconds intValue]){
               if (!isQuestionAnswered ) {
                    [a_Timer invalidate];
                    [self disableOptions:true];
                    [self TimerUp];
               }else{
                    [a_Timer invalidate];
                    [timerImg.layer removeAllAnimations];
                    [self notifyUser:tagbtn];
               }
          }
     }
     if ([_challenge.isBot intValue]== 0){
          
          if(timeSpend >= [timeSeconds intValue]){
               if (!isQuestionAnswered ) {
                    
                    [a_Timer invalidate];
                    [self disableOptions:true];
                    [self TimerUp];
               }else{
                    [a_Timer invalidate];
                    [timerImg.layer removeAllAnimations];
                    [self notifyUser:tagbtn];
               }
          }
     }
     if ([_challenge.isSuperBot intValue]== 1) {
          if ([timerLbl.text intValue] <= [timeSeconds intValue]) {
               if (isQuestionAnswered && isWrongAns) {
                    [a_Timer invalidate];
                    [timerImg.layer removeAllAnimations];
                    [self notifyUser:tagbtn];
                    
               }else if(!isQuestionAnswered){
                    [a_Timer invalidate];
                    [self TimerUp];
                    [timerImg.layer removeAllAnimations];
               }
          }
     }
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     CGFloat screenWidth = screenRect.size.width;
     
     int width = (screenWidth/10)*(timeSpend+2);
     width = screenWidth - width;
     
     if(width>-60) {
          [UIView beginAnimations:@"" context:nil];
          [UIView setAnimationDuration:2]; //whatever time you want
          _timerBar.frame = CGRectMake(0, 0, width, 7);//ends small
          if((width <= screenWidth/2) && (width > screenWidth/4) ){
               _timerBar.backgroundColor = [UIColor yellowColor];
          }
          else if(width <= (screenWidth/4)){
               _timerBar.backgroundColor = [UIColor redColor];
          }
          [UIView commitAnimations];
     }
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if(requestType == nil) {
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          requestType = delegate.requestType;
     }
     if(timeSpend%2 == 1) {
          if([requestType isEqualToString:@"points"]) {
               _userStarToBlink.image = [UIImage imageNamed:@"staryellow.png"];
               _opponentStarToBlink.image = [UIImage imageNamed:@"staryellow.png"];
          }
          else {
               _userStarToBlink.image = [UIImage imageNamed:@"gemyellow.png"];
               _opponentStarToBlink.image = [UIImage imageNamed:@"gemyellow.png"];
          }
     }
     else {
          if([requestType isEqualToString:@"points"]) {
               _userStarToBlink.image = [UIImage imageNamed:@"starwhite.png"];
               _opponentStarToBlink.image = [UIImage imageNamed:@"starwhite.png"];
          }
          else {
               _userStarToBlink.image = [UIImage imageNamed:@"gemwhite.png"];
               _opponentStarToBlink.image = [UIImage imageNamed:@"gemwhite.png"];
          }
     }
}

-(void) disableOptions :(BOOL) isDisable {
          if(isDisable) {
     
               option_1_Btn.userInteractionEnabled = false;
               option_2_Btn.userInteractionEnabled = false;
               option_3_Btn.userInteractionEnabled = false;
               option_4_Btn.userInteractionEnabled = false;
     
          }
          else {
     
               option_1_Btn.userInteractionEnabled = true;
               option_2_Btn.userInteractionEnabled = true;
               option_3_Btn.userInteractionEnabled = true;
               option_4_Btn.userInteractionEnabled = true;
               
          }
}

- (IBAction)showTimeLine:(id)sender {
     [[NavigationHandler getInstance] MoveToTimeLine];
}

- (IBAction)rightMenu:(id)sender {
     
     [self.view endEditing:YES];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}
-(void)TimerUp{
     
     if(!isQuestionAnswered){
          answerReaction.hidden = true;
          int timeSpend = 10 - ([timerLbl.text  intValue] - 1);
          if(timeSpend >= 10)
          {
               if (languageCode == 0) {
                    
                    answerTxt.text = @"Time is up..";
               }else if (languageCode==1){
                    
                    answerTxt.text = TIMES_UP_1;
                    
               }else if (languageCode==2){
                    
                    answerTxt.text = TIMES_UP_2;
                    
               }else if (languageCode==3){
                    
                    answerTxt.text = TIMES_UP_3;
                    
               }else if (languageCode==4){
                    
                    answerTxt.text = TIMES_UP_4;
               }
               
          }else{
               if (languageCode == 0) {
                    
                    answerTxt.text = @"Wrong answer, Opponent Answered Before You";
               }else if (languageCode==1){
                    
                    answerTxt.text = OPPONENT_ANS_BEFORE_1;
                    
               }else if (languageCode==2){
                    
                    answerTxt.text = OPPONENT_ANS_BEFORE_2;
                    
               }else if (languageCode==3){
                    
                    answerTxt.text = OPPONENT_ANS_BEFORE_3;
                    
               }else if (languageCode==4){
                    answerTxt.text = OPPONENT_ANS_BEFORE_4;
               }
          }
     }
     if(currentIndex == 7) {
          return;
     }
     if(_challenge.challengeID == nil){
          Question *tempQuestion = [_challenge.questionsArray objectAtIndex:currentIndex];
          for(int i=0; i<tempQuestion.optionsArray.count; i++) {
               Option *tempOption1 = [tempQuestion.optionsArray objectAtIndex:i];
               if([tempOption1.isCorrect intValue] == 1) {
                    
                    buttonToBlink = (UIButton*)[self.view viewWithTag:i+100];
                    
                    switch (i) {
                         case 0:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"1right.png"] forState:UIControlStateNormal];
                              _optionImg1.hidden = false;
                              
                              break;
                         case 1:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"2right.png"] forState:UIControlStateNormal];
                              _optionImg2.hidden = false;
                              break;
                         case 2:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"3right.png"] forState:UIControlStateNormal];
                              _optionImg3.hidden = false;
                              break;
                         case 3:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"4right.png"] forState:UIControlStateNormal];
                              _optionImg4.hidden = false;
                              break;
                              
                         default:
                              break;
                    }
               }
          }
     }
     
     [self notifyUser:-1];
}


-(IBAction)optionSelected:(id)sender{
     addOnBtn.enabled = false;
     isQuestionAnswered = true;
     
     [self disableOptions:true];
     
     if([_challenge.isSuperBot intValue] == 1 && isQuestionAnswered){
          
          ChancesSuperbot = 1 + rand() % (100-1);
          if (ChancesSuperbot <= 70) {
               timeSeconds = @"6";
               
          }else if (ChancesSuperbot >70 && ChancesSuperbot <= 90){
               timeSeconds = @"4";
               
          }else if (ChancesSuperbot >90 && ChancesSuperbot <= 100){
               timeSeconds = @"8";
               
          }
     }
     UIButton *btn = (UIButton *)sender;
     if(currentIndex == 7) {
          NSLog(@"Issue Here ::: optionSelected");
     }
     Question *tempQuestion = [_challenge.questionsArray objectAtIndex:currentIndex];
     
     Option *tempOption = [tempQuestion.optionsArray objectAtIndex:(btn.tag-100)];
     UIButton *answerLbl = (UIButton *)[self.view viewWithTag:btn.tag];
     
     
     if([tempOption.isCorrect intValue] == 1) {
          
          isWrongAns = false;
          [self playCorrectSound:@"correct.mp3" Loop: NO];
          [a_Timer invalidate];
          [timerImg.layer removeAllAnimations];
          
          switch (btn.tag) {
               case 100:
                    [option_1_Btn setBackgroundImage:[UIImage imageNamed:@"1right.png"] forState:UIControlStateNormal];
                    break;
               case 101:
                    [option_2_Btn setBackgroundImage:[UIImage imageNamed:@"2right.png"] forState:UIControlStateNormal];
                    break;
               case 102:
                    [option_3_Btn setBackgroundImage:[UIImage imageNamed:@"3right.png"] forState:UIControlStateNormal];
                    break;
               case 103:
                    [option_4_Btn setBackgroundImage:[UIImage imageNamed:@"4right.png"] forState:UIControlStateNormal];
                    break;
                    
                    
               default:
                    break;
          }
          
          [self notifyUser:(int)(btn.tag-100)];
     }
     else {
          [self playCorrectSound:@"incorrect.mp3" Loop: NO];
          switch (btn.tag) {
               case 100:
                    [option_1_Btn setBackgroundImage:[UIImage imageNamed:@"1wrong.png"] forState:UIControlStateNormal];
                    break;
               case 101:
                    [option_2_Btn setBackgroundImage:[UIImage imageNamed:@"2wrong.png"] forState:UIControlStateNormal];
                    break;
               case 102:
                    [option_3_Btn setBackgroundImage:[UIImage imageNamed:@"3wrong.png"] forState:UIControlStateNormal];
                    break;
               case 103:
                    [option_4_Btn setBackgroundImage:[UIImage imageNamed:@"4wrong.png"] forState:UIControlStateNormal];
                    break;
                    
               default:
                    break;
          }
          
          isWrongAns = true;
          tagbtn = (int)(btn.tag-100);
          
          answerReaction.image = [UIImage imageNamed:@""];
          
          if (languageCode == 0) {
               answerTxt.text = @"Wrong Answer! Waiting for Opponent to Answer..";
          }else if (languageCode==1){
               answerTxt.text = WRONG_ANS_WAIT_OPP_1;
          }else if (languageCode==2){
               answerTxt.text = WRONG_ANS_WAIT_OPP_2;
          }else if (languageCode==3){
               answerTxt.text = WRONG_ANS_WAIT_OPP_3;
          }else if (languageCode==4){
               answerTxt.text = WRONG_ANS_WAIT_OPP_4;
          }
          answerTxt.hidden = NO;
          
          for(int i=0; i<tempQuestion.optionsArray.count; i++) {
               Option *tempOption1 = [tempQuestion.optionsArray objectAtIndex:i];
               if([tempOption1.isCorrect intValue] == 1) {
                    buttonToBlink = (UIButton*)[self.view viewWithTag:i+100];
                    
                    switch (i) {
                         case 0:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"1right.png"] forState:UIControlStateNormal];
                              break;
                         case 1:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"2right.png"] forState:UIControlStateNormal];
                              break;
                         case 2:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"3right.png"] forState:UIControlStateNormal];
                              break;
                         case 3:
                              [buttonToBlink setBackgroundImage:[UIImage imageNamed:@"4right.png"] forState:UIControlStateNormal];
                              break;
                              
                         default:
                              break;
                    }
                    break;
               }
          }
          //Fix Done by Ahmed
          if([_challenge.isBot intValue] == 0 && [_challenge.isSuperBot intValue]== 0){
               [a_Timer invalidate];
               [timerImg.layer removeAllAnimations];
               [self notifyUser:tagbtn];
          }
          else {
               NSLog(@":::::::::: Did Nothing :::::::::::::");
          }
     }
     
     [self dissableOptionSelection];
}

-(void)blink {
     
     //     if(blinkStatus == NO){
     //          labelToBlink.textColor = [UIColor greenColor];
     //          blinkStatus = YES;
     //     }else {
     //          labelToBlink.textColor = [UIColor grayColor];
     //          blinkStatus = NO;
     //     }
     
}

#pragma mark Sound Methods
-(BOOL) playCorrectSound: (NSString*) vSFXName Loop: (BOOL) vLoop
{
     BOOL isSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
     if(isSoundOn) {
          NSError *error;
          
          NSBundle* bundle = [NSBundle mainBundle];
          
          NSString* bundleDirectory = (NSString*)[bundle bundlePath];
          
          NSURL *url = [NSURL fileURLWithPath:[bundleDirectory stringByAppendingPathComponent:vSFXName]];
          
          audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
          
          if(vLoop)
               audioPlayer.numberOfLoops = -1;
          else
               audioPlayer.numberOfLoops = 0;
          
          BOOL success = YES;
          
          if (audioPlayer == nil)
          {
               success = NO;
          }
          else
          {
               success = [audioPlayer play];
          }
          return success;
     }
     else
          return false;
     
}


#pragma mark -
#pragma mark Enable Options


-(void)enableOptionSelection{
     
     for (int x=0; x<4; x++) {
          
          UIButton *_btn = (UIButton *)[self.view viewWithTag:x];
          _btn.enabled = YES;
     }
     
}


-(void)dissableOptionSelection{
     
     for (int x=0; x<4; x++) {
          
          UIButton *_btn = (UIButton *)[self.view viewWithTag:x];
          _btn.enabled = NO;
     }
}

#pragma mark -
#pragma mark Animation

-(void)addAnimationToQuestionsView{
     if (_challenge.questionsArray == nil || _challenge.questionsArray.count == 0) {
          
     }
     else if(_challenge.questionsArray.count == 7){
          if(currentIndex >= 7) {
               return;
          }
          _userStarToBlink = (UIImageView*)[upperViewLeft viewWithTag:currentIndex+1];
          _opponentStarToBlink = (UIImageView*)[upperViewRight viewWithTag:currentIndex+1];
          
          Question *tempQuestion = [_challenge.questionsArray objectAtIndex:currentIndex];
          if(languageCode == 1 ) {
               ArabicConverter *converter = [[ArabicConverter alloc] init];
               NSString* convertedString = [converter convertArabic:tempQuestion.questionText];
               [questionTextLbl setText:convertedString];
          }
          else{
               [questionTextLbl setText:tempQuestion.questionText];
          }
          option_1_Btn.hidden = true;
          option_2_Btn.hidden = true;
          option_3_Btn.hidden = true;
          option_4_Btn.hidden = true;
          
          _option1 = [tempQuestion.optionsArray objectAtIndex:0];
          [option_1_Lbl setText:_option1.optionText];
          
          _option2 = [tempQuestion.optionsArray objectAtIndex:1];
          [option_2_Lbl setText:_option2.optionText];
          
          _option3 = [tempQuestion.optionsArray objectAtIndex:2];
          [option_3_Lbl setText:_option3.optionText];
          
          _option4 = [tempQuestion.optionsArray objectAtIndex:3];
          [option_4_Lbl setText:_option4.optionText];
          
          option_1_Lbl.hidden = true;
          option_2_Lbl.hidden = true;
          option_3_Lbl.hidden = true;
          option_4_Lbl.hidden = true;
          
          _questionView.hidden = false;
          [self fadeInAnimation:_questionView];
          
     }
     
     
}

-(void) appAddOn: (NSNumber*) number{
     
     UIButton *btn1;
     UILabel *lbl1;
     UIButton *btn2;
     UILabel *lbl2;
     
     int isCorrect = [_option1.isCorrect intValue];
     int randomValue1 = 0;
     int randomValue2 = 0;
     if(isCorrect == 1) {
          int arr[3] = {1, 2, 3};
          randomValue1 = arr[rand()%3];
          if(randomValue1 == 1) {
               randomValue2 = 2;
          }
          else if (randomValue1 == 2) {
               randomValue2 = 3;
          }
          else if (randomValue1 == 3) {
               randomValue2 = 1;
          }
     }
     else {
          int isCorrect = [_option2.isCorrect intValue];
          if(isCorrect == 1) {
               int arr[3] = {0, 2, 3};
               randomValue1 = arr[rand()%3];
               if(randomValue1 == 0) {
                    randomValue2 = 2;
               }
               else if (randomValue1 == 2) {
                    randomValue2 = 3;
               }
               else if (randomValue1 == 3) {
                    randomValue2 = 0;
               }
          }
          else {
               int isCorrect = [_option3.isCorrect intValue];
               if(isCorrect == 1) {
                    int arr[3] = {0, 1, 3};
                    randomValue1 = arr[rand()%3];
                    if(randomValue1 == 0) {
                         randomValue2 = 1;
                    }
                    else if (randomValue1 == 1) {
                         randomValue2 = 3;
                    }
                    else if (randomValue1 == 3) {
                         randomValue2 = 0;
                    }
               }
               else{
                    int isCorrect = [_option4.isCorrect intValue];
                    if(isCorrect == 1) {
                         int arr[3] = {0, 1, 2};
                         randomValue1 = arr[rand()%3];
                         if(randomValue1 == 0) {
                              randomValue2 = 1;
                         }
                         else if (randomValue1 == 1) {
                              randomValue2 = 2;
                         }
                         else if (randomValue1 == 2) {
                              randomValue2 = 0;
                         }
                    }
               }
          }
     }
     switch (randomValue1) {
          case 0:
               btn1 = option_1_Btn;
               lbl1 = option_1_Lbl;
               option_1_Btn.enabled = false;
               break;
          case 1:
               btn1 = option_2_Btn;
               lbl1 = option_2_Lbl;
               option_2_Btn.enabled = false;
               break;
          case 2:
               btn1 = option_3_Btn;
               lbl1 = option_3_Lbl;
               option_3_Btn.enabled = false;
               break;
          case 3:
               btn1 = option_4_Btn;
               lbl1 = option_4_Lbl;
               option_4_Btn.enabled = false;
               break;
               
          default:
               
               break;
               
     }
     switch (randomValue2) {
               
          case 0:
               btn2 = option_1_Btn;
               lbl2 = option_1_Lbl;
               option_1_Btn.enabled = false;
               break;
               
          case 1:
               btn2 = option_2_Btn;
               lbl2 = option_2_Lbl;
               option_2_Btn.enabled = false;
               break;
               
          case 2:
               btn2 = option_3_Btn;
               lbl2 = option_3_Lbl;
               option_3_Btn.enabled = false;
               break;
               
          case 3:
               btn2 = option_4_Btn;
               lbl2 = option_4_Lbl;
               option_4_Btn.enabled = false;
               
               break;
               
          default:
               break;
               
     }
     currentAddOns--;
     
     [UIView animateWithDuration:0.5
                           delay:0.0
                         options:UIViewAnimationCurveLinear|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowAnimatedContent
                      animations:^{
                           
                           btn1.transform = CGAffineTransformMakeScale(1.3, 1.3);
                           lbl1.transform = CGAffineTransformMakeScale(1.3, 1.3);
                           btn2.transform = CGAffineTransformMakeScale(1.3, 1.3);
                           lbl2.transform = CGAffineTransformMakeScale(1.3, 1.3);
                           
                           
                      }
                      completion:^(BOOL finished) {
                           
                           [UIView animateWithDuration:0.5
                                                 delay:0
                                               options:UIViewAnimationCurveLinear
                                            animations:^{
                                                 btn1.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                 lbl1.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                 btn2.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                 lbl2.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                 
                                            }
                                            completion:^(BOOL finished){
                                                 btn1.hidden = YES;
                                                 btn2.hidden = YES;
                                                 
                                                 lbl1.hidden = YES;
                                                 lbl2.hidden = YES;
                                                 
                                                 [a_Timer invalidate];
                                                 
                                                 a_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                                                 
                                            }];
                      }];
     if(currentAddOns < 0) {
          currentAddOns = 0;
     }
     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",currentAddOns] forKey:@"currentAddOns"];
     [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -
#pragma mark Notify User

-(void)notifyUser:(int)_selectedIndex{
     
     reconnectAttempt = 0;
     
     sharedManager.socketdelegate = self;
     latestEvent = nil;
     latestEvent = [[EventModel alloc] init];
     int seconds = [timerLbl.text intValue];
     seconds = 10-seconds;
     
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if(requestType == nil){
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          requestType = delegate.requestType;
     }
     
     if([_challenge.isBot intValue] == 1 || [_challenge.isSuperBot intValue] == 1) {
          
          Question *tempQuestion = [_challenge.questionsArray objectAtIndex:currentIndex];
          
          if(_selectedIndex == -1) // If user has not selected any thing
          {
               NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
               NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
               
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",@"-1",@"q_option_id",@"2",@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds", _challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",requestType, @"request_type", nil];
               NSLog(@":::::::::::: Not Selected :::::::::::::");
               NSLog( @"%@", registerDictionary );
               latestEvent.eventName = @"individualQuestionResult";
               latestEvent.params = registerDictionary;
               
               [sharedManager sendEvent:@"individualQuestionResult" andParameters:registerDictionary];
          }
          else
          {
               NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
               NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
               Option *tempOption = [tempQuestion.optionsArray objectAtIndex:_selectedIndex];
               
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",tempOption.optionID,@"q_option_id",tempOption.isCorrect,@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds", _challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",requestType, @"request_type", nil];
               NSLog( @"%@", registerDictionary );
               latestEvent.eventName = @"individualQuestionResult";
               latestEvent.params = registerDictionary;
               [sharedManager sendEvent:@"individualQuestionResult" andParameters:registerDictionary];
          }
          
          if ([_challenge.isBot intValue] == 1) {    // Sending call for Bot
               botLatestEvent = [[EventModel alloc] init];
               
               Option *_tempOption = [tempQuestion getCorrectBotOption];
               if(currentIndex == 7) {
                    NSLog(@"Issue Here ::: Notify User 2nd");
               }
               NSString *correctOpt = [_challenge.randAnswerArray objectAtIndex:currentIndex];
               NSString *_optionId = _tempOption.optionID;
               
               if (_tempOption == nil) {
                    _optionId = @"0";
               }
               
               NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
               NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
               
               if ([_challenge.isSuperBot intValue]== 0 && _selectedIndex == -1){
                    
                    int randomNumber = 2 + rand() % (7-2);
                    timeInSeconds = [NSString stringWithFormat:@"%d",randomNumber];
                    correctOpt = [_challenge.randAnswerArray objectAtIndex:currentIndex];
                    
               }
               
               if ([_challenge.isSuperBot intValue]== 1 && _selectedIndex == -1) {
                    
                    if (ChancesSuperbot <= 70) {
                         timeInSeconds = @"7";
                         correctOpt = @"1";
                    }else if (ChancesSuperbot >70 && ChancesSuperbot <= 90){
                         timeInSeconds = @"8";
                         correctOpt = @"1";
                    }else if (ChancesSuperbot >90 && ChancesSuperbot <= 100){
                         timeInSeconds = @"6";
                         correctOpt = @"1";
                    }
                    
               }else{
                    
                    
                    NSLog(@"randomNumber : %d",ChancesSuperbot);
                    if (ChancesSuperbot <= 70) {
                         timeInSeconds = @"7";
                         correctOpt = @"1";
                    }else if (ChancesSuperbot >70 && ChancesSuperbot <= 90){
                         timeInSeconds = @"8";
                         correctOpt = @"1";
                    }else if (ChancesSuperbot >90 && ChancesSuperbot <= 100){
                         timeInSeconds = @"6";
                         correctOpt = @"1";
                    }
                    
                    [a_Timer invalidate];
                    [timerImg.layer removeAllAnimations];
                    
               }
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_challenge.opponent_ID,@"user_id",tempQuestion.questionID,@"question_id",_optionId,@"q_option_id",correctOpt,@"is_correct",otherPointsStr,@"current_points",timeInSeconds,@"seconds", [SharedManager getInstance].userID,@"opponent_id", selfPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",requestType, @"request_type", nil];
               
               botLatestEvent.eventName = @"individualQuestionResult";
               botLatestEvent.params = registerDictionary;
               
               [sharedManager sendEvent:@"individualQuestionResult" andParameters:registerDictionary];
          }
     }else {
          if(currentIndex == 7) {
               NSLog(@"Issue Here ::: Notify User 3rd");
          }
          Question *tempQuestion = [_challenge.questionsArray objectAtIndex:currentIndex];
          
          if(_selectedIndex == -1) // If user has not selected any thing
          {
               if (_challenge.challengeID == nil) {
                    NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
                    NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",@"-1",@"q_option_id",@"2",@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds", _challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",requestType, @"request_type", nil];
                    
                    latestEvent.eventName = @"individualQuestionResult";
                    latestEvent.params = registerDictionary;
                    
                    [sharedManager sendEvent:@"individualQuestionResult" andParameters:registerDictionary];
               }
               else{
                    NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
                    NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",@"-1",@"q_option_id",@"2",@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds", _challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",_challenge.challengeID,@"challenge_id",requestType, @"request_type", nil];
                    
                    latestEvent.eventName = @"individualQuestionResult";
                    latestEvent.params = registerDictionary;
                    
                    [sharedManager sendEvent:@"individualQuestionResult" andParameters:registerDictionary];
               }
               
          }
          else
          {
               NSDictionary *registerDictionary;
               if (_challenge.type == nil) {
                    rematchType = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"rematchType"];
                    rematchTypeId = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"rematchTypeId"];
                    
                    NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
                    NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
                    Option *tempOption = [tempQuestion.optionsArray objectAtIndex:_selectedIndex];
                    
                    registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",tempOption.optionID,@"q_option_id",tempOption.isCorrect,@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds", _challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", rematchType,@"type",rematchTypeId,@"type_id",_challenge.contest_ID,@"contest_id",_challenge.challengeID,@"challenge_id",requestType,@"request_type", nil];
               }else{
                    
                    
                    if (_challenge.challengeID == nil) {
                         NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
                         NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
                         Option *tempOption = [tempQuestion.optionsArray objectAtIndex:_selectedIndex];
                         
                         registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",tempOption.optionID,@"q_option_id",tempOption.isCorrect,@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds",_challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",requestType,@"request_type", nil];
                         
                    }
                    else {
                         NSString *selfPointsStr = [NSString stringWithFormat:@"%i",currentSelfPoints];
                         NSString *otherPointsStr = [NSString stringWithFormat:@"%i",currentOtherPoints];
                         Option *tempOption = [tempQuestion.optionsArray objectAtIndex:_selectedIndex];
                         
                         registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",tempQuestion.questionID,@"question_id",tempOption.optionID,@"q_option_id",tempOption.isCorrect,@"is_correct",selfPointsStr,@"current_points",[NSString stringWithFormat:@"%d",seconds],@"seconds",_challenge.opponent_ID,@"opponent_id", otherPointsStr,@"opponent_points", _challenge.type,@"type",_challenge.type_ID,@"type_id",_challenge.contest_ID,@"contest_id",_challenge.challengeID,@"challenge_id",requestType,@"request_type", nil];
                         NSLog([NSString stringWithFormat:@"Request Type for This Challenege is  ::::::::::::::::::::  %@",requestType]);
                         
                    }
               }
               latestEvent.eventName = @"individualQuestionResult";
               latestEvent.params = registerDictionary;
               
               [sharedManager sendEvent:@"individualQuestionResult" andParameters:registerDictionary];
          }
     }
     responeTimeOutTimer = [NSTimer
                            scheduledTimerWithTimeInterval:(NSTimeInterval)(60.0)
                            target:self
                            selector:@selector(responseTimeOut)
                            userInfo:nil
                            repeats:TRUE];
     responseStatus = NO;
     
}


- (BOOL)connected
{
     Reachability *reachability = [Reachability reachabilityForInternetConnection];
     NetworkStatus networkStatus = [reachability currentReachabilityStatus];
     return networkStatus != NotReachable;
}


#pragma mark -
#pragma mark Quite User

-(IBAction)quiteUser:(id)sender{
     
     quitGameDialog.layer.borderColor = [UIColor lightGrayColor].CGColor;
     quitGameDialog.layer.borderWidth = 1.0f;
     
     if (languageCode == 0) {
          QuitTitle.text = QUIT_GAME;
          quitMsg.text = SURRENDER_LBL;
          [quityes setTitle:YES_BTN forState:UIControlStateNormal];
          [quitno setTitle:NO_BTN forState:UIControlStateNormal];
     }else if (languageCode == 1){
          QuitTitle.text = QUIT_GAME_1;
          quitMsg.text = SURRENDER_LBL_1;
          [quityes setTitle:YES_BTN_1 forState:UIControlStateNormal];
          [quitno setTitle:NO_BTN_1 forState:UIControlStateNormal];
     }else if (languageCode == 2){
          QuitTitle.text = QUIT_GAME_2;
          quitMsg.text = SURRENDER_LBL_2;
          [quityes setTitle:YES_BTN_2 forState:UIControlStateNormal];
          [quitno setTitle:NO_BTN_2 forState:UIControlStateNormal];
     }else if (languageCode == 3){
          QuitTitle.text = QUIT_GAME_3;
          quitMsg.text = SURRENDER_LBL_3;
          [quityes setTitle:YES_BTN_3 forState:UIControlStateNormal];
          [quitno setTitle:NO_BTN_3 forState:UIControlStateNormal];
     }else if (languageCode == 4){
          QuitTitle.text = QUIT_GAME_4;
          quitMsg.text = SURRENDER_LBL_4;
          [quityes setTitle:YES_BTN_4 forState:UIControlStateNormal];
          [quitno setTitle:NO_BTN_4 forState:UIControlStateNormal];
     }
     
     quitGameDialog.center = self.view.center;
     quitGameDialog.center = CGPointMake(self.view.center.x, quitGameDialog.center.y);
     [self.view addSubview:quitGameDialog];
     
}

- (IBAction)QuitYes:(id)sender {
     
     
     [responeTimeOutTimer invalidate];
     responeTimeOutTimer = nil;
     [a_Timer invalidate];
     [self fetchResults];
     isGameEnd = true;
     userDisconnected = true;
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if(requestType == nil) {
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          requestType = delegate.requestType;
     }
     
     if([_challenge.isBot intValue] == 1) {
          if(sharedManager.socketIO.isConnected) {
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_challenge.contest_ID,@"contest_id",_challenge.opponent_ID,@"opponent_id",requestType,@"request_type", nil];
               [sharedManager sendEvent:@"notifyOnSurrender" andParameters:registerDictionary];
          }
          else {
               
          }
     }else if ([_challenge.isSuperBot intValue] == 1){
          if(sharedManager.socketIO.isConnected) {
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_challenge.contest_ID,@"contest_id",_challenge.opponent_ID,@"opponent_id",requestType,@"request_type", nil];
               [sharedManager sendEvent:@"notifyOnSurrender" andParameters:registerDictionary];
          }
          else {
               
          }
          
     }
     else {
          if(sharedManager.socketIO.isConnected) {
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_challenge.contest_ID,@"contest_id",_challenge.opponent_ID,@"opponent_id",_challenge.challengeID,@"challenge_id",requestType,@"request_type", nil];
               [sharedManager sendEvent:@"notifyOnSurrender" andParameters:registerDictionary];
          }
          else {
          }
     }
     
}

- (IBAction)QuitNO:(id)sender {
     
     [quitGameDialog removeFromSuperview];
}


-(void)setResultantView{
     
     float height = (tempVar+2)*25;
     height = 336;
     [resultCard_View setFrame:CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, height)];
     if(IS_IPHONE_4) {
          rescultScrollView.contentSize = CGSizeMake(310, 407);
          resultCard_View.frame = CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, resultCard_View.frame.size.height+36);
          playbtn.frame = CGRectMake(playbtn.frame.origin.x, playbtn.frame.origin.y+65, playbtn.frame.size.width, playbtn.frame.size.height);
          homeBtn.frame = CGRectMake(homeBtn.frame.origin.x, homeBtn.frame.origin.y+65, homeBtn.frame.size.width, homeBtn.frame.size.height);
     }
     else if (IS_IPAD) {
          [resultCard_View setFrame:CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, height+40)];
          playbtn.frame = CGRectMake(playbtn.frame.origin.x, playbtn.frame.origin.y+112, playbtn.frame.size.width, playbtn.frame.size.height);
          homeBtn.frame = CGRectMake(homeBtn.frame.origin.x, homeBtn.frame.origin.y+112, homeBtn.frame.size.width, homeBtn.frame.size.height);
     }
}

#pragma mark -
#pragma mark Update Points

-(void)UpdatePointsAndSwitch:(NSDictionary *)_dict{
     
     NSDictionary *temp_1 = [_dict objectForKey:[SharedManager getInstance].userID];
     NSNumber *userPoints = [temp_1 objectForKey:@"points"];
     currentSelfPoints = [userPoints intValue];
     selfPointsLbl.text = [userPoints stringValue];
     
     int opponentID = [_challenge.opponent_ID intValue];
     
     NSString *str_oID = [NSString stringWithFormat:@"%d",opponentID];
     NSDictionary *temp_2 = [_dict objectForKey:str_oID];
     NSNumber *opponentPoints = [temp_2 objectForKey:@"points"];
     currentOtherPoints = [opponentPoints intValue];
     opponentPointsLbl.text = [opponentPoints stringValue];
     
}

#pragma mark -
#pragma mark Show Results


-(void)fetchResults{
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.isGameInProcess = false;
     
     [responeTimeOutTimer invalidate];
     responeTimeOutTimer = nil;
     responseStatus = YES;
     loadView = [[LoadingView alloc] init];
     [loadView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParamas = [[NSMutableDictionary alloc] init];
     [postParamas setObject:@"gameContestResult" forKey:@"method"];
     [postParamas setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParamas setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParamas setObject:_challenge.contest_ID forKey:@"contest_id"];
     [postParamas setObject:_challenge.opponent_ID forKey:@"opponent_id"];
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParamas httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOper){
          
          [loadView hide];
          NSDictionary *mainDict = [completedOper responseJSON];
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:1]]) {
               
               int consumed_gems = [[SharedManager getInstance]._userProfile.consumedGems intValue];
               
               
               isGameEnd = true;
               int *userEarnedPoints = [[mainDict objectForKey:@"user_score"] intValue];
               NSString* userEarnedPointsSte = [NSString stringWithFormat:@"%d",userEarnedPoints];
               
               userTotal.text = userEarnedPointsSte;
               userGemTotal.text = [SharedManager getInstance]._userProfile.cashablePoints;
              userPointsTotal.text =  [SharedManager getInstance]._userProfile.totalPoints;
               [SharedManager getInstance]._userProfile.cashablePoints = [mainDict objectForKey:@"gems"];
               NSString *val = [mainDict objectForKey:@"gems"];
               if ([val intValue] < 0) {
                    [SharedManager getInstance]._userProfile.cashablePoints = @"0";
                    
               }
               
               [SharedManager getInstance]._userProfile.totalPoints = [mainDict objectForKey:@"points"];
               int oppID = [_challenge.opponent_ID intValue];
               NSString *opponentUSerIdStr = [NSString stringWithFormat:@"%d", oppID];
               senderPointsArray = [mainDict objectForKey:opponentUSerIdStr];
               selfPointsArray = [mainDict objectForKey:[SharedManager getInstance].userID];
               
               [self_resultImg setImage:[selfProfileImg image]];
               [self_resultImg roundImageCorner];
               [opponent_resultImg setImage:[opponentProfileImg image]];
               if([senderPointsArray count] > [selfPointsArray count])
                    tempVar = (int)[senderPointsArray count];
               else
                    tempVar = (int)[selfPointsArray count];
               
               
               if(IS_IPHONE_4) {
                    ResultsView.frame = CGRectMake(0, 0, 320, 480);
               }
               else if (IS_IPHONE_5) {
                    ResultsView.frame = CGRectMake(0, 0, 320, 568);
               }
               
               int receiverTotalPoints = [[mainDict objectForKey:@"user_score"] intValue];
               int senderTotalPoints = [[mainDict objectForKey:@"opponent_score"] intValue];
               
               if (receiverTotalPoints > senderTotalPoints)
               {
                    //resultLbl.textColor = [UIColor greenColor];
                    
                    if (languageCode == 0) {
                         
                         resultLbl.text = YOU_WIN;
                         youWinTitle.text = YOU_WIN;
                         
                    }else if (languageCode == 1){
                         
                         resultLbl.text = YOU_WIN_1;
                         youWinTitle.text = YOU_WIN_1;
                         
                    }else if (languageCode == 2){
                         
                         resultLbl.text = YOU_WIN_2;
                         youWinTitle.text = YOU_WIN_2;
                         
                    }else if (languageCode == 3){
                         
                         resultLbl.text = YOU_WIN_3;
                         youWinTitle.text = YOU_WIN_3;
                         
                    }else if (languageCode == 4){
                         
                         resultLbl.text = YOU_WIN_4;
                         youWinTitle.text = YOU_WIN_4;
                         
                    }
                    
                    youWinTitle.hidden = false;
                    youLooseTitle.hidden = true;
               }
               else{
                    if (receiverTotalPoints<senderTotalPoints || receiverTotalPoints < 0)
                    {
                         if (languageCode == 0) {
                              
                              resultLbl.text = BETTER_LUCK;
                              youLooseTitle.text = BETTER_LUCK;
                              
                         }else if (languageCode == 1){
                              
                              resultLbl.text = BETTER_LUCK_1;
                              youLooseTitle.text = BETTER_LUCK_1;
                              
                         }else if (languageCode == 2){
                              
                              resultLbl.text = BETTER_LUCK_2;
                              youLooseTitle.text = BETTER_LUCK_2;
                              
                         }else if (languageCode == 3){
                              
                              resultLbl.text = BETTER_LUCK_3;
                              youLooseTitle.text = BETTER_LUCK_3;
                              
                         }else if (languageCode == 4){
                              
                              resultLbl.text = BETTER_LUCK_4;
                              youLooseTitle.text = BETTER_LUCK_4;
                              
                         }
                         
                         youWinTitle.hidden = true;
                         youLooseTitle.hidden = false;
                    }
                    else {
                         
                         
                         if (languageCode == 0) {
                              
                              resultLbl.text = ITS_TIE;
                              youWinTitle.text = ITS_TIE;
                              
                         }else if (languageCode == 1){
                              
                              resultLbl.text = ITS_TIE_1;
                              youWinTitle.text = ITS_TIE_1;
                              
                         }else if (languageCode == 2){
                              
                              resultLbl.text = ITS_TIE_2;
                              youWinTitle.text = ITS_TIE_2;
                              
                         }else if (languageCode == 3){
                              
                              resultLbl.text = ITS_TIE_3;
                              youWinTitle.text = ITS_TIE_3;
                              
                         }else if (languageCode == 4){
                              
                              resultLbl.text = ITS_TIE_4;
                              youWinTitle.text = ITS_TIE_4;
                              
                         }
                         youLooseTitle.hidden = true;
                         youWinTitle.hidden = false;
                    }
               }
               CATransition *transition = [CATransition animation];
               transition.duration = 0.3;
               transition.type = kCATransitionPush; //choose your animation
               transition.subtype = kCATransitionFromBottom;
               [ResultsView.layer addAnimation:transition forKey:nil];
               ResultsView.hidden = false;
               [self.view addSubview:ResultsView];
               
               
               userProgress.hidden = YES;
               opponentProgress.hidden = YES;
               
               if(consumed_gems >= 100) {
                    _rewardsBtn.enabled = true;
               }
          }
          else {
               NSString *emailMsg;
               NSString *title;
               
               if (languageCode == 0 ) {
                    emailMsg = @"Check your internet connection setting.";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"Quelque chose se est mal passé, réessayez plus tard";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"Algo salió mal, inténtelo más tarde";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Algo deu errado, tente novamente mais tarde";
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
               
               [[NavigationHandler getInstance] NavigateToRoot];
          }
          
     }onError:^(NSError *error){
          
          [loadView hide];
          
          NSString *emailMsg;
          NSString *title;
          
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Quelque chose se est mal passé, réessayez plus tard";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Algo salió mal, inténtelo más tarde";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Algo deu errado, tente novamente mais tarde";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          [[NavigationHandler getInstance] NavigateToRoot];
          
     }];
     
     [engine enqueueOperation:operation];
     
}

-(void)gotoRewardsList {
     
}

-(void) updateProgressBars {
     if(!isGameEnd) {
          [userProgress removeFromSuperview];
          [opponentProgress removeFromSuperview];
          
          float userProgressI = [selfPointsLbl.text floatValue];
          float oppnentProgress = [opponentPointsLbl.text floatValue];
          
          float userPercentageProgress = (float)(userProgressI/200);
          userPercentageProgress = userPercentageProgress*70;
          float opponentPercentageProgress = (float)((float)(oppnentProgress/200)*70);
          
          
          int userProgressFactor = 0;
          int opponentProgressFactor = 0;
          
          if(IS_IPAD) {
               userProgressFactor = (userPercentageProgress/70)*590;
               opponentProgressFactor = (opponentPercentageProgress/70)*590;
          }
          else {
               userProgressFactor = (userPercentageProgress/70)*173;
               opponentProgressFactor = (opponentPercentageProgress/70)*173;
          }
          
          if ([requestType isEqualToString:@"points"]) {
               float userPercentageProgress = (float)(userProgressI/70);
               userPercentageProgress = userPercentageProgress*70;
               float opponentPercentageProgress = (float)((float)(oppnentProgress/70)*70);
               
               if(IS_IPAD) {
                    userProgressFactor = (userPercentageProgress/70)*590;
                    opponentProgressFactor = (opponentPercentageProgress/70)*590;
               }
               else {
                    userProgressFactor = (userPercentageProgress/70)*173;
                    opponentProgressFactor = (opponentPercentageProgress/70)*173;
               }
          }
          userProgress = [[UIImageView alloc] init];
          opponentProgress = [[UIImageView alloc] init];
          if(IS_IPHONE_5) {
               userProgress.frame = CGRectMake(40, 485, userProgressFactor, 10);
               opponentProgress.frame = CGRectMake(40, 503, opponentProgressFactor, 10);
          }
          else if (IS_IPHONE_4) {
               userProgress.frame = CGRectMake(40, 408, userProgressFactor, 10);
               opponentProgress.frame = CGRectMake(40, 423, opponentProgressFactor, 10);
          }
          else if(IS_IPAD) {
               userProgress.frame = CGRectMake(89, 774, userProgressFactor, 30);
               opponentProgress.frame = CGRectMake(89, 812, opponentProgressFactor, 30);
          }
          
          userProgress.image = [UIImage imageNamed:@"green_filled.png"];
          opponentProgress.image = [UIImage imageNamed:@"blue_filled.png"];
          [self.view addSubview:userProgress];
          [self.view addSubview:opponentProgress];
     }
     
     
}

- (void) ticki:(NSTimer *) timer {
    

     if(sharedManager.socketIO.isConnected) {
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          
          searchingOpponentLbl.textColor = [UIColor colorWithRed:(255/255.f) green:(228/255.f) blue:(1/255.f) alpha:1];
          if (languageCode == 0) {
               [cancelbuttonOutlet setTitle:@"Cancel" forState:UIControlStateNormal];
               searchingOpponentLbl.text = @"Waiting for opponent...";
          }else if(languageCode == 1){
               [cancelbuttonOutlet setTitle:@"إلغاء" forState:UIControlStateNormal];
               searchingOpponentLbl.text = @"االبحث عن الخصم...";
          }else if (languageCode == 2 ){
               [cancelbuttonOutlet setTitle:@"Cancelar" forState:UIControlStateNormal];
               searchingOpponentLbl.text = @"Recherche d\'un adversaire...";
          }else if (languageCode == 3){
               [cancelbuttonOutlet setTitle:@"Annuler" forState:UIControlStateNormal];
               searchingOpponentLbl.text = @"La búsqueda de un oponente...";
          }else if (languageCode == 4){
               [cancelbuttonOutlet setTitle:@"Cancelar" forState:UIControlStateNormal];
               searchingOpponentLbl.text = @"Procurando um adversário...";
          }

          [GemsDialogView removeFromSuperview];
          [searchingView removeFromSuperview];
          appDelegate.friendToBeChalleneged = nil;
          UIView *effectView = [self.view viewWithTag:499];
          
          [effectView removeFromSuperview];
//          _gmGemsSelected = false;
//          _gmChallengeSelected = false;
//          _gameModView.hidden = true;
//          [_gameModView removeFromSuperview];
          //Challenge *_challenge1 = [[Challenge alloc] initWithDictionary:userDictInner];
          _challenge.type = rematchType;
          _challenge.type_ID = rematchTypeId;
         // _challenge.challengeID = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ChallengeId"];
          
          isOpponentFound = true;
          ChallengeVC *_challengeVC = [[ChallengeVC alloc] initWithChallenge:_challenge ];
          [self.navigationController pushViewController:_challengeVC animated:YES ] ;
     }
     
}
- (void) tick:(NSTimer *) timer {
     //do something here..
     
     answerReaction.hidden = true;
     answerTxt.hidden = true;
     if([self checkFinished])
     {
          [self fetchResults];
     }
     else {
          
          [self showQuestion:currentIndex];
          [self addAnimationToQuestionsView];
     }
     
}

-(void)resetLabelColors{
     for (int i=0; i<4; i++) {
          
          UILabel *_label = (UILabel *)[self.view viewWithTag:i+10];
          _label.textColor = [UIColor whiteColor];
     }
     
     option_1_Lbl.tag = 10;
     option_2_Lbl.tag = 11;
     option_3_Lbl.tag = 12;
     option_4_Lbl.tag = 13;
     
     option_1_Btn.transform = CGAffineTransformMakeScale(1,1);
     option_2_Btn.transform = CGAffineTransformMakeScale(1,1);
     option_3_Btn.transform = CGAffineTransformMakeScale(1,1);
     option_4_Btn.transform = CGAffineTransformMakeScale(1,1);
     
     
     option_1_Lbl.transform = CGAffineTransformMakeScale(1,1);
     option_2_Lbl.transform = CGAffineTransformMakeScale(1,1);
     option_3_Lbl.transform = CGAffineTransformMakeScale(1,1);
     option_4_Lbl.transform = CGAffineTransformMakeScale(1,1);
     
     option_1_Btn.hidden = NO;
     option_2_Btn.hidden = NO;
     option_3_Btn.hidden = NO;
     option_4_Btn.hidden = NO;
     
     option_1_Lbl.hidden = NO;
     option_2_Lbl.hidden = NO;
     option_3_Lbl.hidden = NO;
     option_4_Lbl.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (IBAction)playAgainPressed:(id)sender {
     
     [lblGemsPoints setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [lblStarsPoints setText:[[SharedManager getInstance] _userProfile].totalPoints];
     
     if(IS_IPHONE_4){
          GemsDialogView.frame = CGRectMake(0, 0, 320, 480);
     }else if (IS_IPHONE_5){
          GemsDialogView.frame = CGRectMake(0, 0, 320, 568);
     }else if (IS_IPHONE_6){
         // GemsDialogView.frame = CGRectMake(0, 0, 375, 667);
     }
     
     if (languageCode == 1) {
          
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentRight;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentRight;
          
          if (IS_IPAD) {
               
               starImage.hidden = YES;
               gemImage.hidden = YES;
               
               starimg2.hidden = NO;
               gemimg2.hidden = NO;
               
          }else{
               starImage.frame = CGRectMake(265, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(270, gemImage.frame.origin.y+2 , 25, 25);
               
          }
          
     }else{
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentLeft;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentLeft;
          
          if (IS_IPAD) {
               starImage.autoresizingMask = UIViewAutoresizingNone;
               starImage.frame = CGRectMake(32, 246, 60, 53);
               gemImage.frame = CGRectMake(37, 309, 51, 53);
          }else{
               starImage.frame = CGRectMake(8, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(13, gemImage.frame.origin.y+2 , 25, 25);
          }
          
     }
     
     [self.view addSubview:GemsDialogView];
     
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if(requestType == nil) {
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          requestType = delegate.requestType;
     }
     
     int totalPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
     if (totalPoints <10) {
          isDisabled = true;
     }else{
          isDisabled = false;
     }
}

- (IBAction)addOnBtnPressed:(id)sender {
     isAddOnEnabled = true;
     addOnBtn.hidden = true;
     bg.image = [UIImage imageNamed:@"5050bg.png"];
     [self performSelector:@selector(appAddOn:)
                withObject: [NSNumber numberWithFloat: 1.0f]
                afterDelay:0.0];
}

- (IBAction)PlaywitStars:(id)sender {
      [opponentProfileImageView roundImageCorner];
     requestType = @"points";
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     isPlayAgain = true;
     
     isRematch = true;
     [loadView showInView:self.view withTitle:loadingTitle];
     rematchType = _challenge.type;
     rematchTypeId = _challenge.type_ID;
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_challenge.contest_ID,@"contest_id",language,@"language",requestType,@"challenge_type", nil];
     [sharedManager sendEvent:@"reMatch" andParameters:registerDictionary];
     
     
}

- (IBAction)PlaywithGems:(id)sender {
      [opponentProfileImageView roundImageCorner];
     requestType = @"gems";
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     int totalPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
     if (totalPoints < 10) {
          
          // Move to store Code
          [self.tabBarController setSelectedIndex:2];
     }
     else {
          isPlayAgain = true;
          
          isRematch = true;
          [loadView showInView:self.view withTitle:loadingTitle];
          rematchType = _challenge.type;
          rematchTypeId = _challenge.type_ID;
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          
          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_challenge.contest_ID,@"contest_id",language,@"language",requestType,@"challenge_type", nil];
          [sharedManager sendEvent:@"reMatch" andParameters:registerDictionary];
     }
}

- (IBAction)CloseGemsDialog:(id)sender {
     [GemsDialogView removeFromSuperview];
     
}

- (IBAction)homePressed:(id)sender {
     
     [self.navigationController popToRootViewControllerAnimated:false];
}

- (IBAction)quitGame:(id)sender {
     [searchingView removeFromSuperview];
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
     
     [spinnerImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma mark ----------------
#pragma mark Send Challenge

-(void)SendRematchChallengeToYourFriend{
     /*isRematch = true;
      [loadView showInView:self.view withTitle:@"Sending ..."];
      
      MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
      
      NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
      [postParams setObject:@"sendReMatchRequest" forKey:@"method"];
      [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
      [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
      [postParams setObject:_challenge.contest_ID forKey:@"contest_id"];
      [postParams setObject:@"0" forKey:@"language"];
      
      MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
      
      [op onCompletion:^(MKNetworkOperation *compOp){
      
      [loadView hide];
      NSDictionary *mainDict = [compOp responseJSON];
      NSString *message = [mainDict objectForKey:@"message"];
      NSNumber *flag = [mainDict objectForKey:@"flag"];
      
      if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
      {
      [self displayNameAndImage];
      if(IS_IPHONE_5) {
      searchingView.frame = CGRectMake(0, 0, 320, 568);
      }
      else if(IS_IPHONE_4) {
      searchingView.frame = CGRectMake(0, 0, 320, 480);
      }
      [self.view addSubview:searchingView];
      [self runSpinAnimationOnView:opponentProfileImageView duration:3600 rotations:0.3 repeat:0];
      
      timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
      }
      else{
      [SocketManager getInstance].socketdelegate = nil;
      [[SocketManager getInstance] closeWebSocket];
      isPlayAgain = false;
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error .." message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
      
      [alert show];
      }
      }onError:^(NSError *error){
      
      [loadView hide];
      [SocketManager getInstance].socketdelegate = nil;
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavalible" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
      
      [alert show];
      }];
      
      [engine enqueueOperation:op];*/
}

- (void)increaseTimerCount
{
     if (!isOpponentFound){
          timeSinceTimer++;
          _loaderIndex++;
          if(_loaderIndex == 5) {
               _loaderIndex = 1;
          }
          for(int i = 1; i<5; i++) {
               UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
               if(i == _loaderIndex) {
                    dot.image = [UIImage imageNamed:@"dotglow.png"];
               }
               else {
                    dot.image = [UIImage imageNamed:@"dotblack.png"];
               }
          }
     }
     if(timeSinceTimer == 180) {
          if(!isOpponentFound) {
               [searchingView removeFromSuperview];
               //[SocketManager getInstance].socketdelegate = nil;
          }
          else {
               [timer invalidate];
               timer = nil;
          }
     }
}

#pragma mark Socket Communication Methods
- (void) connectToSocket {
     
     sharedManager = [SocketManager getInstance];
     sharedManager.socketdelegate = nil;
     sharedManager.socketdelegate = self;
}

#pragma mark iPhone - Server Communication
-(void) DataRevieved:(SocketIOPacket *)dict{
       
     [loadView hide];
     
     [self dissableOptionSelection];
     
     [responeTimeOutTimer invalidate];
     responeTimeOutTimer = nil;
     
     if([dict.name isEqualToString:@"notifyOnSurrender"])
     {
          if(!userDisconnected) {
               
               NSString *title;
               
               if (languageCode == 0 ) {
                    message = @"Sorry, your opponent has surrendered. Try again later.";
                    title = Friend_Not_Available;
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    message = @"نأسف، استسلم خصمك. حاول مرة أخرى في وقت لاحق.";
                    title = Friend_Not_Availabl_1;
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    message = @"Désolé, votre adversaire a abandonné. Réessayez plus tard.";
                    title = Friend_Not_Availabl_2;
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    message = @"Lo sentimos, tu oponente se ha rendido. Inténtalo de nuevo más tarde.";
                    title = Friend_Not_Availabl_3;
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    message = @"Desculpe, seu oponente se rendeu. Tente novamente mais tarde.";
                    title = Friend_Not_Availabl_4;
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
               [responeTimeOutTimer invalidate];
               responeTimeOutTimer = nil;
               [a_Timer invalidate];
               [self fetchResults];
               isGameEnd = true;
          }
          
     }
     else if([dict.name isEqualToString:@"findPlayerOpponent"])
     {
          NSArray* args = dict.args;
          NSDictionary *json = (NSDictionary*)args[0] ;
          int flag = [[json objectForKey:@"flag"] intValue];
          if(flag == 3) {
               
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               
//               if(!(_gmChallengeSelected))
//               {
//                    if (languageCode == 0) {
//                         _searchOppLbl.text = @"Searching opponent...";
//                    }else if(languageCode == 1){
//                         _searchOppLbl.text = @"االبحث عن الخصم...";
//                    }else if (languageCode == 2 ){
//                         _searchOppLbl.text = @"Recherche d\'un adversaire...";
//                    }else if (languageCode == 3){
//                         _searchOppLbl.text = @"La búsqueda de un oponente...";
//                    }else if (languageCode == 4){
//                         _searchOppLbl.text = @"Procurando um adversário...";
//                    }
//               }else
//               {
                    if (languageCode == 0) {
                         [cancelbuttonOutlet setTitle:@"Cancel" forState:UIControlStateNormal];
                         searchingOpponentLbl.text = @"Waiting for opponent...";
                    }else if(languageCode == 1){
                         [cancelbuttonOutlet setTitle:@"إلغاء" forState:UIControlStateNormal];
                         searchingOpponentLbl.text = @"االبحث عن الخصم...";
                    }else if (languageCode == 2 ){
                          [cancelbuttonOutlet setTitle:@"Cancelar" forState:UIControlStateNormal];
                         searchingOpponentLbl.text = @"Recherche d\'un adversaire...";
                    }else if (languageCode == 3){
                           [cancelbuttonOutlet setTitle:@"Annuler" forState:UIControlStateNormal];
                         searchingOpponentLbl.text = @"La búsqueda de un oponente...";
                    }else if (languageCode == 4){
                       [cancelbuttonOutlet setTitle:@"Cancelar" forState:UIControlStateNormal];
                         searchingOpponentLbl.text = @"Procurando um adversário...";
                    }
                    
                    
               //}
               //Oponent is still searching
               
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"2",@"type",_challenge.type_ID,@"type_id",language,@"language",@"false",@"is_cancel",requestType, @"request_type", nil];
               [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionary];
               
          }
          else if(flag == 1){
               //Oponent Found
               _searchingLoaderView.hidden = true;
               searchingOpponentLbl.textColor = [UIColor colorWithRed:(255/255.f) green:(228/255.f) blue:(1/255.f) alpha:1];
               searchingOpponentLbl.text = @"VS";
               //               _searchOppLbl.text = @"";
               [timer invalidate];
               timer = nil;
               
               //isGameStarted = true;
               
               NSString *oppName = [json objectForKey:@"displayName"];
               searchingTxt.text = oppName;
               NSString *image = [json objectForKey:@"profileImage"];
               
               opponentProfileImageView.imageURL = [NSURL URLWithString:image];
               NSURL *url = [NSURL URLWithString:image];
               [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
               [opponentProfileImageView roundImageCorner];
              _challenge = [[Challenge alloc] initWithDictionary:json];
               _challenge.type = @"2";
              // _challenge.type_ID = tempToplic.topic_id;
               
               
               [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(ticki:) userInfo:nil repeats:NO];
               
          }
          
          else if(flag == 0){
               //////
              
               [searchingView removeFromSuperview];
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"You don't have sufficient Gems in your account.";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"ليس لديك رصيد كافٍ من الجواهر";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"Vous n'avez pas assez de Gems";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"YNo tienes suficientes gemas";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Não tem Gemas suficientes";
                    title = @"erro";
                    cancel = CANCEL_4;
               }
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
               
          }
          
     }

     else if([dict.name isEqualToString:@"reMatch"])
     {
          NSArray* args = dict.args;
          NSDictionary *json = args[0];
          
          NSDictionary *userDictInner = [json objectForKey:[SharedManager getInstance].userID];
          
          NSString *chId =[userDictInner objectForKey:@"challenge_id"];
          
          [[NSUserDefaults standardUserDefaults] setObject:chId forKey:@"ChallengeId"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 0){
               //opponent gone away
               
             //  NSString *message;
              // NSString *title;
               
//               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
//               [sharedManager sendEvent:@"register" andParameters:registerDictionary];
//               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
//               languageCode = [language intValue];
               
//               NSArray* args = dict.args;
//               NSDictionary* arg = args[0];
//               
//               NSString *isVerified = [arg objectForKey:@"msg"];
//               if([isVerified isEqualToString:@"verified"] ){
                    NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
                    languageCode = [language intValue];
               
//                    if(appDelegate.friendToBeChalleneged) {
//                         NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",appDelegate.friendToBeChalleneged.friendID,@"friend_id",@"2",@"type",_challenge.type_ID,@"type_id",language,@"language",requestType,@"challenge_type", nil];
//                         [sharedManager sendEvent:@"sendChallenge" andParameters:registerDictionary];
//                         
//                    }
//                    else {
                         NSDictionary *registerDictionaryS = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"2",@"type",_challenge.type_ID,@"type_id",language,@"language",@"false",@"is_cancel",requestType, @"request_type", nil];
                         [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionaryS];
                   // }
            //   }//
               
               [self displayNameAndImage];
               if(IS_IPHONE_5) {
                    searchingView.frame = CGRectMake(0, 0, 320, 568);
               }
               else if(IS_IPHONE_4) {
                    searchingView.frame = CGRectMake(0, 0, 320, 480);
               }
               [self.view addSubview:searchingView];
               _loaderIndex = 1;
               
               for(int i = 1; i<5; i++) {
                    UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
                    if(i == _loaderIndex) {
                         dot.image = [UIImage imageNamed:@"dotglow.png"];
                    }
                    else {
                         dot.image = [UIImage imageNamed:@"dotblack.png"];
                    }
               }
               timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
//               if (languageCode == 0 ) {
//                    title = Friend_Not_Available;
//                    message = @"Unfortunately, your friend can't be reached at the moment. Please try later.";
//               }else if (languageCode == 1){
//                    title = Friend_Not_Availabl_1;
//                    message = @"لسوء الحظ، لا يمكن أن يتم التوصل صديقك في الوقت الراهن. يرجى المحاولة لاحقا.";
//               }else if (languageCode == 2){
//                    title = Friend_Not_Availabl_2;
//                    message = @"Malheureusement, votre ami ne peut pas être atteint pour le moment. Se il vous plaît réessayer plus tard.";
//               }else if (languageCode == 3){
//                    title = Friend_Not_Availabl_3;
//                    message = @"Por desgracia, su amigo no puede ser alcanzado por el momento. Por favor, intente más tarde.";
//               }else if (languageCode == 4){
//                    title = Friend_Not_Availabl_4;
//                    message = @"Infelizmente, o seu amigo não pode ser alcançado no momento. Por favor, tente mais tarde.";
//               }
//               
//               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
//               //[[NavigationHandler getInstance] NavigateToRoot];
     }
          else{
               //UI for Socket connection and User searching
               [self displayNameAndImage];
               if(IS_IPHONE_5) {
                    searchingView.frame = CGRectMake(0, 0, 320, 568);
               }
               else if(IS_IPHONE_4) {
                    searchingView.frame = CGRectMake(0, 0, 320, 480);
               }
               [self.view addSubview:searchingView];
               _loaderIndex = 1;
               
               for(int i = 1; i<5; i++) {
                    UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
                    if(i == _loaderIndex) {
                         dot.image = [UIImage imageNamed:@"dotglow.png"];
                    }
                    else {
                         dot.image = [UIImage imageNamed:@"dotblack.png"];
                    }
               }
               timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
          }
     }
     else if([dict.name isEqualToString:@"acceptChallenge"])
     {
          isOpponentFound = true;
          [timer invalidate];
          timer = nil;
          NSArray* args = dict.args;
          NSDictionary *json = args[0];
          
          NSDictionary *userDictInner = [json objectForKey:[SharedManager getInstance].userID];
          
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 1){
               [searchingView removeFromSuperview];
               Challenge *_challenge1 = [[Challenge alloc] initWithDictionary:userDictInner];
               _challenge1.type = rematchType;
               _challenge1.type_ID = rematchTypeId;
               _challenge1.challengeID = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ChallengeId"];
               
               ChallengeVC *_challengeT = [[ChallengeVC alloc] initWithChallenge:_challenge1];
               [self.navigationController pushViewController:_challengeT animated:YES];
               
          }
          else if(flag == 5) {
               
               NSString *emailMsg;
               NSString *title;
               
               if (languageCode == 0 ) {
                    message = @"Sorry, your friend is not interested in the challenge request at the moment. Retry later.";
                    title = @"Challenge Not Accepted";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    message = @"عذرا، صديقك ليست مهتمة في الطلب تحديا في الوقت الراهن. إعادة المحاولة في وقت لاحق!";
                    title = @"لا تحدى مقبول";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    message = @"Désolé, votre ami ne est pas intéressé par la demande au moment de défi. Réessayez plus tard!";
                    title = @"Ne contestera pas acceptés";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    message = @"Lo sentimos, tu amigo no está interesado en la solicitud de desafío en este momento. Vuelva a intentarlo más tarde!";
                    title = @"Desafía No Aceptada";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    message = @"Desculpe, seu amigo não está interessado no pedido desafio no momento. Tente novamente mais tarde!";
                    title = @"Desafie Não Aceite";
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          }
          else {
               
               NSString *title;
               NSString *message;
               
               if (languageCode == 0 ) {
                    title = Friend_Not_Available;
                    message = @"Unfortunately, your friend can't be reached at the moment. Please try later.";
               }else if (languageCode == 1){
                    title = Friend_Not_Availabl_1;
                    message = @"لسوء الحظ، لا يمكن أن يتم التوصل صديقك في الوقت الراهن. يرجى المحاولة لاحقا.";
               }else if (languageCode == 2){
                    title = Friend_Not_Availabl_2;
                    message = @"Malheureusement, votre ami ne peut pas être atteint pour le moment. Se il vous plaît réessayer plus tard.";
               }else if (languageCode == 3){
                    title = Friend_Not_Availabl_3;
                    message = @"Por desgracia, su amigo no puede ser alcanzado por el momento. Por favor, intente más tarde.";
               }else if (languageCode == 4){
                    title = Friend_Not_Availabl_4;
                    message = @"Infelizmente, o seu amigo não pode ser alcançado no momento. Por favor, tente mais tarde.";
               }
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          }
     }
     else {
          latestEvent = nil;
          NSArray* args = dict.args;
          NSDictionary *dictTemp = (NSDictionary*)args[0];
          //Just For testing
          NSDictionary *userDict = [dictTemp objectForKey:[SharedManager getInstance].userID];
          
          
          int flag = [[userDict objectForKey:@"flag"] intValue];
          
          responseStatus = YES;
          
          if(flag == SOCKET_GAME_END)
          {
               [self fetchResults];
          }
          
          else if(flag == SOCKET_FAIL)
          {
               [self fetchResults];
          }
          
          else if(flag == SOCKET_SESSION_OUT)
          {
               // Logout user here from application
               [self fetchResults];
          }
          
          else if(flag == 1)
          {
               [a_Timer invalidate];
               [self UpdatePointsAndSwitch:userDict];
               [searchingView removeFromSuperview];
               
               requestType = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"requestType"];
               if ([requestType isEqualToString:@"gems"] && currentSelfPoints <10) {
                    NSString *emailMsg;
                    NSString *title;
                    
                    if (languageCode == 0 ) {
                         emailMsg = @"You don't have sufficient Gems in your account.";
                         title = @"Error";
                         cancel = CANCEL;
                    } else if(languageCode == 1) {
                         emailMsg = @"ليس لديك رصيد كافٍ من الجواهر";
                         title = @"خطأ";
                         cancel = CANCEL_1;
                    }else if (languageCode == 2){
                         emailMsg = @"Vous n'avez pas assez de Gems";
                         title = @"Erreur";
                         cancel = CANCEL_2;
                    }else if (languageCode == 3){
                         emailMsg = @"YNo tienes suficientes gemas";
                         title = @"Error";
                         cancel = CANCEL_3;
                    }else if (languageCode == 4){
                         emailMsg = @"Não tem Gemas suficientes";
                         title = @"erro";
                         cancel = CANCEL_4;
                    }
                    
                    [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                    
                    [self fetchResults];
                    //}
                    
               }else {
                    NSString *idUser = [SharedManager getInstance].userID;
                    NSDictionary *userRecord = (NSDictionary*)[userDict objectForKey:idUser];
                    int o_id = [_challenge.opponent_ID intValue];
                    NSString *opponentID = [NSString stringWithFormat:@"%d",o_id];
                    
                    NSDictionary *opponentRecord = (NSDictionary*)[userDict objectForKey:opponentID];
                    
                    answerReaction.hidden = false;
                    answerTxt.hidden = false;
                    
                    int earned = [[userRecord objectForKey:@"earned_points"] intValue];
                    int oppoentEarned = [[opponentRecord objectForKey:@"earned_points"] intValue];
                    
                    UIImageView *starImgLeftView = (UIImageView*)[upperViewLeft viewWithTag:currentIndex+1];
                    UIImageView *starImgRightView = (UIImageView*)[upperViewRight viewWithTag:currentIndex+1];
                    
                    if(earned >= 3) {
                         
                         if([requestType isEqualToString:@"gems"]) {
                              starImgLeftView.image = [UIImage imageNamed:@"gemyellow.png"];
                              starImgRightView.image = [UIImage imageNamed:@"gemwhite.png"];
                         }
                         else {
                              starImgLeftView.image = [UIImage imageNamed:@"staryellow.png"];
                              starImgRightView.image = [UIImage imageNamed:@"starwhite.png"];
                         }
                    }
                    else {
                         answerReaction.hidden = true;
                         NSString *is_correct = (NSString*)[userRecord objectForKey:@"is_correct"];
                         if( [is_correct caseInsensitiveCompare:@"1"] == NSOrderedSame ) {
                              // user did not answered
                              if(oppoentEarned > earned) {
                                   //Opponent Answered Before You
                                   if([requestType isEqualToString:@"gems"]) {
                                        starImgLeftView.image = [UIImage imageNamed:@"gemwhite.png"];
                                        starImgRightView.image = [UIImage imageNamed:@"gemyellow.png"];
                                   }
                                   else {
                                        starImgLeftView.image = [UIImage imageNamed:@"starwhite.png"];
                                        starImgRightView.image = [UIImage imageNamed:@"staryellow.png"];
                                   }
                                   
                              }
                         }
                         else {
                              answerReaction.image = [UIImage imageNamed:@""];
                              int isCorrect = [is_correct intValue];
                              if(isCorrect == 0) {
                                   if([requestType isEqualToString:@"gems"]) {
                                        if(oppoentEarned > earned) {
                                             starImgLeftView.image = [UIImage imageNamed:@"gemwhite.png"];
                                             starImgRightView.image = [UIImage imageNamed:@"gemyellow.png"];
                                        }
                                        else {
                                             starImgLeftView.image = [UIImage imageNamed:@"gemwhite.png"];
                                             starImgRightView.image = [UIImage imageNamed:@"gemwhite.png"];
                                        }
                                        
                                   }
                                   else {
                                        if(oppoentEarned > earned) {
                                             starImgLeftView.image = [UIImage imageNamed:@"starwhite.png"];
                                             starImgRightView.image = [UIImage imageNamed:@"staryellow.png"];
                                        }
                                        else {
                                             starImgLeftView.image = [UIImage imageNamed:@"starwhite.png"];
                                             starImgRightView.image = [UIImage imageNamed:@"starwhite.png"];
                                        }
                                   }
                              }
                              if(oppoentEarned > earned) {
                                   if([requestType isEqualToString:@"gems"]) {
                                        starImgLeftView.image = [UIImage imageNamed:@"gemwhite.png"];
                                        starImgRightView.image = [UIImage imageNamed:@"gemyellow.png"];
                                   }
                                   else {
                                        starImgLeftView.image = [UIImage imageNamed:@"starwhite.png"];
                                        starImgRightView.image = [UIImage imageNamed:@"staryellow.png"];
                                   }
                                   
                              }
                              else {
                                   if([requestType isEqualToString:@"gems"]) {
                                        starImgLeftView.image = [UIImage imageNamed:@"gemwhite.png"];
                                        starImgRightView.image = [UIImage imageNamed:@"gemwhite.png"];
                                   }
                                   else{
                                        starImgLeftView.image = [UIImage imageNamed:@"starwhite.png"];
                                        starImgRightView.image = [UIImage imageNamed:@"starwhite.png"];
                                   }
                                   
                              }
                         }
                    }
                    isFirstLoad = NO;
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(tick:) userInfo:nil repeats:NO];
               }
          }
          else {
               NSLog(@"::::::::::?????Nothing Happened?????:::::::::::::");
          }
     }
}

-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     [loadView hide];
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.isGameInProcess = false;
     if(!isGameEnd && currentIndex<6) {
          
          NSString *emailMsg;
          NSString *title;
          
          if (languageCode == 0 ) {
               emailMsg = @"Something went wrong.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"لقد حصل خطأ ما";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Erreur: Quelque chose s\'est mal passé!";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Algo salió mal!";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Alguma coisa deu errado!";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          isGameEnd = true;
          [sharedManager closeWebSocket];
          [self fetchResults];
     }
}
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     [loadView hide];
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.isGameInProcess = false;
     NSLog(@"Challenge Got Error%@",error);
     if(!isGameEnd && currentIndex < 6) {
          
          NSString *emailMsg;
          NSString *title;
          
          if (languageCode == 0 ) {
               emailMsg = @"Something went wrong.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"لقد حصل خطأ ما";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Erreur: Quelque chose s\'est mal passé!";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Algo salió mal!";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Alguma coisa deu errado!";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          
          isGameEnd = true;
          [sharedManager closeWebSocket];
          [self fetchResults];
     }
}

#pragma Reconnect User

-(void)responseTimeOut {
     if(!isGameEnd) {
          [loadView hide];
          
          [responeTimeOutTimer invalidate];
          responeTimeOutTimer = nil;
          
          NSString *message1;
          NSString *title;
          
          if (languageCode == 0 ) {
               message1 = @"Sorry, either you or your opponent lost internet connection.";
               title = @"Something went wrong";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message1 = @"عذرا، إما أنت أو خصمك فقدتم الاتصال بشبكة الانترنت";
               title = @"لقد حصل خطأ ما";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message1 = @"Désolé, vous ou votre adversaire avez perdu votre connexion Internet.";
               title = @"Erreur: Quelque chose s\'est mal passé!";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message1 = @"Lo sentimos, usted o su oponente habeis perdido conexión a Internet.";
               title = @"Algo salió mal!";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message1 = @"Desculpe, você ou o seu adversário perdestes a conexão internet.";
               title = @"Alguma coisa deu errado!";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:message1 andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          isGameEnd = true;
          
          [sharedManager closeWebSocket];
          
          [self fetchResults];
     }
}
#pragma mark Language


-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     PlayAgainLabel.layer.shadowColor = [UIColor colorWithRed:183 green:216 blue:255 alpha:1.0].CGColor;
     PlayAgainLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
     PlayAgainLabel.layer.shadowRadius = 3.0;
     PlayAgainLabel.layer.shadowOpacity = 0.9;
     PlayAgainLabel.layer.masksToBounds = NO;
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          _roundLbl.text = Round;
          roundTitleLbl.text = Round;
          
          lblGemsPoints.text = PLAY_FOR_GEMS;
          lblPlayforPoints.text = PLAY_FOR_POINTS;
          willhelpinRanking.text = WILL_HELP_IN_RANKING;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY;
          gameModForGems.text = For_Gems;
          gameModForPoints.text = For_Points;
          loadingTitle = Loading;
          resultTitle.text = RESULTS_LBL;
     }
     else if(languageCode == 1 ) {
          
          loadingTitle = Loading_1;
          _roundLbl.text = Round_1;
          PlayAgainLabel.text = @"إلعب مرة أخرى";
          lblPlayforPoints.text = PLAY_FOR_POINTS_1;
          lblplayforGems.text = PLAY_FOR_GEMS_1;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_1;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_1;
          gameModForGems.text = For_Gems1;
          gameModForPoints.text = For_Points1;
          roundTitleLbl.text = Round_1;
          resultTitle.text = RESULTS_LBL_1;
     }
     else if(languageCode == 2) {
          loadingTitle = Loading_2;
          PlayAgainLabel.text = @"Rejouer";
          _roundLbl.text = Round_2;
          gameModForGems.text = For_Gems2;
          gameModForPoints.text = For_Points2;
          lblPlayforPoints.text = PLAY_FOR_POINTS_2;
          lblplayforGems.text = PLAY_FOR_GEMS_2;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_2;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_2;
          
          roundTitleLbl.text = Round_2;
          resultTitle.text = RESULTS_LBL_2;
     }
     else if(languageCode == 3) {
          gameModForGems.text = For_Gems3;
          gameModForPoints.text = For_Points3;
          loadingTitle = Loading_3;
          _roundLbl.text = Round_3;
          PlayAgainLabel.text= @"Jugar de nuevo";
          roundTitleLbl.text = Round_3;
          lblPlayforPoints.text = PLAY_FOR_POINTS_3;
          lblplayforGems.text = PLAY_FOR_GEMS_3;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_3;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_3;
          
          resultTitle.text = RESULTS_LBL_3;
     }
     else if(languageCode == 4) {
          loadingTitle = Loading_4;
          PlayAgainLabel.text = @"Jogar Novamente";
          _roundLbl.text = Round_4;
          lblPlayforPoints.text = PLAY_FOR_POINTS_4;
          lblplayforGems.text = PLAY_FOR_GEMS_4;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_4;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_4;
          gameModForGems.text = For_Gems4;
          gameModForPoints.text = For_Points4;
          roundTitleLbl.text = Round_4;
          resultTitle.text = RESULTS_LBL_4;
     }
     
     if (languageCode == 1) {
          
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentRight;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentRight;
          
          if (IS_IPAD) {
               
               starImage.hidden = YES;
               gemImage.hidden = YES;
               starimg2.hidden = NO;
               gemimg2.hidden = NO;
               
          }else{
               starImage.frame = CGRectMake(265, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(270, gemImage.frame.origin.y+2 , 25, 25);
          }
          
     }else{
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentLeft;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentLeft;
          
          if (IS_IPAD) {
               starImage.autoresizingMask = UIViewAutoresizingNone;
               starImage.frame = CGRectMake(32, 246, 60, 53);
               gemImage.frame = CGRectMake(37, 309, 51, 53);
          }else{
               starImage.frame = CGRectMake(8, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(13, gemImage.frame.origin.y+2 , 25, 25);
          }
     }
}

#pragma New UI changes

-(void)fadeInAnimation:(UIView *)aView {
     CATransition *transition = [CATransition animation];
     transition.delegate = self;
     transition.type =kCATransitionFade;
     transition.duration = 0.5f;
     transition.delegate = self;
     [transition setValue:@"questionView" forKey:@"popUpQuestion"];
     [aView.layer addAnimation:transition forKey:@"popUpQuestion"];
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
     if (flag)
     {
          NSString *animationName = [theAnimation valueForKey:@"popUpQuestion"];
          if ([animationName isEqualToString:@"questionView"])
          {
               
               option_1_Btn.hidden = false;
               option_1_Lbl.hidden = false;
               option_1_Btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
               option_1_Lbl.transform = CGAffineTransformMakeScale(0.1, 0.1);
               
               [UIView animateWithDuration:0.5
                                     delay:0.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                     //yourAnimation
                                     option_1_Btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                     option_1_Lbl.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                } completion:^(BOOL finished){
                                     
                                     option_2_Btn.hidden = false;
                                     option_2_Lbl.hidden = false;
                                     option_2_Btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                     option_2_Lbl.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                     
                                     [UIView animateWithDuration:0.5
                                                           delay:0.0
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                           //yourAnimation
                                                           option_2_Btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                           option_2_Lbl.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                      } completion:^(BOOL finished){
                                                           
                                                           option_3_Btn.hidden = false;
                                                           option_3_Lbl.hidden = false;
                                                           option_3_Btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                           option_3_Lbl.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                           
                                                           [UIView animateWithDuration:0.5
                                                                                 delay:0.0
                                                                               options:UIViewAnimationOptionTransitionCrossDissolve
                                                                            animations:^{
                                                                                 //yourAnimation
                                                                                 option_3_Btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                                                 option_3_Lbl.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                                            } completion:^(BOOL finished){
                                                                                 option_4_Btn.hidden = false;
                                                                                 option_4_Lbl.hidden = false;
                                                                                 option_4_Btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                                                 option_4_Lbl.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                                                                 
                                                                                 [UIView animateWithDuration:0.5
                                                                                                       delay:0.0
                                                                                                     options:UIViewAnimationOptionTransitionCrossDissolve
                                                                                                  animations:^{
                                                                                                       //yourAnimation
                                                                                                       option_4_Btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                                                                       option_4_Lbl.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                                                                  } completion:^(BOOL finished){
                                                                                                       
                                                                                                       self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.carrierView];
                                                                                                       NSTimeInterval duration = 5.0f;
                                                                                                       CABasicAnimation* rotationAnimation;
                                                                                                       rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                                                                                       rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 0.5 * 4000 ];
                                                                                                       rotationAnimation.duration = 4000;
                                                                                                       rotationAnimation.cumulative = YES;
                                                                                                       rotationAnimation.repeatCount = 0;
                                                                                                       
                                                                                                       [timerImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                                                                                                       
                                                                                                       [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionRepeat| UIViewAnimationOptionCurveLinear animations:^{
                                                                                                       } completion:nil];
                                                                                                       
                                                                                                       [self enableOptionSelection];
                                                                                                       [self resetLabelColors];
                                                                                                       
                                                                                                       isQuestionAnswered = false;
                                                                                                       
                                                                                                       if([_challenge.isBot intValue] == 1){
                                                                                                            int randomNumber = 5 + rand() % 4;
                                                                                                            timeSeconds = [NSString stringWithFormat:@"%d",randomNumber];
                                                                                                       }else{
                                                                                                            timeSeconds = [NSString stringWithFormat:@"%d",10];
                                                                                                       }
                                                                                                       
                                                                                                       if([_challenge.isSuperBot intValue] == 1 && !isQuestionAnswered){
                                                                                                            
                                                                                                            ChancesSuperbot = 1 + rand() % (100-1);
                                                                                                            if (ChancesSuperbot <= 70) {
                                                                                                                 timeSeconds = @"3";
                                                                                                                 
                                                                                                            }else if (ChancesSuperbot >70 && ChancesSuperbot <= 90){
                                                                                                                 timeSeconds = @"2";
                                                                                                                 
                                                                                                            }else if (ChancesSuperbot >90 && ChancesSuperbot <= 100){
                                                                                                                 timeSeconds = @"4";
                                                                                                            }
                                                                                                       }
                                                                                                       
                                                                                                       if(currentAddOns > 0){
                                                                                                            addOnBtn.enabled = true;
                                                                                                            if(7-currentIndex <= currentAddOns){
                                                                                                                 isAddOnEnabled = true;
                                                                                                                 addOnBtn.hidden = true;
                                                                                                                 bg.image = [UIImage imageNamed:@"5050bg.png"];
                                                                                                                 [self performSelector:@selector(appAddOn:)
                                                                                                                            withObject: [NSNumber numberWithFloat: 1.0f]
                                                                                                                            afterDelay:0.0];
                                                                                                            }
                                                                                                            else if (isAddOnEnabled) {
                                                                                                                 isAddOnEnabled = true;
                                                                                                                 addOnBtn.hidden = true;
                                                                                                                 bg.image = [UIImage imageNamed:@"5050bg.png"];
                                                                                                                 [self performSelector:@selector(appAddOn:)
                                                                                                                            withObject: [NSNumber numberWithFloat: 1.0f]
                                                                                                                            afterDelay:0.0];
                                                                                                            }
                                                                                                            else {
                                                                                                                 isAddOnEnabled = false;
                                                                                                                 addOnBtn.hidden = false;
                                                                                                                 
                                                                                                                 [a_Timer invalidate];
                                                                                                                 
                                                                                                                 a_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                                                                                                            }
                                                                                                       }
                                                                                                       else {
                                                                                                            addOnBtn.hidden = true;
                                                                                                            addOnBtn.enabled = false;
                                                                                                            bg.image = [UIImage imageNamed:@"newbg.png"];
                                                                                                            
                                                                                                            [a_Timer invalidate];
                                                                                                            
                                                                                                            a_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                                                                                                       }
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                  }];
                                                                            }];
                                                           
                                                      }];
                                }];
               
               return;
               
          }
     }
}

- (IBAction)rewardsBtnPressed:(id)sender {
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     appDelegate.isStore = false;
     if (IS_IPAD) {
          RewardsListVC *update = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC_iPad" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }else{
          
          RewardsListVC *update = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }
}
@end
