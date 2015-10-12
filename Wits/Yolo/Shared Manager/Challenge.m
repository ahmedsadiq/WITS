//
//  Challenge.m
//  Yolo
//
//  Created by Salman Khalid on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "Challenge.h"
#import "Question.h"


@implementation Challenge

@synthesize opponent_ID, opponentDisplayName, opponent_profileImage, opponent_points, contest_ID,isBot,randAnswerArray, questionsArray,challengeID,type,type_ID,isSuperBot;


-(id)initWithDictionary:(NSDictionary *)_dictionary{
    
    self = [super init];
    if(self)
    {
        self.questionsArray = [[NSMutableArray alloc] init];
        [self LoadChallenge:_dictionary];
        
    }
    return self;
}
-(id)initWithChallengeDictionary:(NSDictionary *)_dictionary{
     
     self = [super init];
     if(self)
     {
          self.questionsArray = [[NSMutableArray alloc] init];
          [self LoadRealChallenge:_dictionary];
          
     }
     return self;
}

-(void)LoadChallenge:(NSDictionary *)_dictionary{
     
     NSLog(@"Dict ::::::::%@ ", _dictionary);
    
    self.opponent_ID = [_dictionary objectForKey:@"oId"];
    self.opponentDisplayName = [_dictionary objectForKey:@"displayName"];
    self.opponent_profileImage = [_dictionary objectForKey:@"profileImage"];
    self.opponent_points = [_dictionary objectForKey:@"points"];
    self.challengeID = [_dictionary objectForKey:@"challenge_id"];
     
    self.contest_ID = [_dictionary objectForKey:@"contestId"];
    
    self.isBot = [_dictionary objectForKey:@"isBot"];
     self.isSuperBot = [_dictionary objectForKey:@"isSuperBot"];
    self.randAnswerArray = [_dictionary objectForKey:@"randAnswer"];

     
     NSArray *r_questionsArray = [[NSArray alloc] init];
     r_questionsArray = [_dictionary objectForKey:@"questionOptions"];
     if (r_questionsArray) {
          if(![r_questionsArray isKindOfClass:[NSNull class]]){
               for (int x=0; x<[r_questionsArray count]; x++) {
                    
                    NSDictionary *questionDict = [r_questionsArray objectAtIndex:x];
                    
                    Question *tempQuestion = [[Question alloc] initWithDictionary:questionDict];
                    
                    [self.questionsArray addObject:tempQuestion];
               }
          }
     }
}
-(void)LoadRealChallenge:(NSDictionary *)_dictionary{
     
     
     self.opponent_ID = [_dictionary objectForKey:@"oId"];
     self.opponentDisplayName = [_dictionary objectForKey:@"displayName"];
     self.opponent_profileImage = [_dictionary objectForKey:@"profileImage"];
     self.opponent_points = [_dictionary objectForKey:@"points"];
     
     self.contest_ID = [_dictionary objectForKey:@"contestId"];
     self.isBot = [_dictionary objectForKey:@"isBot"];
       self.isSuperBot = [_dictionary objectForKey:@"isSuperBot"];
     
     self.randAnswerArray = [_dictionary objectForKey:@"randAnswer"];
     
     NSArray *r_questionsArray = [_dictionary objectForKey:@"questionOptions"];
     if (r_questionsArray) {
          
          if(![r_questionsArray isKindOfClass:[NSNull class]]){
               for (int x=0; x<[r_questionsArray count]; x++) {
                    
                    NSDictionary *questionDict = [r_questionsArray objectAtIndex:x];
                    Question *tempQuestion = [[Question alloc] initWithDictionary:questionDict];
                    [self.questionsArray addObject:tempQuestion];
               }
          }
          
     }
     
     
}


@end
