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
@interface CustomLoading : UIView {
    
     NSTimer *timer;
     int timeSinceTimer;
     BOOL isOpponentFound;
     ChallengeSearchObject *senderObj;
     __weak IBOutlet UIImageView *searchBg;
     __weak IBOutlet AsyncImageView *senderProfileImageView;
     
     __weak IBOutlet UILabel *senderNameLbl;
    __weak IBOutlet UILabel *opponentNameLbl;
     
     __weak IBOutlet AsyncImageView *opponentProfileImageView;
}

- (void)showAlertMessage:(ChallengeSearchObject *)searchObject;
-(void)DismissAlertMessage;

@property int loaderIndex;
@property (weak, nonatomic) IBOutlet UIImageView *senderProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *opponentProfileImageView;

@property (weak, nonatomic) IBOutlet UIView *searchingLoaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstdot;
@property (weak, nonatomic) IBOutlet UIImageView *secondDot;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDot;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDot;
@end
