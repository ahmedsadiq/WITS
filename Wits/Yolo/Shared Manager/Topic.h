//
//  Topic.h
//  Yolo
//
//  Created by Salman Khalid on 25/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject{
    
    NSString *topic_id;
    NSString *_description;
    NSString *title;
    NSString *is_recommended;
    NSString *parentTopicID;
    NSString *categoryID;
    BOOL isSelected;
    
/*    counter = 0;
    "created_date" = "2014-06-09 09:17:10";
    description = "General is a sub topic of Arts";
    id = 1;
    image = "";
    "is_active" = 1;
    "is_recommended" = 0;
    "modify_date" = "0000-00-00 00:00:00";
    staffpick = 0;
    tid = 1;
    title = General;
 */
    
}

@property (nonatomic, retain)  NSString *topic_id;
@property (nonatomic, retain) NSString *_description;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSString *is_recommended;
@property (nonatomic, retain) NSString *parentTopicID;

@property BOOL isSelected;
@end
