//
//  ThirdLayerVC.h
//  Wits
//
//  Created by Mr on 01/01/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "TopicModel.h"
#import "CategoryModel.h"
#import "Challenge.h"
#import "SocketManager.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface ThirdLayerVC : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UISearchDisplayDelegate,SocketManagerDelegate> {
     int languageCode;
     IBOutlet UITableView *topicTblView;
     IBOutlet UISearchBar *searchBar;
     NSArray *topicsArray;
     LoadingView *loadView;
     TopicModel *parentTopics;
     IBOutlet UILabel *mainTitlelbl;
     IBOutlet UIImageView *statusView;
     AppDelegate *appDelegate;
     
     //labels
     IBOutlet UILabel *forGemsLable;
     IBOutlet UILabel *forPointsLabel;
     
     IBOutlet UILabel *challengeAFriend;
     IBOutlet UILabel *PlayNowLabel;
     
     
     
     NSString *howtoPlay1;
     NSString *howtoPlay2;
     NSString *howtoPlay3;
     NSString *howtouseStoreDesc;
     NSString *howtoEarnPointDesc;
     
     NSMutableArray *subtopicsArray;
     NSArray *topicsArrayForSearch;
     NSUInteger currentSelectedIndex;
     
     BOOL isChallengeSelected;
     Challenge *_challenge;
     IBOutlet UILabel *opponent;
     
     IBOutlet UITextField *answerTxt;
     IBOutlet UIView *addQuestion;
     IBOutlet UITextField *questionTxt;
     
     IBOutlet UITableView *expandView;
     IBOutlet UIView *tutorialView;
     
     NSMutableArray      *sectionTitleArray;
     NSMutableDictionary *sectionContentDict;
     NSMutableArray      *arrayForBool;
     
     
     NSString *HowtoPlay;
     NSString *HowWitsStore;
     NSString *HowtoEarnPoints;
     
     
     NSString *ThirdLayerMaintempImgName ;
     NSMutableArray *tutorialArray1;
     NSMutableArray *tutorialArray2;
     NSMutableArray *tutorialArray3;
     
     IBOutlet UILabel *CategoriesLbl;
     
#pragma mark -
#pragma mark Searching Opponent
     
     IBOutlet UIView *searchingView;
     
     __weak IBOutlet UIImageView *senderProfileImageView;
     
     __weak IBOutlet UILabel *senderNameLbl;
     
     __weak IBOutlet UIImageView *opponentProfileImageView;
     
     IBOutlet UIImageView *spinnerImage;
     IBOutlet UILabel *searchingTxt;
     
     IBOutlet UILabel *vsLbl;
     IBOutlet UIButton *backBtn2;
     NSTimer *timer;
     int timeSinceTimer;
     BOOL isOpponentFound;
     
     SocketManager *sharedManager;
     
     IBOutlet UILabel *knowledgeLbl;
     IBOutlet UILabel *tutoDesc1;
     IBOutlet UILabel *tutoDesc2;
     IBOutlet UIButton *backBtn1;
     
     IBOutlet UILabel *AddaQuestion;
     IBOutlet UIButton *sendQuestion;
     
     IBOutlet UILabel *homeLbl;
     IBOutlet UILabel *adContentLbl;
     IBOutlet UILabel *SubtopicsLbl;
     IBOutlet UILabel *guidelineLbl;
     
     
     IBOutlet UIButton *backBtn3;
     __weak IBOutlet UIImageView *searchBg;
     BOOL isGameStarted;
     IBOutlet UIButton *backBtn;
     
      NSArray *imageNames;
     //Gems and Stars
     
     IBOutlet UIView *GemsDialogView;
     
     IBOutlet UIImageView *buynowlabel;
     IBOutlet UILabel *lblGemsPoints;
     IBOutlet UILabel *lblStarsPoints;
     IBOutlet UIButton *playwithGemsbtn;
     
     IBOutlet UILabel *lblPlayforPoints;
     IBOutlet UILabel *lblplayforGems;
     IBOutlet UILabel *willhelpinRanking;
     IBOutlet UILabel *willHelpinEarnMoney;
     
     IBOutlet UITextView *buygemsdesc;
     IBOutlet UILabel *buygemsHeading;
     
     IBOutlet UIImageView *starimg2;
     IBOutlet UIImageView *starImage;
     IBOutlet UIImageView *gemImage;
     
     IBOutlet UIImageView *gemimg2;
     BOOL isChallenge;
     BOOL *isDisabled;
     NSString *requestType;
     NSTimer *animationTimer;
     
#pragma New UI
     int indexCounter;
     NSString *loadingTitle;
     BOOL isChallenegAlreadySelected;
     NSString *challengeID;
     
}

- (IBAction)PlaywitStars:(id)sender;
- (IBAction)PlaywithGems:(id)sender;
- (IBAction)CloseGemsDialog:(id)sender;

@property (strong, nonatomic) NSMutableArray *subtopicsArray;

-(id)initWithParentTopic:(TopicModel *)_parentTopic;
-(id)initWithAllSubTopics;
-(IBAction)ShowRightMenu:(id)sender;

-(void)PlayNowSlected:(id)sender;
-(void)discussionSelected:(id)sender;
-(void)challengeSelected:(id)sender;
-(void)rankingsSelected:(id)sender;

- (IBAction)homePressed:(id)sender;
- (IBAction)topicsPressed:(id)sender;
- (IBAction)newContentPressed:(id)sender;
- (IBAction)guidelinesPressed:(id)sender;
- (IBAction)gameQuit:(id)sender;

- (IBAction)sendQuestion:(id)sender;
- (IBAction)addQuestionView:(id)sender;
- (IBAction)mainBackPressed:(id)sender;

#pragma GameModeScreen
@property int loaderIndex;
@property BOOL gmGemsSelected;
@property BOOL gmChallengeSelected;
@property (weak, nonatomic) IBOutlet UIImageView *gmBg;
@property (weak, nonatomic) IBOutlet UIButton *playNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *gmStarsBtn;
@property (strong, nonatomic) IBOutlet UIView *gameModView;
@property (weak, nonatomic) IBOutlet UIButton *challengeNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *gmGemButton;
@property (weak, nonatomic) IBOutlet UILabel *searchOppLbl;
@property (strong, nonatomic)  IBOutlet UIView *buyGemsView;
@property (weak, nonatomic) IBOutlet UIButton *acceptbuygems;
@property (weak, nonatomic) IBOutlet UIButton *rejectbuygems;
- (IBAction)gmGoPressed:(id)sender;
- (IBAction)gmGemsPressed:(id)sender;
- (IBAction)gmStarsPressed:(id)sender;
- (IBAction)gmPlayNowPressed:(id)sender;
- (IBAction)challengeNowPressed:(id)sender;
- (IBAction)gameModCanelBtnPressed:(id)sender;

#pragma Searching UI Changes
@property (weak, nonatomic) IBOutlet UIView *searchingLoaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstdot;
@property (weak, nonatomic) IBOutlet UIImageView *secondDot;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDot;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDot;
@end
