//
//  RightBarVC.h
//  Yolo
//
//  Created by Salman Khalid on 19/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import<CoreLocation/CoreLocation.h>


enum {
     
     OFF_HIDDEN = 0,
     ON_SCREEN = 1,
     
};
typedef NSUInteger CurrentState;


@interface RightBarVC : UIViewController<CLLocationManagerDelegate>{
     
     CLLocationManager *locationManager;
     UIView *parentView;
     CurrentState _currentState;
     NSString *language;
     int languageCode;
     IBOutlet UIView *overlay;
     IBOutlet UIImageView *colorRing;
     NSString *loadingTitle;
     LoadingView *_loadingView;
     
     BOOL isProfileImageLoaded;
     IBOutlet UIImageView *profileImageView;
     
     IBOutlet UILabel *namelbl;
     IBOutlet UILabel *isVerfiedlbl;
     IBOutlet UIButton *updateProfile;
     IBOutlet UILabel *lblsetting;
     
     IBOutlet UILabel *lbllogout;
     IBOutlet UILabel *lblaboutus;
     IBOutlet UILabel *lblranking;
     IBOutlet UILabel *lblmesage;
     IBOutlet UILabel *lblhistory;
     IBOutlet UIImageView *homeImg;
     IBOutlet UIImageView *friendsImg;
     IBOutlet UIImageView *topicsImg;
     IBOutlet UIImageView *historyImg;
     IBOutlet UIImageView *messagesImg;
     IBOutlet UIImageView *storeImg;
     IBOutlet UIImageView *rankingImg;
     IBOutlet UIImageView *settingsImg;
     IBOutlet UIImageView *transferPointImg;
     IBOutlet UIImageView *logoutImg;
     IBOutlet UIImageView *contactUsimg;
     
     
     IBOutlet UIButton *ProfileImgOutlet;
     
     IBOutlet UIButton *removeBtn;
     IBOutlet UIButton *storeBtn;
     
     IBOutlet UIButton *homeBtn;
     IBOutlet UIButton *topicsBtn;
     IBOutlet UIButton *friendsBtn;
     IBOutlet UIButton *historyBtn;
     IBOutlet UIButton *messageBtn;
     IBOutlet UIButton *discussionBtn;
     IBOutlet UIButton *rankingBtn;
     IBOutlet UIButton *witsStoreBtn;
     IBOutlet UIButton *settingsBtn;
     IBOutlet UIButton *logOutBtn;
     IBOutlet UIButton *transferPoints;
     IBOutlet UIButton *contactsBtn;
     
     IBOutlet UILabel *userRankingLbl;
}
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property CurrentState _currentState;

+(RightBarVC *)getInstance;
-(void)AddInView:(UIView *)parentView;
-(void)ShowInView;
-(void)loadProfileImage;
-(IBAction)MoveToHome:(id)sender;
-(IBAction)MovetoTopics:(id)sender;
-(IBAction)ShowHistory:(id)sender;
-(IBAction)LogOutUser:(id)sender;
-(IBAction)generalAction:(id)sender;
-(IBAction)MoveToStore:(id)sender;
-(IBAction)ShowSetting:(id)sender;
-(IBAction)MoveToFriends:(id)sender;
-(IBAction)UpdateProfile:(id)sender;
-(IBAction)ShowMessages:(id)sender;
-(IBAction)ShowDiscussion:(id)sender;
-(IBAction)ShowTransferPoints:(id)sender;
-(IBAction)showContactUs:(id)sender;
-(IBAction)showTimeLine:(id)sender;
- (IBAction)movetoranking:(id)sender;
@end
