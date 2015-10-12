//
//  Challenge.h
//  Yolo
//
//  Created by Salman Khalid on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Challenge : NSObject{
    
    NSString *opponent_ID;
    NSString *opponentDisplayName;
    NSString *opponent_profileImage;
    NSString *opponent_points;
    NSString *contest_ID;
     NSString *challengeID;
    NSNumber *isBot;
     NSNumber *isSuperBot;
    
    NSArray *randAnswerArray;
    NSMutableArray *questionsArray;
     
}

@property (nonatomic, retain) NSString *opponent_ID;
@property (nonatomic, retain) NSString *challengeID;
@property (nonatomic, retain) NSString *opponentDisplayName;
@property (nonatomic, retain) NSString *opponent_profileImage;
@property (nonatomic, retain) NSString *opponent_points;
@property (nonatomic, retain) NSString *contest_ID;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *type_ID;
@property (nonatomic) NSNumber *isBot;
@property (nonatomic) NSNumber *isSuperBot;

@property (nonatomic, retain) NSArray *randAnswerArray;
@property (nonatomic, retain) NSMutableArray *questionsArray;





-(id)initWithDictionary:(NSDictionary *)_dictionary;
-(id)initWithChallengeDictionary:(NSDictionary *)_dictionary;
/*
 "o_id": "124",
 "display_name": "Taha",
 "profile_image": "http://quizapplication.faditekdev.com/api/images/1.jpg",
 "points": 100,
 
 "o_language": "0",
 "contest_id": "900"
 */
@end
