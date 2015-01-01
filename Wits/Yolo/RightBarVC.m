//
//  RightBarVC.m
//  Yolo
//
//  Created by Salman Khalid on 19/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "RightBarVC.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "Utils.h"
#import "NavigationHandler.h"
#import "UIImageView+RoundImage.h"
#import "AppDelegate.h"
#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "SettingVC.h"
#import "MessagesVC.h"
#import "ContactUsViewController.h"
#import "UpdateProfileVC.h"
#import "EarnFreePointsViewController.h"
@interface RightBarVC () {
     CLGeocoder *geocoder;
     CLPlacemark *placemark;
}

@end

static RightBarVC *RightBar_Instance= NULL;


@implementation RightBarVC
@synthesize _currentState,profileImageView;
float _yLocation;
+(RightBarVC *)getInstance{
     
     if(RightBar_Instance == NULL)
     {
          if ([[UIScreen mainScreen] bounds].size.height == iPad){
               RightBar_Instance = [[RightBarVC alloc] initWithNibName:@"RightBarVC_iPad" bundle:nil];
               _yLocation = 50.0f;
          }
          
          else{
               RightBar_Instance = [[RightBarVC alloc] initWithNibName:@"RightBarVC" bundle:nil];
               _yLocation = 36.0f;
          }
     }
     return RightBar_Instance;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
          // Custom initialization
          
          _currentState = OFF_HIDDEN;
     }
     return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     
     // Do any additional setup after loading the view from its nib.
     _loadingView = [[LoadingView alloc] init];
     //self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     if(IS_IPAD){
          userRankingLbl.font = [UIFont fontWithName:FONT_NAME size:30];
          lblaboutus.font = [UIFont fontWithName:FONT_NAME size:17];
          lblhistory.font = [UIFont fontWithName:FONT_NAME size:17];
          lbllogout.font = [UIFont fontWithName:FONT_NAME size:17];
          lblmesage.font = [UIFont fontWithName:FONT_NAME size:17];
          lblranking.font = [UIFont fontWithName:FONT_NAME size:17];
          namelbl.font = [UIFont fontWithName:FONT_NAME size:30];
          lblsetting.font = [UIFont fontWithName:FONT_NAME size:17];
     }
     else{
          userRankingLbl.font = [UIFont fontWithName:FONT_NAME size:15];
          lblaboutus.font = [UIFont fontWithName:FONT_NAME size:11];
          lblhistory.font = [UIFont fontWithName:FONT_NAME size:11];
          lbllogout.font = [UIFont fontWithName:FONT_NAME size:11];
          lblmesage.font = [UIFont fontWithName:FONT_NAME size:11];
          lblranking.font = [UIFont fontWithName:FONT_NAME size:11];
          namelbl.font = [UIFont fontWithName:FONT_NAME size:18];
          lblsetting.font = [UIFont fontWithName:FONT_NAME size:11];
     }
     
     userRankingLbl.text = @"Loading...";
     
     geocoder = [[CLGeocoder alloc] init];
     if (locationManager == nil)
     {
          locationManager = [[CLLocationManager alloc]  init];
          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
          locationManager.delegate = self;
     }
     
     if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
          [locationManager requestWhenInUseAuthorization];
     }
     
     [locationManager startUpdatingLocation];
     
     RightBar_Instance = self;
     _loadingView = [[LoadingView alloc] init];
     isProfileImageLoaded = false;
     
     if([SharedManager getInstance]._userProfile.profile_image != NULL)
          [self loadProfileImage];
     
     
     [self ShowInView];
     
     removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [removeBtn setFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
     [removeBtn addTarget:self action:@selector(ShowInView) forControlEvents:UIControlEventTouchUpInside];
     
}


- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     //initData
     [self setLanguage];
     [namelbl setText:[SharedManager getInstance]._userProfile.display_name];
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     if(!appDelegate.fromHomeScreen)
          appDelegate.resetToHomeScreen = true;
     [self.tabBarController.tabBar setHidden:NO];
     
}
-(void)AddInView:(UIView *)_parentView{
     [self setLanguage];
     
     
     parentView = _parentView;
     
     if(_currentState == OFF_HIDDEN)
          [self.view setFrame:CGRectMake(parentView.frame.size.width, _yLocation, self.view.frame.size.width, self.view.frame.size.height)];
     [_parentView addSubview:self.view];
     
}




