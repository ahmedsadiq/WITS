//
//  MainSingnUpVC.h
//  Yolo
//
//  Created by Salman Khalid on 12/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoadingView.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "NIDropDown.h"
#import "AlertMessage.h"
#import "GetTopicsVC.h"
@class AlertMessage;
@class GPPSignInButton;
@class SA_OAuthTwitterEngine;

static NSString * const kClientId = @"1020327276316-t4kr4gqvabt8dl5rscsblcco5nq7v13s.apps.googleusercontent.com";

@interface MainSingnUpVC : UIViewController<GPPSignInDelegate,FBLoginViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NIDropDownDelegate,UIScrollViewDelegate>{
    
     __weak IBOutlet UIButton *forgotPasswordLabel;
    NSString *LoadingTitle;
    LoadingView *_loadingView;
    AlertMessage *AlertOBj;
    NSString *email;
     __weak IBOutlet UILabel *OrlabellForgotpasswrod;
    NSString *displayName;
    NSString *user_name_id;
     __weak IBOutlet UILabel *orLabel;
    NSString *profileImageUrl;
    NSString *gender;
    NSString *birthday;
     __weak IBOutlet UIButton *forgotpasswordSigninButtonn;
     __weak IBOutlet UILabel *signuplabelTextbelow;
    NSString *lastRequestType;
    
    IBOutlet UITableView *expandView;
    
    NSString *howtoPlay1;
    NSString *howtoPlay2;
    NSString *howtoPlay3;
    NSString *howtouseStoreDesc;
    NSString *howtoEarnPointDesc;
    
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
    NSMutableArray *tutorialArray1;
    NSMutableArray *tutorialArray2;
    NSMutableArray *tutorialArray3;
    NSString *language;
    int languageCode;
    
    NSString *HowtoPlay;
    NSString *HowWitsStore;
    NSString *HowtoEarnPoints;
    IBOutlet UIView *tutorialView;
    
    IBOutlet UITextField     *tweetTextField;
    SA_OAuthTwitterEngine    *_engine;
    
    IBOutlet UIView *langSelectionPopUp;
    IBOutlet UILabel *languageTitle;
    IBOutlet UIButton *languageBtn;
    IBOutlet UIButton *languageSaveBtn;
    
    NSArray *languageArray;
    NIDropDown *dropDown;
    
    IBOutlet UIButton *twitterBtn;
    IBOutlet UIButton *signUpBtn;
    IBOutlet UILabel *alreadyLbl;
    IBOutlet UILabel *logInBtn;
    IBOutlet UIButton *tutorialBtn;
    IBOutlet UILabel *languageSelectionLbl;
    IBOutlet UILabel *chooseLangLbl;
    IBOutlet UILabel *tutorialLbl;
    IBOutlet UILabel *knowledgelbl;
    IBOutlet UILabel *tutorialDescLbl;
    IBOutlet UILabel *tutorialDescLbl2;
    IBOutlet UIButton *LoginBtnOutlet;
    
     IBOutlet UILabel *forgot_password_button_text_label;
    IBOutlet UIButton *backLbl;
    
    NSString *userImageURLFB;
    
    IBOutlet UIScrollView *tutorialScroll;
    IBOutlet UIView *tutorialScrollView;
    
    
    int i;
    int j;
    AppDelegate *appDelegate;
    NSMutableArray *arrPoints;
    float point;
    int currentPageNo;
    int scrollViewPage;
    float alphaValue;
    float alphaValue1;
    float alphaValue2;
    float alphaValue3;
    float alphaValue4;
    
    float lastContentOffset;
    BOOL shouldHidePage0;
    BOOL shouldHidePage1;
    BOOL shouldHidePage2;
    BOOL shouldHidePage3;
    BOOL shouldHidePage4;
    
    int contentValue;
    
    BOOL didStopPage0;
    BOOL didStopPage1;
    BOOL didStopPage2;
    BOOL didStopPage3;
    BOOL didStopPage4;
    
    UIPageControl *pageController;
    
    NSString *tutoStr1;
    NSString *tutoStr2;
    NSString *tutoStr3;
    NSString *tutoStr4;
    
    IBOutlet UIButton *skipbtn;
    
    
#pragma Login Objects
     NSString *Ok;
     
    __weak IBOutlet UITextField *emailTxt;
    __weak IBOutlet UITextField *pswdTxt;
     
     IBOutlet UIView *DialogView;
     IBOutlet UILabel *dialogTitle;
     IBOutlet UILabel *DialogMsg;
     
     IBOutlet UIButton *Dialogno;
     IBOutlet UIButton *Dialogyes;
     
     NSString *security_War;
     NSString *Already_loggedin_msg;
     NSString *Nobtn;
     NSString *yesbtn;
    
}
@property (weak, nonatomic) IBOutlet UIButton *resetButtonOutlet;
@property ( strong , nonatomic ) UITabBarController *tabBarController;
@property (strong, nonatomic) GetTopicsVC *viewController;
@property ( strong , nonatomic ) UINavigationController *navController;
-(void)testMethod;

- (IBAction)tutorialBackPressed:(id)sender;
- (IBAction)languageSelectonPressed:(id)sender;
- (IBAction)languageSaved:(id)sender;
- (IBAction)tutorialPressed:(id)sender;
-(IBAction)SignInUsingGoogle:(id)sender;
-(IBAction)SignUpUsingEmail:(id)sender;
-(IBAction)loginAction:(id)sender;

- (IBAction)twiiterSignIn:(id)sender;



@property (strong, nonatomic) IBOutlet UIImageView *imgTutorial1;
@property (strong, nonatomic) IBOutlet UIImageView *imgTutorial2;
@property (strong, nonatomic) IBOutlet UIImageView *imgTutorial3;
@property (strong, nonatomic) IBOutlet UIImageView *imgTutorial4;

@property (strong, nonatomic) IBOutlet UIImageView *imgTutorials;
@property (strong, nonatomic) IBOutlet UILabel *lblTutorial;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
- (IBAction)btnSkip:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *skipOutlet;

- (IBAction)resetPasswordPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *resetPswdView;
@property (weak, nonatomic) IBOutlet UITextField *resetPswdEmail;
- (IBAction)sendResetPswdCall:(id)sender;
- (IBAction)signInView:(id)sender;

@end
