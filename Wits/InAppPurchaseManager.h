//
//  InAppPurchaseManager.h
//  SleepTime
//
//  Created by Apple on 23/04/2014.
//  Copyright (c) 2014 TxLabz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}
+ (InAppPurchaseManager *)sharedInstance;
- (void)requestProUpgradeProductData;
- (void)loadStore;
- (void)loadStoreFor220Points;
- (void)loadStoreFor500Points;
- (BOOL)canMakePurchases;
- (void)purchase100Points;
- (void)purchase500Points;
- (void)purchase1000Points;
@end
