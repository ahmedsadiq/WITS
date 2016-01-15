//
//  AppDelegate.m
//  Yolo
//
//  Created by Salman Khalid on 03/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Utils.h"
#import "NavigationHandler.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "PushNotificationCenter.h"
#import <AudioToolbox/AudioToolbox.h>
#import "iRate.h"
#import "UserProfile.h"
#import "AlertMessage.h"
#import "AddOnViewSelected.h"

static NSString *_deviceToken = NULL;

@implementation AppDelegate
@synthesize profileImage,isChatNotificationOn,transferPointsEmail,isFirstTime,isLanguageChanged,isGameInProcess,isInbox,LoginEmail,isAlreadyFetched,isStore,selectedIndex,friendToBeChalleneged,isFriendRequest,requestType,isGameOver;
+(NSString *)getDeviceToken{
    
    return _deviceToken;
}

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"VIEW_CATEGORY";
NSString * const NotificationActionTwoIdent = @"CLOSE_CATEGORY";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     isInbox = false;
     isGameInProcess = false;
     isGameOver = false;

     
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    NavigationHandler *navHandler = [[NavigationHandler alloc] initWithMainWindow:self.window];
    [navHandler loadFirstVC];
    
    [self.window makeKeyAndVisible];
    
      [[NSUserDefaults standardUserDefaults] setObject:LoginEmail forKey:@"LoginEmail"];
      [[NSUserDefaults standardUserDefaults] synchronize];
     // The changes make sure that the FBLoginView class is loaded before the view is shown
    [FBLoginView class];
     
     [[UIApplication sharedApplication] registerForRemoteNotifications];
     
     if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
     {
          // iOS 8 Notifications
          //1. Create action buttons..:)
          
          UIMutableUserNotificationAction *viewAction = [[UIMutableUserNotificationAction alloc] init];
          viewAction.identifier = NotificationActionOneIdent;
          viewAction.title = @"View";
          viewAction.activationMode = UIUserNotificationActivationModeForeground;
          viewAction.destructive = NO;
          viewAction.authenticationRequired = YES;
          
     ///////second button
     
          UIMutableUserNotificationAction *closeAction = [[UIMutableUserNotificationAction alloc] init];
          closeAction.identifier = NotificationActionTwoIdent;
          closeAction.title = @"Decline";
          closeAction.activationMode = UIUserNotificationActivationModeBackground;
          closeAction.destructive = NO;
          closeAction.authenticationRequired = YES;
          
          //2. Then create the category to group actions.:)
          
          UIMutableUserNotificationCategory *actionCategory;
          actionCategory = [[UIMutableUserNotificationCategory alloc] init];
          [actionCategory setIdentifier:NotificationCategoryIdent];
          [actionCategory setActions:@[viewAction,closeAction]
                          forContext:UIUserNotificationActionContextDefault];
          
          //3. Then add categories into one set..:)
          NSSet *categories = [NSSet setWithObjects:actionCategory,nil];
          
          
          [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:categories]];
          [[UIApplication sharedApplication] registerForRemoteNotifications];
          
     }
     else
     {
          // iOS < 8 Notifications
          [application registerForRemoteNotificationTypes:
           (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
          
          UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
          [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
          [[UIApplication sharedApplication] registerForRemoteNotifications];
     }
     
    isFirstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTime"];
    if(!isFirstTime) {
        isChatNotificationOn = true;
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"music"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"vibration"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"challenge"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"chat"];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"isFirstTime"];
    
    }else {
        /*BOOL isMusicOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
        if(isMusicOn) {
            [self musicSwitch:true];
        }*/
    }
     ///  Launch Notification when the application is closed
     NSDictionary *userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
     [self showNotoficationAlert:userInfo];
     
     if (userInfo) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"UIApplicationLaunchOptionsRemoteNotificationKey" object:nil userInfo:userInfo];
     }
     
  
    return YES;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
     
     if ([identifier isEqualToString:NotificationActionOneIdent] ){
          [self showNotoficationAlert:userInfo];
     }
//          else if ([identifier isEqualToString:NotificationActionTwoIdent]){
//     
//     }
     
     if(completionHandler != nil)    //Finally call completion handler if its not nil
           // Must be called when finished
          completionHandler();
}


