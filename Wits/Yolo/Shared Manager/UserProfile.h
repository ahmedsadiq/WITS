//
//  UserProfile.h
//  Yolo
//
//  Created by Salman Khalid on 19/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOT_FRIEND @"0"
#define ALREADY_FRIEND @"1"
#define ACCEPT_REQUEST @"2"
#define REQUEST_SENT @"3"


@interface UserProfile : NSObject{
    
    NSString *display_name;
    NSString *gender;
    NSString *birthday;
    NSString *about;
    NSString *profile_image;
    NSString *wallpaper;
    NSString *cur_countryID;
    NSString *cur_countryName;
    NSString *cityName;
    
    NSArray *titleArray;
    
    NSString *friendID;
    NSString *onlinestatus;
    NSString *RelationshipStatus;
    
    NSString *status;
    NSIndexPath *_IndexPath;
    BOOL isSelected;
    NSString *isVerfied;
    NSString *totalPoints;
    NSString *cashablePoints;
    
    NSString *referral_code;
    
    BOOL onlineStatus;
     int onlineStatusValue;
    
    NSDate *lastFetched;
    
    NSMutableArray *countries;
    NSMutableArray *achievements;
}
@property (nonatomic, retain) NSMutableArray *countries;
@property (nonatomic, retain) NSMutableArray *achievements;
@property (nonatomic, retain) NSString *display_name;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *usernameID;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *profile_image;
@property (nonatomic, retain) NSString *wallpaper;
@property (nonatomic, retain) NSString *cur_countryID;
@property (nonatomic, retain) NSString *cur_countryName;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSString *friendID;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *referral_code;
@property (nonatomic, retain) NSString *onlinestatus;
@property (nonatomic, retain) NSString *RelationshipStatus;

@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *chat_threadID;

@property (nonatomic, retain) NSIndexPath *_IndexPath;
@property BOOL isSelected;
@property BOOL onlineStatus;
@property BOOL isVerifiedBool;

@property int onlineStatusValue;

@property (nonatomic, retain) NSString *isVerfied;
@property (nonatomic, retain) NSString *totalPoints;
@property (nonatomic, retain) NSString *cashablePoints;
@property (nonatomic, retain) NSString *consumedGems;
@property (nonatomic) NSDate *lastFetched;

-(void)SetValuesFromDictionary:(NSDictionary *)_dictionary;

@end
