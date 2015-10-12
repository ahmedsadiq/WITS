//
//  MessageThreads.m
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "MessageThreads.h"

@implementation MessageThreads

@synthesize displayName,profileImage,userId,threadId,lastMessage,timeAgo,discussionTitle,discussion_ID,currentServerTime;



-(id)init{
     self = [super init];
     if (self) {
          //
     }
     
     return self;
}



-(void)SetValuesFromDictionary:(NSDictionary *)_receivedDict{
     
     displayName = [_receivedDict objectForKey:@"display_name"];
     profileImage = [_receivedDict objectForKey:@"profile_image"];
     userId = [_receivedDict objectForKey:@"user_id"];
     threadId = [_receivedDict objectForKey:@"thread_id"];
     lastMessage = [_receivedDict objectForKey:@"last_message"];
     timeAgo = [_receivedDict objectForKey:@"time_ago"];
     currentServerTime = [_receivedDict objectForKey:@"current_time"];
     
}

@end
