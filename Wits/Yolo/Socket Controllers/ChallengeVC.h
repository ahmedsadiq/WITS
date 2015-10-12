//
//  ChallengeVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"
#import "LoadingView.h"
#import "SocketManager.h"
#import <AVFoundation/AVFoundation.h>
#import "EventModel.h"
#import "Option.h"
@interface ChallengeVC : UIViewController<SocketManagerDelegate>{
     
     __weak IBOutlet UIImageView *selfProfileImg;
     __weak IBOutlet UIImageView *opponentProfileImg;
     __weak IBOutlet UILabel *selfPointsLbl;
     __weak IBOutlet UILabel *opponentPointsLbl;
     __weak IBOutlet UILabel *questionTextLbl;
     __weak IBOutlet UILabel *timerLbl;
     __weak IBOutlet UILabel *option_1_Lbl;
     __weak IBOutlet UILabel *option_2_Lbl;
     __weak IBOutlet UILabel *option_3_Lbl;
     __weak IBOutlet UILabel *option_4_Lbl;
     IBOutlet UIButton *option_1_Btn;
     IBOutlet UIButton *option_2_Btn;
     IBOutlet UIButton *option_3_Btn;
     IBOutlet UIButton *option_4_Btn;
     IBOutlet UIView *initialView;
     
     BOOL isFirstLoad;
     int ChancesSuperbot;
     
     //Quit Game
     IBOutlet UIView *quitGameDialog;
     
     IBOutlet UILabel *QuitTitle;
     IBOutlet UITextView *quitMsg;
     IBOutlet UIButton *quitno;
     IBOutlet UIButton *quityes;
     
     NSString *loadingTitle;
     
     NSString *cancel;
     NSString *timeInSeconds;
     NSString *timeSeconds;
     int tagbtn;
     
     int languageCode;
     NSString *message;
     NSString *FriendNotAvail;
     AVAudioPlayer *audioPlayer;
     Challenge *_challenge;
     int currentIndex;
     int currentResponseIndex;
     BOOL isWrongAns;
     
     BOOL isQuestionAnswered;
     BOOL isGameEnd;
     BOOL isOptionSelected;
     NSTimer *a_Timer;
     BOOL isTimeUp;
     BOOL blinkStatus;
     UILabel *labelToBlink;
     UIButton *buttonToBlink;
     NSTimer *blinkTimer;
     IBOutlet UILabel *resultTitle;
     
     NSTimer *responeTimeOutTimer;
     BOOL responseStatus;
     BOOL isPlayAgain;
     BOOL botAnswerSeconds;
     
#pragma mark -
#pragma mark Result Card
     
     IBOutlet UIView *ResultsView;
     
     IBOutlet UIView *resultCard_View;
     IBOutlet UILabel *resultLbl;
     
     IBOutlet UIImageView *self_resultImg;
     IBOutlet UIImageView *opponent_resultImg;
     
     NSArray *senderPointsArray;
     NSArray *selfPointsArray;
     
     //    int receiverTotalPoints;
     int currentSelfPoints;
     int currentOtherPoints;
     
     LoadingView *loadView;
     
     int tempVar;
     IBOutlet UIImageView *timerImg;
     IBOutlet UIView *upperViewLeft;
     IBOutlet UIView *upperViewRight;
     
     IBOutlet UIImageView *questionImg;
     
     IBOutlet UILabel *answerTxt;
     IBOutlet UIImageView *answerReaction;
     
     UIImageView *userProgress;
     UIImageView *opponentProgress;
     
     IBOutlet UIView *resultTopBar;
     IBOutlet UILabel *playerName;
     IBOutlet UILabel *opponentName;
     
     IBOutlet UILabel *topBarPlayerName;
     IBOutlet UILabel *topBarOpponentName;
     
     IBOutlet UIView *resulltSecondLayer;
     
     IBOutlet UIView *resultBottomBar;
     IBOutlet UILabel *userTotal;
     IBOutlet UILabel *opponentTotal;
     
     IBOutlet UIButton *playbtn;
     IBOutlet UIButton *homeBtn;
     IBOutlet UILabel *roundTitleLbl;
     
     
     IBOutlet UIImageView *roundBg;
     
#pragma mark -
#pragma mark Searching Opponent
     
     IBOutlet UIView *searchingView;
     
     __weak IBOutlet UIImageView *senderProfileImageView;
     
     __weak IBOutlet UILabel *senderNameLbl;
     
     __weak IBOutlet UIImageView *opponentProfileImageView;
     
