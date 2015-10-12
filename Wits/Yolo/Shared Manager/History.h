//
//  History.h
//  Wits
//
//  Created by Salman Khalid on 02/09/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject{
    
    NSString *contest_id;
    NSString *game_message;
    NSString *game_status;
    NSString *history_date;
    NSString *history_for;
    NSString *opponent_id;
    NSString *opponent_image;
    NSString *sub_topic_id;
    NSString *sub_topic_image;
    NSString *sub_topic_title;
    NSString *topic_id;
    NSString *user_id;
    
    BOOL isSelected;
}


@property (nonatomic, retain) NSString *contest_id;
@property (nonatomic, retain) NSString *game_message;
@property (nonatomic, retain) NSString *game_status;
@property (nonatomic, retain) NSString *history_date;
@property (nonatomic, retain) NSString *history_for;
@property (nonatomic, retain) NSString *opponent_id;
@property (nonatomic, retain) NSString *opponent_image;
@property (nonatomic, retain) NSString *sub_topic_id;
@property (nonatomic, retain) NSString *sub_topic_image;
@property (nonatomic, retain) NSString *sub_topic_title;
@property (nonatomic, retain) NSString *topic_id;
@property (nonatomic, retain) NSString *user_id;

@property (nonatomic) BOOL isSelected;

/*
 {
 "contest_id" = 1339;
 "discussion_id" =             (
    {
        id = 1;
    },
    {
        id = 5;
    }
    );
    "game_message" = "John Carter Beat you 12 days ago";
    "game_status" = 1;
    "history_date" = "2014-08-21 14:29:01";
    "history_for" = 1;
    "opponent_id" = 83;
    "opponent_image" = "http://quizapplication.faditekdev.com/api/images/profile_53a14d79e8dc8.jpg";
    "opponent_name" = "John Carter";
    "sub_topic_id" = 1;
    "sub_topic_image" = "http://quizapplication.faditekdev.com/api/images/";
    "sub_topic_title" = General;
    "topic_id" = 1;
    "user_id" = 124;
 }
 */

@end
