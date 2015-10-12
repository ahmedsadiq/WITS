//
//  AddOnObj.h
//  Wits
//
//  Created by Ahmed Sadiq on 02/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddOnObj : NSObject
@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *productDescription;
@property (nonatomic, retain) NSString *gemsRequired;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *counter;
@property BOOL isSelected;
@property BOOL isUnlocked;
@end