     IBOutlet UIImageView *spinnerImg;
     IBOutlet UILabel *searchingTxt;
     BOOL isRematch;
     BOOL isChallenge;
     
     IBOutlet UIView *resultPopUpView;
     IBOutlet UILabel *youWinTitle;
     IBOutlet UILabel *youLooseTitle;
     IBOutlet UIScrollView *rescultScrollView;
     
     NSTimer *timer;
     int timeSinceTimer;
     BOOL isOpponentFound;
     
     //Revamp
     BOOL isSocketConnected;
     BOOL userDisconnected;
     SocketManager *sharedManager;
     
     int finalScore;
     int finalGameScore;
     
     EventModel *latestEvent;
     EventModel *botLatestEvent;
     int reconnectAttempt;
     int currentAddOns;
     NSString *rematchType;
     NSString *rematchTypeId;
     BOOL isAddOnEnabled;
     
     
     //Gems and Stars
     
     IBOutlet UIImageView *oppGametypeimg;
     
     IBOutlet UIImageView *selfgameTypeimg;
     
     IBOutlet UIImageView *resultGametypeimg;
     
     //Play with Gems and Stars
     
     IBOutlet UIView *GemsDialogView;
     IBOutlet UIImageView *buynowlabel;
     IBOutlet UILabel *lblGemsPoints;
     IBOutlet UILabel *lblStarsPoints;
     
     IBOutlet UILabel *lblPlayforPoints;
     IBOutlet UILabel *lblplayforGems;
     IBOutlet UILabel *willhelpinRanking;
     IBOutlet UILabel *willHelpinEarnMoney;
     
     IBOutlet UIImageView *starImage;
     IBOutlet UIImageView *gemImage;
     
     IBOutlet UIImageView *gemimg2;
     IBOutlet UIImageView *starimg2;
     BOOL *isDisabled;
     
     IBOutlet UIButton *playwithGemsbtn;
     
     
     Option *_option1;
     Option *_option2;
     Option *_option3;
     Option *_option4;
     
     __weak IBOutlet UIImageView *bg;
     
     __weak IBOutlet UIButton *addOnBtn;
     
     int indexCounter;
}
- (IBAction)addOnBtnPressed:(id)sender;
- (IBAction)PlaywitStars:(id)sender;
- (IBAction)PlaywithGems:(id)sender;
- (IBAction)CloseGemsDialog:(id)sender;

- (IBAction)QuitYes:(id)sender;
- (IBAction)QuitNO:(id)sender;


- (id)initWithChallenge:(Challenge *)_Challenge andRecieved:(BOOL) isRecieved;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) SocketManager *sharedManager;
@property UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIView *optionsView;
@property (strong, nonatomic) IBOutlet UIView *questionView;
@property (strong, nonatomic) IBOutlet UIView *carrierView;

@property (strong, nonatomic) IBOutlet UIView *roundView;
@property (strong, nonatomic) IBOutlet UILabel *roundLbl;
@property (weak, nonatomic) IBOutlet UIImageView *gamebg;

- (id)initWithChallenge:(Challenge *)_Challenge;

-(IBAction)optionSelected:(id)sender;

-(IBAction)GotoHome:(id)sender;
+(ChallengeVC *)getInstance;

-(void)UpdatePointsAndSwitch:(NSDictionary *)_dict;
-(void)TimerUp;

-(IBAction)quiteUser:(id)sender;
-(BOOL)checkFinished;

- (IBAction)playAgainPressed:(id)sender;
- (IBAction)homePressed:(id)sender;
- (IBAction)quitGame:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *quitOutlet;
-(void) disableOptions :(BOOL) isDisable;
- (IBAction)showTimeLine:(id)sender;
- (IBAction)rightMenu:(id)sender;

#pragma mark UI Changes
@property (weak, nonatomic) IBOutlet UIView *timerBar;

@property (weak, nonatomic) UIImageView *userStarToBlink;
@property (weak, nonatomic) UIImageView *opponentStarToBlink;
@property (weak, nonatomic) IBOutlet UIButton *rewardsBtn;
- (IBAction)rewardsBtnPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *optionImg1;
@property (weak, nonatomic) IBOutlet UIImageView *optionImg2;
@property (weak, nonatomic) IBOutlet UIImageView *optionImg3;
@property (weak, nonatomic) IBOutlet UIImageView *optionImg4;

#pragma Searching UI Changes
@property (weak, nonatomic) IBOutlet UIView *searchingLoaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstdot;
@property (weak, nonatomic) IBOutlet UIImageView *secondDot;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDot;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDot;

@property int loaderIndex;
@end
