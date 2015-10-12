//
//  SubTopicsModel.h
//  Wits
//
//  Created by Mr on 01/01/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubTopicsModel : NSObject
@property (nonatomic, retain) NSString *subTopic_id;
@property (nonatomic, retain) NSString *topicID;
@property (nonatomic, retain) NSString *_description;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *is_recommended;
@property BOOL isSelected;
@end
