//
//  GetTopicsVC.h
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import <MessageUI/MessageUI.h>
#import "Challenge.h"
#import "SocketManager.h"
#import "AppDelegate.h"
#import "CustomAnimationView.h"

@interface GetTopicsVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UISearchDisplayDelegate,SocketManagerDelegate>{
     
     IBOutlet UISearchBar *searchBar;
     IBOutlet UITableView *topicTblView;
     
     NSString *howtoPlay1;
     NSString *howtoPlay2;
     NSString *howtoPlay3;
     NSString *howtouseStoreDesc;
     NSString *howtoEarnPointDesc;
     
     AppDelegate *emailOBj;
     NSString *verified;
     
     NSString *loadingTitle;
     
     NSArray *topicsArray;
     NSArray *topicsArrayForSearch;
     NSArray *tempArray;
     LoadingView *loadView;
     LoadingView *_loadingView;

     Challenge *_challenge;
     NSUInteger currentSelectedIndex;
     IBOutlet UILabel *opponent;
     IBOutlet UITextField *answerTxt;
     IBOutlet UIButton *backBtn;
     IBOutlet UIView *addQuestion;
     IBOutlet UITextField *questionTxt;
     IBOutlet UITableView *expandView;
     IBOutlet UIView *tutorialView;
     IBOutlet UIImageView *statusView;
     
     IBOutlet UIButton *backBtn2;
     
     IBOutlet UIButton *backBtn3;
     IBOutlet UILabel *vsLbl;
     
     int languageCode;
     NSMutableArray      *sectionTitleArray;
     NSMutableDictionary *sectionContentDict;
     NSMutableArray      *arrayForBool;
     
     NSMutableArray *tutorialArray1;
     NSMutableArray *tutorialArray2;
     NSMutableArray *tutorialArray3;
     
     IBOutlet UIView *searchingView;
     
     __weak IBOutlet UIImageView *senderProfileImageView;
     
     __weak IBOutlet UILabel *senderNameLbl;
     
     __weak IBOutlet UIImageView *opponentProfileImageView;
     
     IBOutlet UILabel *searchingTxt;
     
     NSString *HowtoPlay;
     NSString *HowWitsStore;
     NSString *HowtoEarnPoints;
     
     NSString *catMaintempImgName;
     NSString *catthumbnailtempName;
     
     IBOutlet UILabel *knowledgeLbl;
     
     IBOutlet UILabel *tutoDesc1;
     IBOutlet UILabel *tutoDesc2;
     IBOutlet UIButton *backBtn1;
     
     IBOutlet UILabel *AddaQuestion;
     IBOutlet UIButton *sendQuestion;
     
     IBOutlet UILabel *homeLbl;
     IBOutlet UILabel *adContentLbl;
     IBOutlet UILabel *topicLbl;
     IBOutlet UILabel *guidelineLbl;
     
     NSTimer *timer;
     int timeSinceTimer;
     BOOL isOpponentFound;
     
     SocketManager *sharedManager;
     BOOL isGameStarted;
     
     //Gems and Stars
     
     IBOutlet UIView *GemsDialogView;
     
     IBOutlet UILabel *lblGemsPoints;
     IBOutlet UILabel *lblStarsPoints;
     
     IBOutlet UILabel *titleErrrorMsg;
     
     IBOutlet UIButton *loginbuttonErrorMsg;
     IBOutlet UILabel *msgErrrormsg;
#pragma New UI
     int indexCounter;
     CustomAnimationView *customObject;
     IBOutlet UIView *invalidUserBg;
     
     
}
- (IBAction)goToLogin:(id)sender;

- (IBAction)PlaywitStars:(id)sender;
- (IBAction)PlaywithGems:(id)sender;
- (IBAction)CloseGemsDialog:(id)sender;


- (IBAction)sendQuestion:(id)sender;
- (IBAction)ShowRightMenu:(id)sender;
- (IBAction)homePressed:(id)sender;
- (IBAction)subTopicPressed:(id)sender;
- (IBAction)newContentPressed:(id)sender;
- (IBAction)recommendPressed:(id)sender;
- (IBAction)addQuestionView:(id)sender;
- (IBAction)tutorialBackPressed:(id)sender;
- (IBAction)mainBackPressed:(id)sender;
- (IBAction)searchPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *rightarrow;
@property (strong, nonatomic) IBOutlet UILabel *CategoriesLbl;
@end
