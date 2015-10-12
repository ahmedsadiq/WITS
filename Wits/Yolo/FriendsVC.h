//
//  FriendsVC.h
//  Yolo
//
//  Created by Salman Khalid on 27/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "UserProfile.h"
#import "AsyncImageView.h"
@interface FriendsVC : UIViewController<UIAlertViewDelegate>{
     
     IBOutlet UIImageView *searchimg;
     LoadingView *_loadingView;
     IBOutlet UITextField *searchField;
     NSMutableArray *friendsList;
     IBOutlet UITableView *friendsTable;
     IBOutlet UIView *friendImageView;
     IBOutlet UIImageView *friendLargeImage;
     
     NSMutableArray *arrFriendImage;
     int languageCode;
     NSString *statusStr;
     NSString *loadingTitle;
     IBOutlet UIButton *GoBtn;
     
     IBOutlet UILabel *noFriendLbl;
     IBOutlet UIButton *backbtn;
     
     IBOutlet UIButton *mainBackBtn;
     UIGestureRecognizer *tapper;
     

     
     BOOL isSearched;
     
#pragma New UI changes
     int currentIndex;
     UserProfile *selectedUser;
}
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UILabel *friendsLbl;

-(void)FetchFriendList;
-(void)SendSearchFriendCall;
-(IBAction)ShowRightMenu:(id)sender;
-(IBAction)sendSearcgCall:(id)sender;
-(IBAction)mainBackPressed:(id)sender;
-(IBAction)largeImageBackPressed:(id)sender;
-(BOOL) isFriendAcceptRequest :(UserProfile*) userProfile;


#pragma mark-
#pragma FriendModeScreen
@property (weak, nonatomic) IBOutlet UIImageView *fmBg;
@property (strong, nonatomic) IBOutlet UIView *friendModView;
@property (weak, nonatomic) IBOutlet UIButton *fmChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *fmChallengeNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *fmFriendButton;

- (IBAction)fmchallengepointspressed:(id)sender;
- (IBAction)fmChatBtnPressed:(id)sender;
- (IBAction)fmChallenegeGemsPressed:(id)sender;
- (IBAction)fmChallengeNowBtnPressed:(id)sender;
- (IBAction)fmFriendButtonPressed:(id)sender;
- (IBAction)friendModCanelBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *friendActionView;
@property (weak, nonatomic) IBOutlet UILabel *friendActionTitle;
@property (weak, nonatomic) IBOutlet AsyncImageView *friendActionImg;
@property (weak, nonatomic) IBOutlet UITextView *friendActionText;
@property (weak, nonatomic) IBOutlet UIButton *friendActionAcceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendActionRejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *challengeForPoints;
@property (weak, nonatomic) IBOutlet UIButton *challengeForGems;

- (IBAction)friendActionRejectBtnPressed:(id)sender;
- (IBAction)friendActionAcceptBtnPressed:(id)sender;
- (IBAction)friendActionQuit:(id)sender;


@property (weak, nonatomic) IBOutlet AsyncImageView *friendPopUpImg;
@property (weak, nonatomic) IBOutlet UILabel *friendNamePopUp;

@end
