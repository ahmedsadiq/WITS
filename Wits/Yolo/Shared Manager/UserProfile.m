
//
//  UserProfile.m
//  Yolo
//
//  Created by Salman Khalid on 19/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

@synthesize display_name,gender,birthday,about,profile_image,wallpaper,cur_countryID,cur_countryName,cityName,titleArray,friendID,onlinestatus,RelationshipStatus,status,_IndexPath,isSelected,isVerfied, totalPoints, lastFetched,cashablePoints,countries,achievements,usernameID,referral_code,chat_threadID,isVerifiedBool,email,consumedGems;

-(id)init{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

-(void)SetValuesFromDictionary:(NSDictionary *)_dictionary{
    
     
     
    self.display_name = [_dictionary objectForKey:@"display_name"];
     self.display_name = [self.display_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.gender = [_dictionary objectForKey:@"gender"];
    self.birthday = [_dictionary objectForKey:@"birthday"] ;
    self.about = [_dictionary objectForKey:@"about"];
    self.profile_image = [_dictionary objectForKey:@"profile_image"];
    self.email = [_dictionary objectForKey:@"email"];
    self.friendID = [_dictionary objectForKey:@"id"];
    _onlineStatusValue = [[_dictionary objectForKey:@"online_status"] intValue];
    
     
    if(_onlineStatusValue == 1)
    {
         onlineStatus = false;
    }
    self.RelationshipStatus = [_dictionary objectForKey:@"status"];
    
    self.cur_countryID = [_dictionary objectForKey:@"cur_country_id"];
    self.cur_countryName = [_dictionary objectForKey:@"cur_country_name"];
    self.cityName = [_dictionary objectForKey:@"city_name"];
    self.isVerfied = [_dictionary objectForKey:@"isVerfied"];
     if( [self.isVerfied caseInsensitiveCompare:@"verified"] == NSOrderedSame ) {
          self.isVerifiedBool = true;
     }
     else {
          isVerifiedBool = false;
     }

    self.totalPoints = [_dictionary objectForKey:@"totalPoints"];
    self.usernameID = [_dictionary objectForKey:@"user_name_id"];
    NSString *onlineStr = [_dictionary objectForKey:@"online_status"];
    self.chat_threadID = [_dictionary objectForKey:@"chat_thread_id"];
    
    if([onlineStr intValue] == 0) {
        onlineStatus = false;
    }
    else {
        onlineStatus = true;
    }
    NSArray *countriesTemp = (NSArray*)[_dictionary objectForKey:@"country_list"];
    countries = [[NSMutableArray alloc] init];
    for (int i=0; i<countriesTemp.count; i++) {
        NSDictionary *country = (NSDictionary*)[countriesTemp objectAtIndex:i];
        NSString *countryName = (NSString*)[country objectForKey:@"name"];
        [countries addObject:countryName];
    }
    
    NSArray *achievemnetsTemp = (NSArray*)[_dictionary objectForKey:@"title"];
    achievements = [[NSMutableArray alloc] init];
    for (int i=0; i<achievemnetsTemp.count; i++) {
        NSDictionary *title = (NSDictionary*)[achievemnetsTemp objectAtIndex:i];
        NSString *titleName = (NSString*)[title objectForKey:@"title"];
        [achievements addObject:titleName];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.display_name forKey:@"display_name"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.about forKey:@"about"];
    [encoder encodeObject:self.profile_image forKey:@"profile_image"];
    
    [encoder encodeObject:self.cur_countryID forKey:@"cur_countryID"];
    [encoder encodeObject:self.friendID forKey:@"id"];
    [encoder encodeObject:self.isVerfied forKey:@"isVerfied"];
    [encoder encodeObject:self.totalPoints forKey:@"totalPoints"];
    [encoder encodeObject:self.lastFetched forKey:@"lastFetched"];
 }


- (id)initWithCoder:(NSCoder *)decoder
{
	if(self== [super init])
	{
        self.display_name = [decoder decodeObjectForKey:@"display_name"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.about = [decoder decodeObjectForKey:@"about"];
        self.profile_image = [decoder decodeObjectForKey:@"profile_image"];
        
        self.cur_countryID = [decoder decodeObjectForKey:@"cur_countryID"];
        self.friendID = [decoder decodeObjectForKey:@"id"];
        self.isVerfied = [decoder decodeObjectForKey:@"isVerfied"];
        self.totalPoints = [decoder decodeObjectForKey:@"totalPoints"];
        self.lastFetched = [decoder decodeObjectForKey:@"lastFetched"];
                
	}
	return self;
}


@end
