//
//  RewardsListVC.h
//  Wits
//
//  Created by Ahmed Sadiq on 05/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
@interface RewardsListVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    __weak IBOutlet UITableView *rewardsTableView;
    __weak IBOutlet UILabel *gemsCountLbl;
    __weak IBOutlet UILabel *pointsCountLbl;
     LoadingView *_loadingView;
     int consumedGems;
     __weak IBOutlet UIView *popupView;
     NSUInteger currentSelectedIndex;
     
     bool firsttime;

     IBOutlet UILabel *buyAddonLbl;
     NSString *claim;
     NSString *loadingTitle;
     NSString *cannotPurchase;
     NSString *purchaseError;
     NSString *OKstr;
     NSIndexPath *indexPath;
     int currentIndex;
     UIImage *selectedRewardImage;
     NSString *product_id;
     int timeSort;
     IBOutlet UILabel *LblCograts;
     
     IBOutlet UILabel *lblRequestRecieved;
     IBOutlet UILabel *ourTeamMsg;
     IBOutlet UIButton *backBtn;
     IBOutlet UILabel *lblRewards;
     
     IBOutlet UIView *rewardDetailView;
     
     __weak IBOutlet UILabel *discriptionlbl;
     __weak IBOutlet UILabel *titlelbl;
     __weak IBOutlet UIImageView *rewardsiconimgview;
    __weak IBOutlet UILabel *gemsAmountlbl;
     
     __weak IBOutlet UIButton *sortbtn;
      IBOutlet UITextField *searchField;
}
@property (strong, nonatomic) NSMutableArray *addOnsArray;
@property (strong, nonatomic) NSMutableArray *addOnsArraySorted;
@property (strong, nonatomic) NSMutableArray *listFiles ;

- (IBAction)backPressed:(id)sender;
- (IBAction)popupBackBtn:(id)sender;
- (IBAction)Crossbtn:(id)sender;
- (IBAction)sortBtn:(id)sender;


@end
