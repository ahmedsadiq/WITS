//
//  SharedManager_ipad.h
//  TimeTraveller
//
//  Created by Jawad Sheikh on 9/24/12.
//  Copyright 2012 Xint Solutions. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "UserProfile.h"
#import "Topic.h"
#import "CategoryModel.h"
#import "TopicModel.h"
#import "Rank.h"
#import "SubTopicsModel.h"


@interface SharedManager : NSObject <NSCoding>
{
    NSString *userID;
    NSString *sessionID;
    UserProfile *_userProfile;
    
    NSMutableArray *categoryArray;
    NSMutableArray *topicsArray;
    NSMutableArray *subTopicsArray;
    
    NSMutableArray *rankingArray;
    
    NSUInteger *profileImageType;
    
//    NSString *notificationKey;
    BOOL isNotificationRegister;
    
    BOOL isFriendListSelected;
    UserProfile *friendProfile;

//    NSInteger selectedTopic;
    
}

@property (nonatomic,strong)NSString *userID;
@property (nonatomic,strong)NSString *sessionID;

@property (nonatomic, strong) UserProfile *_userProfile;

@property (nonatomic, strong) NSMutableArray *topicsArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *subTopicsArray;
@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *categoriesArray;

@property (nonatomic, strong) NSMutableArray *rankingArray;
@property (nonatomic) NSUInteger *profileImageType;

//@property (nonatomic,strong)NSString *notificationKey;
@property BOOL isNotificationRegister;

@property BOOL isFriendListSelected;
@property (nonatomic, strong) UserProfile *friendProfile;

//@property NSInteger selectedTopic;



+(SharedManager *)getInstance;

+(id)loadModel;
-(void)saveModel;
-(NSMutableArray *)getAllSubTopics;
-(void)ResetTopicSelectionValues;
-(NSMutableArray *)getAllSubTopicsInTopics;
-(NSMutableArray *)getSubTopicsOfParent:(Topic *)MainTopic;
-(BOOL)isDownloaded:(Rank *)_rank;

-(void)ResetModel;

@end
