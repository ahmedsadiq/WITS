//
//  Rank.m
//  Yolo
//
//  Created by Jawad Mahmood  on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "Rank.h"

@implementation Rank

@synthesize displayName,gender,cityName,countryName,countryCode,scorePoints,profileImage_url,profileImage_path,countryImage_url,countryImage_path,isProfileDownloaded;



///////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.displayName forKey:@"displayName"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.cityName forKey:@"cityName"];
    [encoder encodeObject:self.countryName forKey:@"countryName"];
    [encoder encodeObject:self.countryCode forKey:@"countryCode"];
    [encoder encodeObject:self.scorePoints forKey:@"scorePoints"];
    [encoder encodeObject:self.profileImage_url forKey:@"profileImage_url"];
    [encoder encodeObject:self.profileImage_path forKey:@"profileImage_path"];
    [encoder encodeObject:self.countryImage_url forKey:@"countryImage_url"];
    [encoder encodeObject:self.countryImage_path forKey:@"countryImage_path"];
    
    [encoder encodeBool:isProfileDownloaded forKey:@"isProfileDownloaded"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
	
	if(self== [super init])
	{
        
        self.displayName = [decoder decodeObjectForKey:@"displayName"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.cityName = [decoder decodeObjectForKey:@"cityName"];
        self.countryName = [decoder decodeObjectForKey:@"countryName"];
        self.countryCode = [decoder decodeObjectForKey:@"countryCode"];
        self.scorePoints = [decoder decodeObjectForKey:@"scorePoints"];
        self.profileImage_url = [decoder decodeObjectForKey:@"profileImage_url"];
        self.profileImage_path = [decoder decodeObjectForKey:@"profileImage_path"];
        self.countryImage_url = [decoder decodeObjectForKey:@"countryImage_url"];
        self.countryImage_path = [decoder decodeObjectForKey:@"countryImage_path"];
        
        self.isProfileDownloaded = [decoder decodeBoolForKey:@"isProfileDownloaded"];
	}
	return self;
}



@end
