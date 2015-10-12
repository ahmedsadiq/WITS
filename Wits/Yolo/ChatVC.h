//
//  ChatVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 04/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "UserProfile.h"
#import "MessageThreads.h"

@interface ChatVC : UIViewController{
    
    IBOutlet UILabel *titleLbl;
    
     int languageCode;
     
    IBOutlet UIImageView *greenImg;
    IBOutlet UIImageView *coverImg;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *pointsLbl;
    LoadingView *_loadView;
    UserProfile *profile;
    
    IBOutlet UILabel *gemLbl;
    IBOutlet UIImageView *star_icon;
    IBOutlet UIImageView *gem_icon;
    IBOutlet UILabel *currentGems;
    IBOutlet UILabel *userRankingStatus;
}
-(IBAction)sendChatMessage:(id)sender;
- (IBAction)myAccount:(id)sender;
- (IBAction)backPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *profileLbl;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UILabel *pointsLbl;
@property (strong, nonatomic) IBOutlet UILabel *myaccountLbl;
@property (strong, nonatomic) IBOutlet UIButton *backOutlet;
@property (strong, nonatomic) IBOutlet UILabel *OnlineLbl;
@property (strong, nonatomic) IBOutlet UILabel *currentPoints;


@end
