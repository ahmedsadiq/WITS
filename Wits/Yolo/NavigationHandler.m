//
//  NavigationHandler.m
//  Yolo
//
//  Created by Salman Khalid on 13/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "NavigationHandler.h"
#import "MainSingnUpVC.h"
#import "SharedManager.h"
#import "Utils.h"
#import "HistoryVC.h"
#import "StoreVC.h"
#import "SettingVC.h"
#import "FriendsVC.h"
#import "UpdateProfileVC.h"
#import "MessagesVC.h"
#import "DiscussionVC.h"
#import "ChallengeVC.h"
#import "PurchaseVC.h"
#import "EarnFreePointsViewController.h"
#import "ConversationVC.h"
#import "HistoryViewController.h"
#import "TransferPointsViewController.h"
#import "ContactUsViewController.h"
#import "ChatVC.h"
#import "Tutorial.h"
#import "AddOnViewController.h"
#import "RewardsListVC.h"
#import "MKNetworkEngine.h"
#import "MKNetworkOperation.h"
#import "SignUpVC.h"
#import "RightBarVC.h"


@implementation NavigationHandler

- (id)initWithMainWindow:(UIWindow *)_tempWindow{
     
     if(self = [super init])
     {
          _window = _tempWindow;
     }
     instance = self;
     return self;
}

static NavigationHandler *instance= NULL;

+(NavigationHandler *)getInstance
{
     return instance;
}





