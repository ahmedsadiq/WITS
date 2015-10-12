//
//  NavigationHandler.h
//  Yolo
//
//  Created by Salman Khalid on 13/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Challenge.h"
#import "MessageThreads.h"
#import "HomeVC.h"
#import "GetTopicsVC.h"

@interface NavigationHandler : NSObject{
    
    UINavigationController *navController;
    UIWindow *_window;
}

@property ( strong , nonatomic ) UITabBarController *tabBarController;
@property (strong, nonatomic) GetTopicsVC *viewController;
@property ( strong , nonatomic ) UINavigationController *navigationController;

-(id)initWithMainWindow:(UIWindow *)_tempWindow;
-(void)loadFirstVC;

+(NavigationHandler *)getInstance;
-(void)NavigateToHomeScreen;

-(void)MoveToRanking;
-(void)MoveToTransferPoints;
-(void)NavigateToSignUpScreen;
-(void)NavigateToRoot;
-(void)MoveToTopics;
-(void)MoveToHistory;
-(void)MoveToStore;
-(void)MoveToSetting;
-(void)MoveToFriends;
-(void)MoveToUpdateProfile;
-(void)MoveToMessages;
-(void)MoveToDiscussion;
-(void)MoveToContactUs;
-(void)MoveToTimeLine;
-(void)MoveToEarnFreePoint;
-(void)MoveToChallenge:(Challenge *)_challengeDetail;
-(void)MoveToPurchaseController;
-(void)LogOutUserOnInvalidSession;
-(void)openConversation:(MessageThreads *)tempThread;
-(void)MoveToChallenge:(Challenge *)_challengeDetail andRecieved :(BOOL) isRecieved;
-(void)MoveToAddOnVC;
-(void)MoveToRewardsVC;
-(void)NavigateToSignUp;
@end
