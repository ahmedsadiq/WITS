//
//  Article.m
//  Libas
//
//  Created by Salman Khalid on 13/02/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize PagesArray,_isDownloaded, articleName, articleID, _isAdvertisement, _isContactForm, video_link,website_link,facebook_link,twitter_link,instagram_link,other_link,keywords;

-(id)init{
    self = [super init];
    if(self)
    {
        self.PagesArray = [[NSMutableArray alloc] init];
        self._isDownloaded = false;
        self._isAdvertisement = false;
        self._isContactForm = false;
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.articleID forKey:@"articleID"];
    [encoder encodeObject:self.articleName forKey:@"articleName"];
    [encoder encodeObject:self.PagesArray forKey:@"PagesArray"];
    
	[encoder encodeBool:self._isDownloaded forKey:@"_isDownloaded"];
    [encoder encodeBool:self._isAdvertisement forKey:@"_isAdvertisement"];
    [encoder encodeBool:self._isContactForm forKey:@"_isContactForm"];

    [encoder encodeObject:self.video_link forKey:@"video_link"];
    [encoder encodeObject:self.website_link forKey:@"website_link"];
    [encoder encodeObject:self.facebook_link forKey:@"facebook_link"];
    [encoder encodeObject:self.twitter_link forKey:@"twitter_link"];
    [encoder encodeObject:self.instagram_link forKey:@"instagram_link"];
    [encoder encodeObject:self.other_link forKey:@"other_link"];
    [encoder encodeObject:self.keywords forKey:@"keywords"];
    
}


- (id)initWithCoder:(NSCoder *)decoder
{
	if(self== [super init])
	{
        self.articleID = [decoder decodeObjectForKey:@"articleID"];
        self.articleName = [decoder decodeObjectForKey:@"articleName"];
        self.PagesArray=[decoder decodeObjectForKey:@"PagesArray"];
        
        self._isDownloaded = [decoder decodeBoolForKey:@"_isDownloaded"];
        self._isAdvertisement = [decoder decodeBoolForKey:@"_isAdvertisement"];
        self._isContactForm = [decoder decodeBoolForKey:@"_isContactForm"];
        
        self.video_link = [decoder decodeObjectForKey:@"video_link"];
        self.website_link = [decoder decodeObjectForKey:@"website_link"];
        self.facebook_link = [decoder decodeObjectForKey:@"facebook_link"];
        self.twitter_link = [decoder decodeObjectForKey:@"twitter_link"];
        self.instagram_link = [decoder decodeObjectForKey:@"instagram_link"];
        self.other_link = [decoder decodeObjectForKey:@"other_link"];
        self.keywords = [decoder decodeObjectForKey:@"keywords"];
        
	}
	return self;
}

@end
