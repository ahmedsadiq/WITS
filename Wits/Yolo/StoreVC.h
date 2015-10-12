//
//  StoreVC.h
//  Yolo
//
//  Created by Salman Khalid on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "NIDropDown.h"
#import <MessageUI/MessageUI.h>

@interface StoreVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NIDropDownDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UITableView *productsTblView;
    NSArray *productsArray;
    LoadingView *loadView;
    IBOutlet UILabel *pointslbl;
    
     NSString *loadingTitle;
     int languageCode;
    IBOutlet UILabel *cashablePoints;
    IBOutlet UILabel *nonCashablePoints;
    IBOutlet UILabel *totalCashablePoints;
    IBOutlet UITextField *cashTxt;
    BOOL isPriceEntered;
    
    
     IBOutlet UILabel *LblbuyButtonText;
    IBOutlet UILabel *BuynowGemslbl;
    IBOutlet UILabel *transferGemslbl;
    IBOutlet UILabel *cashoutGemslbl;
  
    NIDropDown *dropDown;
    NSString *paymentMethod;
    
    IBOutlet UILabel *Dollar199;
    
     IBOutlet UIButton *CancelBtn;
     IBOutlet UIButton *OKBtn;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *cashableTitle;
    IBOutlet UILabel *noncashableTitle;
    IBOutlet UILabel *buyTitle;
    IBOutlet UILabel *cashoutTitle;
    IBOutlet UILabel *currentPointTitle;
    IBOutlet UILabel *descLbl;
    IBOutlet UIButton *cashOutBtn;
    IBOutlet UIButton *buyBtn1;
    IBOutlet UIButton *buyBtn2;
    IBOutlet UIButton *buyBtn3;
    IBOutlet UIButton *transferPointsBtn;
    
    int pointForPurchase;
    CGPoint scrollPoint;
    IBOutlet UIView *overlayView;
    
    IBOutlet UIView *cashoutSmallView;
    IBOutlet UILabel *cashoutDollarLbl;
     BOOL isNumKeypad;
    
    IBOutlet UIButton *O1SendBtn;
    IBOutlet UIButton *O2sendBtn;
    
    IBOutlet UIButton *backBtn;
    IBOutlet UILabel *cashoutLbl;
    IBOutlet UIButton *backBtn1;
    
    IBOutlet UILabel *cashoutAmount;
    IBOutlet UIButton *storeMainBack;
    
}
- (IBAction)addPoints:(id)sender;
- (IBAction)deductPoints:(id)sender;

- (IBAction)cashOutPressed:(id)sender;
@property (nonatomic, retain) IBOutlet UILabel *pointslbl;
- (IBAction)buy100Pressed:(id)sender;
- (IBAction)buy500Pressed:(id)sender;
- (IBAction)buy1000Points:(id)sender;

-(IBAction)ShowRightMenu:(id)sender;
-(IBAction)purchaseApp:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *O1View;
@property (strong, nonatomic) IBOutlet UIView *O2View;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)selectClicked:(id)sender;
-(void)rel;
@property (strong, nonatomic) IBOutlet UIView *cashOutView;

@property (strong, nonatomic) IBOutlet UITextField *O1name;
@property (strong, nonatomic) IBOutlet UITextField *O1emailAccount;
@property (strong, nonatomic) IBOutlet UITextField *O1ContactAccount;
@property (strong, nonatomic) IBOutlet UITextField *O1ContactNumber;
@property (strong, nonatomic) IBOutlet UITextField *O1Address;

- (IBAction)O1SendPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *O2BankTitle;
@property (strong, nonatomic) IBOutlet UITextField *O2BankAcoount;
@property (strong, nonatomic) IBOutlet UITextField *O2SwiftCode;
@property (strong, nonatomic) IBOutlet UITextField *O2IbanNumber;
@property (strong, nonatomic) IBOutlet UITextField *O2BankName;
@property (strong, nonatomic) IBOutlet UITextField *O2BankLoc;
- (IBAction)O2SendPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)transferPoints:(id)sender;

- (IBAction)pointsOkayPressed:(id)sender;
- (IBAction)pointsCancelPressed:(id)sender;

////////View Agreement /////////

@property (strong, nonatomic) IBOutlet UIView *ViewAgreement;
@property (strong, nonatomic) IBOutlet UILabel *ageemntTitle;

@property (strong, nonatomic) IBOutlet UITextView *txtAgreemnt;
- (IBAction)AcceptAgremnt:(id)sender;

- (IBAction)RejectAgreemnt:(id)sender;
- (IBAction)AgreemntBackPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;

@property (strong, nonatomic) IBOutlet UILabel *cashoutLbl2;

@property (strong, nonatomic) IBOutlet UILabel *cashOutlbl;
- (IBAction)addOnsPressed:(id)sender;
- (IBAction)rewardsPressed:(id)sender;
- (IBAction)StoreMainBackPressed:(id)sender;

@end


