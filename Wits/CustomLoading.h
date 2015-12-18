//
//  CustomLoading.h
//  Wits
//
//  Created by Obaid ur Rehman on 01/09/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeSearchObject.h"
#import "AsyncImageView.h"
#import "AsyncImageView.h"
#import "SocketManager.h"
@interface CustomLoading : UIView {
     int languageCode;
     NSString *language;
     NSTimer *timer;
     int timeSinceTimer;
     SocketManager *sharedManager;
     BOOL isOpponentFound;
     ChallengeSearchObject *senderObj;
     __weak IBOutlet UIImageView *searchBg;
     __weak IBOutlet AsyncImageView *senderProfileImageView;
     
     __weak IBOutlet UIButton *cancelbtn;
     __weak IBOutlet UILabel *senderNameLbl;
    __weak IBOutlet UILabel *opponentNameLbl;
     
     __weak IBOutlet AsyncImageView *opponentProfileImageView;
}

- (void)showAlertMessage:(ChallengeSearchObject *)searchObject;
-(void)DismissAlertMessage;

@property int loaderIndex;
@property (weak, nonatomic) IBOutlet UIImageView *senderProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *opponentProfileImageView;
- (IBAction)cancelPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *searchingLoaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstdot;
@property (weak, nonatomic) IBOutlet UIImageView *secondDot;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDot;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDot;
@end
