//
//  EventModel.h
//  Wits
//
//  Created by Mr on 16/02/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDictionary *params;

@end
