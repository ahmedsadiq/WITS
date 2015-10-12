//
//  TopicModel.h
//  Wits
//
//  Created by Mr on 01/01/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject
@property (nonatomic, retain) NSString *topic_id;
@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSString *_description;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *is_recommended;
@property (nonatomic, retain) NSMutableArray *subTopicsArray;
@property BOOL isSelected;
@end
