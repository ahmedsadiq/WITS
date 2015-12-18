//
//  EarnFreePointsViewController.h
//  Wits
//
//  Created by Mr on 21/10/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LoadingView.h"

@interface EarnFreePointsViewController : UIViewController<MFMailComposeViewControllerDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UIScrollViewDelegate> {
     LoadingView *loadView;
     
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

     
     NSString *HowtoPlay;
     NSString *HowWitsStore;
     NSString *HowtoEarnPoints;
     IBOutlet UIView *tutorialView;
     
     IBOutlet UILabel *knowledgelbl;
     IBOutlet UILabel *tutorialDescLbl;
     IBOutlet UILabel *tutorialDescLbl2;
     
     int languageCode;
     NSString *newShareString;
     NSString *referalStr;
     NSString *referalStr2;
    IBOutlet UIButton *mainBack;
}
- (IBAction)tutorialpressed:(id)sender;
- (IBAction)tutorialBackPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *tutorialBacklbl;

@property (strong, nonatomic) IBOutlet UIButton *tutorialPressed;
- (IBAction)fbBtnPressed:(id)sender;
- (IBAction)twitterBtnPressed:(id)sender;
- (IBAction)smsBtnPressed:(id)sender;
- (IBAction)emailBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *referralText;
- (IBAction)sendPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *knowlegdeLbl;
@property (strong, nonatomic) IBOutlet UILabel *shareLbl;
@property (strong, nonatomic) IBOutlet UILabel *EarnfreePointLbl;
- (IBAction)mainBackPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblTutorial;

#pragma mark -
#pragma new UI

@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
- (IBAction)tutorialSkipPressed:(id)sender;

@end
