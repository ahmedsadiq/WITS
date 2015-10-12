//
//  RewardsListVC.h
//  Wits
//
//  Created by Ahmed Sadiq on 05/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
@interface RewardsListVC : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    __weak IBOutlet UITableView *rewardsTableView;
    __weak IBOutlet UILabel *gemsCountLbl;
    __weak IBOutlet UILabel *pointsCountLbl;
     LoadingView *_loadingView;
     int consumedGems;
     __weak IBOutlet UIView *popupView;
     NSUInteger currentSelectedIndex;
     
     IBOutlet UILabel *buyAddonLbl;
     NSString *claim;
     NSString *loadingTitle;
     NSString *cannotPurchase;
     NSString *purchaseError;
     NSString *OKstr;
     NSIndexPath *indexPath;
     
     IBOutlet UILabel *LblCograts;
     
     IBOutlet UILabel *lblRequestRecieved;
     IBOutlet UILabel *ourTeamMsg;
     IBOutlet UIButton *backBtn;
     IBOutlet UILabel *lblRewards;
     
}
@property (strong, nonatomic) NSMutableArray *addOnsArray;
- (IBAction)backPressed:(id)sender;
- (IBAction)popupBackBtn:(id)sender;

@end
