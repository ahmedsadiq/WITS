//
//  PushNotificationCenter.h
//  Yolo
//
//  Created by Nisar Ahmad on 05/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "SocketManager.h"
#import "NotifAlertMessage.h"
#import "CustomLoading.h"

enum{
     CHALLENGE_NOTIFICATION_TYPE = 0,
     FRIEND_REQUEST_TYPE = 1,
     CHAT_MESSAGE_TYPE = 2,
     POINTS_RECIEVED_TYPE = 4,
     BROADCAST_NOTIF_TYPE = 6,
     REMATCH_TYPE =5,
     TEMP_TYPE = 1024
     //type=3 for discussion and type=2 for chat and type=1 for friend challenge
};
typedef NSUInteger CurrentNotificationType;

@interface PushNotificationCenter : NSObject<SocketManagerDelegate,NotifAlertMessageDelegate>{
     
     NSDictionary *challengeDIctionary;
     NSInteger currentSelectedIndex;
     NSDictionary *messageDictionary;
     int Tag ;
     NSString *challengeID;
     
     UIImageView *searchingicon;
     
     NotifAlertMessage *notif;
     CurrentNotificationType _currentType;
     NSDictionary *dictChallenge;
     NSString *language;
     int languageCode;
     
     /////by fiza////
     UIView *challengeView;
     CustomLoading *customSerachView;
     NSString *opponentsenderImage;
     NSString *opposenderName;
     UIImageView *sample;
     UILabel *searchLbl;
     BOOL isChallengeAccepted;
     NSString *type;
     NSString *type_id;
     int eventId;
     NSTimer *timer;
     BOOL isOpponentFound;
     int timeSinceTimer;
}

+(PushNotificationCenter *)getInstance;

-(void)AnalyzeNotification:(NSDictionary *)notification;
@property (strong, nonatomic) SocketManager *sharedManager;
@end
