//
//  SettingVC.h
//  Yolo
//
//  Created by Jawad Mahmood  on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "LoadingView.h"
#import "WitsDB.h"
@interface SettingVC : UIViewController<NIDropDownDelegate,UITextFieldDelegate>{
    
     
     NSString *loadingtitle;
    IBOutlet UIButton *musicBtn;
    IBOutlet UIButton *soundEffectBtn;
    IBOutlet UIButton *vibrationBtn;
    IBOutlet UIButton *challengeNotificationBtn;
    IBOutlet UIButton *chatNotificationBtn;
    IBOutlet UITextField *referralCodeTxt;
    BOOL isMusicOn;
    BOOL isSoundOn;
    BOOL isVibrationOn;
    BOOL isChallengeOn;
    BOOL isChatOn;
     LoadingView *loadView;
    
     IBOutlet UILabel *selectlanguageHeading;
     IBOutlet UILabel *pushnotificationsheading;
    IBOutlet UIButton *rateUs;
     NSString *message;
     NSString *language;
     int languageCode;
     NSString *langBtnTitle;
     
     
    IBOutlet UILabel *chooseLang;
    IBOutlet UILabel *settingsLbl;
    IBOutlet UILabel *musiclbl;
    IBOutlet UILabel *soundEffectLbl;
    IBOutlet UILabel *vibrationLbl;
    IBOutlet UILabel *generalLbl;
    IBOutlet UILabel *pushNotificationLbl;
    IBOutlet UILabel *challengeNotificationLbl;
    IBOutlet UILabel *chatNotification;
    IBOutlet UILabel *referalCode;
    IBOutlet UIButton *sendBtn;
    IBOutlet UIButton *aboutBtn;
    IBOutlet UIButton *changeLangBtn;
    
     IBOutlet UIButton *languageButtonOutlet;
    IBOutlet UIView *langSelectionPopUp;
    IBOutlet UILabel *languageTitle;
    IBOutlet UIButton *languageBtn;
    IBOutlet UIButton *languageSaveBtn;
    
    IBOutlet UIButton *mainbackBtn;
     BOOL sent;
    NSArray *languageArray;
    NIDropDown *dropDown;
    __weak IBOutlet UIScrollView *mainscrollView;
}
@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) WitsDB *witsdb;

- (IBAction)aboutUsPressed:(id)sender;
- (IBAction)ShowRightMenu:(id)sender;
- (IBAction)musicBtnPressed:(id)sender;
- (IBAction)soundEffectPressed:(id)sender;
- (IBAction)vibrationPressed:(id)sender;
- (IBAction)challengeNotificationPressed:(id)sender;
- (IBAction)chatNotificationPressed:(id)sender;
- (IBAction)changeLanguagePressed:(id)sender;
- (IBAction)rateUsPressed:(id)sender;
- (IBAction)sendPressed:(id)sender;
- (IBAction)mainBackPressed:(id)sender;

@end