-(void) musicSwitch :(BOOL)isON {
    if(isON) {
        NSString* path;
        NSURL* url;
        path = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"];
        url = [NSURL fileURLWithPath:path];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        audioPlayer.delegate = self;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        audioPlayer.numberOfLoops =  -1;
        [audioPlayer play];
    }
    else {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
}
#pragma mark -
#pragma mark Did Recieve Remove Notofication

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error");
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *deviceToken1 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	deviceToken1 = [deviceToken1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    _deviceToken = deviceToken1;
     
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
     if(!isGameInProcess) {
           NSLog(@"Notification message: %@",[userInfo valueForKey:@"aps"]);
          
          if(application.applicationState != UIApplicationStateActive){
               [self showNotoficationAlert:userInfo];
          }else{
               [self showNotoficationAlert:userInfo];
          }
          completionHandler(UIBackgroundFetchResultNewData);
     }

}
-(void)showNotoficationAlert:(NSDictionary *)userInfo {
     
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationMessageReceivedNotification" object:nil userInfo:userInfo];
     
	if(userInfo)
	{
		NSDictionary *notification = [userInfo objectForKey:@"aps"]; // main dictionary
         NSString *alertMsg = @"";
         NSString *badge = @"";
         NSString *sound = @"";
         NSString *custom = @"";
         
         if( [notification objectForKey:@"alert"] != NULL)
         {
              alertMsg = [notification objectForKey:@"alert"];
         }
         
         
         if( [notification objectForKey:@"badge"] != NULL)
         {
              badge = [notification objectForKey:@"badge"];
         }
         
         
         if( [notification objectForKey:@"sound"] != NULL)
         {
              sound = [notification objectForKey:@"sound"];
         }
         
         if( [notification objectForKey:@"Custom"] != NULL)
         {
              custom = [notification objectForKey:@"Custom"];
         }
         
		if(userInfo)
		{
             BOOL isSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
             if(isSoundOn) {
                  [self playCorrectSound:@"beep.mp3" Loop: NO];
             }
            
             BOOL isMusicOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
             if(isMusicOn) {
                  [self musicSwitch:true];
             }
            PushNotificationCenter *instance = [PushNotificationCenter getInstance];
            [instance AnalyzeNotification:userInfo];
		}
	}
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    NSLog(@"URL Scheme: %@",[url scheme]);
    
    if([[url scheme] isEqualToString:GOOGlE_SCHEME])
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    else if([[url scheme] isEqualToString:FACEBOOK_SCHEME])
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        
    return false;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    if([SharedManager getInstance].userID != nil)
//        [self sendOnlineStatusCall:@"0"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if([SharedManager getInstance].userID != nil)
        [self sendOnlineStatusCall:@"1"];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)sendOnlineStatusCall:(NSString *)_status{
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:@"onlineStatus" forKey:@"method"];
    [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
    [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
[postParams setObject:language forKey:@"language"];
    [postParams setObject:_status forKey:@"online_status"];
    
    
    MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
    
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation){
        
        NSDictionary *mainDict = [completedOperation responseJSON];
        NSLog(@"main dict %@",mainDict);
        
    }
                    onError:^(NSError *error){
                        
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
#pragma mark Sound Methods
-(BOOL) playCorrectSound: (NSString*) vSFXName Loop: (BOOL) vLoop
{
     NSError *error;
     
     NSBundle* bundle = [NSBundle mainBundle];
     
     NSString* bundleDirectory = (NSString*)[bundle bundlePath];
     
     NSURL *url = [NSURL fileURLWithPath:[bundleDirectory stringByAppendingPathComponent:vSFXName]];
     
     audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
     
     if(vLoop)
          audioPlayer.numberOfLoops = -1;
     else
          audioPlayer.numberOfLoops = 0;
     
     BOOL success = YES;
     
     if (audioPlayer == nil)
     {
          success = NO;
     }
     else
     {
          success = [audioPlayer play];
     }

     return success;
}
- (void)showRewards:(NSNotification *)notification {
     [[NavigationHandler getInstance] MoveToAddOnVC];
}
- (void)recieveInventoryUpdate:(NSNotification *)notification {
     int points = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
     points = points+100;
     
     NSString *totalPoints = [NSString stringWithFormat:@"%d",points];
     [[SharedManager getInstance] _userProfile].cashablePoints = totalPoints;
     //[cashablePoints setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"inAppPointsPurchase" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:@"100" forKey:@"purchased_point"];
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          NSDictionary *responseDict = [completedOperation responseJSON];
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               
          }
          
     } onError:^(NSError* error) {
          
          
     }];
     
     [engine enqueueOperation:op];
     
     if(points >= 100) {
          //Add Add On Screen here
          [[NavigationHandler getInstance] MoveToAddOnVC];
     }
}
- (void)recieveInventoryUpdateFailure:(NSNotification *)notification {
     //pointForPurchase = 0;
     
}


@end
