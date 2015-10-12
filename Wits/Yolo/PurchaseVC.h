//
//  PurchaseVC.h
//  Wits
//
//  Created by Nisar Ahmad on 15/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface PurchaseVC : UIViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView *_purchaseWebView;
    
    LoadingView *loadView;
}

-(IBAction)ShowRightMenu:(id)sender;
- (id)init;
@end