-(void)ShowInView{
     [namelbl setText:[SharedManager getInstance]._userProfile.display_name];
     NSString *verified = [SharedManager getInstance]._userProfile.isVerfied;
     [isVerfiedlbl setText:verified];
     if (languageCode == 1) {
          storeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     }else{
          storeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          
     }
     
     
     
     
}


-(IBAction)LogOutUser:(id)sender{
     
     _loadingView = [[LoadingView alloc] init];
     [_loadingView showInView:parentView withTitle:@""];
     //logout user
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"userLogOut" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [_loadingView hide];
          
          NSDictionary *recievedDict = [completedOperation responseJSON];
          NSNumber *flag = [recievedDict objectForKey:@"flag"];
          
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          delegate.profileImage = nil;
          [[SharedManager getInstance] ResetModel];
          //Take user to sign up page
          [[NavigationHandler getInstance] NavigateToSignUpScreen];
          //[self ShowInView];
          [self removeImage:@"test"];
          profileImageView.image = [UIImage imageNamed:@"personal.png"];
          [delegate musicSwitch:false];
     } onError:^(NSError* error) {
          
          [_loadingView hide];
          
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          delegate.profileImage = nil;
          [[SharedManager getInstance] ResetModel];
          [[NavigationHandler getInstance] NavigateToSignUpScreen];
          [self ShowInView];
          
     }];
     
     
     [engine enqueueOperation:op];
     
}


-(IBAction)MoveToHome:(id)sender{
     [[NavigationHandler getInstance] NavigateToRoot];
     [self ShowInView];
}

-(IBAction)MovetoTopics:(id)sender{
     [[NavigationHandler getInstance] MoveToTopics];
}

-(IBAction)ShowHistory:(id)sender{
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          HistoryViewController *update = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController_iPad" bundle:nil];
          update.isRanking = false;
          [self.navigationController pushViewController:update animated:YES];
     }
     else{
          
          HistoryViewController *update = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
          update.isRanking = false;
          [self.navigationController pushViewController:update animated:YES];
     }
}

-(IBAction)ShowMessages:(id)sender{
     
     [self.tabBarController.tabBar setHidden:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          EarnFreePointsViewController *update = [[EarnFreePointsViewController alloc] initWithNibName:@"EarnFreePointsViewController_iPad" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }
     else{
          
          EarnFreePointsViewController *update = [[EarnFreePointsViewController alloc] initWithNibName:@"EarnFreePointsViewController" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }

}

-(IBAction)generalAction:(id)sender{
     
     [self ShowInView];
}

-(IBAction)MoveToStore:(id)sender{
     
     [[NavigationHandler getInstance] MoveToStore];
}

-(IBAction)ShowSetting:(id)sender{
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          SettingVC *setting = [[SettingVC alloc] initWithNibName:@"SettingVC_iPad" bundle:nil];
          [self.navigationController pushViewController:setting animated:YES];
     }
     else{
          
          SettingVC *setting = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
          [self.navigationController pushViewController:setting animated:YES];
     }
}
-(IBAction)ShowTransferPoints:(id)sender{
     AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
     del.transferPointsEmail = @"";
     [[NavigationHandler getInstance] MoveToTransferPoints];
}

- (IBAction)showContactUs:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.witsapplication.com/"]];
}

- (IBAction)showTimeLine:(id)sender {
     [[NavigationHandler getInstance] MoveToTimeLine];
}

- (IBAction)movetoranking:(id)sender {
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          HistoryViewController *update = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController_iPad" bundle:nil];
          update.isRanking = true;
          [self.navigationController pushViewController:update animated:YES];
     }
     else{
          HistoryViewController *update = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
          update.isRanking = true;
          [self.navigationController pushViewController:update animated:YES];
     }
}


-(IBAction)MoveToFriends:(id)sender{
     
     [[NavigationHandler getInstance] MoveToFriends];
}


