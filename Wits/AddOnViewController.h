//
//  AddOnViewController.h
//  Wits
//
//  Created by Ahmed Sadiq on 02/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface AddOnViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
     LoadingView *loadingView;
    
    __weak IBOutlet UIView *successPopUp;
    __weak IBOutlet UILabel *successMsg;
     NSString *loadingTitle;
     
     NSUInteger currentSelectedIndex;
    
     NSString *Msgfor2Ques;
     NSString *Msgfor5Ques;
     NSString *counterStrfor2;
     NSString *productDescStrfor2;
     int languageCode;
     NSString *counterStrfor5;
     NSString *productDescStrfor5;
     NSString *buystr;
     
     NSString *cannotPurchase;
     NSString *purchaseError;
     NSString *OKstr;
     
     IBOutlet UIImageView *counterBg;
     IBOutlet UILabel *counterLabel;
     NSIndexPath *index;
     
     IBOutlet UILabel *addOnmainlabel;
     IBOutlet UILabel *lblAddons;
     IBOutlet UILabel *lblCongratulations;
     
     IBOutlet UIButton *backBtn;
     IBOutlet UILabel *lblYouUnlocked;
     IBOutlet UILabel *lblpopupSuccesMsg;
}
@property (strong, nonatomic) NSMutableArray *addOnsArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITableView *mainTbl;
@property (weak, nonatomic) IBOutlet UILabel *gemsLbl;
@property (weak, nonatomic) IBOutlet UILabel *pointsLbl;

- (IBAction)backPressed:(id)sender;
- (IBAction)popUpCrossPressed:(id)sender;


@end
