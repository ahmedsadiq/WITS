//
//  HistoryViewController.h
//  Wits
//
//  Created by Mr on 10/11/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "Challenge.h"
#import "SocketManager.h"

@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     __weak IBOutlet UIImageView *selfProfileImg;
     __weak IBOutlet UIImageView *opponentProfileImg;
     
     IBOutlet UIScrollView *mainScrollView;
     IBOutlet UIButton *historyBtn;
     IBOutlet UIButton *rankingBtn;
     LoadingView *loadView;
     NSMutableArray *historyArray;
     IBOutlet UITableView *resultTable;
     int tempVar;
     
     NSMutableArray *imagesArr;
     UIImageView *saveOppImage;
     
     NSString *contest;
     Challenge *_challenge;
     NSString *rematchType;
     NSString *rematchTypeId;
     
     SocketManager *sharedManager;
     
     NSString *somethingtitle;
     
     NSString *days_ago;
     NSString *hours_ago;
     NSString *minutes_ago;
     NSString *seconds_ago;
     NSString *loadingtitle;
     
     NSString *language;
     int languageCode;
     
     IBOutlet UILabel *NoRecordLbl;
     NSArray *senderPointsArray;
     NSArray *selfPointsArray;
     IBOutlet UIView *ResultsView;
     
     IBOutlet UIView *resultCard_View;
     IBOutlet UILabel *resultLbl;
     
     IBOutlet UIImageView *self_resultImg;
     IBOutlet UIImageView *opponent_resultImg;
     
     IBOutlet UIImageView *selfSearchingImage;
     IBOutlet UIImageView *opponentSearchImg;
     
     IBOutlet UIScrollView *rescultScrollView;
     
     IBOutlet UIView *resultTopBar;
     IBOutlet UILabel *playerName;
     IBOutlet UILabel *opponentName;
     
     IBOutlet UILabel *searchPlayerName;
     
     IBOutlet UILabel *searchOpponentName;
     
     IBOutlet UILabel *topBarPlayerName;
     IBOutlet UILabel *topBarOpponentName;
     
     IBOutlet UIView *resulltSecondLayer;
     
     IBOutlet UIView *resultBottomBar;
     IBOutlet UILabel *userTotal;
     IBOutlet UILabel *opponentTotal;
     
     NSArray *rankingArray;
     int rankCounter;
     
     IBOutlet UILabel *RankingTitleLbl;
     
     IBOutlet UIButton *playAgain;
     
     IBOutlet UIButton *ReturnHome;
     IBOutlet UILabel *resultsTitle;
     
     IBOutlet UIImageView *resultGameTypeimg;
     
     NSDate *currentServerDate;
     
     
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
     NSString *requestType;
     
     IBOutlet UIImageView *spinner;
     IBOutlet UIView *searchingView;
     IBOutlet UIButton *quitsearch;
     
     IBOutlet UIButton *mainBack;
#pragma New UI changes
     int currentIndex;
     int currentIndexHistory;
}

- (IBAction)PlaywitStars:(id)sender;
- (IBAction)PlaywithGems:(id)sender;
- (IBAction)CloseGemsDialog:(id)sender;

- (IBAction)rankingPressed:(id)sender;
- (IBAction)historyPressed:(id)sender;
- (IBAction)rightSliderPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)PlayAgainPressed:(id)sender;
- (IBAction)ReturnHomePressed:(id)sender;
- (IBAction)Rightbar:(id)sender;
- (IBAction)quitSearch:(id)sender;

@property BOOL isRanking;
@property (strong, nonatomic) IBOutlet UIView *RankingPinkLine;
@property (strong, nonatomic) IBOutlet UIView *HistoryPinkLine;
- (IBAction)MainBackPressed:(id)sender;
- (IBAction)resultBack:(id)sender;

@end
