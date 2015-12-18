//
//  CustomLoading.m
//  Wits
//
//  Created by Obaid ur Rehman on 01/09/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import "CustomLoading.h"
#import "SharedManager.h"
#import "MKNetworkEngine.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "UIImageView+RoundImage.h"
#import "Utils.h"
@implementation CustomLoading
static BOOL showing;


CustomLoading *loaderObj;

- (void)showAlertMessage:(ChallengeSearchObject *)searchObject
{
     senderObj = searchObject;
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     if(languageCode == 0)
          [cancelbtn setTitle:@"Cancel" forState:UIControlStateNormal];
     else if(languageCode == 1)
          [cancelbtn setTitle:@"إلغاء" forState:UIControlStateNormal];
     else if(languageCode == 2)
          [cancelbtn setTitle:@"Cancelar" forState:UIControlStateNormal];
     else if(languageCode == 3)
          [cancelbtn setTitle:@"Annuler" forState:UIControlStateNormal];
     else if (languageCode == 4)
          [cancelbtn setTitle:@"Cancelar" forState:UIControlStateNormal];
     [self showPrivate];
}

-(void)showPrivate
{
     
     _loaderIndex = 1;
     timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
     
     for(int i = 1; i<5; i++) {
          UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
          if(i == _loaderIndex) {
               dot.image = [UIImage imageNamed:@"dotglow.png"];
          }
          else {
               dot.image = [UIImage imageNamed:@"dotblack.png"];
          }
     }
     senderNameLbl.text = senderObj.senderName;
     opponentNameLbl.text = senderObj.recieverName;
     
     if(senderObj.senderProfileImage) {
          senderProfileImageView.image = senderObj.senderProfileImage;
     }
     else {
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               [senderProfileImageView setImage:[completedOperation responseImage]];
               [senderProfileImageView roundImageCorner];
               
          } onError:^(NSError* error) {
               //////Changed by Fiza //////
               senderProfileImageView.image= [UIImage imageNamed:@"personal.png"];
               [senderProfileImageView roundImageCorner];
          }];
          
          [engine enqueueOperation:op];
     }
     opponentProfileImageView.image= [UIImage imageNamed:@"personal.png"];
     opponentProfileImageView.imageURL = [NSURL URLWithString:senderObj.recieverProfileImgLink];
     NSURL *url2 = [NSURL URLWithString:senderObj.recieverProfileImgLink];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url2];
     [opponentProfileImageView roundImageCorner];
     
     
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
     
}

-(void) performAnimation
{
     
}
- (void) startTimer {
     [NSTimer scheduledTimerWithTimeInterval:1
                                      target:self
                                    selector:@selector(tick:)
                                    userInfo:nil
                                     repeats:YES];
}

- (void) tick:(NSTimer *) timer {
     [self performAnimation];
     
}
+(void) DismissAlertMessage
{
     
     CustomLoading *cusLoading = [[CustomLoading alloc]init];
     if(showing)
     {
          
          [loaderObj dissmiss ];
     }
}
- (void)dissmiss
{
     showing = false;
}

-(void)frames
{
     
}
- (IBAction)cancelPressed:(id)sender {
     
     [timer invalidate];
   
     timer = nil;
     
     
     AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
     del.isChallengeCancelled = true;
     del.friendToBeChalleneged = nil;
     del.requestType = nil;
     [sharedManager closeWebSocket];
     [self removeFromSuperview];
}
@end
