//
//  SubTopicVC.h
//  Yolo
//
//  Created by Salman Khalid on 25/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "Topic.h"
#import "CategoryModel.h"
#import "Challenge.h"
#import "SocketManager.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
@interface SubTopicVC : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UISearchDisplayDelegate,SocketManagerDelegate>{
     int languageCode;
     IBOutlet UITableView *topicTblView;
     
     NSIndexPath *tableSelection;
     NSArray *topicsArray;
     NSArray *topicsArrayForSearch;
     LoadingView *loadView;
     IBOutlet UISearchBar *searchBar;
     Topic *parentTopic;
     CategoryModel *parentTopicModel;
     AppDelegate *appDelegate;
     
     NSString *howtoPlay1;
     NSString *howtoPlay2;
     NSString *howtoPlay3;
     NSString *howtouseStoreDesc;
     NSString *howtoEarnPointDesc;
     
     IBOutlet UILabel *mainTitlelbl;
     IBOutlet UIImageView *statusView;
      IBOutlet UIView *buyGemsView;
     
     
     NSMutableArray *subtopicsArray;
     NSUInteger currentSelectedIndex;
     
     IBOutlet UILabel *forGemsLable;
     IBOutlet UILabel *forPointsLabel;
     
     IBOutlet UILabel *challengeAFriend;
      IBOutlet UILabel *PlayNowLabel;
     
     BOOL isChallengeSelected;
     Challenge *_challenge;
     IBOutlet UILabel *opponent;
     
     IBOutlet UITextField *answerTxt;
     IBOutlet UIView *addQuestion;
     IBOutlet UITextField *questionTxt;
     
     IBOutlet UITableView *expandView;
     IBOutlet UIView *tutorialView;
     
 
     NSString *HowtoPlay;
     NSString *HowWitsStore;
     NSString *HowtoEarnPoints;
     
     NSString   *subcatMaintempImgName ;
     NSString   *subcatthumbnailtempName;
     
     NSMutableArray      *sectionTitleArray;
     NSMutableDictionary *sectionContentDict;
     NSMutableArray      *arrayForBool;
     
     NSMutableArray *tutorialArray1;
     NSMutableArray *tutorialArray2;
     NSMutableArray *tutorialArray3;
     
     BOOL isGameStarted;
     
     IBOutlet UIButton *backBtn3;
#pragma mark -
#pragma mark Searching Opponent
     
     IBOutlet UIView *searchingView;
     
     __weak IBOutlet UIImageView *searchBg;
     __weak IBOutlet UIImageView *senderProfileImageView;
     
     __weak IBOutlet UILabel *senderNameLbl;
     
     __weak IBOutlet UIImageView *opponentProfileImageView;
     
     
     IBOutlet UIImageView *spinnerImage;
     
     IBOutlet UILabel *searchingTxt;
     
     NSTimer *timer;
     int timeSinceTimer;
     BOOL isOpponentFound;
     
     IBOutlet UILabel *knowledgeLbl;
     
     IBOutlet UILabel *tutoDesc1;
     
     IBOutlet UILabel *tutoDesc2;
     IBOutlet UIButton *backBtn1;
     
     IBOutlet UILabel *AddaQuestion;
     IBOutlet UIButton *sendQuestion;
     
     IBOutlet UILabel *homeLbl;
     IBOutlet UILabel *adContentLbl;
     IBOutlet UILabel *CategoriesLbl;
     IBOutlet UILabel *guidelineLbl;
     
     IBOutlet UIButton *backBtn;
     SocketManager *sharedManager;
     
     IBOutlet UILabel *vsLbl;
     IBOutlet UIButton *backBtn2;
     
     BOOL isAllTopics;
     IBOutlet UIView *GemsDialogView;
     IBOutlet UIImageView *buynowlabel;
     IBOutlet UILabel *lblGemsPoints;
     IBOutlet UILabel *lblStarsPoints;
     
     IBOutlet UILabel *lblPlayforPoints;
     IBOutlet UILabel *lblplayforGems;
     IBOutlet UILabel *willhelpinRanking;
     IBOutlet UILabel *willHelpinEarnMoney;
     BOOL *isDisabled;
     
      IBOutlet UITextView *buygemsdesc;
      IBOutlet UILabel *buygemsHeading;
     IBOutlet UIButton *playwithGemsbtn;
     IBOutlet UIImageView *starImage;
     IBOutlet UIImageView *gemImage;
     
     IBOutlet UIImageView *starimg2;
     
     IBOutlet UIImageView *gemimg2;
     NSString *requestType;
     
     BOOL isChallenge;
     
#pragma New UI
     int indexCounter;
     NSString *loadingTitle;
     BOOL isChallenegAlreadySelected;
     NSString *challengeID;
     NSArray *imageNames;
     NSTimer *animationTimer;
}

- (IBAction)PlaywitStars:(id)sender;
- (IBAction)PlaywithGems:(id)sender;
- (IBAction)CloseGemsDialog:(id)sender;



@property (strong, nonatomic) NSMutableArray *subtopicsArray;
-(id)initWithParentTopic:(Topic *)_parentTopic;
-(id)initWithParentTopicModel:(CategoryModel *)_parentTopic;
-(id)initWithAllTopics;

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
//-(void)SocketDataRecieved:(NSDictionary *)_dict;
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
- (IBAction)rejectGemsBuyPressed:(id)sender;
- (IBAction)acceptGemsBuyPressed:(id)sender;

- (IBAction)gmGoPressed:(id)sender;
- (IBAction)gmGemsPressed:(id)sender;
- (IBAction)gmStarsPressed:(id)sender;
- (IBAction)gmPlayNowPressed:(id)sender;
- (IBAction)challengeNowPressed:(id)sender;
- (IBAction)gameModCanelBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *acceptbuygems;
@property (weak, nonatomic) IBOutlet UIButton *rejectbuygems;

#pragma Searching UI Changes
@property (weak, nonatomic) IBOutlet UIView *searchingLoaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstdot;
@property (weak, nonatomic) IBOutlet UIImageView *secondDot;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDot;
@property (weak, nonatomic) IBOutlet UIImageView *fourthDot;


@end
