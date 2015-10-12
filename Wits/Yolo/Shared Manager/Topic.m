//
//  Topic.m
//  Yolo
//
//  Created by Salman Khalid on 25/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "Topic.h"

@implementation Topic

@synthesize topic_id,_description,title,is_recommended,parentTopicID,isSelected,categoryID;





///////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.topic_id forKey:@"topic_id"];
    [encoder encodeObject:self._description forKey:@"_description"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.is_recommended forKey:@"is_recommended"];
    [encoder encodeObject:self.parentTopicID forKey:@"parentTopicID"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
	
	if(self== [super init])
	{
        
        self.topic_id = [decoder decodeObjectForKey:@"topic_id"];
        self._description = [decoder decodeObjectForKey:@"_description"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.is_recommended = [decoder decodeObjectForKey:@"is_recommended"];
        self.parentTopicID = [decoder decodeObjectForKey:@"parentTopicID"];
        
	}
	return self;
}


@end