-(IBAction)UpdateProfile:(id)sender{
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          UpdateProfileVC *update = [[UpdateProfileVC alloc] initWithNibName:@"UpdateProfileVC_iPad" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }
     else{
          
          UpdateProfileVC *update = [[UpdateProfileVC alloc] initWithNibName:@"UpdateProfileVC" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }
}


-(IBAction)ShowDiscussion:(id)sender{
     
     // [[NavigationHandler getInstance] MoveToDiscussion];
}



-(void)loadProfileImage{
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     UIImage *profileImg = [self loadImage];
     if(profileImg) {
          [profileImageView setImage:profileImg];
          [profileImageView roundImageCornerBlackBorder];
          delegate.profileImage = profileImg;
          isProfileImageLoaded = true;
     }
     else {
          
          //logout user
          if(delegate.profileImage) {
               [profileImageView setImage:delegate.profileImage];
               [profileImageView roundImageCornerBlackBorder];
          }
          else {
               [namelbl setText:[SharedManager getInstance]._userProfile.display_name];
               
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               NSString *link = [SharedManager getInstance]._userProfile.profile_image;
               
               MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [profileImageView setImage:[completedOperation responseImage]];
                    [profileImageView roundImageCornerBlackBorder];
                    delegate.profileImage = [completedOperation responseImage];
                    isProfileImageLoaded = true;
                    
                    [self saveImage:[completedOperation responseImage]];
                    
               } onError:^(NSError* error) {
                    
                    [profileImageView setImage:[UIImage imageNamed:@"personal.png"]];
                    [profileImageView roundImageCornerBlackBorder];
                    
               }];
               
               [engine enqueueOperation:op];
          }
     }
     
     
}

- (void)saveImage: (UIImage*)image
{
     if (image != nil)
     {
          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES);
          NSString *documentsDirectory = [paths objectAtIndex:0];
          NSString* path = [documentsDirectory stringByAppendingPathComponent:
                            @"test.png" ];
          NSData* data = UIImagePNGRepresentation(image);
          [data writeToFile:path atomically:YES];
     }
}

- (UIImage*)loadImage
{
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString* path = [documentsDirectory stringByAppendingPathComponent:
                       @"test.png" ];
     UIImage* image = [UIImage imageWithContentsOfFile:path];
     return image;
}

- (void)removeImage:(NSString*)fileName {
     
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"%@.png", fileName]];
     
     NSError *error = nil;
     if(![fileManager removeItemAtPath:fullPath error:&error]) {
          NSLog(@"Delete failed:%@", error);
     } else {
          NSLog(@"image removed: %@", fullPath);
     }
     
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

