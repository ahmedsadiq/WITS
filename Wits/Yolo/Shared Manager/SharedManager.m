//
//  SharedManager_ipad.m
//  TimeTraveller
//
//  Created by Jawad Sheikh on 9/24/12.
//  Copyright 2012 Xint Solutions. All rights reserved.
//

#import "SharedManager.h"


@implementation SharedManager

@synthesize sessionID,userID, _userProfile,topicsArray,subTopicsArray,categoryArray ,rankingArray,profileImageType,isNotificationRegister,isFriendListSelected,friendProfile,countriesArray,categoriesArray;//,selectedTopic;

static SharedManager *instance= NULL;

+(SharedManager *)getInstance
{
	
	@synchronized (self)
	{
		if(instance==NULL)
		{
			instance=[SharedManager loadModel];
		}
	}
	return instance;
}

-(id)init
{
	if(self == [super init])
	{
        _userProfile = [[UserProfile alloc] init];
        
        topicsArray = [[NSMutableArray alloc] init];
        subTopicsArray = [[NSMutableArray alloc] init];
        
        rankingArray = [[NSMutableArray alloc] init];
        friendProfile = [[UserProfile alloc] init];
        
        isNotificationRegister = false;
	}
	
	return self;
	
}

+(id)loadModel
{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data= [prefs objectForKey:@"Wits"];
    SharedManager *anInstance=nil;
    
    
    if(!data)
        anInstance= [[SharedManager alloc] init];
    else
        anInstance= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
	return anInstance;
	
}

-(void)saveModel
{
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:instance];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:data forKey:@"Wits"];
	

    [prefs synchronize];
	
}


-(NSMutableArray *)getSubTopicsOfParent:(Topic *)MainTopic{
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (Topic *tempTopic in subTopicsArray) {
        
        if([tempTopic.parentTopicID isEqualToString:MainTopic.topic_id])
        {
            [returnArray addObject:tempTopic];
        }
    }
    
    return returnArray;
    
}

-(NSMutableArray *)getAllSubTopics{
     
     NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     for(CategoryModel *tempCategory in categoriesArray) {
          for (Topic *tempTopic in tempCategory.topicsArray) {
               
               [returnArray addObject:tempTopic];
          }
     }
     return returnArray;
     
}

-(NSMutableArray *)getAllSubTopicsInTopics{
     
     NSMutableArray *returnArray = [[NSMutableArray alloc] init];
     for(CategoryModel *tempCategory in categoriesArray) {
          for (TopicModel *tempTopic in tempCategory.topicsArray) {
               if(tempTopic.subTopicsArray.count > 0) {
                    for(SubTopicsModel *tempSubTopic in tempTopic.subTopicsArray) {
                         [returnArray addObject:tempSubTopic];
                    }
               }
          }
     }
     
     return returnArray;
}


-(void)ResetTopicSelectionValues{
    
    for (Topic *tempTopic in subTopicsArray) {
        
        tempTopic.isSelected = false;
    }

}

-(BOOL)isDownloaded:(Rank *)_rank{
    
    for(Rank *tempRank in rankingArray){
        
        if([tempRank.displayName isEqualToString:_rank.displayName])
            return true;
    }
    
    return false;
}

-(void)ResetModel{
    
    self.userID = nil;
    self.sessionID = nil;
    [self._userProfile SetValuesFromDictionary:nil];
     self._userProfile = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"Wits"];
    
    [prefs synchronize];
    
    instance = nil;

}


///////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)encoder
{

    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.sessionID forKey:@"sessionID"];
    [encoder encodeObject:self._userProfile forKey:@"_userProfile"];
    [encoder encodeObject:self.topicsArray forKey:@"topicsArray"];
    [encoder encodeObject:self.subTopicsArray forKey:@"subTopicsArray"];
    [encoder encodeObject:self.rankingArray forKey:@"rankingArray"];
    
//    [encoder encodeObject:self.notificationKey forKey:@"notificationKey"];
    [encoder encodeBool:isNotificationRegister forKey:@"isNotificationRegister"];
    [encoder encodeObject:friendProfile forKey:@"friendProfile"];
   // [encoder encodeObject:self.profileImageType forKey:@"profileImageType"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
	
	if(self== [super init])
	{
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.sessionID = [decoder decodeObjectForKey:@"sessionID"];
        self._userProfile = [decoder decodeObjectForKey:@"_userProfile"];
        self.topicsArray = [decoder decodeObjectForKey:@"topicsArray"];
        self.subTopicsArray = [decoder decodeObjectForKey:@"subTopicsArray"];
        self.rankingArray = [decoder decodeObjectForKey:@"rankingArray"];
        
//        self.notificationKey = [decoder decodeObjectForKey:@"notificationKey"];
        self.isNotificationRegister = [decoder decodeBoolForKey:@"isNotificationRegister"];
        self.friendProfile = [decoder decodeObjectForKey:@"friendProfile"];
	}
	return self;
}


@end
