//
//  ChallengeFriendsVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 30/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import  "Topic.h"
#import "SocketManager.h"
#import "UserProfile.h"
#import "AsyncImageView.h"

@interface ChallengeFriendsVC : UIViewController<SocketManagerDelegate,UITextFieldDelegate>{
     
     IBOutlet UIImageView *searchimg;
     NSString *loadingTitle;
     __weak IBOutlet UITableView *challengeTbl;
     __weak IBOutlet UITextField *searchField;
     
     IBOutlet UIImageView *statusView;
     int languageCode;
     NSMutableArray *challengeArray;
     NSString *topic_ID;
     int currentSelectedIndex;
     NSString *statusStr;
     LoadingView *loadView;
     NSString *subTopic;
     
     IBOutlet UIView *searchingView;
     
     __weak IBOutlet UIImageView *senderProfileImageView;
     
     __weak IBOutlet UILabel *senderNameLbl;
     
     __weak IBOutlet AsyncImageView *opponentProfileImageView;
     IBOutlet UIImageView *spinner;
     
     IBOutlet UILabel *noFriendsLbl;
     
     IBOutlet UILabel *challengesLbl;
     
     IBOutlet UIButton *GoBtn;
     
     IBOutlet UILabel *searchingTxt;
     
     SocketManager *sharedManager;
     BOOL isSocketConnected;
     UserProfile *_selectedUser;
     int eventId;
     NSString *challengeID;
     IBOutlet UIButton *mainback;
     
     NSTimer *timer;
     int timeSinceTimer;
     BOOL isOpponentFound;
     
#pragma New UI changes
     int currentIndex;
     
}


-(id)initWithTopic_ID:(NSString *)_receivedID andSubTopic:(NSString *)_subTopic;
- (IBAction)mainBack:(id)sender;

-(IBAction)ShowRightMenu:(id)sender;
-(IBAction)sendSearchCall:(id)sender;
- (IBAction)quitGame:(id)sender;
- (IBAction)RefreshPressed:(id)sender;



#pragma Searching UI Changes

@property int loaderIndex;
@property (weak, nonatomic) IBOutlet UIView *searchingLoaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstdot;
@property (weak, nonatomic) IBOutlet UIImageView *secondDot;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDot;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDot;
@property (weak, nonatomic) IBOutlet UIButton *backBtn2;

@property (weak, nonatomic) IBOutlet UILabel *searchOppLbl;
@property (weak, nonatomic) IBOutlet UILabel *opponentName;

@end