-(void)loadFirstVC{
     
     if([SharedManager getInstance].userID)
     {
          if(IS_IPAD){
               self.viewController = [[GetTopicsVC alloc] initWithNibName:@"GetTopicsVC_iPad" bundle:nil];
               
               
               
          }
          else {
               self.viewController = [[GetTopicsVC alloc] initWithNibName:@"GetTopicsVC" bundle:nil];
          }
          
          
          self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
          
          [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"homeglow.png"]
                                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] ];
          
          [self.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
           ];
          self.navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
          if(IS_IPAD)
          {
               [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"homeglowForIpad.png"]
                                                                       imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
               
               [self.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"homeForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
              self.navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, -30, 15, 30);
               
          }
          
          [self.navigationController setNavigationBarHidden:YES animated:NO];
          
          UIViewController *friendsVC;
          
          if(IS_IPAD) {
               friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC_iPad" bundle:[NSBundle mainBundle]];
          }
          else {
               friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC" bundle:[NSBundle mainBundle]];
          }
          UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsVC];
          
          
          [friendsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"friendsglow1.png"]
                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [friendsVC.tabBarItem setImage:[[UIImage imageNamed:@"friends.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          friendsVC.tabBarItem.imageInsets =   UIEdgeInsetsMake(6, 0, -6, 0);
          if(IS_IPAD)
               
          {
               [friendsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"friendsglowForIpad.png"]
                                                       imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
               [friendsVC.tabBarItem setImage:[[UIImage imageNamed:@"friendsForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
               friendsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, -30, 15,30);
               
          }
          
          
          [friendsVC.navigationController setNavigationBarHidden:YES animated:NO];
          
          UIViewController *storeVC;
          if(IS_IPAD) {
               storeVC = [[StoreVC alloc] initWithNibName:@"StoreVC_iPad" bundle:[NSBundle mainBundle]];
          }
          else {
               storeVC = [[StoreVC alloc] initWithNibName:@"StoreVC" bundle:[NSBundle mainBundle]];
          }
          UINavigationController *storeNavController = [[UINavigationController alloc] initWithRootViewController:storeVC];
          
          [storeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shopglow.png"]
                                                imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [storeVC.tabBarItem setImage:[[UIImage imageNamed:@"shop.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          storeVC.tabBarItem.imageInsets =  UIEdgeInsetsMake(6, 0, -6, 0);
          if(IS_IPAD){
               [storeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shopglowForIpad.png"]
                                                     imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
               [storeVC.tabBarItem setImage:[[UIImage imageNamed:@"shopForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
               storeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, -20, 15, 20);
               
          }
          
          [storeVC.navigationController setNavigationBarHidden:YES animated:NO];
          UIViewController *rewardsVC;
          
        //  UIViewController *historyViewController;
          
          if(IS_IPAD) {
               rewardsVC = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC_iPad" bundle:[NSBundle mainBundle]];
          }
          else {
               rewardsVC = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC" bundle:[NSBundle mainBundle]];
          }
          UINavigationController *historyNavController = [[UINavigationController alloc] initWithRootViewController:rewardsVC];
          
          [rewardsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"rewardsglowp.png"]
                                                              imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [rewardsVC.tabBarItem setImage:[[UIImage imageNamed:@"rewardsp.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          rewardsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
          if(IS_IPAD)
          {
               [rewardsVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"referglowForIpad.png"]
                                                                   imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
               [rewardsVC.tabBarItem setImage:[[UIImage imageNamed:@"referforIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
               rewardsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0);
               
          }

          
          [rewardsVC.navigationController setNavigationBarHidden:YES animated:NO];
          
          
          UIViewController *settingVC;
          if(IS_IPAD) {
               settingVC = [[RightBarVC alloc] initWithNibName:@"RightBarVC_iPad" bundle:[NSBundle mainBundle]];
          }
          else {
               settingVC = [[RightBarVC alloc] initWithNibName:@"RightBarVC" bundle:[NSBundle mainBundle]];
          }
          
          UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingVC];
          
          [settingVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menuglow.png"]
                                                  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
          [settingVC.tabBarItem setImage:[[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
          settingsNavController.tabBarItem.imageInsets =  UIEdgeInsetsMake(6, 0, -6, 0);
          if(IS_IPAD){
               [settingVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"menuglowForIpad.png"]
                                                       imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
               [settingVC.tabBarItem setImage:[[UIImage imageNamed:@"menuForIpad.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
               settingsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 30, 15, -30);
               
          }
          
          
          
          [settingVC.navigationController setNavigationBarHidden:YES animated:NO];
          
          
          self.tabBarController = [[UITabBarController alloc] init] ;
          self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.navigationController, friendsNavController,storeNavController,historyNavController,settingsNavController,nil];
          [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"menubg.png"]];
          if(IS_IPAD) {
               [self.tabBarController.tabBar setShadowImage:[[UIImage alloc] init]];
               [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"menubgForIpad.png"]];
               //[self.tabBarController.tabBar setClipsToBounds:YES];
          }
          self.viewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
          [[[UIApplication sharedApplication]delegate] window].rootViewController = self.tabBarController;
          
          
          
     }else
     {
          MainSingnUpVC *signUpViewController;
          if(IS_IPAD){
               signUpViewController = [[MainSingnUpVC alloc] initWithNibName:@"MainSignUpVC_iPad" bundle:nil];
          }
          else {
               signUpViewController = [[MainSingnUpVC alloc] initWithNibName:@"MainSingnUpVC" bundle:nil];
          }
          
          self.navigationController = [[UINavigationController alloc] initWithRootViewController:signUpViewController];
          self.navigationController.navigationBar.hidden = YES;
          [[[UIApplication sharedApplication]delegate] window].rootViewController = self.navigationController;
          [[[[UIApplication sharedApplication]delegate] window] makeKeyAndVisible];
     }
}

-(void)NavigateToTutorial{
     
     navController = nil;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          Tutorial *homeVC1 = [[Tutorial alloc] initWithNibName:@"Tutorial" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:homeVC1];
     }
     
     else{
          
          Tutorial *homeVC2 = [[Tutorial alloc] initWithNibName:@"Tutorial" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:homeVC2];
     }
     
     _window.rootViewController = navController;
     
}
-(void)NavigateToSignUp{
     
     navController = nil;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          SignUpVC *homeVC1 = [[SignUpVC alloc] initWithNibName:@"SignUpVC_iPad" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:homeVC1];
     }
     
     else{
          
          SignUpVC *homeVC2 = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:homeVC2];
     }
     
     _window.rootViewController = navController;
     
}



-(void)NavigateToHomeScreen{
     
     navController = nil;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          HomeVC *homeVC1 = [[HomeVC alloc] initWithNibName:@"HomeVC_iPad" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:homeVC1];
     }
     
     else{
          
          HomeVC *homeVC2 = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:homeVC2];
     }
     
     _window.rootViewController = navController;
     
}

-(void)NavigateToSignUpScreen{
     
     navController = nil;
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          MainSingnUpVC *_main1 = [[MainSingnUpVC alloc] initWithNibName:@"MainSignUpVC_iPad" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:_main1];
     }
     else{
          MainSingnUpVC *_main2 = [[MainSingnUpVC alloc] initWithNibName:@"MainSingnUpVC" bundle:nil];
          navController = [[UINavigationController alloc] initWithRootViewController:_main2];
     }
     _window.rootViewController = navController;
}
-(void)MoveToTopics{
     
     [navController popToRootViewControllerAnimated:NO];
     [SharedManager getInstance].isFriendListSelected = NO;
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
     {
          
          GetTopicsVC *topic = [[GetTopicsVC alloc] initWithNibName:@"GetTopicsVC_iPad" bundle:nil];
          [navController pushViewController:topic animated:YES];
     }
     
     else
     {
          
          GetTopicsVC *topic1 = [[GetTopicsVC alloc] initWithNibName:@"GetTopicsVC" bundle:nil];
          [navController pushViewController:topic1 animated:YES];
          
     }
     
}

-(void)MoveToHistory{
     
     [navController popToRootViewControllerAnimated:NO];
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          HistoryVC *historyVC1 = [[HistoryVC alloc] initWithNibName:@"HistoryVC_iPad" bundle:nil];
          [navController pushViewController:historyVC1 animated:YES];
     }
     else{
          
          HistoryVC *historyVC = [[HistoryVC alloc] initWithNibName:@"HistoryVC" bundle:nil];
          [navController pushViewController:historyVC animated:YES];
     }
}
-(void)MoveToEarnFreePoint{
     
     [navController popToRootViewControllerAnimated:NO];
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          EarnFreePointsViewController *historyVC1 = [[EarnFreePointsViewController alloc] initWithNibName:@"EarnFreePointsViewController_iPad" bundle:nil];
          [navController pushViewController:historyVC1 animated:YES];
     }
     else{
          
          EarnFreePointsViewController *historyVC = [[EarnFreePointsViewController alloc] initWithNibName:@"EarnFreePointsViewController" bundle:nil];
          [navController pushViewController:historyVC animated:YES];
     }
}

-(void)NavigateToRoot{
     
     [navController popToRootViewControllerAnimated:YES];
}

-(void)MoveToStore{
     
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          StoreVC *storeVC1 = [[StoreVC alloc] initWithNibName:@"StoreVC_iPad" bundle:nil];
          [navController pushViewController:storeVC1 animated:NO];
     }
     else{
          
          StoreVC *storeVC2 = [[StoreVC alloc] initWithNibName:@"StoreVC" bundle:nil];
          [navController pushViewController:storeVC2 animated:NO];
          
     }
     
}

-(void)MoveToSetting{
     
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          SettingVC *setting = [[SettingVC alloc] initWithNibName:@"SettingVC_iPad" bundle:nil];
          [navController pushViewController:setting animated:YES];
     }
     else{
          
          SettingVC *setting = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
          [navController pushViewController:setting animated:YES];
     }
}
-(void)MoveToTransferPoints{
     
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          TransferPointsViewController *setting = [[TransferPointsViewController alloc] initWithNibName:@"TransferPointsViewController_iPad" bundle:nil];
          [navController pushViewController:setting animated:YES];
     }
     else{
          
          TransferPointsViewController *setting = [[TransferPointsViewController alloc] initWithNibName:@"TransferPointsViewController" bundle:nil];
          [navController pushViewController:setting animated:YES];
     }
}

-(void)MoveToFriends{
     
     [navController popToRootViewControllerAnimated:NO];
     [SharedManager getInstance].isFriendListSelected = NO;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          FriendsVC *_friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC_iPad" bundle:nil];
          [navController pushViewController:_friendsVC animated:YES];
     }
     else{
          
          FriendsVC *_friendsVC = [[FriendsVC alloc] initWithNibName:@"FriendsVC" bundle:nil];
          [navController pushViewController:_friendsVC animated:YES];
     }
     
}
-(void)MoveToContactUs{
     
     [navController popToRootViewControllerAnimated:NO];
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          ContactUsViewController *_friendsVC = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController_iPad" bundle:nil];
          [navController pushViewController:_friendsVC animated:YES];
     }
     else{
          
          ContactUsViewController *_friendsVC = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
          [navController pushViewController:_friendsVC animated:YES];
     }
}

-(void)MoveToUpdateProfile{
     
     //[navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          UpdateProfileVC *update = [[UpdateProfileVC alloc] initWithNibName:@"UpdateProfileVC_iPad" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     else{
          
          UpdateProfileVC *update = [[UpdateProfileVC alloc] initWithNibName:@"UpdateProfileVC" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     
}


-(void)MoveToMessages{
     
     [navController popToRootViewControllerAnimated:NO];
     
     MessagesVC *messageVC = [[MessagesVC alloc] init];
     [navController pushViewController:messageVC animated:YES];
     
}


-(void)openConversation:(MessageThreads *)tempThread{
     [navController popToRootViewControllerAnimated:NO];
     
     ConversationVC *conver = [[ConversationVC alloc] initWithThread:tempThread];
     conver.headerTitle = @"Messages";
     [navController pushViewController:conver animated:YES];
     
}


-(void)MoveToDiscussion{
     
     [navController popToRootViewControllerAnimated:NO];
     
     DiscussionVC *discussion = [[DiscussionVC alloc] initWithSub_Topic:nil];
     discussion.isNewDiscussion = NO;
     [navController pushViewController:discussion animated:YES];
     
}
-(void)MoveToRanking{
     
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          HistoryViewController *update = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController_iPad" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     else{
          
          HistoryViewController *update = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     
}


-(void)MoveToChallenge:(Challenge *)_challengeDetail{
     
     [navController popToRootViewControllerAnimated:NO];
     
     ChallengeVC *_challenge = [[ChallengeVC alloc] initWithChallenge:_challengeDetail];
     [navController pushViewController:_challenge animated:YES];
     
}

-(void)MoveToChallenge:(Challenge *)_challengeDetail andRecieved :(BOOL) isRecieved{
     
     [navController popToRootViewControllerAnimated:NO];
     
     ChallengeVC *_challenge = [[ChallengeVC alloc] initWithChallenge:_challengeDetail andRecieved:true];
     [navController pushViewController:_challenge animated:YES];
     
}


-(void)MoveToPurchaseController{
     
     [navController popToRootViewControllerAnimated:NO];
     
     PurchaseVC *purchase = [[PurchaseVC alloc] init];
     [navController pushViewController:purchase animated:YES];
}


-(void)LogOutUserOnInvalidSession{
     
     [[SharedManager getInstance] ResetModel];
     if([SharedManager getInstance].userID != nil)
          [self sendOnlineStatusCall:@"0"];
     [self NavigateToSignUpScreen];
     
}

-(void)sendOnlineStatusCall:(NSString *)_status{
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"onlineStatus" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:_status forKey:@"online_status"];
     
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     
     [operation onCompletion:^(MKNetworkOperation *completedOperation){
          
          NSDictionary *mainDict = [completedOperation responseJSON];
          
          
     }
                     onError:^(NSError *error){
                          
                          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
                          int languageCode = [language intValue];
                          NSString *emailMsg;
                          NSString *title;
                          NSString *cancel;
                          if (languageCode == 0 ) {
                               emailMsg = @"Check your internet connection setting.";
                               title = @"Error";
                               cancel = CANCEL;
                          } else if(languageCode == 1) {
                               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                               title = @"خطأ";
                               cancel = CANCEL_1;
                          }else if (languageCode == 2){
                               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
                               title = @"Erreur";
                               cancel = CANCEL_2;
                          }else if (languageCode == 3){
                               emailMsg = @"Revise su configuración de conexión a Internet.";
                               title = @"Error";
                               cancel = CANCEL_3;
                          }else if (languageCode == 4){
                               emailMsg = @"Verifique sua configuração de conexão à Internet";
                               title = @"Erro";
                               cancel = CANCEL_4;
                          }
                          
                          
                          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                          
                          /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                           
                           [alert show];*/
                          
                     }];
     
     [engine enqueueOperation:operation];
     
}


-(void)MoveToTimeLine {
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          ChatVC *update = [[ChatVC alloc] initWithNibName:@"ChatVC_iPad" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     else{
          
          ChatVC *update = [[ChatVC alloc] initWithNibName:@"ChatVC" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
}

-(void)MoveToAddOnVC {
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          AddOnViewController *update = [[AddOnViewController alloc] initWithNibName:@"AddOnViewController_iPad" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     else{
          
          AddOnViewController *update = [[AddOnViewController alloc] initWithNibName:@"AddOnViewController" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
}
-(void)MoveToRewardsVC {
     [navController popToRootViewControllerAnimated:NO];
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          RewardsListVC *update = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC_iPad" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
     else{
          
          RewardsListVC *update = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC" bundle:nil];
          [navController pushViewController:update animated:YES];
     }
}




@end