-(void)setLanguage {
     /*
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
      */
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          loadingTitle = Loading;
          
          
          lblhistory.text = HISTORY_BTN;
          lblmesage.text = MESSAGE_BTN;
          lblranking.text =RANKING_BTN;
          lblsetting.text = SETTINGS_BTN;
          lblaboutus.text = ABOUTUS_TEXT;
          lbllogout.text = LOGOUT_BTN;
          
          
          
          
          //          [homeBtn setTitle:HOME_BTN forState:UIControlStateNormal];
          //          [topicsBtn setTitle:TOPICS_BTN forState:UIControlStateNormal];
          //          [friendsBtn setTitle:FRIENDS_BTN forState:UIControlStateNormal];
          //          [historyBtn setTitle:HISTORY_BTN forState:UIControlStateNormal];
          //          [messageBtn setTitle:MESSAGE_BTN forState:UIControlStateNormal];
          //          [discussionBtn setTitle:DISCUSSION_BTN forState:UIControlStateNormal];
          //          [rankingBtn setTitle:RANKING_BTN forState:UIControlStateNormal];
          //          [witsStoreBtn setTitle:WITS_STORE_BTN forState:UIControlStateNormal];
          //          [settingsBtn setTitle:SETTINGS_BTN forState:UIControlStateNormal];
          //          [logOutBtn setTitle:LOGOUT_BTN forState:UIControlStateNormal];
          //          [transferPoints setTitle:TRANSFER_POINTS_BTN forState:UIControlStateNormal];
          //          [contactsBtn setTitle:CONTACTS_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          loadingTitle = Loading_1;
          lblhistory.text = HISTORY_BTN_1;
          lblmesage.text = @"احصل على النقاط مجانية";
          lblranking.text = @"الترتيب";

          lblsetting.text = SETTINGS_BTN_1;
          lblaboutus.text = ABOUTUS_TEXT_1;
          lbllogout.text = LOGOUT_BTN_1;
          
          
          //          [homeBtn setTitle:HOME_BTN_1 forState:UIControlStateNormal];
          //          [topicsBtn setTitle:TOPICS_BTN_1 forState:UIControlStateNormal];
          //          [friendsBtn setTitle:FRIENDS_BTN_1 forState:UIControlStateNormal];
          //          [historyBtn setTitle:HISTORY_BTN_1 forState:UIControlStateNormal];
          //          [messageBtn setTitle:MESSAGE_BTN_1 forState:UIControlStateNormal];
          //          [discussionBtn setTitle:DISCUSSION_BTN_1 forState:UIControlStateNormal];
          //          [rankingBtn setTitle:RANKING_BTN_1 forState:UIControlStateNormal];
          //          [witsStoreBtn setTitle:WITS_STORE_BTN_1 forState:UIControlStateNormal];
          //          [settingsBtn setTitle:SETTINGS_BTN_1 forState:UIControlStateNormal];
          //          [logOutBtn setTitle:LOGOUT_BTN_1 forState:UIControlStateNormal];
          //          [transferPoints setTitle:TRANSFER_POINTS_BTN_1 forState:UIControlStateNormal];
          //          [contactsBtn setTitle:CONTACTS_BTN_1 forState:UIControlStateNormal];
          
          homeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          topicsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          friendsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          discussionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          rankingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          witsStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          settingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          logOutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          transferPoints.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          contactsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     }
     else if(languageCode == 2) {
          
          loadingTitle = Loading_2;
          lblhistory.text = HISTORY_BTN_2;
          lblmesage.text = @"Gagnez des Points";
          lblranking.text = @"Classements";
          lblsetting.text = SETTINGS_BTN_2;
          lblaboutus.text = @"A propos";
          lbllogout.text = LOGOUT_BTN_2;
          //          [homeBtn setTitle:HOME_BTN_2 forState:UIControlStateNormal];
          //          [topicsBtn setTitle:TOPICS_BTN_2 forState:UIControlStateNormal];
          //          [friendsBtn setTitle:FRIENDS_BTN_2 forState:UIControlStateNormal];
          //          [historyBtn setTitle:HISTORY_BTN_2 forState:UIControlStateNormal];
          //          [messageBtn setTitle:MESSAGE_BTN_2 forState:UIControlStateNormal];
          //          [discussionBtn setTitle:DISCUSSION_BTN_2 forState:UIControlStateNormal];
          //          [rankingBtn setTitle:RANKING_BTN_2 forState:UIControlStateNormal];
          //          [witsStoreBtn setTitle:WITS_STORE_BTN_2 forState:UIControlStateNormal];
          //          [settingsBtn setTitle:SETTINGS_BTN_2 forState:UIControlStateNormal];
          //          [logOutBtn setTitle:LOGOUT_BTN_2 forState:UIControlStateNormal];
          //          [transferPoints setTitle:TRANSFER_POINTS_BTN_2 forState:UIControlStateNormal];
          //          [contactsBtn setTitle:CONTACTS_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          
          loadingTitle = Loading_3;
          lblhistory.text = HISTORY_BTN_3;
          lblmesage.text = @"Ganar Puntos gratis";
          lblranking.text = @"Rangos";
          lblsetting.text = @"Configuración";
          lblaboutus.text = @"Sobre";
          lbllogout.text = @"Cerrar sesión";
          
          //          [homeBtn setTitle:HOME_BTN_3 forState:UIControlStateNormal];
          //          [topicsBtn setTitle:TOPICS_BTN_3 forState:UIControlStateNormal];
          //          [friendsBtn setTitle:FRIENDS_BTN_3 forState:UIControlStateNormal];
          //          [historyBtn setTitle:HISTORY_BTN_3 forState:UIControlStateNormal];
          //          [messageBtn setTitle:MESSAGE_BTN_3 forState:UIControlStateNormal];
          //          [discussionBtn setTitle:DISCUSSION_BTN_3 forState:UIControlStateNormal];
          //          [rankingBtn setTitle:RANKING_BTN_3 forState:UIControlStateNormal];
          //          [witsStoreBtn setTitle:WITS_STORE_BTN_3 forState:UIControlStateNormal];
          //          [settingsBtn setTitle:SETTINGS_BTN_3 forState:UIControlStateNormal];
          //          [logOutBtn setTitle:LOGOUT_BTN_3 forState:UIControlStateNormal];
          //          [transferPoints setTitle:TRANSFER_POINTS_BTN_3 forState:UIControlStateNormal];
          //          [contactsBtn setTitle:CONTACTS_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          loadingTitle = Loading_4;
          loadingTitle = Loading_4;
          lblhistory.text = HISTORY_BTN_4;
          lblmesage.text = @"Ganhe Pontos Grátis";
          lblranking.text = @"Classificações";
          lblsetting.text = SETTINGS_BTN_4;
          lblaboutus.text = ABOUTUS_TEXT_4;
          lbllogout.text = LOGOUT_BTN_4;
          
          //          [homeBtn setTitle:HOME_BTN_4 forState:UIControlStateNormal];
          //          [topicsBtn setTitle:TOPICS_BTN_4 forState:UIControlStateNormal];
          //          [friendsBtn setTitle:FRIENDS_BTN_4 forState:UIControlStateNormal];
          //          [historyBtn setTitle:HISTORY_BTN_4 forState:UIControlStateNormal];
          //          [messageBtn setTitle:MESSAGE_BTN_4 forState:UIControlStateNormal];
          //          [discussionBtn setTitle:DISCUSSION_BTN_4 forState:UIControlStateNormal];
          //          [rankingBtn setTitle:RANKING_BTN_4 forState:UIControlStateNormal];
          //          [witsStoreBtn setTitle:WITS_STORE_BTN_4 forState:UIControlStateNormal];
          //          [settingsBtn setTitle:SETTINGS_BTN_4 forState:UIControlStateNormal];
          //          [logOutBtn setTitle:LOGOUT_BTN_4 forState:UIControlStateNormal];
          //          [transferPoints setTitle:TRANSFER_POINTS_BTN_4 forState:UIControlStateNormal];
          //
          //          [contactsBtn setTitle:CONTACTS_BTN_4 forState:UIControlStateNormal];
     }
     if (languageCode == 1) {
          homeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          topicsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          friendsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          discussionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          rankingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          witsStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          settingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          logOutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          transferPoints.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
          contactsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     }else{
          homeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          topicsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          friendsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          discussionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          rankingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          witsStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          settingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          logOutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          transferPoints.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          contactsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     }
     //[self Frames];
}

