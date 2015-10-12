//
//  MessageThreads.h
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageThreads : NSObject{
    
#pragma mark -----------
#pragma mark Messages Threads
    
    NSString *displayName;
    NSString *profileImage;
    NSString *userId;
    NSString *threadId;
    NSString *lastMessage;
    NSString *timeAgo;
    
#pragma mark ----------
#pragma mark Discussion Threads
    
    NSString *discussionTitle;
    NSString *discussion_ID;
    
}

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *profileImage;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *lastMessage;
@property (nonatomic, strong) NSString *timeAgo;
@property (nonatomic, strong) NSString *currentServerTime;

@property (nonatomic, strong)  NSString *discussionTitle;
@property (nonatomic, strong)  NSString *discussion_ID;

-(void)SetValuesFromDictionary:(NSDictionary *)_receivedDict;
@end
