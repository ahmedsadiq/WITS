//
//  RewardObj.h
//  Wits
//
//  Created by Ahmed Sadiq on 05/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardObj : NSObject
@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *productDescription;
@property (nonatomic, retain) NSString *available_store;
@property (nonatomic, retain) NSString *created_at;
@property (nonatomic, retain) NSString *expired_at;
@property (nonatomic, retain) NSString *reward_id;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *unlock_price;
@property BOOL isSelected;
@property BOOL isUnlocked;
@end
