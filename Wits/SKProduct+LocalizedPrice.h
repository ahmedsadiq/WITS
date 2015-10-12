//
//  SKProduct+LocalizedPrice.h
//  SleepTime
//
//  Created by Apple on 23/04/2014.
//  Copyright (c) 2014 TxLabz. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)
@property (nonatomic, readonly) NSString *localizedPrice;

@end