-(void)Frames{
     
     if (IS_IPAD) {
          if (languageCode == 1) {
               homeImg.frame = CGRectMake(230, 150, 40, 40);
               topicsImg.frame = CGRectMake(230, 218, 40, 40);
               friendsImg.frame = CGRectMake(230, 278, 40, 40);
               historyImg.frame = CGRectMake(230, 341, 40, 40);
               messagesImg.frame = CGRectMake(230, 421, 40, 40);
               rankingImg.frame = CGRectMake(230, 484, 40, 40);
               storeImg.frame = CGRectMake(230, 569, 40, 40);
               settingsImg.frame = CGRectMake(230, 654, 40, 40);
               transferPointImg.frame = CGRectMake(230, 718, 40, 40);
               contactUsimg.frame = CGRectMake(230, 716, 40, 40);
               logoutImg.frame = CGRectMake(230, 786, 40, 40);
               
               namelbl.frame = CGRectMake(10, 22, 148, 58);
               isVerfiedlbl.textAlignment = NSTextAlignmentLeft;
               isVerfiedlbl.frame = CGRectMake(20, 109, 130, 30);
               userRankingLbl.frame = CGRectMake(10, 69, 130, 41);
               updateProfile.frame = CGRectMake(10, 10, 157, 108);
               
               ProfileImgOutlet.frame = CGRectMake(178, 13, 110, 110);
               profileImageView.frame = CGRectMake(178, 13, 110, 110);
               namelbl.textAlignment = NSTextAlignmentCenter;
               userRankingLbl.textAlignment = NSTextAlignmentCenter;
               
               homeBtn.frame = CGRectMake(28, 152, 182, 41);
               topicsBtn.frame = CGRectMake(28, 216, 182, 41);
               friendsBtn.frame = CGRectMake(28, 276, 182, 41);
               historyBtn.frame = CGRectMake(28, 339, 182, 41);
               messageBtn.frame = CGRectMake(28, 419, 182, 41);
               rankingBtn.frame = CGRectMake(28, 482, 182, 41);
               storeBtn.frame = CGRectMake(28, 562, 182, 41);
               settingsBtn.frame = CGRectMake(28, 652, 182, 41);
               transferPoints.frame = CGRectMake(28, 710, 182, 41);
               contactsBtn.frame = CGRectMake(28, 716, 182, 41);
               logOutBtn.frame = CGRectMake(28, 787, 182, 41);
               colorRing.frame = CGRectMake(178, 11, 116, 115);
               
          }else{
               homeImg.frame = CGRectMake(28, 153, 40, 40);
               topicsImg.frame = CGRectMake(28, 218, 40, 40);
               friendsImg.frame = CGRectMake(28, 278, 40, 40);
               historyImg.frame = CGRectMake(28, 341, 40, 40);
               messagesImg.frame = CGRectMake(28, 421, 40, 40);
               rankingImg.frame = CGRectMake(28, 484, 40, 40);
               storeImg.frame = CGRectMake(28, 569, 40, 40);
               settingsImg.frame = CGRectMake(28, 654, 40, 40);
               transferPointImg.frame = CGRectMake(28, 718, 40, 40);
               contactUsimg.frame = CGRectMake(28, 717, 40, 40);
               logoutImg.frame = CGRectMake(28, 789, 40, 40);
               
               namelbl.frame = CGRectMake(138, 22, 148, 58);
               isVerfiedlbl.frame = CGRectMake(139, 109, 130, 30);
               userRankingLbl.frame = CGRectMake(139, 69, 130, 41);
               profileImageView.frame = CGRectMake(15, 13, 110, 110);
               ProfileImgOutlet.frame = CGRectMake(10, 13, 110, 110);
               
               homeBtn.frame = CGRectMake(96, 148, 182, 41);
               topicsBtn.frame = CGRectMake(96, 216, 182, 41);
               friendsBtn.frame = CGRectMake(96, 276, 182, 41);
               historyBtn.frame = CGRectMake(96, 339, 182, 41);
               messageBtn.frame = CGRectMake(96, 419, 182, 41);
               rankingBtn.frame = CGRectMake(96, 482, 182, 41);
               storeBtn.frame = CGRectMake(96, 562, 182, 41);
               settingsBtn.frame = CGRectMake(96, 652, 182, 41);
               transferPoints.frame = CGRectMake(96, 710, 182, 41);
               contactsBtn.frame = CGRectMake(96, 716, 182, 41);
               logOutBtn.frame = CGRectMake(96, 787, 182, 41);
               colorRing.frame = CGRectMake(11, 11, 116, 115);
          }
     }else if(IS_IPHONE_4){
          if (languageCode == 1) {
               //               [RightBarVC getInstance].view.autoresizingMask = UIViewAutoresizingNone;
               //
               //
               //               homeImg.frame = CGRectMake(180, 84, 20, 20);
               //               topicsImg.frame = CGRectMake(180, 118, 20, 20);
               //               friendsImg.frame = CGRectMake(180, 153, 20, 20);
               //               historyImg.frame = CGRectMake(180, 186, 20, 20);
               //               messagesImg.frame = CGRectMake(180, 230, 20, 20);
               //               rankingImg.frame = CGRectMake(180, 267, 20, 20);
               //               storeImg.frame = CGRectMake(180, 315, 20, 20);
               //               settingsImg.frame = CGRectMake(180, 358, 20, 20);
               //               transferPointImg.frame = CGRectMake(180, 392, 20, 20);
               //               contactUsimg.frame = CGRectMake(180, 426, 20, 20);
               //               logoutImg.frame = CGRectMake(180, 460, 20, 20);
               //
               namelbl.frame = CGRectMake(9, 14, 120, 22);
               profileImageView.frame = CGRectMake(140, 5, 58, 60);
               ProfileImgOutlet.frame = CGRectMake(160, 7, 70, 58);
               updateProfile.frame= CGRectMake(8, 8, 120, 58);
               userRankingLbl.frame = CGRectMake(9, 38, 120, 22);
               
               namelbl.textAlignment = NSTextAlignmentRight;
               userRankingLbl.textAlignment = NSTextAlignmentRight;
               isVerfiedlbl.textAlignment = NSTextAlignmentLeft;
               //
               //
               //               homeBtn.frame = CGRectMake(20, 85, 147, 22);
               //               topicsBtn.frame = CGRectMake(20, 117, 147, 22);
               //               friendsBtn.frame = CGRectMake(20, 152, 147, 22);
               //               historyBtn.frame = CGRectMake(20, 185, 147, 22);
               //               messageBtn.frame = CGRectMake(20, 229, 147, 22);
               //               rankingBtn.frame = CGRectMake(20, 266, 147, 22);
               //               storeBtn.frame = CGRectMake(20, 314, 147, 22);
               //               settingsBtn.frame = CGRectMake(20, 357, 147, 22);
               //               transferPoints.frame = CGRectMake(20, 391, 147, 22);
               //               contactsBtn.frame = CGRectMake(20, 425, 147, 22);
               //               logOutBtn.frame = CGRectMake(20, 459, 147, 22);
               //
               //
          }else{
               //
               //               homeImg.frame = CGRectMake(20, 84, 20, 20);
               //               topicsImg.frame = CGRectMake(20, 118, 20, 20);
               //               friendsImg.frame = CGRectMake(20, 153, 20, 20);
               //               historyImg.frame = CGRectMake(20, 186, 20, 20);
               //               messagesImg.frame = CGRectMake(20, 230, 20, 20);
               //               rankingImg.frame = CGRectMake(20, 267, 20, 20);
               //               storeImg.frame = CGRectMake(20, 315, 20, 20);
               //               settingsImg.frame = CGRectMake(20, 358, 20, 20);
               //               transferPointImg.frame = CGRectMake(20, 392, 20, 20);
               //               contactUsimg.frame = CGRectMake(20, 426, 20, 20);
               //               logoutImg.frame = CGRectMake(20, 460, 20, 20);
               //
               namelbl.frame = CGRectMake(90, 14, 120, 22);
               profileImageView.frame = CGRectMake(24, 5, 58, 60);
               ProfileImgOutlet.frame = CGRectMake(16, 7, 70, 58);
               updateProfile.frame= CGRectMake(89, 8, 120, 58);
               
               userRankingLbl.frame = CGRectMake(90, 38, 120, 22);
               namelbl.textAlignment = NSTextAlignmentLeft;
               userRankingLbl.textAlignment = NSTextAlignmentLeft;
               isVerfiedlbl.textAlignment = NSTextAlignmentRight;
               //
               //               homeBtn.frame = CGRectMake(53, 85, 147, 22);
               //               topicsBtn.frame = CGRectMake(53, 117, 147, 22);
               //               friendsBtn.frame = CGRectMake(53, 152, 147, 22);
               //               historyBtn.frame = CGRectMake(53, 185, 147, 22);
               //               messageBtn.frame = CGRectMake(53, 229, 147, 22);
               //               rankingBtn.frame = CGRectMake(53, 266, 147, 22);
               //               storeBtn.frame = CGRectMake(53, 314, 147, 22);
               //               settingsBtn.frame = CGRectMake(53, 357, 147, 22);
               //               transferPoints.frame = CGRectMake(53, 391, 147, 22);
               //               contactsBtn.frame = CGRectMake(53, 425, 147, 22);
               //               logOutBtn.frame = CGRectMake(53, 459, 147, 22);
          }
     }else {
          if (languageCode == 1) {
               [RightBarVC getInstance].view.autoresizingMask = UIViewAutoresizingNone;
               homeImg.frame = CGRectMake(180, 90, 20, 20);
               topicsImg.frame = CGRectMake(180, 127, 20, 20);
               friendsImg.frame = CGRectMake(180, 162, 20, 20);
               historyImg.frame = CGRectMake(180, 197, 20, 20);
               messagesImg.frame = CGRectMake(180, 243, 20, 20);
               rankingImg.frame = CGRectMake(180, 282, 20, 20);
               storeImg.frame = CGRectMake(180, 332, 20, 20);
               settingsImg.frame = CGRectMake(180, 377, 20, 20);
               transferPointImg.frame = CGRectMake(180, 413, 20, 20);
               contactUsimg.frame = CGRectMake(180, 413, 20, 20);
               logoutImg.frame = CGRectMake(180, 449, 20, 20);
               
               namelbl.frame = CGRectMake(9, 14, 120, 22);
               profileImageView.frame = CGRectMake(140, 5, 58, 60);
               ProfileImgOutlet.frame = CGRectMake(160, 7, 70, 58);
               updateProfile.frame= CGRectMake(8, 8, 120, 58);
               userRankingLbl.frame = CGRectMake(9, 38, 120, 22);
               
               namelbl.textAlignment = NSTextAlignmentRight;
               userRankingLbl.textAlignment = NSTextAlignmentRight;
               isVerfiedlbl.textAlignment = NSTextAlignmentLeft;
               
               homeBtn.frame = CGRectMake(20, 91, 147, 22);
               topicsBtn.frame = CGRectMake(20, 125, 147, 22);
               friendsBtn.frame = CGRectMake(20, 162, 147, 22);
               historyBtn.frame = CGRectMake(20, 197, 147, 22);
               messageBtn.frame = CGRectMake(20, 242, 147, 22);
               rankingBtn.frame = CGRectMake(20, 281, 147, 22);
               storeBtn.frame = CGRectMake(20, 331, 147, 22);
               settingsBtn.frame = CGRectMake(20, 376, 147, 22);
               transferPoints.frame = CGRectMake(20, 391, 147, 22);
               contactsBtn.frame = CGRectMake(20, 412, 147, 22);
               logOutBtn.frame = CGRectMake(20, 448, 147, 22);
               colorRing.frame = CGRectMake(138, 5, 62, 63);
               
          }else{
               [RightBarVC getInstance].view.autoresizingMask = UIViewAutoresizingNone;
               homeImg.frame = CGRectMake(18, 90, 22, 20);
               topicsImg.frame = CGRectMake(20, 124, 20, 20);
               friendsImg.frame = CGRectMake(20, 159, 20, 20);
               historyImg.frame = CGRectMake(20, 192, 20, 20);
               messagesImg.frame = CGRectMake(20, 246, 20, 20);
               rankingImg.frame = CGRectMake(20, 283, 20, 20);
               storeImg.frame = CGRectMake(20, 331, 20, 20);
               settingsImg.frame = CGRectMake(20, 374, 20, 20);
               transferPointImg.frame = CGRectMake(20, 408, 20, 20);
               contactUsimg.frame = CGRectMake(20, 408, 20, 20);
               logoutImg.frame = CGRectMake(20, 442, 20, 20);
               
               namelbl.frame = CGRectMake(90, 14, 120, 22);
               profileImageView.frame = CGRectMake(24, 5, 58, 60);
               ProfileImgOutlet.frame = CGRectMake(16, 7, 70, 58);
               updateProfile.frame= CGRectMake(89, 8, 120, 58);
               
               namelbl.textAlignment = NSTextAlignmentLeft;
               userRankingLbl.textAlignment = NSTextAlignmentLeft;
               isVerfiedlbl.textAlignment = NSTextAlignmentRight;
               
               homeBtn.frame = CGRectMake(53, 91, 147, 22);
               topicsBtn.frame = CGRectMake(53, 123, 147, 22);
               friendsBtn.frame = CGRectMake(53, 158, 147, 22);
               historyBtn.frame = CGRectMake(53, 191, 147, 22);
               messageBtn.frame = CGRectMake(53, 245, 147, 22);
               rankingBtn.frame = CGRectMake(53, 282, 147, 22);
               storeBtn.frame = CGRectMake(53, 330, 147, 22);
               settingsBtn.frame = CGRectMake(53, 373, 147, 22);
               transferPoints.frame = CGRectMake(53, 407, 147, 22);
               contactsBtn.frame = CGRectMake(53, 407, 147, 22);
               logOutBtn.frame = CGRectMake(53, 441, 147, 22);
               colorRing.frame = CGRectMake(22, 5, 62, 63);
          }
     }
     
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
     CLLocation *newLocation = [locations lastObject];
     [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
          if (error == nil&& [placemarks count] >0) {
               placemark = [placemarks lastObject];
               NSString *latitude, *longitude, *state, *country;
               latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
               longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
               state = placemark.administrativeArea;
               country = placemark.country;
               userRankingLbl.text = [NSString stringWithFormat:@"%@, %@", state, country];
               
          } else {
               NSLog(@"%@", error.debugDescription);
          }
     }];
     // Turn off the location manager to save power.
     [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
     NSLog(@"Cannot find the location.");
}

@end
