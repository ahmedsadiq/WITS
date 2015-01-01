//
//  AppDelegate.h
//  Yolo
//
//  Created by Salman Khalid on 03/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
     AVAudioPlayer*  audioPlayer;
     SystemSoundID mBeep;
     int languageCode;
     
     
}
@property (strong, nonatomic) UserProfile *friendToBeChalleneged;
@property (strong, nonatomic) UIWindow *window;
@property BOOL isChatNotificationOn;
@property BOOL isFriendRequest;
@property BOOL isFirstTime;
@property BOOL isLanguageChanged;
@property BOOL isGameInProcess;
@property BOOL isAlreadyFetched;
@property BOOL isStore;
@property BOOL isChallengeCancelled;
@property BOOL isGameOver;
@property BOOL resetToHomeScreen;
@property BOOL fromHomeScreen;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) NSString *transferPointsEmail;
@property (strong, nonatomic) NSString *LoginEmail;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

@property BOOL isInbox;
+(NSString *)getDeviceToken;
-(void) musicSwitch :(BOOL)isON;
@end
